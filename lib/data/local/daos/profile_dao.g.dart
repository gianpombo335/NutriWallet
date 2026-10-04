// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_dao.dart';

// ignore_for_file: type=lint
mixin _$ProfileDaoMixin on DatabaseAccessor<AppDatabase> {
  $UserProfilesTable get userProfiles => attachedDatabase.userProfiles;
  $AllergenTagsTable get allergenTags => attachedDatabase.allergenTags;
  ProfileDaoManager get managers => ProfileDaoManager(this);
}

class ProfileDaoManager {
  final _$ProfileDaoMixin _db;
  ProfileDaoManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db.attachedDatabase, _db.userProfiles);
  $$AllergenTagsTableTableManager get allergenTags =>
      $$AllergenTagsTableTableManager(_db.attachedDatabase, _db.allergenTags);
}
