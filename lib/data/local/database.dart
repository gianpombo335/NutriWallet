import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class UserProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text()();
  TextColumn get displayName => text().nullable()();
  IntColumn get weeklyBudgetCents => integer().withDefault(const Constant(0))();
  TextColumn get activeDays =>
      text().withDefault(const Constant('1,2,3,4,5,6,7'))();
  IntColumn get mealsPerDay => integer().withDefault(const Constant(3))();
  RealColumn get weightKg => real().nullable()();
  RealColumn get heightCm => real().nullable()();
  IntColumn get age => integer().nullable()();
  TextColumn get sex => text().nullable()();
  TextColumn get activityLevel =>
      text().withDefault(const Constant('moderate'))();
  TextColumn get goalPreset => text().withDefault(const Constant('balanced'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class Dishes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userProfileId =>
      integer().references(UserProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  IntColumn get priceCents => integer()();
  TextColumn get cuisineTag => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get source => text().withDefault(const Constant('manual'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

class Ingredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dishId =>
      integer().references(Dishes, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  RealColumn get quantity => real().withDefault(const Constant(1))();
  TextColumn get unit => text().withDefault(const Constant('serving'))();
  RealColumn get calories => real().withDefault(const Constant(0))();
  RealColumn get proteinG => real().withDefault(const Constant(0))();
  RealColumn get carbsG => real().withDefault(const Constant(0))();
  RealColumn get fatG => real().withDefault(const Constant(0))();
  TextColumn get micronutrientsJson => text().nullable()();
  IntColumn get usdaFdcId => integer().nullable()();
  BoolColumn get isCachedFromApi =>
      boolean().withDefault(const Constant(false))();
}

class NutritionCaches extends Table {
  TextColumn get name => text()();
  RealColumn get calories => real()();
  RealColumn get proteinG => real()();
  RealColumn get carbsG => real()();
  RealColumn get fatG => real()();
  IntColumn get usdaFdcId => integer().nullable()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {name};
}

class AllergenTags extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userProfileId =>
      integer().references(UserProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get label => text()();
}

class DishAllergenTags extends Table {
  IntColumn get dishId =>
      integer().references(Dishes, #id, onDelete: KeyAction.cascade)();
  IntColumn get allergenTagId =>
      integer().references(AllergenTags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {dishId, allergenTagId};
}

class GeneratedPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userProfileId =>
      integer().references(UserProfiles, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get weekStartDate => dateTime()();
  DateTimeColumn get generatedAt => dateTime()();
  IntColumn get totalProjectedCostCents => integer()();
  BoolColumn get isOverBudget => boolean().withDefault(const Constant(false))();
  IntColumn get version => integer()();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  TextColumn get planningFocus =>
      text().withDefault(const Constant('balanced'))();
  TextColumn get currencyCode => text().withDefault(const Constant('USD'))();
}

class MealSlots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get generatedPlanId =>
      integer().references(GeneratedPlans, #id, onDelete: KeyAction.cascade)();
  IntColumn get dayIndex => integer()();
  IntColumn get slotIndex => integer()();
  IntColumn get dishId => integer().references(Dishes, #id)();
  IntColumn get plannedCostCents => integer()();
  RealColumn get plannedCalories => real().withDefault(const Constant(0))();
  RealColumn get plannedProteinG => real().withDefault(const Constant(0))();
  RealColumn get plannedCarbsG => real().withDefault(const Constant(0))();
  RealColumn get plannedFatG => real().withDefault(const Constant(0))();
  RealColumn get servings => real().withDefault(const Constant(1))();
  TextColumn get mealStatus => text().withDefault(const Constant('planned'))();
  IntColumn get actualCostCents => integer().nullable()();
  TextColumn get substituteName => text().nullable()();
  DateTimeColumn get consumedAt => dateTime().nullable()();
}

class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityTable => text()();
  IntColumn get entityId => integer()();
  TextColumn get operation => text()();
  TextColumn get payloadJson => text()();
  BoolColumn get dirtyFlag => boolean().withDefault(const Constant(true))();
  DateTimeColumn get queuedAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
}

class BudgetEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userProfileId =>
      integer().references(UserProfiles, #id, onDelete: KeyAction.cascade)();
  IntColumn get generatedPlanId => integer().nullable().references(
    GeneratedPlans,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get mealSlotId => integer().nullable().references(
    MealSlots,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get amountCents => integer()();
  TextColumn get label => text()();
  DateTimeColumn get occurredAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(
  tables: [
    UserProfiles,
    Dishes,
    Ingredients,
    NutritionCaches,
    AllergenTags,
    DishAllergenTags,
    GeneratedPlans,
    MealSlots,
    SyncQueue,
    BudgetEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? NativeDatabase.memory());

  AppDatabase.persistent()
    : super(
        LazyDatabase(() async {
          final directory = await getApplicationDocumentsDirectory();
          final file = File(p.join(directory.path, 'nutriwallet.sqlite'));
          return NativeDatabase.createInBackground(file);
        }),
      );

  Future<void> clearAccountData() async {
    await transaction(() async {
      await delete(budgetEntries).go();
      await delete(mealSlots).go();
      await delete(generatedPlans).go();
      await delete(ingredients).go();
      await delete(dishAllergenTags).go();
      await delete(dishes).go();
      await delete(allergenTags).go();
      await delete(userProfiles).go();
      await delete(syncQueue).go();
    });
  }

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(nutritionCaches);
      if (from < 3) await m.createTable(budgetEntries);
      if (from < 4) {
        await m.addColumn(generatedPlans, generatedPlans.isActive);
        await customStatement('''
          UPDATE generated_plans
          SET is_active = 1
          WHERE id IN (
            SELECT MAX(id) FROM generated_plans GROUP BY user_profile_id
          )
        ''');
      }
      if (from < 5) {
        await m.addColumn(mealSlots, mealSlots.mealStatus);
        await m.addColumn(mealSlots, mealSlots.actualCostCents);
        await m.addColumn(mealSlots, mealSlots.substituteName);
        await m.addColumn(mealSlots, mealSlots.consumedAt);
      }
      if (from < 6) {
        await m.addColumn(budgetEntries, budgetEntries.mealSlotId);
      }
      if (from < 7) {
        await m.addColumn(generatedPlans, generatedPlans.planningFocus);
        await m.addColumn(generatedPlans, generatedPlans.currencyCode);
      }
      if (from < 8) {
        await m.addColumn(mealSlots, mealSlots.plannedProteinG);
        await m.addColumn(mealSlots, mealSlots.plannedCarbsG);
        await m.addColumn(mealSlots, mealSlots.plannedFatG);
        await m.addColumn(mealSlots, mealSlots.servings);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
