import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class MealReminder {
  const MealReminder({
    required this.id,
    required this.title,
    required this.scheduledAt,
  });

  final int id;
  final String title;
  final DateTime scheduledAt;
}

class NotificationPreferences {
  NotificationPreferences(this._preferences);

  static const _enabledKey = 'meal_reminders_enabled';
  final SharedPreferences _preferences;

  bool get enabled => _preferences.getBool(_enabledKey) ?? true;

  Future<void> setEnabled(bool enabled) =>
      _preferences.setBool(_enabledKey, enabled);
}

abstract interface class MealReminderScheduler {
  Future<void> initialize();
  Future<void> schedule(MealReminder reminder);
  Future<void> cancel(int id);
}

class LocalMealReminderScheduler implements MealReminderScheduler {
  LocalMealReminderScheduler() : _plugin = FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    final localTimezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimezone.identifier));
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _plugin.initialize(settings: settings);
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    _initialized = true;
  }

  @override
  Future<void> schedule(MealReminder reminder) async {
    await initialize();
    final details = const NotificationDetails(
      android: AndroidNotificationDetails(
        'meal_reminders',
        'Meal reminders',
        channelDescription: 'Reminders for scheduled meals',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await _plugin.zonedSchedule(
      id: reminder.id,
      title: 'NutriWallet meal reminder',
      body: reminder.title,
      scheduledDate: tz.TZDateTime.from(reminder.scheduledAt, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancel(int id) => _plugin.cancel(id: id);
}
