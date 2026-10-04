import 'package:drift/drift.dart';

import '../database.dart';

part 'profile_dao.g.dart';

@DriftAccessor(tables: [UserProfiles, AllergenTags])
class ProfileDao extends DatabaseAccessor<AppDatabase> with _$ProfileDaoMixin {
  ProfileDao(super.db);

  Future<UserProfile?> findByEmail(String email) => (select(
    userProfiles,
  )..where((row) => row.email.equals(email))).getSingleOrNull();

  Future<UserProfile?> findById(int id) => (select(
    userProfiles,
  )..where((row) => row.id.equals(id))).getSingleOrNull();

  Future<int> save(UserProfilesCompanion profile) =>
      into(userProfiles).insert(profile);

  Future<int> updateProfile(UserProfilesCompanion profile) {
    final id = profile.id.value;
    return (update(userProfiles)..where((row) => row.id.equals(id))).write(
      profile.copyWith(id: const Value<int>.absent()),
    );
  }

  Future<List<AllergenTag>> allergensForProfile(int profileId) => (select(
    allergenTags,
  )..where((row) => row.userProfileId.equals(profileId))).get();

  Future<void> addAllergen(int profileId, String label) async {
    final normalized = label.trim().toLowerCase();
    if (normalized.isEmpty) return;
    final existing =
        await (select(allergenTags)..where(
              (row) =>
                  row.userProfileId.equals(profileId) &
                  row.label.equals(normalized),
            ))
            .getSingleOrNull();
    if (existing == null) {
      await into(allergenTags).insert(
        AllergenTagsCompanion.insert(
          userProfileId: profileId,
          label: normalized,
        ),
      );
    }
  }

  Future<void> removeAllergen(int id) =>
      (delete(allergenTags)..where((row) => row.id.equals(id))).go();
}
