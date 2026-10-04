import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nutriwallet/features/notifications/notification_service.dart';

void main() {
  test('fake scheduler stores and cancels meal reminders', () async {
    final scheduler = _FakeMealReminderScheduler();
    final reminder = MealReminder(
      id: 1,
      title: 'Lunch',
      scheduledAt: DateTime.utc(2026, 1, 1, 12),
    );

    await scheduler.schedule(reminder);
    expect(scheduler.reminders[1]?.title, 'Lunch');
    await scheduler.cancel(1);
    expect(scheduler.reminders, isEmpty);
  });

  test('notification preference persists enablement', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final settings = NotificationPreferences(preferences);

    expect(settings.enabled, isTrue);
    await settings.setEnabled(false);

    expect(settings.enabled, isFalse);
  });
}

class _FakeMealReminderScheduler implements MealReminderScheduler {
  final reminders = <int, MealReminder>{};

  @override
  Future<void> initialize() async {}

  @override
  Future<void> schedule(MealReminder reminder) async {
    reminders[reminder.id] = reminder;
  }

  @override
  Future<void> cancel(int id) async {
    reminders.remove(id);
  }
}
