import 'dart:convert';

import '../../../data/local/database.dart';

class MealSchedule {
  const MealSchedule(this.minutesAfterMidnight);

  factory MealSchedule.forMealsPerDay(int mealsPerDay) {
    final defaults = switch (mealsPerDay) {
      2 => const [480, 1140],
      3 => const [480, 780, 1140],
      4 => const [450, 720, 990, 1260],
      5 => const [420, 600, 780, 960, 1140],
      _ => const [480, 780, 1140],
    };
    return MealSchedule(defaults);
  }

  factory MealSchedule.fromJson(String? value, int mealsPerDay) {
    final fallback = MealSchedule.forMealsPerDay(mealsPerDay);
    if (value == null || value.trim().isEmpty) return fallback;
    try {
      final decoded = jsonDecode(value);
      if (decoded is! List) return fallback;
      final parsed = decoded
          .whereType<num>()
          .map((item) => item.toInt())
          .toList();
      if (parsed.length != mealsPerDay ||
          parsed.any((item) => item < 0 || item > 1439)) {
        return fallback;
      }
      return MealSchedule(parsed);
    } catch (_) {
      return fallback;
    }
  }

  final List<int> minutesAfterMidnight;

  String get json => jsonEncode(minutesAfterMidnight);

  DateTime timeForSlot({required DateTime date, required int slotIndex}) {
    final minutes =
        minutesAfterMidnight[slotIndex.clamp(
          0,
          minutesAfterMidnight.length - 1,
        )];
    return DateTime(
      date.year,
      date.month,
      date.day,
      minutes ~/ 60,
      minutes % 60,
    );
  }

  String labelForSlot(int slotIndex) {
    final minutes =
        minutesAfterMidnight[slotIndex.clamp(
          0,
          minutesAfterMidnight.length - 1,
        )];
    final hour = minutes ~/ 60;
    final minute = minutes % 60;
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:${minute.toString().padLeft(2, '0')} $suffix';
  }

  MealSchedule withTime(int slotIndex, DateTime time) {
    final updated = [...minutesAfterMidnight];
    updated[slotIndex] = time.hour * 60 + time.minute;
    return MealSchedule(updated);
  }
}

class ScheduledMeal {
  const ScheduledMeal({required this.slot, required this.scheduledAt});

  final MealSlot slot;
  final DateTime scheduledAt;
}

class MealScheduleResolver {
  const MealScheduleResolver._();

  static List<ScheduledMeal> resolve({
    required GeneratedPlan plan,
    required List<MealSlot> slots,
    required MealSchedule schedule,
  }) {
    final weekStart = DateTime(
      plan.weekStartDate.year,
      plan.weekStartDate.month,
      plan.weekStartDate.day,
    );
    final result =
        slots
            .map(
              (slot) => ScheduledMeal(
                slot: slot,
                scheduledAt: schedule.timeForSlot(
                  date: weekStart.add(Duration(days: slot.dayIndex - 1)),
                  slotIndex: slot.slotIndex,
                ),
              ),
            )
            .toList()
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return result;
  }

  static ScheduledMeal? currentMeal(
    List<ScheduledMeal> meals, {
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final due = meals
        .where(
          (meal) =>
              meal.slot.mealStatus == 'planned' &&
              !meal.scheduledAt.isAfter(current),
        )
        .toList();
    return due.isEmpty ? null : due.last;
  }

  static ScheduledMeal? nextMeal(List<ScheduledMeal> meals, {DateTime? now}) {
    final current = now ?? DateTime.now();
    final upcoming = meals
        .where(
          (meal) =>
              meal.slot.mealStatus == 'planned' &&
              meal.scheduledAt.isAfter(current),
        )
        .toList();
    return upcoming.isEmpty ? null : upcoming.first;
  }

  static List<ScheduledMeal> mealsToAutoSkip(
    List<ScheduledMeal> meals, {
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final next = nextMeal(meals, now: current);
    if (next == null ||
        next.scheduledAt.difference(current) > const Duration(hours: 1)) {
      return const [];
    }
    return meals
        .where(
          (meal) =>
              meal.slot.mealStatus == 'planned' &&
              !meal.scheduledAt.isAfter(current) &&
              meal.scheduledAt.isBefore(next.scheduledAt),
        )
        .toList();
  }
}
