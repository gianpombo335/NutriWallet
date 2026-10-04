// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dish_dao.dart';

// ignore_for_file: type=lint
mixin _$DishDaoMixin on DatabaseAccessor<AppDatabase> {
  $UserProfilesTable get userProfiles => attachedDatabase.userProfiles;
  $DishesTable get dishes => attachedDatabase.dishes;
  $IngredientsTable get ingredients => attachedDatabase.ingredients;
  DishDaoManager get managers => DishDaoManager(this);
}

class DishDaoManager {
  final _$DishDaoMixin _db;
  DishDaoManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db.attachedDatabase, _db.userProfiles);
  $$DishesTableTableManager get dishes =>
      $$DishesTableTableManager(_db.attachedDatabase, _db.dishes);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db.attachedDatabase, _db.ingredients);
}
