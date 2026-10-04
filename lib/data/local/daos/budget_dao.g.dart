// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_dao.dart';

// ignore_for_file: type=lint
mixin _$BudgetDaoMixin on DatabaseAccessor<AppDatabase> {
  $UserProfilesTable get userProfiles => attachedDatabase.userProfiles;
  $GeneratedPlansTable get generatedPlans => attachedDatabase.generatedPlans;
  $DishesTable get dishes => attachedDatabase.dishes;
  $MealSlotsTable get mealSlots => attachedDatabase.mealSlots;
  $BudgetEntriesTable get budgetEntries => attachedDatabase.budgetEntries;
  BudgetDaoManager get managers => BudgetDaoManager(this);
}

class BudgetDaoManager {
  final _$BudgetDaoMixin _db;
  BudgetDaoManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db.attachedDatabase, _db.userProfiles);
  $$GeneratedPlansTableTableManager get generatedPlans =>
      $$GeneratedPlansTableTableManager(
        _db.attachedDatabase,
        _db.generatedPlans,
      );
  $$DishesTableTableManager get dishes =>
      $$DishesTableTableManager(_db.attachedDatabase, _db.dishes);
  $$MealSlotsTableTableManager get mealSlots =>
      $$MealSlotsTableTableManager(_db.attachedDatabase, _db.mealSlots);
  $$BudgetEntriesTableTableManager get budgetEntries =>
      $$BudgetEntriesTableTableManager(_db.attachedDatabase, _db.budgetEntries);
}
