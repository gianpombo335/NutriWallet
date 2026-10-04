import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nutriwallet/data/local/database.dart';
import 'package:nutriwallet/data/remote/sync_service.dart';

void main() {
  test(
    'dirty changes remain queued until confirmed and then are marked synced',
    () async {
      final database = AppDatabase();
      addTearDown(database.close);
      final queue = SyncQueueRepository(database);
      final endpoint = _FakeEndpoint();
      final service = SyncService(database: database, endpoint: endpoint);
      final dirtyAt = DateTime.utc(2026, 1, 1);
      await queue.enqueue(
        entityTable: 'Dishes',
        entityId: 4,
        operation: 'update',
        payload: {'name': 'Updated bowl'},
        dirtyAt: dirtyAt,
      );

      expect((await queue.pending()), hasLength(1));
      expect(await service.syncPending(), 1);
      expect(await queue.pending(), isEmpty);
      expect(endpoint.record('Dishes', 4)!['name'], 'Updated bowl');
    },
  );

  test(
    'last-write-wins rejects an older payload as a confirmed conflict',
    () async {
      final endpoint = _FakeEndpoint();
      final newer = DateTime.utc(2026, 2, 1);
      final older = DateTime.utc(2026, 1, 1);
      await endpoint.push(
        entityTable: 'Profile',
        entityId: 1,
        operation: 'update',
        payload: {'budget': 100},
        dirtyAt: newer,
      );
      final result = await endpoint.push(
        entityTable: 'Profile',
        entityId: 1,
        operation: 'update',
        payload: {'budget': 50},
        dirtyAt: older,
      );

      expect(result.conflict, isTrue);
      expect(endpoint.record('Profile', 1)!['budget'], 100);
    },
  );

  test('offline changes sync when connectivity is restored', () async {
    final database = AppDatabase();
    addTearDown(database.close);
    final queue = SyncQueueRepository(database);
    final endpoint = _FakeEndpoint();
    final service = SyncService(database: database, endpoint: endpoint);
    final connectivity = _FakeConnectivity();
    final coordinator = ConnectivitySyncCoordinator(
      syncService: service,
      connectivity: connectivity,
    );
    addTearDown(() async {
      await coordinator.dispose();
      await connectivity.dispose();
    });

    await queue.enqueue(
      entityTable: 'Dishes',
      entityId: 8,
      operation: 'insert',
      payload: {'name': 'Offline bowl'},
    );
    await coordinator.start();
    expect(await queue.pending(), hasLength(1));

    connectivity.emit(const [ConnectivityResult.wifi]);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(await queue.pending(), isEmpty);
    expect(endpoint.record('Dishes', 8)!['name'], 'Offline bowl');
  });
}

class _FakeConnectivity implements ConnectivityStatusSource {
  final _changes = StreamController<List<ConnectivityResult>>.broadcast();

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => const [
    ConnectivityResult.none,
  ];

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => _changes.stream;

  void emit(List<ConnectivityResult> results) => _changes.add(results);

  Future<void> dispose() => _changes.close();
}

class _FakeEndpoint implements SyncRemoteEndpoint {
  final _records = <String, _Record>{};

  Map<String, dynamic>? record(String table, int id) =>
      _records['$table:$id']?.payload;

  @override
  Future<SyncPushResult> push({
    required String entityTable,
    required int entityId,
    required String operation,
    required Map<String, dynamic> payload,
    required DateTime dirtyAt,
  }) async {
    final key = '$entityTable:$entityId';
    final current = _records[key];
    if (current != null && current.updatedAt.isAfter(dirtyAt)) {
      return const SyncPushResult(accepted: false, conflict: true);
    }
    _records[key] = _Record(updatedAt: dirtyAt, payload: payload);
    return const SyncPushResult(accepted: true, conflict: false);
  }
}

class _Record {
  const _Record({required this.updatedAt, required this.payload});

  final DateTime updatedAt;
  final Map<String, dynamic> payload;
}
