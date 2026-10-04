import 'dart:convert';
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';

import '../local/database.dart';

class SyncPushResult {
  const SyncPushResult({required this.accepted, required this.conflict});

  final bool accepted;
  final bool conflict;
}

Map<String, dynamic> userProfileSyncPayload(UserProfile profile) => {
  'email': profile.email,
  'display_name': profile.displayName,
  'weekly_budget_cents': profile.weeklyBudgetCents,
  'active_days': profile.activeDays,
  'meals_per_day': profile.mealsPerDay,
  'weight_kg': profile.weightKg,
  'height_cm': profile.heightCm,
  'age': profile.age,
  'sex': profile.sex,
  'activity_level': profile.activityLevel,
  'goal_preset': profile.goalPreset,
  'created_at': profile.createdAt.toUtc().toIso8601String(),
  'updated_at': profile.updatedAt.toUtc().toIso8601String(),
};

abstract interface class SyncRemoteEndpoint {
  Future<SyncPushResult> push({
    required String entityTable,
    required int entityId,
    required String operation,
    required Map<String, dynamic> payload,
    required DateTime dirtyAt,
  });
}

class SyncQueueRepository {
  SyncQueueRepository(this._database);

  final AppDatabase _database;

  Future<int> enqueue({
    required String entityTable,
    required int entityId,
    required String operation,
    required Map<String, dynamic> payload,
    DateTime? dirtyAt,
  }) {
    return _database
        .into(_database.syncQueue)
        .insert(
          SyncQueueCompanion.insert(
            entityTable: entityTable,
            entityId: entityId,
            operation: operation,
            payloadJson: jsonEncode(payload),
            queuedAt: dirtyAt ?? DateTime.now().toUtc(),
          ),
        );
  }

  Future<List<SyncQueueData>> pending() =>
      (_database.select(_database.syncQueue)
            ..where((row) => row.dirtyFlag.equals(true))
            ..orderBy([
              (row) => OrderingTerm(expression: row.queuedAt),
              (row) => OrderingTerm(expression: row.id),
            ]))
          .get();

  Future<void> markConfirmed(int id, DateTime syncedAt) =>
      (_database.update(
        _database.syncQueue,
      )..where((row) => row.id.equals(id))).write(
        SyncQueueCompanion(
          dirtyFlag: const Value(false),
          syncedAt: Value(syncedAt),
        ),
      );
}

class SyncService {
  SyncService({required AppDatabase database, required this.endpoint})
    : _queue = SyncQueueRepository(database);

  final SyncQueueRepository _queue;
  final SyncRemoteEndpoint endpoint;

  Future<int> syncPending() async {
    var confirmed = 0;
    final pending = await _queue.pending();
    for (final item in pending) {
      final result = await endpoint.push(
        entityTable: item.entityTable,
        entityId: item.entityId,
        operation: item.operation,
        payload: jsonDecode(item.payloadJson) as Map<String, dynamic>,
        dirtyAt: item.queuedAt,
      );
      // A conflict is also confirmed: the server's newer version won under LWW.
      if (result.accepted || result.conflict) {
        await _queue.markConfirmed(item.id, DateTime.now().toUtc());
        confirmed++;
      }
    }
    return confirmed;
  }
}

abstract interface class ConnectivityStatusSource {
  Future<List<ConnectivityResult>> checkConnectivity();
  Stream<List<ConnectivityResult>> get onConnectivityChanged;
}

class ConnectivityStatusAdapter implements ConnectivityStatusSource {
  ConnectivityStatusAdapter(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() =>
      _connectivity.checkConnectivity();

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}

class ConnectivitySyncCoordinator {
  ConnectivitySyncCoordinator({
    required this.syncService,
    required this.connectivity,
  });

  final SyncService syncService;
  final ConnectivityStatusSource connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _syncing = false;

  Future<void> start() async {
    if (_subscription != null) return;
    await _syncIfOnline(await connectivity.checkConnectivity());
    _subscription = connectivity.onConnectivityChanged.listen(_syncIfOnline);
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Future<void> _syncIfOnline(List<ConnectivityResult> results) async {
    if (_syncing ||
        results.every((result) => result == ConnectivityResult.none)) {
      return;
    }
    _syncing = true;
    try {
      await syncService.syncPending();
    } catch (_) {
      // Keep changes dirty so a later connectivity event can retry them.
    } finally {
      _syncing = false;
    }
  }
}

class SupabaseSyncEndpoint implements SyncRemoteEndpoint {
  SupabaseSyncEndpoint({required this.dio, required this.endpoint});

  final Dio dio;
  final String endpoint;

  @override
  Future<SyncPushResult> push({
    required String entityTable,
    required int entityId,
    required String operation,
    required Map<String, dynamic> payload,
    required DateTime dirtyAt,
  }) async {
    final response = await dio.post<Map<String, dynamic>>(
      endpoint,
      data: {
        'entity_table': entityTable,
        'entity_id': entityId,
        'operation': operation,
        'payload': payload,
        'updated_at': dirtyAt.toIso8601String(),
      },
    );
    final data = response.data ?? const <String, dynamic>{};
    return SyncPushResult(
      accepted: data['accepted'] == true,
      conflict: data['conflict'] == true,
    );
  }
}
