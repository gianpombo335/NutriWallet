// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weeklyBudgetCentsMeta = const VerificationMeta(
    'weeklyBudgetCents',
  );
  @override
  late final GeneratedColumn<int> weeklyBudgetCents = GeneratedColumn<int>(
    'weekly_budget_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _activeDaysMeta = const VerificationMeta(
    'activeDays',
  );
  @override
  late final GeneratedColumn<String> activeDays = GeneratedColumn<String>(
    'active_days',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1,2,3,4,5,6,7'),
  );
  static const VerificationMeta _mealsPerDayMeta = const VerificationMeta(
    'mealsPerDay',
  );
  @override
  late final GeneratedColumn<int> mealsPerDay = GeneratedColumn<int>(
    'meals_per_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _mealTimesJsonMeta = const VerificationMeta(
    'mealTimesJson',
  );
  @override
  late final GeneratedColumn<String> mealTimesJson = GeneratedColumn<String>(
    'meal_times_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[480,780,1140]'),
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activityLevelMeta = const VerificationMeta(
    'activityLevel',
  );
  @override
  late final GeneratedColumn<String> activityLevel = GeneratedColumn<String>(
    'activity_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('moderate'),
  );
  static const VerificationMeta _goalPresetMeta = const VerificationMeta(
    'goalPreset',
  );
  @override
  late final GeneratedColumn<String> goalPreset = GeneratedColumn<String>(
    'goal_preset',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('balanced'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    displayName,
    weeklyBudgetCents,
    activeDays,
    mealsPerDay,
    mealTimesJson,
    weightKg,
    heightCm,
    age,
    sex,
    activityLevel,
    goalPreset,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('weekly_budget_cents')) {
      context.handle(
        _weeklyBudgetCentsMeta,
        weeklyBudgetCents.isAcceptableOrUnknown(
          data['weekly_budget_cents']!,
          _weeklyBudgetCentsMeta,
        ),
      );
    }
    if (data.containsKey('active_days')) {
      context.handle(
        _activeDaysMeta,
        activeDays.isAcceptableOrUnknown(data['active_days']!, _activeDaysMeta),
      );
    }
    if (data.containsKey('meals_per_day')) {
      context.handle(
        _mealsPerDayMeta,
        mealsPerDay.isAcceptableOrUnknown(
          data['meals_per_day']!,
          _mealsPerDayMeta,
        ),
      );
    }
    if (data.containsKey('meal_times_json')) {
      context.handle(
        _mealTimesJsonMeta,
        mealTimesJson.isAcceptableOrUnknown(
          data['meal_times_json']!,
          _mealTimesJsonMeta,
        ),
      );
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    }
    if (data.containsKey('activity_level')) {
      context.handle(
        _activityLevelMeta,
        activityLevel.isAcceptableOrUnknown(
          data['activity_level']!,
          _activityLevelMeta,
        ),
      );
    }
    if (data.containsKey('goal_preset')) {
      context.handle(
        _goalPresetMeta,
        goalPreset.isAcceptableOrUnknown(data['goal_preset']!, _goalPresetMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      weeklyBudgetCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_budget_cents'],
      )!,
      activeDays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_days'],
      )!,
      mealsPerDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meals_per_day'],
      )!,
      mealTimesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_times_json'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      ),
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      ),
      sex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sex'],
      ),
      activityLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_level'],
      )!,
      goalPreset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_preset'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final int id;
  final String email;
  final String? displayName;
  final int weeklyBudgetCents;
  final String activeDays;
  final int mealsPerDay;
  final String mealTimesJson;
  final double? weightKg;
  final double? heightCm;
  final int? age;
  final String? sex;
  final String activityLevel;
  final String goalPreset;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserProfile({
    required this.id,
    required this.email,
    this.displayName,
    required this.weeklyBudgetCents,
    required this.activeDays,
    required this.mealsPerDay,
    required this.mealTimesJson,
    this.weightKg,
    this.heightCm,
    this.age,
    this.sex,
    required this.activityLevel,
    required this.goalPreset,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['weekly_budget_cents'] = Variable<int>(weeklyBudgetCents);
    map['active_days'] = Variable<String>(activeDays);
    map['meals_per_day'] = Variable<int>(mealsPerDay);
    map['meal_times_json'] = Variable<String>(mealTimesJson);
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<double>(heightCm);
    }
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    if (!nullToAbsent || sex != null) {
      map['sex'] = Variable<String>(sex);
    }
    map['activity_level'] = Variable<String>(activityLevel);
    map['goal_preset'] = Variable<String>(goalPreset);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      email: Value(email),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      weeklyBudgetCents: Value(weeklyBudgetCents),
      activeDays: Value(activeDays),
      mealsPerDay: Value(mealsPerDay),
      mealTimesJson: Value(mealTimesJson),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      sex: sex == null && nullToAbsent ? const Value.absent() : Value(sex),
      activityLevel: Value(activityLevel),
      goalPreset: Value(goalPreset),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<int>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      weeklyBudgetCents: serializer.fromJson<int>(json['weeklyBudgetCents']),
      activeDays: serializer.fromJson<String>(json['activeDays']),
      mealsPerDay: serializer.fromJson<int>(json['mealsPerDay']),
      mealTimesJson: serializer.fromJson<String>(json['mealTimesJson']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      heightCm: serializer.fromJson<double?>(json['heightCm']),
      age: serializer.fromJson<int?>(json['age']),
      sex: serializer.fromJson<String?>(json['sex']),
      activityLevel: serializer.fromJson<String>(json['activityLevel']),
      goalPreset: serializer.fromJson<String>(json['goalPreset']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'email': serializer.toJson<String>(email),
      'displayName': serializer.toJson<String?>(displayName),
      'weeklyBudgetCents': serializer.toJson<int>(weeklyBudgetCents),
      'activeDays': serializer.toJson<String>(activeDays),
      'mealsPerDay': serializer.toJson<int>(mealsPerDay),
      'mealTimesJson': serializer.toJson<String>(mealTimesJson),
      'weightKg': serializer.toJson<double?>(weightKg),
      'heightCm': serializer.toJson<double?>(heightCm),
      'age': serializer.toJson<int?>(age),
      'sex': serializer.toJson<String?>(sex),
      'activityLevel': serializer.toJson<String>(activityLevel),
      'goalPreset': serializer.toJson<String>(goalPreset),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserProfile copyWith({
    int? id,
    String? email,
    Value<String?> displayName = const Value.absent(),
    int? weeklyBudgetCents,
    String? activeDays,
    int? mealsPerDay,
    String? mealTimesJson,
    Value<double?> weightKg = const Value.absent(),
    Value<double?> heightCm = const Value.absent(),
    Value<int?> age = const Value.absent(),
    Value<String?> sex = const Value.absent(),
    String? activityLevel,
    String? goalPreset,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserProfile(
    id: id ?? this.id,
    email: email ?? this.email,
    displayName: displayName.present ? displayName.value : this.displayName,
    weeklyBudgetCents: weeklyBudgetCents ?? this.weeklyBudgetCents,
    activeDays: activeDays ?? this.activeDays,
    mealsPerDay: mealsPerDay ?? this.mealsPerDay,
    mealTimesJson: mealTimesJson ?? this.mealTimesJson,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    heightCm: heightCm.present ? heightCm.value : this.heightCm,
    age: age.present ? age.value : this.age,
    sex: sex.present ? sex.value : this.sex,
    activityLevel: activityLevel ?? this.activityLevel,
    goalPreset: goalPreset ?? this.goalPreset,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      weeklyBudgetCents: data.weeklyBudgetCents.present
          ? data.weeklyBudgetCents.value
          : this.weeklyBudgetCents,
      activeDays: data.activeDays.present
          ? data.activeDays.value
          : this.activeDays,
      mealsPerDay: data.mealsPerDay.present
          ? data.mealsPerDay.value
          : this.mealsPerDay,
      mealTimesJson: data.mealTimesJson.present
          ? data.mealTimesJson.value
          : this.mealTimesJson,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      age: data.age.present ? data.age.value : this.age,
      sex: data.sex.present ? data.sex.value : this.sex,
      activityLevel: data.activityLevel.present
          ? data.activityLevel.value
          : this.activityLevel,
      goalPreset: data.goalPreset.present
          ? data.goalPreset.value
          : this.goalPreset,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('weeklyBudgetCents: $weeklyBudgetCents, ')
          ..write('activeDays: $activeDays, ')
          ..write('mealsPerDay: $mealsPerDay, ')
          ..write('mealTimesJson: $mealTimesJson, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('age: $age, ')
          ..write('sex: $sex, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('goalPreset: $goalPreset, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    displayName,
    weeklyBudgetCents,
    activeDays,
    mealsPerDay,
    mealTimesJson,
    weightKg,
    heightCm,
    age,
    sex,
    activityLevel,
    goalPreset,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.email == this.email &&
          other.displayName == this.displayName &&
          other.weeklyBudgetCents == this.weeklyBudgetCents &&
          other.activeDays == this.activeDays &&
          other.mealsPerDay == this.mealsPerDay &&
          other.mealTimesJson == this.mealTimesJson &&
          other.weightKg == this.weightKg &&
          other.heightCm == this.heightCm &&
          other.age == this.age &&
          other.sex == this.sex &&
          other.activityLevel == this.activityLevel &&
          other.goalPreset == this.goalPreset &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<int> id;
  final Value<String> email;
  final Value<String?> displayName;
  final Value<int> weeklyBudgetCents;
  final Value<String> activeDays;
  final Value<int> mealsPerDay;
  final Value<String> mealTimesJson;
  final Value<double?> weightKg;
  final Value<double?> heightCm;
  final Value<int?> age;
  final Value<String?> sex;
  final Value<String> activityLevel;
  final Value<String> goalPreset;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.displayName = const Value.absent(),
    this.weeklyBudgetCents = const Value.absent(),
    this.activeDays = const Value.absent(),
    this.mealsPerDay = const Value.absent(),
    this.mealTimesJson = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.age = const Value.absent(),
    this.sex = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.goalPreset = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String email,
    this.displayName = const Value.absent(),
    this.weeklyBudgetCents = const Value.absent(),
    this.activeDays = const Value.absent(),
    this.mealsPerDay = const Value.absent(),
    this.mealTimesJson = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.age = const Value.absent(),
    this.sex = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.goalPreset = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : email = Value(email),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UserProfile> custom({
    Expression<int>? id,
    Expression<String>? email,
    Expression<String>? displayName,
    Expression<int>? weeklyBudgetCents,
    Expression<String>? activeDays,
    Expression<int>? mealsPerDay,
    Expression<String>? mealTimesJson,
    Expression<double>? weightKg,
    Expression<double>? heightCm,
    Expression<int>? age,
    Expression<String>? sex,
    Expression<String>? activityLevel,
    Expression<String>? goalPreset,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (displayName != null) 'display_name': displayName,
      if (weeklyBudgetCents != null) 'weekly_budget_cents': weeklyBudgetCents,
      if (activeDays != null) 'active_days': activeDays,
      if (mealsPerDay != null) 'meals_per_day': mealsPerDay,
      if (mealTimesJson != null) 'meal_times_json': mealTimesJson,
      if (weightKg != null) 'weight_kg': weightKg,
      if (heightCm != null) 'height_cm': heightCm,
      if (age != null) 'age': age,
      if (sex != null) 'sex': sex,
      if (activityLevel != null) 'activity_level': activityLevel,
      if (goalPreset != null) 'goal_preset': goalPreset,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? email,
    Value<String?>? displayName,
    Value<int>? weeklyBudgetCents,
    Value<String>? activeDays,
    Value<int>? mealsPerDay,
    Value<String>? mealTimesJson,
    Value<double?>? weightKg,
    Value<double?>? heightCm,
    Value<int?>? age,
    Value<String?>? sex,
    Value<String>? activityLevel,
    Value<String>? goalPreset,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      weeklyBudgetCents: weeklyBudgetCents ?? this.weeklyBudgetCents,
      activeDays: activeDays ?? this.activeDays,
      mealsPerDay: mealsPerDay ?? this.mealsPerDay,
      mealTimesJson: mealTimesJson ?? this.mealTimesJson,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      activityLevel: activityLevel ?? this.activityLevel,
      goalPreset: goalPreset ?? this.goalPreset,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (weeklyBudgetCents.present) {
      map['weekly_budget_cents'] = Variable<int>(weeklyBudgetCents.value);
    }
    if (activeDays.present) {
      map['active_days'] = Variable<String>(activeDays.value);
    }
    if (mealsPerDay.present) {
      map['meals_per_day'] = Variable<int>(mealsPerDay.value);
    }
    if (mealTimesJson.present) {
      map['meal_times_json'] = Variable<String>(mealTimesJson.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (activityLevel.present) {
      map['activity_level'] = Variable<String>(activityLevel.value);
    }
    if (goalPreset.present) {
      map['goal_preset'] = Variable<String>(goalPreset.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('weeklyBudgetCents: $weeklyBudgetCents, ')
          ..write('activeDays: $activeDays, ')
          ..write('mealsPerDay: $mealsPerDay, ')
          ..write('mealTimesJson: $mealTimesJson, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('age: $age, ')
          ..write('sex: $sex, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('goalPreset: $goalPreset, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DishesTable extends Dishes with TableInfo<$DishesTable, Dishe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DishesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userProfileIdMeta = const VerificationMeta(
    'userProfileId',
  );
  @override
  late final GeneratedColumn<int> userProfileId = GeneratedColumn<int>(
    'user_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceCentsMeta = const VerificationMeta(
    'priceCents',
  );
  @override
  late final GeneratedColumn<int> priceCents = GeneratedColumn<int>(
    'price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cuisineTagMeta = const VerificationMeta(
    'cuisineTag',
  );
  @override
  late final GeneratedColumn<String> cuisineTag = GeneratedColumn<String>(
    'cuisine_tag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userProfileId,
    name,
    priceCents,
    cuisineTag,
    photoPath,
    source,
    createdAt,
    updatedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dishes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Dishe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_profile_id')) {
      context.handle(
        _userProfileIdMeta,
        userProfileId.isAcceptableOrUnknown(
          data['user_profile_id']!,
          _userProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_userProfileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price_cents')) {
      context.handle(
        _priceCentsMeta,
        priceCents.isAcceptableOrUnknown(data['price_cents']!, _priceCentsMeta),
      );
    } else if (isInserting) {
      context.missing(_priceCentsMeta);
    }
    if (data.containsKey('cuisine_tag')) {
      context.handle(
        _cuisineTagMeta,
        cuisineTag.isAcceptableOrUnknown(data['cuisine_tag']!, _cuisineTagMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Dishe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Dishe(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_profile_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      priceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_cents'],
      )!,
      cuisineTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cuisine_tag'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $DishesTable createAlias(String alias) {
    return $DishesTable(attachedDatabase, alias);
  }
}

class Dishe extends DataClass implements Insertable<Dishe> {
  final int id;
  final int userProfileId;
  final String name;
  final int priceCents;
  final String? cuisineTag;
  final String? photoPath;
  final String source;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  const Dishe({
    required this.id,
    required this.userProfileId,
    required this.name,
    required this.priceCents,
    this.cuisineTag,
    this.photoPath,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_profile_id'] = Variable<int>(userProfileId);
    map['name'] = Variable<String>(name);
    map['price_cents'] = Variable<int>(priceCents);
    if (!nullToAbsent || cuisineTag != null) {
      map['cuisine_tag'] = Variable<String>(cuisineTag);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['source'] = Variable<String>(source);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  DishesCompanion toCompanion(bool nullToAbsent) {
    return DishesCompanion(
      id: Value(id),
      userProfileId: Value(userProfileId),
      name: Value(name),
      priceCents: Value(priceCents),
      cuisineTag: cuisineTag == null && nullToAbsent
          ? const Value.absent()
          : Value(cuisineTag),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      source: Value(source),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory Dishe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Dishe(
      id: serializer.fromJson<int>(json['id']),
      userProfileId: serializer.fromJson<int>(json['userProfileId']),
      name: serializer.fromJson<String>(json['name']),
      priceCents: serializer.fromJson<int>(json['priceCents']),
      cuisineTag: serializer.fromJson<String?>(json['cuisineTag']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userProfileId': serializer.toJson<int>(userProfileId),
      'name': serializer.toJson<String>(name),
      'priceCents': serializer.toJson<int>(priceCents),
      'cuisineTag': serializer.toJson<String?>(cuisineTag),
      'photoPath': serializer.toJson<String?>(photoPath),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Dishe copyWith({
    int? id,
    int? userProfileId,
    String? name,
    int? priceCents,
    Value<String?> cuisineTag = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    String? source,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) => Dishe(
    id: id ?? this.id,
    userProfileId: userProfileId ?? this.userProfileId,
    name: name ?? this.name,
    priceCents: priceCents ?? this.priceCents,
    cuisineTag: cuisineTag.present ? cuisineTag.value : this.cuisineTag,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Dishe copyWithCompanion(DishesCompanion data) {
    return Dishe(
      id: data.id.present ? data.id.value : this.id,
      userProfileId: data.userProfileId.present
          ? data.userProfileId.value
          : this.userProfileId,
      name: data.name.present ? data.name.value : this.name,
      priceCents: data.priceCents.present
          ? data.priceCents.value
          : this.priceCents,
      cuisineTag: data.cuisineTag.present
          ? data.cuisineTag.value
          : this.cuisineTag,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Dishe(')
          ..write('id: $id, ')
          ..write('userProfileId: $userProfileId, ')
          ..write('name: $name, ')
          ..write('priceCents: $priceCents, ')
          ..write('cuisineTag: $cuisineTag, ')
          ..write('photoPath: $photoPath, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userProfileId,
    name,
    priceCents,
    cuisineTag,
    photoPath,
    source,
    createdAt,
    updatedAt,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dishe &&
          other.id == this.id &&
          other.userProfileId == this.userProfileId &&
          other.name == this.name &&
          other.priceCents == this.priceCents &&
          other.cuisineTag == this.cuisineTag &&
          other.photoPath == this.photoPath &&
          other.source == this.source &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted);
}

class DishesCompanion extends UpdateCompanion<Dishe> {
  final Value<int> id;
  final Value<int> userProfileId;
  final Value<String> name;
  final Value<int> priceCents;
  final Value<String?> cuisineTag;
  final Value<String?> photoPath;
  final Value<String> source;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  const DishesCompanion({
    this.id = const Value.absent(),
    this.userProfileId = const Value.absent(),
    this.name = const Value.absent(),
    this.priceCents = const Value.absent(),
    this.cuisineTag = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  DishesCompanion.insert({
    this.id = const Value.absent(),
    required int userProfileId,
    required String name,
    required int priceCents,
    this.cuisineTag = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.source = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isDeleted = const Value.absent(),
  }) : userProfileId = Value(userProfileId),
       name = Value(name),
       priceCents = Value(priceCents),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Dishe> custom({
    Expression<int>? id,
    Expression<int>? userProfileId,
    Expression<String>? name,
    Expression<int>? priceCents,
    Expression<String>? cuisineTag,
    Expression<String>? photoPath,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userProfileId != null) 'user_profile_id': userProfileId,
      if (name != null) 'name': name,
      if (priceCents != null) 'price_cents': priceCents,
      if (cuisineTag != null) 'cuisine_tag': cuisineTag,
      if (photoPath != null) 'photo_path': photoPath,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  DishesCompanion copyWith({
    Value<int>? id,
    Value<int>? userProfileId,
    Value<String>? name,
    Value<int>? priceCents,
    Value<String?>? cuisineTag,
    Value<String?>? photoPath,
    Value<String>? source,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isDeleted,
  }) {
    return DishesCompanion(
      id: id ?? this.id,
      userProfileId: userProfileId ?? this.userProfileId,
      name: name ?? this.name,
      priceCents: priceCents ?? this.priceCents,
      cuisineTag: cuisineTag ?? this.cuisineTag,
      photoPath: photoPath ?? this.photoPath,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userProfileId.present) {
      map['user_profile_id'] = Variable<int>(userProfileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (priceCents.present) {
      map['price_cents'] = Variable<int>(priceCents.value);
    }
    if (cuisineTag.present) {
      map['cuisine_tag'] = Variable<String>(cuisineTag.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DishesCompanion(')
          ..write('id: $id, ')
          ..write('userProfileId: $userProfileId, ')
          ..write('name: $name, ')
          ..write('priceCents: $priceCents, ')
          ..write('cuisineTag: $cuisineTag, ')
          ..write('photoPath: $photoPath, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $IngredientsTable extends Ingredients
    with TableInfo<$IngredientsTable, Ingredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dishIdMeta = const VerificationMeta('dishId');
  @override
  late final GeneratedColumn<int> dishId = GeneratedColumn<int>(
    'dish_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES dishes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('serving'),
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _proteinGMeta = const VerificationMeta(
    'proteinG',
  );
  @override
  late final GeneratedColumn<double> proteinG = GeneratedColumn<double>(
    'protein_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _carbsGMeta = const VerificationMeta('carbsG');
  @override
  late final GeneratedColumn<double> carbsG = GeneratedColumn<double>(
    'carbs_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fatGMeta = const VerificationMeta('fatG');
  @override
  late final GeneratedColumn<double> fatG = GeneratedColumn<double>(
    'fat_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _micronutrientsJsonMeta =
      const VerificationMeta('micronutrientsJson');
  @override
  late final GeneratedColumn<String> micronutrientsJson =
      GeneratedColumn<String>(
        'micronutrients_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _usdaFdcIdMeta = const VerificationMeta(
    'usdaFdcId',
  );
  @override
  late final GeneratedColumn<int> usdaFdcId = GeneratedColumn<int>(
    'usda_fdc_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCachedFromApiMeta = const VerificationMeta(
    'isCachedFromApi',
  );
  @override
  late final GeneratedColumn<bool> isCachedFromApi = GeneratedColumn<bool>(
    'is_cached_from_api',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_cached_from_api" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dishId,
    name,
    quantity,
    unit,
    calories,
    proteinG,
    carbsG,
    fatG,
    micronutrientsJson,
    usdaFdcId,
    isCachedFromApi,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ingredient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('dish_id')) {
      context.handle(
        _dishIdMeta,
        dishId.isAcceptableOrUnknown(data['dish_id']!, _dishIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dishIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    }
    if (data.containsKey('protein_g')) {
      context.handle(
        _proteinGMeta,
        proteinG.isAcceptableOrUnknown(data['protein_g']!, _proteinGMeta),
      );
    }
    if (data.containsKey('carbs_g')) {
      context.handle(
        _carbsGMeta,
        carbsG.isAcceptableOrUnknown(data['carbs_g']!, _carbsGMeta),
      );
    }
    if (data.containsKey('fat_g')) {
      context.handle(
        _fatGMeta,
        fatG.isAcceptableOrUnknown(data['fat_g']!, _fatGMeta),
      );
    }
    if (data.containsKey('micronutrients_json')) {
      context.handle(
        _micronutrientsJsonMeta,
        micronutrientsJson.isAcceptableOrUnknown(
          data['micronutrients_json']!,
          _micronutrientsJsonMeta,
        ),
      );
    }
    if (data.containsKey('usda_fdc_id')) {
      context.handle(
        _usdaFdcIdMeta,
        usdaFdcId.isAcceptableOrUnknown(data['usda_fdc_id']!, _usdaFdcIdMeta),
      );
    }
    if (data.containsKey('is_cached_from_api')) {
      context.handle(
        _isCachedFromApiMeta,
        isCachedFromApi.isAcceptableOrUnknown(
          data['is_cached_from_api']!,
          _isCachedFromApiMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ingredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ingredient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dishId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dish_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      )!,
      proteinG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_g'],
      )!,
      carbsG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_g'],
      )!,
      fatG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_g'],
      )!,
      micronutrientsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}micronutrients_json'],
      ),
      usdaFdcId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usda_fdc_id'],
      ),
      isCachedFromApi: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_cached_from_api'],
      )!,
    );
  }

  @override
  $IngredientsTable createAlias(String alias) {
    return $IngredientsTable(attachedDatabase, alias);
  }
}

class Ingredient extends DataClass implements Insertable<Ingredient> {
  final int id;
  final int dishId;
  final String name;
  final double quantity;
  final String unit;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final String? micronutrientsJson;
  final int? usdaFdcId;
  final bool isCachedFromApi;
  const Ingredient({
    required this.id,
    required this.dishId,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.micronutrientsJson,
    this.usdaFdcId,
    required this.isCachedFromApi,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dish_id'] = Variable<int>(dishId);
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<double>(quantity);
    map['unit'] = Variable<String>(unit);
    map['calories'] = Variable<double>(calories);
    map['protein_g'] = Variable<double>(proteinG);
    map['carbs_g'] = Variable<double>(carbsG);
    map['fat_g'] = Variable<double>(fatG);
    if (!nullToAbsent || micronutrientsJson != null) {
      map['micronutrients_json'] = Variable<String>(micronutrientsJson);
    }
    if (!nullToAbsent || usdaFdcId != null) {
      map['usda_fdc_id'] = Variable<int>(usdaFdcId);
    }
    map['is_cached_from_api'] = Variable<bool>(isCachedFromApi);
    return map;
  }

  IngredientsCompanion toCompanion(bool nullToAbsent) {
    return IngredientsCompanion(
      id: Value(id),
      dishId: Value(dishId),
      name: Value(name),
      quantity: Value(quantity),
      unit: Value(unit),
      calories: Value(calories),
      proteinG: Value(proteinG),
      carbsG: Value(carbsG),
      fatG: Value(fatG),
      micronutrientsJson: micronutrientsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(micronutrientsJson),
      usdaFdcId: usdaFdcId == null && nullToAbsent
          ? const Value.absent()
          : Value(usdaFdcId),
      isCachedFromApi: Value(isCachedFromApi),
    );
  }

  factory Ingredient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ingredient(
      id: serializer.fromJson<int>(json['id']),
      dishId: serializer.fromJson<int>(json['dishId']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      calories: serializer.fromJson<double>(json['calories']),
      proteinG: serializer.fromJson<double>(json['proteinG']),
      carbsG: serializer.fromJson<double>(json['carbsG']),
      fatG: serializer.fromJson<double>(json['fatG']),
      micronutrientsJson: serializer.fromJson<String?>(
        json['micronutrientsJson'],
      ),
      usdaFdcId: serializer.fromJson<int?>(json['usdaFdcId']),
      isCachedFromApi: serializer.fromJson<bool>(json['isCachedFromApi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dishId': serializer.toJson<int>(dishId),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(unit),
      'calories': serializer.toJson<double>(calories),
      'proteinG': serializer.toJson<double>(proteinG),
      'carbsG': serializer.toJson<double>(carbsG),
      'fatG': serializer.toJson<double>(fatG),
      'micronutrientsJson': serializer.toJson<String?>(micronutrientsJson),
      'usdaFdcId': serializer.toJson<int?>(usdaFdcId),
      'isCachedFromApi': serializer.toJson<bool>(isCachedFromApi),
    };
  }

  Ingredient copyWith({
    int? id,
    int? dishId,
    String? name,
    double? quantity,
    String? unit,
    double? calories,
    double? proteinG,
    double? carbsG,
    double? fatG,
    Value<String?> micronutrientsJson = const Value.absent(),
    Value<int?> usdaFdcId = const Value.absent(),
    bool? isCachedFromApi,
  }) => Ingredient(
    id: id ?? this.id,
    dishId: dishId ?? this.dishId,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    calories: calories ?? this.calories,
    proteinG: proteinG ?? this.proteinG,
    carbsG: carbsG ?? this.carbsG,
    fatG: fatG ?? this.fatG,
    micronutrientsJson: micronutrientsJson.present
        ? micronutrientsJson.value
        : this.micronutrientsJson,
    usdaFdcId: usdaFdcId.present ? usdaFdcId.value : this.usdaFdcId,
    isCachedFromApi: isCachedFromApi ?? this.isCachedFromApi,
  );
  Ingredient copyWithCompanion(IngredientsCompanion data) {
    return Ingredient(
      id: data.id.present ? data.id.value : this.id,
      dishId: data.dishId.present ? data.dishId.value : this.dishId,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      calories: data.calories.present ? data.calories.value : this.calories,
      proteinG: data.proteinG.present ? data.proteinG.value : this.proteinG,
      carbsG: data.carbsG.present ? data.carbsG.value : this.carbsG,
      fatG: data.fatG.present ? data.fatG.value : this.fatG,
      micronutrientsJson: data.micronutrientsJson.present
          ? data.micronutrientsJson.value
          : this.micronutrientsJson,
      usdaFdcId: data.usdaFdcId.present ? data.usdaFdcId.value : this.usdaFdcId,
      isCachedFromApi: data.isCachedFromApi.present
          ? data.isCachedFromApi.value
          : this.isCachedFromApi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ingredient(')
          ..write('id: $id, ')
          ..write('dishId: $dishId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('calories: $calories, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('micronutrientsJson: $micronutrientsJson, ')
          ..write('usdaFdcId: $usdaFdcId, ')
          ..write('isCachedFromApi: $isCachedFromApi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dishId,
    name,
    quantity,
    unit,
    calories,
    proteinG,
    carbsG,
    fatG,
    micronutrientsJson,
    usdaFdcId,
    isCachedFromApi,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ingredient &&
          other.id == this.id &&
          other.dishId == this.dishId &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.calories == this.calories &&
          other.proteinG == this.proteinG &&
          other.carbsG == this.carbsG &&
          other.fatG == this.fatG &&
          other.micronutrientsJson == this.micronutrientsJson &&
          other.usdaFdcId == this.usdaFdcId &&
          other.isCachedFromApi == this.isCachedFromApi);
}

class IngredientsCompanion extends UpdateCompanion<Ingredient> {
  final Value<int> id;
  final Value<int> dishId;
  final Value<String> name;
  final Value<double> quantity;
  final Value<String> unit;
  final Value<double> calories;
  final Value<double> proteinG;
  final Value<double> carbsG;
  final Value<double> fatG;
  final Value<String?> micronutrientsJson;
  final Value<int?> usdaFdcId;
  final Value<bool> isCachedFromApi;
  const IngredientsCompanion({
    this.id = const Value.absent(),
    this.dishId = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.calories = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.micronutrientsJson = const Value.absent(),
    this.usdaFdcId = const Value.absent(),
    this.isCachedFromApi = const Value.absent(),
  });
  IngredientsCompanion.insert({
    this.id = const Value.absent(),
    required int dishId,
    required String name,
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.calories = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.micronutrientsJson = const Value.absent(),
    this.usdaFdcId = const Value.absent(),
    this.isCachedFromApi = const Value.absent(),
  }) : dishId = Value(dishId),
       name = Value(name);
  static Insertable<Ingredient> custom({
    Expression<int>? id,
    Expression<int>? dishId,
    Expression<String>? name,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<double>? calories,
    Expression<double>? proteinG,
    Expression<double>? carbsG,
    Expression<double>? fatG,
    Expression<String>? micronutrientsJson,
    Expression<int>? usdaFdcId,
    Expression<bool>? isCachedFromApi,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dishId != null) 'dish_id': dishId,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (calories != null) 'calories': calories,
      if (proteinG != null) 'protein_g': proteinG,
      if (carbsG != null) 'carbs_g': carbsG,
      if (fatG != null) 'fat_g': fatG,
      if (micronutrientsJson != null) 'micronutrients_json': micronutrientsJson,
      if (usdaFdcId != null) 'usda_fdc_id': usdaFdcId,
      if (isCachedFromApi != null) 'is_cached_from_api': isCachedFromApi,
    });
  }

  IngredientsCompanion copyWith({
    Value<int>? id,
    Value<int>? dishId,
    Value<String>? name,
    Value<double>? quantity,
    Value<String>? unit,
    Value<double>? calories,
    Value<double>? proteinG,
    Value<double>? carbsG,
    Value<double>? fatG,
    Value<String?>? micronutrientsJson,
    Value<int?>? usdaFdcId,
    Value<bool>? isCachedFromApi,
  }) {
    return IngredientsCompanion(
      id: id ?? this.id,
      dishId: dishId ?? this.dishId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      calories: calories ?? this.calories,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatG: fatG ?? this.fatG,
      micronutrientsJson: micronutrientsJson ?? this.micronutrientsJson,
      usdaFdcId: usdaFdcId ?? this.usdaFdcId,
      isCachedFromApi: isCachedFromApi ?? this.isCachedFromApi,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dishId.present) {
      map['dish_id'] = Variable<int>(dishId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (proteinG.present) {
      map['protein_g'] = Variable<double>(proteinG.value);
    }
    if (carbsG.present) {
      map['carbs_g'] = Variable<double>(carbsG.value);
    }
    if (fatG.present) {
      map['fat_g'] = Variable<double>(fatG.value);
    }
    if (micronutrientsJson.present) {
      map['micronutrients_json'] = Variable<String>(micronutrientsJson.value);
    }
    if (usdaFdcId.present) {
      map['usda_fdc_id'] = Variable<int>(usdaFdcId.value);
    }
    if (isCachedFromApi.present) {
      map['is_cached_from_api'] = Variable<bool>(isCachedFromApi.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientsCompanion(')
          ..write('id: $id, ')
          ..write('dishId: $dishId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('calories: $calories, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('micronutrientsJson: $micronutrientsJson, ')
          ..write('usdaFdcId: $usdaFdcId, ')
          ..write('isCachedFromApi: $isCachedFromApi')
          ..write(')'))
        .toString();
  }
}

class $NutritionCachesTable extends NutritionCaches
    with TableInfo<$NutritionCachesTable, NutritionCache> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NutritionCachesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinGMeta = const VerificationMeta(
    'proteinG',
  );
  @override
  late final GeneratedColumn<double> proteinG = GeneratedColumn<double>(
    'protein_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsGMeta = const VerificationMeta('carbsG');
  @override
  late final GeneratedColumn<double> carbsG = GeneratedColumn<double>(
    'carbs_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatGMeta = const VerificationMeta('fatG');
  @override
  late final GeneratedColumn<double> fatG = GeneratedColumn<double>(
    'fat_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usdaFdcIdMeta = const VerificationMeta(
    'usdaFdcId',
  );
  @override
  late final GeneratedColumn<int> usdaFdcId = GeneratedColumn<int>(
    'usda_fdc_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    name,
    calories,
    proteinG,
    carbsG,
    fatG,
    usdaFdcId,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nutrition_caches';
  @override
  VerificationContext validateIntegrity(
    Insertable<NutritionCache> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('protein_g')) {
      context.handle(
        _proteinGMeta,
        proteinG.isAcceptableOrUnknown(data['protein_g']!, _proteinGMeta),
      );
    } else if (isInserting) {
      context.missing(_proteinGMeta);
    }
    if (data.containsKey('carbs_g')) {
      context.handle(
        _carbsGMeta,
        carbsG.isAcceptableOrUnknown(data['carbs_g']!, _carbsGMeta),
      );
    } else if (isInserting) {
      context.missing(_carbsGMeta);
    }
    if (data.containsKey('fat_g')) {
      context.handle(
        _fatGMeta,
        fatG.isAcceptableOrUnknown(data['fat_g']!, _fatGMeta),
      );
    } else if (isInserting) {
      context.missing(_fatGMeta);
    }
    if (data.containsKey('usda_fdc_id')) {
      context.handle(
        _usdaFdcIdMeta,
        usdaFdcId.isAcceptableOrUnknown(data['usda_fdc_id']!, _usdaFdcIdMeta),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name};
  @override
  NutritionCache map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NutritionCache(
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      )!,
      proteinG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_g'],
      )!,
      carbsG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_g'],
      )!,
      fatG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_g'],
      )!,
      usdaFdcId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usda_fdc_id'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $NutritionCachesTable createAlias(String alias) {
    return $NutritionCachesTable(attachedDatabase, alias);
  }
}

class NutritionCache extends DataClass implements Insertable<NutritionCache> {
  final String name;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final int? usdaFdcId;
  final DateTime cachedAt;
  const NutritionCache({
    required this.name,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.usdaFdcId,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['calories'] = Variable<double>(calories);
    map['protein_g'] = Variable<double>(proteinG);
    map['carbs_g'] = Variable<double>(carbsG);
    map['fat_g'] = Variable<double>(fatG);
    if (!nullToAbsent || usdaFdcId != null) {
      map['usda_fdc_id'] = Variable<int>(usdaFdcId);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  NutritionCachesCompanion toCompanion(bool nullToAbsent) {
    return NutritionCachesCompanion(
      name: Value(name),
      calories: Value(calories),
      proteinG: Value(proteinG),
      carbsG: Value(carbsG),
      fatG: Value(fatG),
      usdaFdcId: usdaFdcId == null && nullToAbsent
          ? const Value.absent()
          : Value(usdaFdcId),
      cachedAt: Value(cachedAt),
    );
  }

  factory NutritionCache.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NutritionCache(
      name: serializer.fromJson<String>(json['name']),
      calories: serializer.fromJson<double>(json['calories']),
      proteinG: serializer.fromJson<double>(json['proteinG']),
      carbsG: serializer.fromJson<double>(json['carbsG']),
      fatG: serializer.fromJson<double>(json['fatG']),
      usdaFdcId: serializer.fromJson<int?>(json['usdaFdcId']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'calories': serializer.toJson<double>(calories),
      'proteinG': serializer.toJson<double>(proteinG),
      'carbsG': serializer.toJson<double>(carbsG),
      'fatG': serializer.toJson<double>(fatG),
      'usdaFdcId': serializer.toJson<int?>(usdaFdcId),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  NutritionCache copyWith({
    String? name,
    double? calories,
    double? proteinG,
    double? carbsG,
    double? fatG,
    Value<int?> usdaFdcId = const Value.absent(),
    DateTime? cachedAt,
  }) => NutritionCache(
    name: name ?? this.name,
    calories: calories ?? this.calories,
    proteinG: proteinG ?? this.proteinG,
    carbsG: carbsG ?? this.carbsG,
    fatG: fatG ?? this.fatG,
    usdaFdcId: usdaFdcId.present ? usdaFdcId.value : this.usdaFdcId,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  NutritionCache copyWithCompanion(NutritionCachesCompanion data) {
    return NutritionCache(
      name: data.name.present ? data.name.value : this.name,
      calories: data.calories.present ? data.calories.value : this.calories,
      proteinG: data.proteinG.present ? data.proteinG.value : this.proteinG,
      carbsG: data.carbsG.present ? data.carbsG.value : this.carbsG,
      fatG: data.fatG.present ? data.fatG.value : this.fatG,
      usdaFdcId: data.usdaFdcId.present ? data.usdaFdcId.value : this.usdaFdcId,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NutritionCache(')
          ..write('name: $name, ')
          ..write('calories: $calories, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('usdaFdcId: $usdaFdcId, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(name, calories, proteinG, carbsG, fatG, usdaFdcId, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NutritionCache &&
          other.name == this.name &&
          other.calories == this.calories &&
          other.proteinG == this.proteinG &&
          other.carbsG == this.carbsG &&
          other.fatG == this.fatG &&
          other.usdaFdcId == this.usdaFdcId &&
          other.cachedAt == this.cachedAt);
}

class NutritionCachesCompanion extends UpdateCompanion<NutritionCache> {
  final Value<String> name;
  final Value<double> calories;
  final Value<double> proteinG;
  final Value<double> carbsG;
  final Value<double> fatG;
  final Value<int?> usdaFdcId;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const NutritionCachesCompanion({
    this.name = const Value.absent(),
    this.calories = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.usdaFdcId = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NutritionCachesCompanion.insert({
    required String name,
    required double calories,
    required double proteinG,
    required double carbsG,
    required double fatG,
    this.usdaFdcId = const Value.absent(),
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       calories = Value(calories),
       proteinG = Value(proteinG),
       carbsG = Value(carbsG),
       fatG = Value(fatG),
       cachedAt = Value(cachedAt);
  static Insertable<NutritionCache> custom({
    Expression<String>? name,
    Expression<double>? calories,
    Expression<double>? proteinG,
    Expression<double>? carbsG,
    Expression<double>? fatG,
    Expression<int>? usdaFdcId,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (calories != null) 'calories': calories,
      if (proteinG != null) 'protein_g': proteinG,
      if (carbsG != null) 'carbs_g': carbsG,
      if (fatG != null) 'fat_g': fatG,
      if (usdaFdcId != null) 'usda_fdc_id': usdaFdcId,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NutritionCachesCompanion copyWith({
    Value<String>? name,
    Value<double>? calories,
    Value<double>? proteinG,
    Value<double>? carbsG,
    Value<double>? fatG,
    Value<int?>? usdaFdcId,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return NutritionCachesCompanion(
      name: name ?? this.name,
      calories: calories ?? this.calories,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatG: fatG ?? this.fatG,
      usdaFdcId: usdaFdcId ?? this.usdaFdcId,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (proteinG.present) {
      map['protein_g'] = Variable<double>(proteinG.value);
    }
    if (carbsG.present) {
      map['carbs_g'] = Variable<double>(carbsG.value);
    }
    if (fatG.present) {
      map['fat_g'] = Variable<double>(fatG.value);
    }
    if (usdaFdcId.present) {
      map['usda_fdc_id'] = Variable<int>(usdaFdcId.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NutritionCachesCompanion(')
          ..write('name: $name, ')
          ..write('calories: $calories, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('usdaFdcId: $usdaFdcId, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AllergenTagsTable extends AllergenTags
    with TableInfo<$AllergenTagsTable, AllergenTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AllergenTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userProfileIdMeta = const VerificationMeta(
    'userProfileId',
  );
  @override
  late final GeneratedColumn<int> userProfileId = GeneratedColumn<int>(
    'user_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, userProfileId, label];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'allergen_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<AllergenTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_profile_id')) {
      context.handle(
        _userProfileIdMeta,
        userProfileId.isAcceptableOrUnknown(
          data['user_profile_id']!,
          _userProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_userProfileIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AllergenTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AllergenTag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_profile_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
    );
  }

  @override
  $AllergenTagsTable createAlias(String alias) {
    return $AllergenTagsTable(attachedDatabase, alias);
  }
}

class AllergenTag extends DataClass implements Insertable<AllergenTag> {
  final int id;
  final int userProfileId;
  final String label;
  const AllergenTag({
    required this.id,
    required this.userProfileId,
    required this.label,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_profile_id'] = Variable<int>(userProfileId);
    map['label'] = Variable<String>(label);
    return map;
  }

  AllergenTagsCompanion toCompanion(bool nullToAbsent) {
    return AllergenTagsCompanion(
      id: Value(id),
      userProfileId: Value(userProfileId),
      label: Value(label),
    );
  }

  factory AllergenTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AllergenTag(
      id: serializer.fromJson<int>(json['id']),
      userProfileId: serializer.fromJson<int>(json['userProfileId']),
      label: serializer.fromJson<String>(json['label']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userProfileId': serializer.toJson<int>(userProfileId),
      'label': serializer.toJson<String>(label),
    };
  }

  AllergenTag copyWith({int? id, int? userProfileId, String? label}) =>
      AllergenTag(
        id: id ?? this.id,
        userProfileId: userProfileId ?? this.userProfileId,
        label: label ?? this.label,
      );
  AllergenTag copyWithCompanion(AllergenTagsCompanion data) {
    return AllergenTag(
      id: data.id.present ? data.id.value : this.id,
      userProfileId: data.userProfileId.present
          ? data.userProfileId.value
          : this.userProfileId,
      label: data.label.present ? data.label.value : this.label,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AllergenTag(')
          ..write('id: $id, ')
          ..write('userProfileId: $userProfileId, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userProfileId, label);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AllergenTag &&
          other.id == this.id &&
          other.userProfileId == this.userProfileId &&
          other.label == this.label);
}

class AllergenTagsCompanion extends UpdateCompanion<AllergenTag> {
  final Value<int> id;
  final Value<int> userProfileId;
  final Value<String> label;
  const AllergenTagsCompanion({
    this.id = const Value.absent(),
    this.userProfileId = const Value.absent(),
    this.label = const Value.absent(),
  });
  AllergenTagsCompanion.insert({
    this.id = const Value.absent(),
    required int userProfileId,
    required String label,
  }) : userProfileId = Value(userProfileId),
       label = Value(label);
  static Insertable<AllergenTag> custom({
    Expression<int>? id,
    Expression<int>? userProfileId,
    Expression<String>? label,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userProfileId != null) 'user_profile_id': userProfileId,
      if (label != null) 'label': label,
    });
  }

  AllergenTagsCompanion copyWith({
    Value<int>? id,
    Value<int>? userProfileId,
    Value<String>? label,
  }) {
    return AllergenTagsCompanion(
      id: id ?? this.id,
      userProfileId: userProfileId ?? this.userProfileId,
      label: label ?? this.label,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userProfileId.present) {
      map['user_profile_id'] = Variable<int>(userProfileId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AllergenTagsCompanion(')
          ..write('id: $id, ')
          ..write('userProfileId: $userProfileId, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }
}

class $DishAllergenTagsTable extends DishAllergenTags
    with TableInfo<$DishAllergenTagsTable, DishAllergenTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DishAllergenTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dishIdMeta = const VerificationMeta('dishId');
  @override
  late final GeneratedColumn<int> dishId = GeneratedColumn<int>(
    'dish_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES dishes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _allergenTagIdMeta = const VerificationMeta(
    'allergenTagId',
  );
  @override
  late final GeneratedColumn<int> allergenTagId = GeneratedColumn<int>(
    'allergen_tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES allergen_tags (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [dishId, allergenTagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dish_allergen_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<DishAllergenTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('dish_id')) {
      context.handle(
        _dishIdMeta,
        dishId.isAcceptableOrUnknown(data['dish_id']!, _dishIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dishIdMeta);
    }
    if (data.containsKey('allergen_tag_id')) {
      context.handle(
        _allergenTagIdMeta,
        allergenTagId.isAcceptableOrUnknown(
          data['allergen_tag_id']!,
          _allergenTagIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_allergenTagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dishId, allergenTagId};
  @override
  DishAllergenTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DishAllergenTag(
      dishId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dish_id'],
      )!,
      allergenTagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allergen_tag_id'],
      )!,
    );
  }

  @override
  $DishAllergenTagsTable createAlias(String alias) {
    return $DishAllergenTagsTable(attachedDatabase, alias);
  }
}

class DishAllergenTag extends DataClass implements Insertable<DishAllergenTag> {
  final int dishId;
  final int allergenTagId;
  const DishAllergenTag({required this.dishId, required this.allergenTagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['dish_id'] = Variable<int>(dishId);
    map['allergen_tag_id'] = Variable<int>(allergenTagId);
    return map;
  }

  DishAllergenTagsCompanion toCompanion(bool nullToAbsent) {
    return DishAllergenTagsCompanion(
      dishId: Value(dishId),
      allergenTagId: Value(allergenTagId),
    );
  }

  factory DishAllergenTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DishAllergenTag(
      dishId: serializer.fromJson<int>(json['dishId']),
      allergenTagId: serializer.fromJson<int>(json['allergenTagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dishId': serializer.toJson<int>(dishId),
      'allergenTagId': serializer.toJson<int>(allergenTagId),
    };
  }

  DishAllergenTag copyWith({int? dishId, int? allergenTagId}) =>
      DishAllergenTag(
        dishId: dishId ?? this.dishId,
        allergenTagId: allergenTagId ?? this.allergenTagId,
      );
  DishAllergenTag copyWithCompanion(DishAllergenTagsCompanion data) {
    return DishAllergenTag(
      dishId: data.dishId.present ? data.dishId.value : this.dishId,
      allergenTagId: data.allergenTagId.present
          ? data.allergenTagId.value
          : this.allergenTagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DishAllergenTag(')
          ..write('dishId: $dishId, ')
          ..write('allergenTagId: $allergenTagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(dishId, allergenTagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DishAllergenTag &&
          other.dishId == this.dishId &&
          other.allergenTagId == this.allergenTagId);
}

class DishAllergenTagsCompanion extends UpdateCompanion<DishAllergenTag> {
  final Value<int> dishId;
  final Value<int> allergenTagId;
  final Value<int> rowid;
  const DishAllergenTagsCompanion({
    this.dishId = const Value.absent(),
    this.allergenTagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DishAllergenTagsCompanion.insert({
    required int dishId,
    required int allergenTagId,
    this.rowid = const Value.absent(),
  }) : dishId = Value(dishId),
       allergenTagId = Value(allergenTagId);
  static Insertable<DishAllergenTag> custom({
    Expression<int>? dishId,
    Expression<int>? allergenTagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dishId != null) 'dish_id': dishId,
      if (allergenTagId != null) 'allergen_tag_id': allergenTagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DishAllergenTagsCompanion copyWith({
    Value<int>? dishId,
    Value<int>? allergenTagId,
    Value<int>? rowid,
  }) {
    return DishAllergenTagsCompanion(
      dishId: dishId ?? this.dishId,
      allergenTagId: allergenTagId ?? this.allergenTagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dishId.present) {
      map['dish_id'] = Variable<int>(dishId.value);
    }
    if (allergenTagId.present) {
      map['allergen_tag_id'] = Variable<int>(allergenTagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DishAllergenTagsCompanion(')
          ..write('dishId: $dishId, ')
          ..write('allergenTagId: $allergenTagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GeneratedPlansTable extends GeneratedPlans
    with TableInfo<$GeneratedPlansTable, GeneratedPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GeneratedPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userProfileIdMeta = const VerificationMeta(
    'userProfileId',
  );
  @override
  late final GeneratedColumn<int> userProfileId = GeneratedColumn<int>(
    'user_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _weekStartDateMeta = const VerificationMeta(
    'weekStartDate',
  );
  @override
  late final GeneratedColumn<DateTime> weekStartDate =
      GeneratedColumn<DateTime>(
        'week_start_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _generatedAtMeta = const VerificationMeta(
    'generatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
    'generated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalProjectedCostCentsMeta =
      const VerificationMeta('totalProjectedCostCents');
  @override
  late final GeneratedColumn<int> totalProjectedCostCents =
      GeneratedColumn<int>(
        'total_projected_cost_cents',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _isOverBudgetMeta = const VerificationMeta(
    'isOverBudget',
  );
  @override
  late final GeneratedColumn<bool> isOverBudget = GeneratedColumn<bool>(
    'is_over_budget',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_over_budget" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _planningFocusMeta = const VerificationMeta(
    'planningFocus',
  );
  @override
  late final GeneratedColumn<String> planningFocus = GeneratedColumn<String>(
    'planning_focus',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('balanced'),
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userProfileId,
    weekStartDate,
    generatedAt,
    totalProjectedCostCents,
    isOverBudget,
    version,
    isActive,
    planningFocus,
    currencyCode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'generated_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<GeneratedPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_profile_id')) {
      context.handle(
        _userProfileIdMeta,
        userProfileId.isAcceptableOrUnknown(
          data['user_profile_id']!,
          _userProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_userProfileIdMeta);
    }
    if (data.containsKey('week_start_date')) {
      context.handle(
        _weekStartDateMeta,
        weekStartDate.isAcceptableOrUnknown(
          data['week_start_date']!,
          _weekStartDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weekStartDateMeta);
    }
    if (data.containsKey('generated_at')) {
      context.handle(
        _generatedAtMeta,
        generatedAt.isAcceptableOrUnknown(
          data['generated_at']!,
          _generatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    if (data.containsKey('total_projected_cost_cents')) {
      context.handle(
        _totalProjectedCostCentsMeta,
        totalProjectedCostCents.isAcceptableOrUnknown(
          data['total_projected_cost_cents']!,
          _totalProjectedCostCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalProjectedCostCentsMeta);
    }
    if (data.containsKey('is_over_budget')) {
      context.handle(
        _isOverBudgetMeta,
        isOverBudget.isAcceptableOrUnknown(
          data['is_over_budget']!,
          _isOverBudgetMeta,
        ),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('planning_focus')) {
      context.handle(
        _planningFocusMeta,
        planningFocus.isAcceptableOrUnknown(
          data['planning_focus']!,
          _planningFocusMeta,
        ),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GeneratedPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GeneratedPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_profile_id'],
      )!,
      weekStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}week_start_date'],
      )!,
      generatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}generated_at'],
      )!,
      totalProjectedCostCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_projected_cost_cents'],
      )!,
      isOverBudget: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_over_budget'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      planningFocus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}planning_focus'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
    );
  }

  @override
  $GeneratedPlansTable createAlias(String alias) {
    return $GeneratedPlansTable(attachedDatabase, alias);
  }
}

class GeneratedPlan extends DataClass implements Insertable<GeneratedPlan> {
  final int id;
  final int userProfileId;
  final DateTime weekStartDate;
  final DateTime generatedAt;
  final int totalProjectedCostCents;
  final bool isOverBudget;
  final int version;
  final bool isActive;
  final String planningFocus;
  final String currencyCode;
  const GeneratedPlan({
    required this.id,
    required this.userProfileId,
    required this.weekStartDate,
    required this.generatedAt,
    required this.totalProjectedCostCents,
    required this.isOverBudget,
    required this.version,
    required this.isActive,
    required this.planningFocus,
    required this.currencyCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_profile_id'] = Variable<int>(userProfileId);
    map['week_start_date'] = Variable<DateTime>(weekStartDate);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    map['total_projected_cost_cents'] = Variable<int>(totalProjectedCostCents);
    map['is_over_budget'] = Variable<bool>(isOverBudget);
    map['version'] = Variable<int>(version);
    map['is_active'] = Variable<bool>(isActive);
    map['planning_focus'] = Variable<String>(planningFocus);
    map['currency_code'] = Variable<String>(currencyCode);
    return map;
  }

  GeneratedPlansCompanion toCompanion(bool nullToAbsent) {
    return GeneratedPlansCompanion(
      id: Value(id),
      userProfileId: Value(userProfileId),
      weekStartDate: Value(weekStartDate),
      generatedAt: Value(generatedAt),
      totalProjectedCostCents: Value(totalProjectedCostCents),
      isOverBudget: Value(isOverBudget),
      version: Value(version),
      isActive: Value(isActive),
      planningFocus: Value(planningFocus),
      currencyCode: Value(currencyCode),
    );
  }

  factory GeneratedPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GeneratedPlan(
      id: serializer.fromJson<int>(json['id']),
      userProfileId: serializer.fromJson<int>(json['userProfileId']),
      weekStartDate: serializer.fromJson<DateTime>(json['weekStartDate']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
      totalProjectedCostCents: serializer.fromJson<int>(
        json['totalProjectedCostCents'],
      ),
      isOverBudget: serializer.fromJson<bool>(json['isOverBudget']),
      version: serializer.fromJson<int>(json['version']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      planningFocus: serializer.fromJson<String>(json['planningFocus']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userProfileId': serializer.toJson<int>(userProfileId),
      'weekStartDate': serializer.toJson<DateTime>(weekStartDate),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
      'totalProjectedCostCents': serializer.toJson<int>(
        totalProjectedCostCents,
      ),
      'isOverBudget': serializer.toJson<bool>(isOverBudget),
      'version': serializer.toJson<int>(version),
      'isActive': serializer.toJson<bool>(isActive),
      'planningFocus': serializer.toJson<String>(planningFocus),
      'currencyCode': serializer.toJson<String>(currencyCode),
    };
  }

  GeneratedPlan copyWith({
    int? id,
    int? userProfileId,
    DateTime? weekStartDate,
    DateTime? generatedAt,
    int? totalProjectedCostCents,
    bool? isOverBudget,
    int? version,
    bool? isActive,
    String? planningFocus,
    String? currencyCode,
  }) => GeneratedPlan(
    id: id ?? this.id,
    userProfileId: userProfileId ?? this.userProfileId,
    weekStartDate: weekStartDate ?? this.weekStartDate,
    generatedAt: generatedAt ?? this.generatedAt,
    totalProjectedCostCents:
        totalProjectedCostCents ?? this.totalProjectedCostCents,
    isOverBudget: isOverBudget ?? this.isOverBudget,
    version: version ?? this.version,
    isActive: isActive ?? this.isActive,
    planningFocus: planningFocus ?? this.planningFocus,
    currencyCode: currencyCode ?? this.currencyCode,
  );
  GeneratedPlan copyWithCompanion(GeneratedPlansCompanion data) {
    return GeneratedPlan(
      id: data.id.present ? data.id.value : this.id,
      userProfileId: data.userProfileId.present
          ? data.userProfileId.value
          : this.userProfileId,
      weekStartDate: data.weekStartDate.present
          ? data.weekStartDate.value
          : this.weekStartDate,
      generatedAt: data.generatedAt.present
          ? data.generatedAt.value
          : this.generatedAt,
      totalProjectedCostCents: data.totalProjectedCostCents.present
          ? data.totalProjectedCostCents.value
          : this.totalProjectedCostCents,
      isOverBudget: data.isOverBudget.present
          ? data.isOverBudget.value
          : this.isOverBudget,
      version: data.version.present ? data.version.value : this.version,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      planningFocus: data.planningFocus.present
          ? data.planningFocus.value
          : this.planningFocus,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GeneratedPlan(')
          ..write('id: $id, ')
          ..write('userProfileId: $userProfileId, ')
          ..write('weekStartDate: $weekStartDate, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('totalProjectedCostCents: $totalProjectedCostCents, ')
          ..write('isOverBudget: $isOverBudget, ')
          ..write('version: $version, ')
          ..write('isActive: $isActive, ')
          ..write('planningFocus: $planningFocus, ')
          ..write('currencyCode: $currencyCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userProfileId,
    weekStartDate,
    generatedAt,
    totalProjectedCostCents,
    isOverBudget,
    version,
    isActive,
    planningFocus,
    currencyCode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GeneratedPlan &&
          other.id == this.id &&
          other.userProfileId == this.userProfileId &&
          other.weekStartDate == this.weekStartDate &&
          other.generatedAt == this.generatedAt &&
          other.totalProjectedCostCents == this.totalProjectedCostCents &&
          other.isOverBudget == this.isOverBudget &&
          other.version == this.version &&
          other.isActive == this.isActive &&
          other.planningFocus == this.planningFocus &&
          other.currencyCode == this.currencyCode);
}

class GeneratedPlansCompanion extends UpdateCompanion<GeneratedPlan> {
  final Value<int> id;
  final Value<int> userProfileId;
  final Value<DateTime> weekStartDate;
  final Value<DateTime> generatedAt;
  final Value<int> totalProjectedCostCents;
  final Value<bool> isOverBudget;
  final Value<int> version;
  final Value<bool> isActive;
  final Value<String> planningFocus;
  final Value<String> currencyCode;
  const GeneratedPlansCompanion({
    this.id = const Value.absent(),
    this.userProfileId = const Value.absent(),
    this.weekStartDate = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.totalProjectedCostCents = const Value.absent(),
    this.isOverBudget = const Value.absent(),
    this.version = const Value.absent(),
    this.isActive = const Value.absent(),
    this.planningFocus = const Value.absent(),
    this.currencyCode = const Value.absent(),
  });
  GeneratedPlansCompanion.insert({
    this.id = const Value.absent(),
    required int userProfileId,
    required DateTime weekStartDate,
    required DateTime generatedAt,
    required int totalProjectedCostCents,
    this.isOverBudget = const Value.absent(),
    required int version,
    this.isActive = const Value.absent(),
    this.planningFocus = const Value.absent(),
    this.currencyCode = const Value.absent(),
  }) : userProfileId = Value(userProfileId),
       weekStartDate = Value(weekStartDate),
       generatedAt = Value(generatedAt),
       totalProjectedCostCents = Value(totalProjectedCostCents),
       version = Value(version);
  static Insertable<GeneratedPlan> custom({
    Expression<int>? id,
    Expression<int>? userProfileId,
    Expression<DateTime>? weekStartDate,
    Expression<DateTime>? generatedAt,
    Expression<int>? totalProjectedCostCents,
    Expression<bool>? isOverBudget,
    Expression<int>? version,
    Expression<bool>? isActive,
    Expression<String>? planningFocus,
    Expression<String>? currencyCode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userProfileId != null) 'user_profile_id': userProfileId,
      if (weekStartDate != null) 'week_start_date': weekStartDate,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (totalProjectedCostCents != null)
        'total_projected_cost_cents': totalProjectedCostCents,
      if (isOverBudget != null) 'is_over_budget': isOverBudget,
      if (version != null) 'version': version,
      if (isActive != null) 'is_active': isActive,
      if (planningFocus != null) 'planning_focus': planningFocus,
      if (currencyCode != null) 'currency_code': currencyCode,
    });
  }

  GeneratedPlansCompanion copyWith({
    Value<int>? id,
    Value<int>? userProfileId,
    Value<DateTime>? weekStartDate,
    Value<DateTime>? generatedAt,
    Value<int>? totalProjectedCostCents,
    Value<bool>? isOverBudget,
    Value<int>? version,
    Value<bool>? isActive,
    Value<String>? planningFocus,
    Value<String>? currencyCode,
  }) {
    return GeneratedPlansCompanion(
      id: id ?? this.id,
      userProfileId: userProfileId ?? this.userProfileId,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      generatedAt: generatedAt ?? this.generatedAt,
      totalProjectedCostCents:
          totalProjectedCostCents ?? this.totalProjectedCostCents,
      isOverBudget: isOverBudget ?? this.isOverBudget,
      version: version ?? this.version,
      isActive: isActive ?? this.isActive,
      planningFocus: planningFocus ?? this.planningFocus,
      currencyCode: currencyCode ?? this.currencyCode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userProfileId.present) {
      map['user_profile_id'] = Variable<int>(userProfileId.value);
    }
    if (weekStartDate.present) {
      map['week_start_date'] = Variable<DateTime>(weekStartDate.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (totalProjectedCostCents.present) {
      map['total_projected_cost_cents'] = Variable<int>(
        totalProjectedCostCents.value,
      );
    }
    if (isOverBudget.present) {
      map['is_over_budget'] = Variable<bool>(isOverBudget.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (planningFocus.present) {
      map['planning_focus'] = Variable<String>(planningFocus.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GeneratedPlansCompanion(')
          ..write('id: $id, ')
          ..write('userProfileId: $userProfileId, ')
          ..write('weekStartDate: $weekStartDate, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('totalProjectedCostCents: $totalProjectedCostCents, ')
          ..write('isOverBudget: $isOverBudget, ')
          ..write('version: $version, ')
          ..write('isActive: $isActive, ')
          ..write('planningFocus: $planningFocus, ')
          ..write('currencyCode: $currencyCode')
          ..write(')'))
        .toString();
  }
}

class $MealSlotsTable extends MealSlots
    with TableInfo<$MealSlotsTable, MealSlot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealSlotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _generatedPlanIdMeta = const VerificationMeta(
    'generatedPlanId',
  );
  @override
  late final GeneratedColumn<int> generatedPlanId = GeneratedColumn<int>(
    'generated_plan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES generated_plans (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dayIndexMeta = const VerificationMeta(
    'dayIndex',
  );
  @override
  late final GeneratedColumn<int> dayIndex = GeneratedColumn<int>(
    'day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slotIndexMeta = const VerificationMeta(
    'slotIndex',
  );
  @override
  late final GeneratedColumn<int> slotIndex = GeneratedColumn<int>(
    'slot_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dishIdMeta = const VerificationMeta('dishId');
  @override
  late final GeneratedColumn<int> dishId = GeneratedColumn<int>(
    'dish_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES dishes (id)',
    ),
  );
  static const VerificationMeta _plannedCostCentsMeta = const VerificationMeta(
    'plannedCostCents',
  );
  @override
  late final GeneratedColumn<int> plannedCostCents = GeneratedColumn<int>(
    'planned_cost_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedCaloriesMeta = const VerificationMeta(
    'plannedCalories',
  );
  @override
  late final GeneratedColumn<double> plannedCalories = GeneratedColumn<double>(
    'planned_calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _plannedProteinGMeta = const VerificationMeta(
    'plannedProteinG',
  );
  @override
  late final GeneratedColumn<double> plannedProteinG = GeneratedColumn<double>(
    'planned_protein_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _plannedCarbsGMeta = const VerificationMeta(
    'plannedCarbsG',
  );
  @override
  late final GeneratedColumn<double> plannedCarbsG = GeneratedColumn<double>(
    'planned_carbs_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _plannedFatGMeta = const VerificationMeta(
    'plannedFatG',
  );
  @override
  late final GeneratedColumn<double> plannedFatG = GeneratedColumn<double>(
    'planned_fat_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _servingsMeta = const VerificationMeta(
    'servings',
  );
  @override
  late final GeneratedColumn<double> servings = GeneratedColumn<double>(
    'servings',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _mealStatusMeta = const VerificationMeta(
    'mealStatus',
  );
  @override
  late final GeneratedColumn<String> mealStatus = GeneratedColumn<String>(
    'meal_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('planned'),
  );
  static const VerificationMeta _actualCostCentsMeta = const VerificationMeta(
    'actualCostCents',
  );
  @override
  late final GeneratedColumn<int> actualCostCents = GeneratedColumn<int>(
    'actual_cost_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _substituteNameMeta = const VerificationMeta(
    'substituteName',
  );
  @override
  late final GeneratedColumn<String> substituteName = GeneratedColumn<String>(
    'substitute_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _consumedAtMeta = const VerificationMeta(
    'consumedAt',
  );
  @override
  late final GeneratedColumn<DateTime> consumedAt = GeneratedColumn<DateTime>(
    'consumed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    generatedPlanId,
    dayIndex,
    slotIndex,
    dishId,
    plannedCostCents,
    plannedCalories,
    plannedProteinG,
    plannedCarbsG,
    plannedFatG,
    servings,
    mealStatus,
    actualCostCents,
    substituteName,
    consumedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_slots';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealSlot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('generated_plan_id')) {
      context.handle(
        _generatedPlanIdMeta,
        generatedPlanId.isAcceptableOrUnknown(
          data['generated_plan_id']!,
          _generatedPlanIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generatedPlanIdMeta);
    }
    if (data.containsKey('day_index')) {
      context.handle(
        _dayIndexMeta,
        dayIndex.isAcceptableOrUnknown(data['day_index']!, _dayIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIndexMeta);
    }
    if (data.containsKey('slot_index')) {
      context.handle(
        _slotIndexMeta,
        slotIndex.isAcceptableOrUnknown(data['slot_index']!, _slotIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_slotIndexMeta);
    }
    if (data.containsKey('dish_id')) {
      context.handle(
        _dishIdMeta,
        dishId.isAcceptableOrUnknown(data['dish_id']!, _dishIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dishIdMeta);
    }
    if (data.containsKey('planned_cost_cents')) {
      context.handle(
        _plannedCostCentsMeta,
        plannedCostCents.isAcceptableOrUnknown(
          data['planned_cost_cents']!,
          _plannedCostCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedCostCentsMeta);
    }
    if (data.containsKey('planned_calories')) {
      context.handle(
        _plannedCaloriesMeta,
        plannedCalories.isAcceptableOrUnknown(
          data['planned_calories']!,
          _plannedCaloriesMeta,
        ),
      );
    }
    if (data.containsKey('planned_protein_g')) {
      context.handle(
        _plannedProteinGMeta,
        plannedProteinG.isAcceptableOrUnknown(
          data['planned_protein_g']!,
          _plannedProteinGMeta,
        ),
      );
    }
    if (data.containsKey('planned_carbs_g')) {
      context.handle(
        _plannedCarbsGMeta,
        plannedCarbsG.isAcceptableOrUnknown(
          data['planned_carbs_g']!,
          _plannedCarbsGMeta,
        ),
      );
    }
    if (data.containsKey('planned_fat_g')) {
      context.handle(
        _plannedFatGMeta,
        plannedFatG.isAcceptableOrUnknown(
          data['planned_fat_g']!,
          _plannedFatGMeta,
        ),
      );
    }
    if (data.containsKey('servings')) {
      context.handle(
        _servingsMeta,
        servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta),
      );
    }
    if (data.containsKey('meal_status')) {
      context.handle(
        _mealStatusMeta,
        mealStatus.isAcceptableOrUnknown(data['meal_status']!, _mealStatusMeta),
      );
    }
    if (data.containsKey('actual_cost_cents')) {
      context.handle(
        _actualCostCentsMeta,
        actualCostCents.isAcceptableOrUnknown(
          data['actual_cost_cents']!,
          _actualCostCentsMeta,
        ),
      );
    }
    if (data.containsKey('substitute_name')) {
      context.handle(
        _substituteNameMeta,
        substituteName.isAcceptableOrUnknown(
          data['substitute_name']!,
          _substituteNameMeta,
        ),
      );
    }
    if (data.containsKey('consumed_at')) {
      context.handle(
        _consumedAtMeta,
        consumedAt.isAcceptableOrUnknown(data['consumed_at']!, _consumedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealSlot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealSlot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      generatedPlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}generated_plan_id'],
      )!,
      dayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_index'],
      )!,
      slotIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slot_index'],
      )!,
      dishId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dish_id'],
      )!,
      plannedCostCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_cost_cents'],
      )!,
      plannedCalories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}planned_calories'],
      )!,
      plannedProteinG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}planned_protein_g'],
      )!,
      plannedCarbsG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}planned_carbs_g'],
      )!,
      plannedFatG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}planned_fat_g'],
      )!,
      servings: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}servings'],
      )!,
      mealStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_status'],
      )!,
      actualCostCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_cost_cents'],
      ),
      substituteName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}substitute_name'],
      ),
      consumedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}consumed_at'],
      ),
    );
  }

  @override
  $MealSlotsTable createAlias(String alias) {
    return $MealSlotsTable(attachedDatabase, alias);
  }
}

class MealSlot extends DataClass implements Insertable<MealSlot> {
  final int id;
  final int generatedPlanId;
  final int dayIndex;
  final int slotIndex;
  final int dishId;
  final int plannedCostCents;
  final double plannedCalories;
  final double plannedProteinG;
  final double plannedCarbsG;
  final double plannedFatG;
  final double servings;
  final String mealStatus;
  final int? actualCostCents;
  final String? substituteName;
  final DateTime? consumedAt;
  const MealSlot({
    required this.id,
    required this.generatedPlanId,
    required this.dayIndex,
    required this.slotIndex,
    required this.dishId,
    required this.plannedCostCents,
    required this.plannedCalories,
    required this.plannedProteinG,
    required this.plannedCarbsG,
    required this.plannedFatG,
    required this.servings,
    required this.mealStatus,
    this.actualCostCents,
    this.substituteName,
    this.consumedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['generated_plan_id'] = Variable<int>(generatedPlanId);
    map['day_index'] = Variable<int>(dayIndex);
    map['slot_index'] = Variable<int>(slotIndex);
    map['dish_id'] = Variable<int>(dishId);
    map['planned_cost_cents'] = Variable<int>(plannedCostCents);
    map['planned_calories'] = Variable<double>(plannedCalories);
    map['planned_protein_g'] = Variable<double>(plannedProteinG);
    map['planned_carbs_g'] = Variable<double>(plannedCarbsG);
    map['planned_fat_g'] = Variable<double>(plannedFatG);
    map['servings'] = Variable<double>(servings);
    map['meal_status'] = Variable<String>(mealStatus);
    if (!nullToAbsent || actualCostCents != null) {
      map['actual_cost_cents'] = Variable<int>(actualCostCents);
    }
    if (!nullToAbsent || substituteName != null) {
      map['substitute_name'] = Variable<String>(substituteName);
    }
    if (!nullToAbsent || consumedAt != null) {
      map['consumed_at'] = Variable<DateTime>(consumedAt);
    }
    return map;
  }

  MealSlotsCompanion toCompanion(bool nullToAbsent) {
    return MealSlotsCompanion(
      id: Value(id),
      generatedPlanId: Value(generatedPlanId),
      dayIndex: Value(dayIndex),
      slotIndex: Value(slotIndex),
      dishId: Value(dishId),
      plannedCostCents: Value(plannedCostCents),
      plannedCalories: Value(plannedCalories),
      plannedProteinG: Value(plannedProteinG),
      plannedCarbsG: Value(plannedCarbsG),
      plannedFatG: Value(plannedFatG),
      servings: Value(servings),
      mealStatus: Value(mealStatus),
      actualCostCents: actualCostCents == null && nullToAbsent
          ? const Value.absent()
          : Value(actualCostCents),
      substituteName: substituteName == null && nullToAbsent
          ? const Value.absent()
          : Value(substituteName),
      consumedAt: consumedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(consumedAt),
    );
  }

  factory MealSlot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealSlot(
      id: serializer.fromJson<int>(json['id']),
      generatedPlanId: serializer.fromJson<int>(json['generatedPlanId']),
      dayIndex: serializer.fromJson<int>(json['dayIndex']),
      slotIndex: serializer.fromJson<int>(json['slotIndex']),
      dishId: serializer.fromJson<int>(json['dishId']),
      plannedCostCents: serializer.fromJson<int>(json['plannedCostCents']),
      plannedCalories: serializer.fromJson<double>(json['plannedCalories']),
      plannedProteinG: serializer.fromJson<double>(json['plannedProteinG']),
      plannedCarbsG: serializer.fromJson<double>(json['plannedCarbsG']),
      plannedFatG: serializer.fromJson<double>(json['plannedFatG']),
      servings: serializer.fromJson<double>(json['servings']),
      mealStatus: serializer.fromJson<String>(json['mealStatus']),
      actualCostCents: serializer.fromJson<int?>(json['actualCostCents']),
      substituteName: serializer.fromJson<String?>(json['substituteName']),
      consumedAt: serializer.fromJson<DateTime?>(json['consumedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'generatedPlanId': serializer.toJson<int>(generatedPlanId),
      'dayIndex': serializer.toJson<int>(dayIndex),
      'slotIndex': serializer.toJson<int>(slotIndex),
      'dishId': serializer.toJson<int>(dishId),
      'plannedCostCents': serializer.toJson<int>(plannedCostCents),
      'plannedCalories': serializer.toJson<double>(plannedCalories),
      'plannedProteinG': serializer.toJson<double>(plannedProteinG),
      'plannedCarbsG': serializer.toJson<double>(plannedCarbsG),
      'plannedFatG': serializer.toJson<double>(plannedFatG),
      'servings': serializer.toJson<double>(servings),
      'mealStatus': serializer.toJson<String>(mealStatus),
      'actualCostCents': serializer.toJson<int?>(actualCostCents),
      'substituteName': serializer.toJson<String?>(substituteName),
      'consumedAt': serializer.toJson<DateTime?>(consumedAt),
    };
  }

  MealSlot copyWith({
    int? id,
    int? generatedPlanId,
    int? dayIndex,
    int? slotIndex,
    int? dishId,
    int? plannedCostCents,
    double? plannedCalories,
    double? plannedProteinG,
    double? plannedCarbsG,
    double? plannedFatG,
    double? servings,
    String? mealStatus,
    Value<int?> actualCostCents = const Value.absent(),
    Value<String?> substituteName = const Value.absent(),
    Value<DateTime?> consumedAt = const Value.absent(),
  }) => MealSlot(
    id: id ?? this.id,
    generatedPlanId: generatedPlanId ?? this.generatedPlanId,
    dayIndex: dayIndex ?? this.dayIndex,
    slotIndex: slotIndex ?? this.slotIndex,
    dishId: dishId ?? this.dishId,
    plannedCostCents: plannedCostCents ?? this.plannedCostCents,
    plannedCalories: plannedCalories ?? this.plannedCalories,
    plannedProteinG: plannedProteinG ?? this.plannedProteinG,
    plannedCarbsG: plannedCarbsG ?? this.plannedCarbsG,
    plannedFatG: plannedFatG ?? this.plannedFatG,
    servings: servings ?? this.servings,
    mealStatus: mealStatus ?? this.mealStatus,
    actualCostCents: actualCostCents.present
        ? actualCostCents.value
        : this.actualCostCents,
    substituteName: substituteName.present
        ? substituteName.value
        : this.substituteName,
    consumedAt: consumedAt.present ? consumedAt.value : this.consumedAt,
  );
  MealSlot copyWithCompanion(MealSlotsCompanion data) {
    return MealSlot(
      id: data.id.present ? data.id.value : this.id,
      generatedPlanId: data.generatedPlanId.present
          ? data.generatedPlanId.value
          : this.generatedPlanId,
      dayIndex: data.dayIndex.present ? data.dayIndex.value : this.dayIndex,
      slotIndex: data.slotIndex.present ? data.slotIndex.value : this.slotIndex,
      dishId: data.dishId.present ? data.dishId.value : this.dishId,
      plannedCostCents: data.plannedCostCents.present
          ? data.plannedCostCents.value
          : this.plannedCostCents,
      plannedCalories: data.plannedCalories.present
          ? data.plannedCalories.value
          : this.plannedCalories,
      plannedProteinG: data.plannedProteinG.present
          ? data.plannedProteinG.value
          : this.plannedProteinG,
      plannedCarbsG: data.plannedCarbsG.present
          ? data.plannedCarbsG.value
          : this.plannedCarbsG,
      plannedFatG: data.plannedFatG.present
          ? data.plannedFatG.value
          : this.plannedFatG,
      servings: data.servings.present ? data.servings.value : this.servings,
      mealStatus: data.mealStatus.present
          ? data.mealStatus.value
          : this.mealStatus,
      actualCostCents: data.actualCostCents.present
          ? data.actualCostCents.value
          : this.actualCostCents,
      substituteName: data.substituteName.present
          ? data.substituteName.value
          : this.substituteName,
      consumedAt: data.consumedAt.present
          ? data.consumedAt.value
          : this.consumedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealSlot(')
          ..write('id: $id, ')
          ..write('generatedPlanId: $generatedPlanId, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('slotIndex: $slotIndex, ')
          ..write('dishId: $dishId, ')
          ..write('plannedCostCents: $plannedCostCents, ')
          ..write('plannedCalories: $plannedCalories, ')
          ..write('plannedProteinG: $plannedProteinG, ')
          ..write('plannedCarbsG: $plannedCarbsG, ')
          ..write('plannedFatG: $plannedFatG, ')
          ..write('servings: $servings, ')
          ..write('mealStatus: $mealStatus, ')
          ..write('actualCostCents: $actualCostCents, ')
          ..write('substituteName: $substituteName, ')
          ..write('consumedAt: $consumedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    generatedPlanId,
    dayIndex,
    slotIndex,
    dishId,
    plannedCostCents,
    plannedCalories,
    plannedProteinG,
    plannedCarbsG,
    plannedFatG,
    servings,
    mealStatus,
    actualCostCents,
    substituteName,
    consumedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealSlot &&
          other.id == this.id &&
          other.generatedPlanId == this.generatedPlanId &&
          other.dayIndex == this.dayIndex &&
          other.slotIndex == this.slotIndex &&
          other.dishId == this.dishId &&
          other.plannedCostCents == this.plannedCostCents &&
          other.plannedCalories == this.plannedCalories &&
          other.plannedProteinG == this.plannedProteinG &&
          other.plannedCarbsG == this.plannedCarbsG &&
          other.plannedFatG == this.plannedFatG &&
          other.servings == this.servings &&
          other.mealStatus == this.mealStatus &&
          other.actualCostCents == this.actualCostCents &&
          other.substituteName == this.substituteName &&
          other.consumedAt == this.consumedAt);
}

class MealSlotsCompanion extends UpdateCompanion<MealSlot> {
  final Value<int> id;
  final Value<int> generatedPlanId;
  final Value<int> dayIndex;
  final Value<int> slotIndex;
  final Value<int> dishId;
  final Value<int> plannedCostCents;
  final Value<double> plannedCalories;
  final Value<double> plannedProteinG;
  final Value<double> plannedCarbsG;
  final Value<double> plannedFatG;
  final Value<double> servings;
  final Value<String> mealStatus;
  final Value<int?> actualCostCents;
  final Value<String?> substituteName;
  final Value<DateTime?> consumedAt;
  const MealSlotsCompanion({
    this.id = const Value.absent(),
    this.generatedPlanId = const Value.absent(),
    this.dayIndex = const Value.absent(),
    this.slotIndex = const Value.absent(),
    this.dishId = const Value.absent(),
    this.plannedCostCents = const Value.absent(),
    this.plannedCalories = const Value.absent(),
    this.plannedProteinG = const Value.absent(),
    this.plannedCarbsG = const Value.absent(),
    this.plannedFatG = const Value.absent(),
    this.servings = const Value.absent(),
    this.mealStatus = const Value.absent(),
    this.actualCostCents = const Value.absent(),
    this.substituteName = const Value.absent(),
    this.consumedAt = const Value.absent(),
  });
  MealSlotsCompanion.insert({
    this.id = const Value.absent(),
    required int generatedPlanId,
    required int dayIndex,
    required int slotIndex,
    required int dishId,
    required int plannedCostCents,
    this.plannedCalories = const Value.absent(),
    this.plannedProteinG = const Value.absent(),
    this.plannedCarbsG = const Value.absent(),
    this.plannedFatG = const Value.absent(),
    this.servings = const Value.absent(),
    this.mealStatus = const Value.absent(),
    this.actualCostCents = const Value.absent(),
    this.substituteName = const Value.absent(),
    this.consumedAt = const Value.absent(),
  }) : generatedPlanId = Value(generatedPlanId),
       dayIndex = Value(dayIndex),
       slotIndex = Value(slotIndex),
       dishId = Value(dishId),
       plannedCostCents = Value(plannedCostCents);
  static Insertable<MealSlot> custom({
    Expression<int>? id,
    Expression<int>? generatedPlanId,
    Expression<int>? dayIndex,
    Expression<int>? slotIndex,
    Expression<int>? dishId,
    Expression<int>? plannedCostCents,
    Expression<double>? plannedCalories,
    Expression<double>? plannedProteinG,
    Expression<double>? plannedCarbsG,
    Expression<double>? plannedFatG,
    Expression<double>? servings,
    Expression<String>? mealStatus,
    Expression<int>? actualCostCents,
    Expression<String>? substituteName,
    Expression<DateTime>? consumedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (generatedPlanId != null) 'generated_plan_id': generatedPlanId,
      if (dayIndex != null) 'day_index': dayIndex,
      if (slotIndex != null) 'slot_index': slotIndex,
      if (dishId != null) 'dish_id': dishId,
      if (plannedCostCents != null) 'planned_cost_cents': plannedCostCents,
      if (plannedCalories != null) 'planned_calories': plannedCalories,
      if (plannedProteinG != null) 'planned_protein_g': plannedProteinG,
      if (plannedCarbsG != null) 'planned_carbs_g': plannedCarbsG,
      if (plannedFatG != null) 'planned_fat_g': plannedFatG,
      if (servings != null) 'servings': servings,
      if (mealStatus != null) 'meal_status': mealStatus,
      if (actualCostCents != null) 'actual_cost_cents': actualCostCents,
      if (substituteName != null) 'substitute_name': substituteName,
      if (consumedAt != null) 'consumed_at': consumedAt,
    });
  }

  MealSlotsCompanion copyWith({
    Value<int>? id,
    Value<int>? generatedPlanId,
    Value<int>? dayIndex,
    Value<int>? slotIndex,
    Value<int>? dishId,
    Value<int>? plannedCostCents,
    Value<double>? plannedCalories,
    Value<double>? plannedProteinG,
    Value<double>? plannedCarbsG,
    Value<double>? plannedFatG,
    Value<double>? servings,
    Value<String>? mealStatus,
    Value<int?>? actualCostCents,
    Value<String?>? substituteName,
    Value<DateTime?>? consumedAt,
  }) {
    return MealSlotsCompanion(
      id: id ?? this.id,
      generatedPlanId: generatedPlanId ?? this.generatedPlanId,
      dayIndex: dayIndex ?? this.dayIndex,
      slotIndex: slotIndex ?? this.slotIndex,
      dishId: dishId ?? this.dishId,
      plannedCostCents: plannedCostCents ?? this.plannedCostCents,
      plannedCalories: plannedCalories ?? this.plannedCalories,
      plannedProteinG: plannedProteinG ?? this.plannedProteinG,
      plannedCarbsG: plannedCarbsG ?? this.plannedCarbsG,
      plannedFatG: plannedFatG ?? this.plannedFatG,
      servings: servings ?? this.servings,
      mealStatus: mealStatus ?? this.mealStatus,
      actualCostCents: actualCostCents ?? this.actualCostCents,
      substituteName: substituteName ?? this.substituteName,
      consumedAt: consumedAt ?? this.consumedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (generatedPlanId.present) {
      map['generated_plan_id'] = Variable<int>(generatedPlanId.value);
    }
    if (dayIndex.present) {
      map['day_index'] = Variable<int>(dayIndex.value);
    }
    if (slotIndex.present) {
      map['slot_index'] = Variable<int>(slotIndex.value);
    }
    if (dishId.present) {
      map['dish_id'] = Variable<int>(dishId.value);
    }
    if (plannedCostCents.present) {
      map['planned_cost_cents'] = Variable<int>(plannedCostCents.value);
    }
    if (plannedCalories.present) {
      map['planned_calories'] = Variable<double>(plannedCalories.value);
    }
    if (plannedProteinG.present) {
      map['planned_protein_g'] = Variable<double>(plannedProteinG.value);
    }
    if (plannedCarbsG.present) {
      map['planned_carbs_g'] = Variable<double>(plannedCarbsG.value);
    }
    if (plannedFatG.present) {
      map['planned_fat_g'] = Variable<double>(plannedFatG.value);
    }
    if (servings.present) {
      map['servings'] = Variable<double>(servings.value);
    }
    if (mealStatus.present) {
      map['meal_status'] = Variable<String>(mealStatus.value);
    }
    if (actualCostCents.present) {
      map['actual_cost_cents'] = Variable<int>(actualCostCents.value);
    }
    if (substituteName.present) {
      map['substitute_name'] = Variable<String>(substituteName.value);
    }
    if (consumedAt.present) {
      map['consumed_at'] = Variable<DateTime>(consumedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealSlotsCompanion(')
          ..write('id: $id, ')
          ..write('generatedPlanId: $generatedPlanId, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('slotIndex: $slotIndex, ')
          ..write('dishId: $dishId, ')
          ..write('plannedCostCents: $plannedCostCents, ')
          ..write('plannedCalories: $plannedCalories, ')
          ..write('plannedProteinG: $plannedProteinG, ')
          ..write('plannedCarbsG: $plannedCarbsG, ')
          ..write('plannedFatG: $plannedFatG, ')
          ..write('servings: $servings, ')
          ..write('mealStatus: $mealStatus, ')
          ..write('actualCostCents: $actualCostCents, ')
          ..write('substituteName: $substituteName, ')
          ..write('consumedAt: $consumedAt')
          ..write(')'))
        .toString();
  }
}

class $MealSlotItemsTable extends MealSlotItems
    with TableInfo<$MealSlotItemsTable, MealSlotItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealSlotItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _mealSlotIdMeta = const VerificationMeta(
    'mealSlotId',
  );
  @override
  late final GeneratedColumn<int> mealSlotId = GeneratedColumn<int>(
    'meal_slot_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meal_slots (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dishIdMeta = const VerificationMeta('dishId');
  @override
  late final GeneratedColumn<int> dishId = GeneratedColumn<int>(
    'dish_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES dishes (id)',
    ),
  );
  static const VerificationMeta _plannedCostCentsMeta = const VerificationMeta(
    'plannedCostCents',
  );
  @override
  late final GeneratedColumn<int> plannedCostCents = GeneratedColumn<int>(
    'planned_cost_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedCaloriesMeta = const VerificationMeta(
    'plannedCalories',
  );
  @override
  late final GeneratedColumn<double> plannedCalories = GeneratedColumn<double>(
    'planned_calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _plannedProteinGMeta = const VerificationMeta(
    'plannedProteinG',
  );
  @override
  late final GeneratedColumn<double> plannedProteinG = GeneratedColumn<double>(
    'planned_protein_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _plannedCarbsGMeta = const VerificationMeta(
    'plannedCarbsG',
  );
  @override
  late final GeneratedColumn<double> plannedCarbsG = GeneratedColumn<double>(
    'planned_carbs_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _plannedFatGMeta = const VerificationMeta(
    'plannedFatG',
  );
  @override
  late final GeneratedColumn<double> plannedFatG = GeneratedColumn<double>(
    'planned_fat_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _servingsMeta = const VerificationMeta(
    'servings',
  );
  @override
  late final GeneratedColumn<double> servings = GeneratedColumn<double>(
    'servings',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mealSlotId,
    dishId,
    plannedCostCents,
    plannedCalories,
    plannedProteinG,
    plannedCarbsG,
    plannedFatG,
    servings,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_slot_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealSlotItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('meal_slot_id')) {
      context.handle(
        _mealSlotIdMeta,
        mealSlotId.isAcceptableOrUnknown(
          data['meal_slot_id']!,
          _mealSlotIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mealSlotIdMeta);
    }
    if (data.containsKey('dish_id')) {
      context.handle(
        _dishIdMeta,
        dishId.isAcceptableOrUnknown(data['dish_id']!, _dishIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dishIdMeta);
    }
    if (data.containsKey('planned_cost_cents')) {
      context.handle(
        _plannedCostCentsMeta,
        plannedCostCents.isAcceptableOrUnknown(
          data['planned_cost_cents']!,
          _plannedCostCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedCostCentsMeta);
    }
    if (data.containsKey('planned_calories')) {
      context.handle(
        _plannedCaloriesMeta,
        plannedCalories.isAcceptableOrUnknown(
          data['planned_calories']!,
          _plannedCaloriesMeta,
        ),
      );
    }
    if (data.containsKey('planned_protein_g')) {
      context.handle(
        _plannedProteinGMeta,
        plannedProteinG.isAcceptableOrUnknown(
          data['planned_protein_g']!,
          _plannedProteinGMeta,
        ),
      );
    }
    if (data.containsKey('planned_carbs_g')) {
      context.handle(
        _plannedCarbsGMeta,
        plannedCarbsG.isAcceptableOrUnknown(
          data['planned_carbs_g']!,
          _plannedCarbsGMeta,
        ),
      );
    }
    if (data.containsKey('planned_fat_g')) {
      context.handle(
        _plannedFatGMeta,
        plannedFatG.isAcceptableOrUnknown(
          data['planned_fat_g']!,
          _plannedFatGMeta,
        ),
      );
    }
    if (data.containsKey('servings')) {
      context.handle(
        _servingsMeta,
        servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealSlotItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealSlotItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mealSlotId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meal_slot_id'],
      )!,
      dishId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dish_id'],
      )!,
      plannedCostCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_cost_cents'],
      )!,
      plannedCalories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}planned_calories'],
      )!,
      plannedProteinG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}planned_protein_g'],
      )!,
      plannedCarbsG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}planned_carbs_g'],
      )!,
      plannedFatG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}planned_fat_g'],
      )!,
      servings: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}servings'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $MealSlotItemsTable createAlias(String alias) {
    return $MealSlotItemsTable(attachedDatabase, alias);
  }
}

class MealSlotItem extends DataClass implements Insertable<MealSlotItem> {
  final int id;
  final int mealSlotId;
  final int dishId;
  final int plannedCostCents;
  final double plannedCalories;
  final double plannedProteinG;
  final double plannedCarbsG;
  final double plannedFatG;
  final double servings;
  final int sortOrder;
  const MealSlotItem({
    required this.id,
    required this.mealSlotId,
    required this.dishId,
    required this.plannedCostCents,
    required this.plannedCalories,
    required this.plannedProteinG,
    required this.plannedCarbsG,
    required this.plannedFatG,
    required this.servings,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['meal_slot_id'] = Variable<int>(mealSlotId);
    map['dish_id'] = Variable<int>(dishId);
    map['planned_cost_cents'] = Variable<int>(plannedCostCents);
    map['planned_calories'] = Variable<double>(plannedCalories);
    map['planned_protein_g'] = Variable<double>(plannedProteinG);
    map['planned_carbs_g'] = Variable<double>(plannedCarbsG);
    map['planned_fat_g'] = Variable<double>(plannedFatG);
    map['servings'] = Variable<double>(servings);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  MealSlotItemsCompanion toCompanion(bool nullToAbsent) {
    return MealSlotItemsCompanion(
      id: Value(id),
      mealSlotId: Value(mealSlotId),
      dishId: Value(dishId),
      plannedCostCents: Value(plannedCostCents),
      plannedCalories: Value(plannedCalories),
      plannedProteinG: Value(plannedProteinG),
      plannedCarbsG: Value(plannedCarbsG),
      plannedFatG: Value(plannedFatG),
      servings: Value(servings),
      sortOrder: Value(sortOrder),
    );
  }

  factory MealSlotItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealSlotItem(
      id: serializer.fromJson<int>(json['id']),
      mealSlotId: serializer.fromJson<int>(json['mealSlotId']),
      dishId: serializer.fromJson<int>(json['dishId']),
      plannedCostCents: serializer.fromJson<int>(json['plannedCostCents']),
      plannedCalories: serializer.fromJson<double>(json['plannedCalories']),
      plannedProteinG: serializer.fromJson<double>(json['plannedProteinG']),
      plannedCarbsG: serializer.fromJson<double>(json['plannedCarbsG']),
      plannedFatG: serializer.fromJson<double>(json['plannedFatG']),
      servings: serializer.fromJson<double>(json['servings']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mealSlotId': serializer.toJson<int>(mealSlotId),
      'dishId': serializer.toJson<int>(dishId),
      'plannedCostCents': serializer.toJson<int>(plannedCostCents),
      'plannedCalories': serializer.toJson<double>(plannedCalories),
      'plannedProteinG': serializer.toJson<double>(plannedProteinG),
      'plannedCarbsG': serializer.toJson<double>(plannedCarbsG),
      'plannedFatG': serializer.toJson<double>(plannedFatG),
      'servings': serializer.toJson<double>(servings),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  MealSlotItem copyWith({
    int? id,
    int? mealSlotId,
    int? dishId,
    int? plannedCostCents,
    double? plannedCalories,
    double? plannedProteinG,
    double? plannedCarbsG,
    double? plannedFatG,
    double? servings,
    int? sortOrder,
  }) => MealSlotItem(
    id: id ?? this.id,
    mealSlotId: mealSlotId ?? this.mealSlotId,
    dishId: dishId ?? this.dishId,
    plannedCostCents: plannedCostCents ?? this.plannedCostCents,
    plannedCalories: plannedCalories ?? this.plannedCalories,
    plannedProteinG: plannedProteinG ?? this.plannedProteinG,
    plannedCarbsG: plannedCarbsG ?? this.plannedCarbsG,
    plannedFatG: plannedFatG ?? this.plannedFatG,
    servings: servings ?? this.servings,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  MealSlotItem copyWithCompanion(MealSlotItemsCompanion data) {
    return MealSlotItem(
      id: data.id.present ? data.id.value : this.id,
      mealSlotId: data.mealSlotId.present
          ? data.mealSlotId.value
          : this.mealSlotId,
      dishId: data.dishId.present ? data.dishId.value : this.dishId,
      plannedCostCents: data.plannedCostCents.present
          ? data.plannedCostCents.value
          : this.plannedCostCents,
      plannedCalories: data.plannedCalories.present
          ? data.plannedCalories.value
          : this.plannedCalories,
      plannedProteinG: data.plannedProteinG.present
          ? data.plannedProteinG.value
          : this.plannedProteinG,
      plannedCarbsG: data.plannedCarbsG.present
          ? data.plannedCarbsG.value
          : this.plannedCarbsG,
      plannedFatG: data.plannedFatG.present
          ? data.plannedFatG.value
          : this.plannedFatG,
      servings: data.servings.present ? data.servings.value : this.servings,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealSlotItem(')
          ..write('id: $id, ')
          ..write('mealSlotId: $mealSlotId, ')
          ..write('dishId: $dishId, ')
          ..write('plannedCostCents: $plannedCostCents, ')
          ..write('plannedCalories: $plannedCalories, ')
          ..write('plannedProteinG: $plannedProteinG, ')
          ..write('plannedCarbsG: $plannedCarbsG, ')
          ..write('plannedFatG: $plannedFatG, ')
          ..write('servings: $servings, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mealSlotId,
    dishId,
    plannedCostCents,
    plannedCalories,
    plannedProteinG,
    plannedCarbsG,
    plannedFatG,
    servings,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealSlotItem &&
          other.id == this.id &&
          other.mealSlotId == this.mealSlotId &&
          other.dishId == this.dishId &&
          other.plannedCostCents == this.plannedCostCents &&
          other.plannedCalories == this.plannedCalories &&
          other.plannedProteinG == this.plannedProteinG &&
          other.plannedCarbsG == this.plannedCarbsG &&
          other.plannedFatG == this.plannedFatG &&
          other.servings == this.servings &&
          other.sortOrder == this.sortOrder);
}

class MealSlotItemsCompanion extends UpdateCompanion<MealSlotItem> {
  final Value<int> id;
  final Value<int> mealSlotId;
  final Value<int> dishId;
  final Value<int> plannedCostCents;
  final Value<double> plannedCalories;
  final Value<double> plannedProteinG;
  final Value<double> plannedCarbsG;
  final Value<double> plannedFatG;
  final Value<double> servings;
  final Value<int> sortOrder;
  const MealSlotItemsCompanion({
    this.id = const Value.absent(),
    this.mealSlotId = const Value.absent(),
    this.dishId = const Value.absent(),
    this.plannedCostCents = const Value.absent(),
    this.plannedCalories = const Value.absent(),
    this.plannedProteinG = const Value.absent(),
    this.plannedCarbsG = const Value.absent(),
    this.plannedFatG = const Value.absent(),
    this.servings = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  MealSlotItemsCompanion.insert({
    this.id = const Value.absent(),
    required int mealSlotId,
    required int dishId,
    required int plannedCostCents,
    this.plannedCalories = const Value.absent(),
    this.plannedProteinG = const Value.absent(),
    this.plannedCarbsG = const Value.absent(),
    this.plannedFatG = const Value.absent(),
    this.servings = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : mealSlotId = Value(mealSlotId),
       dishId = Value(dishId),
       plannedCostCents = Value(plannedCostCents);
  static Insertable<MealSlotItem> custom({
    Expression<int>? id,
    Expression<int>? mealSlotId,
    Expression<int>? dishId,
    Expression<int>? plannedCostCents,
    Expression<double>? plannedCalories,
    Expression<double>? plannedProteinG,
    Expression<double>? plannedCarbsG,
    Expression<double>? plannedFatG,
    Expression<double>? servings,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mealSlotId != null) 'meal_slot_id': mealSlotId,
      if (dishId != null) 'dish_id': dishId,
      if (plannedCostCents != null) 'planned_cost_cents': plannedCostCents,
      if (plannedCalories != null) 'planned_calories': plannedCalories,
      if (plannedProteinG != null) 'planned_protein_g': plannedProteinG,
      if (plannedCarbsG != null) 'planned_carbs_g': plannedCarbsG,
      if (plannedFatG != null) 'planned_fat_g': plannedFatG,
      if (servings != null) 'servings': servings,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  MealSlotItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? mealSlotId,
    Value<int>? dishId,
    Value<int>? plannedCostCents,
    Value<double>? plannedCalories,
    Value<double>? plannedProteinG,
    Value<double>? plannedCarbsG,
    Value<double>? plannedFatG,
    Value<double>? servings,
    Value<int>? sortOrder,
  }) {
    return MealSlotItemsCompanion(
      id: id ?? this.id,
      mealSlotId: mealSlotId ?? this.mealSlotId,
      dishId: dishId ?? this.dishId,
      plannedCostCents: plannedCostCents ?? this.plannedCostCents,
      plannedCalories: plannedCalories ?? this.plannedCalories,
      plannedProteinG: plannedProteinG ?? this.plannedProteinG,
      plannedCarbsG: plannedCarbsG ?? this.plannedCarbsG,
      plannedFatG: plannedFatG ?? this.plannedFatG,
      servings: servings ?? this.servings,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mealSlotId.present) {
      map['meal_slot_id'] = Variable<int>(mealSlotId.value);
    }
    if (dishId.present) {
      map['dish_id'] = Variable<int>(dishId.value);
    }
    if (plannedCostCents.present) {
      map['planned_cost_cents'] = Variable<int>(plannedCostCents.value);
    }
    if (plannedCalories.present) {
      map['planned_calories'] = Variable<double>(plannedCalories.value);
    }
    if (plannedProteinG.present) {
      map['planned_protein_g'] = Variable<double>(plannedProteinG.value);
    }
    if (plannedCarbsG.present) {
      map['planned_carbs_g'] = Variable<double>(plannedCarbsG.value);
    }
    if (plannedFatG.present) {
      map['planned_fat_g'] = Variable<double>(plannedFatG.value);
    }
    if (servings.present) {
      map['servings'] = Variable<double>(servings.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealSlotItemsCompanion(')
          ..write('id: $id, ')
          ..write('mealSlotId: $mealSlotId, ')
          ..write('dishId: $dishId, ')
          ..write('plannedCostCents: $plannedCostCents, ')
          ..write('plannedCalories: $plannedCalories, ')
          ..write('plannedProteinG: $plannedProteinG, ')
          ..write('plannedCarbsG: $plannedCarbsG, ')
          ..write('plannedFatG: $plannedFatG, ')
          ..write('servings: $servings, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityTableMeta = const VerificationMeta(
    'entityTable',
  );
  @override
  late final GeneratedColumn<String> entityTable = GeneratedColumn<String>(
    'entity_table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dirtyFlagMeta = const VerificationMeta(
    'dirtyFlag',
  );
  @override
  late final GeneratedColumn<bool> dirtyFlag = GeneratedColumn<bool>(
    'dirty_flag',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty_flag" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _queuedAtMeta = const VerificationMeta(
    'queuedAt',
  );
  @override
  late final GeneratedColumn<DateTime> queuedAt = GeneratedColumn<DateTime>(
    'queued_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityTable,
    entityId,
    operation,
    payloadJson,
    dirtyFlag,
    queuedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_table')) {
      context.handle(
        _entityTableMeta,
        entityTable.isAcceptableOrUnknown(
          data['entity_table']!,
          _entityTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entityTableMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('dirty_flag')) {
      context.handle(
        _dirtyFlagMeta,
        dirtyFlag.isAcceptableOrUnknown(data['dirty_flag']!, _dirtyFlagMeta),
      );
    }
    if (data.containsKey('queued_at')) {
      context.handle(
        _queuedAtMeta,
        queuedAt.isAcceptableOrUnknown(data['queued_at']!, _queuedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_queuedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entityTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_table'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entity_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      dirtyFlag: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty_flag'],
      )!,
      queuedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}queued_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final String entityTable;
  final int entityId;
  final String operation;
  final String payloadJson;
  final bool dirtyFlag;
  final DateTime queuedAt;
  final DateTime? syncedAt;
  const SyncQueueData({
    required this.id,
    required this.entityTable,
    required this.entityId,
    required this.operation,
    required this.payloadJson,
    required this.dirtyFlag,
    required this.queuedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_table'] = Variable<String>(entityTable);
    map['entity_id'] = Variable<int>(entityId);
    map['operation'] = Variable<String>(operation);
    map['payload_json'] = Variable<String>(payloadJson);
    map['dirty_flag'] = Variable<bool>(dirtyFlag);
    map['queued_at'] = Variable<DateTime>(queuedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      entityTable: Value(entityTable),
      entityId: Value(entityId),
      operation: Value(operation),
      payloadJson: Value(payloadJson),
      dirtyFlag: Value(dirtyFlag),
      queuedAt: Value(queuedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      entityTable: serializer.fromJson<String>(json['entityTable']),
      entityId: serializer.fromJson<int>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      dirtyFlag: serializer.fromJson<bool>(json['dirtyFlag']),
      queuedAt: serializer.fromJson<DateTime>(json['queuedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityTable': serializer.toJson<String>(entityTable),
      'entityId': serializer.toJson<int>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'dirtyFlag': serializer.toJson<bool>(dirtyFlag),
      'queuedAt': serializer.toJson<DateTime>(queuedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  SyncQueueData copyWith({
    int? id,
    String? entityTable,
    int? entityId,
    String? operation,
    String? payloadJson,
    bool? dirtyFlag,
    DateTime? queuedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => SyncQueueData(
    id: id ?? this.id,
    entityTable: entityTable ?? this.entityTable,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    payloadJson: payloadJson ?? this.payloadJson,
    dirtyFlag: dirtyFlag ?? this.dirtyFlag,
    queuedAt: queuedAt ?? this.queuedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      entityTable: data.entityTable.present
          ? data.entityTable.value
          : this.entityTable,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      dirtyFlag: data.dirtyFlag.present ? data.dirtyFlag.value : this.dirtyFlag,
      queuedAt: data.queuedAt.present ? data.queuedAt.value : this.queuedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('entityTable: $entityTable, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('dirtyFlag: $dirtyFlag, ')
          ..write('queuedAt: $queuedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityTable,
    entityId,
    operation,
    payloadJson,
    dirtyFlag,
    queuedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.entityTable == this.entityTable &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payloadJson == this.payloadJson &&
          other.dirtyFlag == this.dirtyFlag &&
          other.queuedAt == this.queuedAt &&
          other.syncedAt == this.syncedAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> entityTable;
  final Value<int> entityId;
  final Value<String> operation;
  final Value<String> payloadJson;
  final Value<bool> dirtyFlag;
  final Value<DateTime> queuedAt;
  final Value<DateTime?> syncedAt;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.entityTable = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.dirtyFlag = const Value.absent(),
    this.queuedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String entityTable,
    required int entityId,
    required String operation,
    required String payloadJson,
    this.dirtyFlag = const Value.absent(),
    required DateTime queuedAt,
    this.syncedAt = const Value.absent(),
  }) : entityTable = Value(entityTable),
       entityId = Value(entityId),
       operation = Value(operation),
       payloadJson = Value(payloadJson),
       queuedAt = Value(queuedAt);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? entityTable,
    Expression<int>? entityId,
    Expression<String>? operation,
    Expression<String>? payloadJson,
    Expression<bool>? dirtyFlag,
    Expression<DateTime>? queuedAt,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityTable != null) 'entity_table': entityTable,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (dirtyFlag != null) 'dirty_flag': dirtyFlag,
      if (queuedAt != null) 'queued_at': queuedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? entityTable,
    Value<int>? entityId,
    Value<String>? operation,
    Value<String>? payloadJson,
    Value<bool>? dirtyFlag,
    Value<DateTime>? queuedAt,
    Value<DateTime?>? syncedAt,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      entityTable: entityTable ?? this.entityTable,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payloadJson: payloadJson ?? this.payloadJson,
      dirtyFlag: dirtyFlag ?? this.dirtyFlag,
      queuedAt: queuedAt ?? this.queuedAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityTable.present) {
      map['entity_table'] = Variable<String>(entityTable.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (dirtyFlag.present) {
      map['dirty_flag'] = Variable<bool>(dirtyFlag.value);
    }
    if (queuedAt.present) {
      map['queued_at'] = Variable<DateTime>(queuedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('entityTable: $entityTable, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('dirtyFlag: $dirtyFlag, ')
          ..write('queuedAt: $queuedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class $BudgetEntriesTable extends BudgetEntries
    with TableInfo<$BudgetEntriesTable, BudgetEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userProfileIdMeta = const VerificationMeta(
    'userProfileId',
  );
  @override
  late final GeneratedColumn<int> userProfileId = GeneratedColumn<int>(
    'user_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _generatedPlanIdMeta = const VerificationMeta(
    'generatedPlanId',
  );
  @override
  late final GeneratedColumn<int> generatedPlanId = GeneratedColumn<int>(
    'generated_plan_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES generated_plans (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _mealSlotIdMeta = const VerificationMeta(
    'mealSlotId',
  );
  @override
  late final GeneratedColumn<int> mealSlotId = GeneratedColumn<int>(
    'meal_slot_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meal_slots (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userProfileId,
    generatedPlanId,
    mealSlotId,
    amountCents,
    label,
    occurredAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_profile_id')) {
      context.handle(
        _userProfileIdMeta,
        userProfileId.isAcceptableOrUnknown(
          data['user_profile_id']!,
          _userProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_userProfileIdMeta);
    }
    if (data.containsKey('generated_plan_id')) {
      context.handle(
        _generatedPlanIdMeta,
        generatedPlanId.isAcceptableOrUnknown(
          data['generated_plan_id']!,
          _generatedPlanIdMeta,
        ),
      );
    }
    if (data.containsKey('meal_slot_id')) {
      context.handle(
        _mealSlotIdMeta,
        mealSlotId.isAcceptableOrUnknown(
          data['meal_slot_id']!,
          _mealSlotIdMeta,
        ),
      );
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_profile_id'],
      )!,
      generatedPlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}generated_plan_id'],
      ),
      mealSlotId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meal_slot_id'],
      ),
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BudgetEntriesTable createAlias(String alias) {
    return $BudgetEntriesTable(attachedDatabase, alias);
  }
}

class BudgetEntry extends DataClass implements Insertable<BudgetEntry> {
  final int id;
  final int userProfileId;
  final int? generatedPlanId;
  final int? mealSlotId;
  final int amountCents;
  final String label;
  final DateTime occurredAt;
  final DateTime createdAt;
  const BudgetEntry({
    required this.id,
    required this.userProfileId,
    this.generatedPlanId,
    this.mealSlotId,
    required this.amountCents,
    required this.label,
    required this.occurredAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_profile_id'] = Variable<int>(userProfileId);
    if (!nullToAbsent || generatedPlanId != null) {
      map['generated_plan_id'] = Variable<int>(generatedPlanId);
    }
    if (!nullToAbsent || mealSlotId != null) {
      map['meal_slot_id'] = Variable<int>(mealSlotId);
    }
    map['amount_cents'] = Variable<int>(amountCents);
    map['label'] = Variable<String>(label);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BudgetEntriesCompanion toCompanion(bool nullToAbsent) {
    return BudgetEntriesCompanion(
      id: Value(id),
      userProfileId: Value(userProfileId),
      generatedPlanId: generatedPlanId == null && nullToAbsent
          ? const Value.absent()
          : Value(generatedPlanId),
      mealSlotId: mealSlotId == null && nullToAbsent
          ? const Value.absent()
          : Value(mealSlotId),
      amountCents: Value(amountCents),
      label: Value(label),
      occurredAt: Value(occurredAt),
      createdAt: Value(createdAt),
    );
  }

  factory BudgetEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetEntry(
      id: serializer.fromJson<int>(json['id']),
      userProfileId: serializer.fromJson<int>(json['userProfileId']),
      generatedPlanId: serializer.fromJson<int?>(json['generatedPlanId']),
      mealSlotId: serializer.fromJson<int?>(json['mealSlotId']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      label: serializer.fromJson<String>(json['label']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userProfileId': serializer.toJson<int>(userProfileId),
      'generatedPlanId': serializer.toJson<int?>(generatedPlanId),
      'mealSlotId': serializer.toJson<int?>(mealSlotId),
      'amountCents': serializer.toJson<int>(amountCents),
      'label': serializer.toJson<String>(label),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BudgetEntry copyWith({
    int? id,
    int? userProfileId,
    Value<int?> generatedPlanId = const Value.absent(),
    Value<int?> mealSlotId = const Value.absent(),
    int? amountCents,
    String? label,
    DateTime? occurredAt,
    DateTime? createdAt,
  }) => BudgetEntry(
    id: id ?? this.id,
    userProfileId: userProfileId ?? this.userProfileId,
    generatedPlanId: generatedPlanId.present
        ? generatedPlanId.value
        : this.generatedPlanId,
    mealSlotId: mealSlotId.present ? mealSlotId.value : this.mealSlotId,
    amountCents: amountCents ?? this.amountCents,
    label: label ?? this.label,
    occurredAt: occurredAt ?? this.occurredAt,
    createdAt: createdAt ?? this.createdAt,
  );
  BudgetEntry copyWithCompanion(BudgetEntriesCompanion data) {
    return BudgetEntry(
      id: data.id.present ? data.id.value : this.id,
      userProfileId: data.userProfileId.present
          ? data.userProfileId.value
          : this.userProfileId,
      generatedPlanId: data.generatedPlanId.present
          ? data.generatedPlanId.value
          : this.generatedPlanId,
      mealSlotId: data.mealSlotId.present
          ? data.mealSlotId.value
          : this.mealSlotId,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      label: data.label.present ? data.label.value : this.label,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetEntry(')
          ..write('id: $id, ')
          ..write('userProfileId: $userProfileId, ')
          ..write('generatedPlanId: $generatedPlanId, ')
          ..write('mealSlotId: $mealSlotId, ')
          ..write('amountCents: $amountCents, ')
          ..write('label: $label, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userProfileId,
    generatedPlanId,
    mealSlotId,
    amountCents,
    label,
    occurredAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetEntry &&
          other.id == this.id &&
          other.userProfileId == this.userProfileId &&
          other.generatedPlanId == this.generatedPlanId &&
          other.mealSlotId == this.mealSlotId &&
          other.amountCents == this.amountCents &&
          other.label == this.label &&
          other.occurredAt == this.occurredAt &&
          other.createdAt == this.createdAt);
}

class BudgetEntriesCompanion extends UpdateCompanion<BudgetEntry> {
  final Value<int> id;
  final Value<int> userProfileId;
  final Value<int?> generatedPlanId;
  final Value<int?> mealSlotId;
  final Value<int> amountCents;
  final Value<String> label;
  final Value<DateTime> occurredAt;
  final Value<DateTime> createdAt;
  const BudgetEntriesCompanion({
    this.id = const Value.absent(),
    this.userProfileId = const Value.absent(),
    this.generatedPlanId = const Value.absent(),
    this.mealSlotId = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.label = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BudgetEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int userProfileId,
    this.generatedPlanId = const Value.absent(),
    this.mealSlotId = const Value.absent(),
    required int amountCents,
    required String label,
    required DateTime occurredAt,
    required DateTime createdAt,
  }) : userProfileId = Value(userProfileId),
       amountCents = Value(amountCents),
       label = Value(label),
       occurredAt = Value(occurredAt),
       createdAt = Value(createdAt);
  static Insertable<BudgetEntry> custom({
    Expression<int>? id,
    Expression<int>? userProfileId,
    Expression<int>? generatedPlanId,
    Expression<int>? mealSlotId,
    Expression<int>? amountCents,
    Expression<String>? label,
    Expression<DateTime>? occurredAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userProfileId != null) 'user_profile_id': userProfileId,
      if (generatedPlanId != null) 'generated_plan_id': generatedPlanId,
      if (mealSlotId != null) 'meal_slot_id': mealSlotId,
      if (amountCents != null) 'amount_cents': amountCents,
      if (label != null) 'label': label,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BudgetEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? userProfileId,
    Value<int?>? generatedPlanId,
    Value<int?>? mealSlotId,
    Value<int>? amountCents,
    Value<String>? label,
    Value<DateTime>? occurredAt,
    Value<DateTime>? createdAt,
  }) {
    return BudgetEntriesCompanion(
      id: id ?? this.id,
      userProfileId: userProfileId ?? this.userProfileId,
      generatedPlanId: generatedPlanId ?? this.generatedPlanId,
      mealSlotId: mealSlotId ?? this.mealSlotId,
      amountCents: amountCents ?? this.amountCents,
      label: label ?? this.label,
      occurredAt: occurredAt ?? this.occurredAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userProfileId.present) {
      map['user_profile_id'] = Variable<int>(userProfileId.value);
    }
    if (generatedPlanId.present) {
      map['generated_plan_id'] = Variable<int>(generatedPlanId.value);
    }
    if (mealSlotId.present) {
      map['meal_slot_id'] = Variable<int>(mealSlotId.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetEntriesCompanion(')
          ..write('id: $id, ')
          ..write('userProfileId: $userProfileId, ')
          ..write('generatedPlanId: $generatedPlanId, ')
          ..write('mealSlotId: $mealSlotId, ')
          ..write('amountCents: $amountCents, ')
          ..write('label: $label, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $DishesTable dishes = $DishesTable(this);
  late final $IngredientsTable ingredients = $IngredientsTable(this);
  late final $NutritionCachesTable nutritionCaches = $NutritionCachesTable(
    this,
  );
  late final $AllergenTagsTable allergenTags = $AllergenTagsTable(this);
  late final $DishAllergenTagsTable dishAllergenTags = $DishAllergenTagsTable(
    this,
  );
  late final $GeneratedPlansTable generatedPlans = $GeneratedPlansTable(this);
  late final $MealSlotsTable mealSlots = $MealSlotsTable(this);
  late final $MealSlotItemsTable mealSlotItems = $MealSlotItemsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $BudgetEntriesTable budgetEntries = $BudgetEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfiles,
    dishes,
    ingredients,
    nutritionCaches,
    allergenTags,
    dishAllergenTags,
    generatedPlans,
    mealSlots,
    mealSlotItems,
    syncQueue,
    budgetEntries,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'user_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('dishes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'dishes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ingredients', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'user_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('allergen_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'dishes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('dish_allergen_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'allergen_tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('dish_allergen_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'user_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('generated_plans', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'generated_plans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('meal_slots', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'meal_slots',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('meal_slot_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'user_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budget_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'generated_plans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budget_entries', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'meal_slots',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budget_entries', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      required String email,
      Value<String?> displayName,
      Value<int> weeklyBudgetCents,
      Value<String> activeDays,
      Value<int> mealsPerDay,
      Value<String> mealTimesJson,
      Value<double?> weightKg,
      Value<double?> heightCm,
      Value<int?> age,
      Value<String?> sex,
      Value<String> activityLevel,
      Value<String> goalPreset,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<String> email,
      Value<String?> displayName,
      Value<int> weeklyBudgetCents,
      Value<String> activeDays,
      Value<int> mealsPerDay,
      Value<String> mealTimesJson,
      Value<double?> weightKg,
      Value<double?> heightCm,
      Value<int?> age,
      Value<String?> sex,
      Value<String> activityLevel,
      Value<String> goalPreset,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$UserProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile> {
  $$UserProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DishesTable, List<Dishe>> _dishesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.dishes,
    aliasName: 'user_profiles__id__dishes__user_profile_id',
  );

  $$DishesTableProcessedTableManager get dishesRefs {
    final manager = $$DishesTableTableManager(
      $_db,
      $_db.dishes,
    ).filter((f) => f.userProfileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dishesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AllergenTagsTable, List<AllergenTag>>
  _allergenTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.allergenTags,
    aliasName: 'user_profiles__id__allergen_tags__user_profile_id',
  );

  $$AllergenTagsTableProcessedTableManager get allergenTagsRefs {
    final manager = $$AllergenTagsTableTableManager(
      $_db,
      $_db.allergenTags,
    ).filter((f) => f.userProfileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_allergenTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GeneratedPlansTable, List<GeneratedPlan>>
  _generatedPlansRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.generatedPlans,
    aliasName: 'user_profiles__id__generated_plans__user_profile_id',
  );

  $$GeneratedPlansTableProcessedTableManager get generatedPlansRefs {
    final manager = $$GeneratedPlansTableTableManager(
      $_db,
      $_db.generatedPlans,
    ).filter((f) => f.userProfileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_generatedPlansRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BudgetEntriesTable, List<BudgetEntry>>
  _budgetEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetEntries,
    aliasName: 'user_profiles__id__budget_entries__user_profile_id',
  );

  $$BudgetEntriesTableProcessedTableManager get budgetEntriesRefs {
    final manager = $$BudgetEntriesTableTableManager(
      $_db,
      $_db.budgetEntries,
    ).filter((f) => f.userProfileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeklyBudgetCents => $composableBuilder(
    column: $table.weeklyBudgetCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeDays => $composableBuilder(
    column: $table.activeDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mealsPerDay => $composableBuilder(
    column: $table.mealsPerDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealTimesJson => $composableBuilder(
    column: $table.mealTimesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalPreset => $composableBuilder(
    column: $table.goalPreset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> dishesRefs(
    Expression<bool> Function($$DishesTableFilterComposer f) f,
  ) {
    final $$DishesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dishes,
      getReferencedColumn: (t) => t.userProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DishesTableFilterComposer(
            $db: $db,
            $table: $db.dishes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> allergenTagsRefs(
    Expression<bool> Function($$AllergenTagsTableFilterComposer f) f,
  ) {
    final $$AllergenTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.allergenTags,
      getReferencedColumn: (t) => t.userProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AllergenTagsTableFilterComposer(
            $db: $db,
            $table: $db.allergenTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> generatedPlansRefs(
    Expression<bool> Function($$GeneratedPlansTableFilterComposer f) f,
  ) {
    final $$GeneratedPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.generatedPlans,
      getReferencedColumn: (t) => t.userProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GeneratedPlansTableFilterComposer(
            $db: $db,
            $table: $db.generatedPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> budgetEntriesRefs(
    Expression<bool> Function($$BudgetEntriesTableFilterComposer f) f,
  ) {
    final $$BudgetEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.userProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableFilterComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyBudgetCents => $composableBuilder(
    column: $table.weeklyBudgetCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeDays => $composableBuilder(
    column: $table.activeDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mealsPerDay => $composableBuilder(
    column: $table.mealsPerDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealTimesJson => $composableBuilder(
    column: $table.mealTimesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalPreset => $composableBuilder(
    column: $table.goalPreset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weeklyBudgetCents => $composableBuilder(
    column: $table.weeklyBudgetCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activeDays => $composableBuilder(
    column: $table.activeDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mealsPerDay => $composableBuilder(
    column: $table.mealsPerDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mealTimesJson => $composableBuilder(
    column: $table.mealTimesJson,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goalPreset => $composableBuilder(
    column: $table.goalPreset,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> dishesRefs<T extends Object>(
    Expression<T> Function($$DishesTableAnnotationComposer a) f,
  ) {
    final $$DishesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dishes,
      getReferencedColumn: (t) => t.userProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DishesTableAnnotationComposer(
            $db: $db,
            $table: $db.dishes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> allergenTagsRefs<T extends Object>(
    Expression<T> Function($$AllergenTagsTableAnnotationComposer a) f,
  ) {
    final $$AllergenTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.allergenTags,
      getReferencedColumn: (t) => t.userProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AllergenTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.allergenTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> generatedPlansRefs<T extends Object>(
    Expression<T> Function($$GeneratedPlansTableAnnotationComposer a) f,
  ) {
    final $$GeneratedPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.generatedPlans,
      getReferencedColumn: (t) => t.userProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GeneratedPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.generatedPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> budgetEntriesRefs<T extends Object>(
    Expression<T> Function($$BudgetEntriesTableAnnotationComposer a) f,
  ) {
    final $$BudgetEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.userProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (UserProfile, $$UserProfilesTableReferences),
          UserProfile,
          PrefetchHooks Function({
            bool dishesRefs,
            bool allergenTagsRefs,
            bool generatedPlansRefs,
            bool budgetEntriesRefs,
          })
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<int> weeklyBudgetCents = const Value.absent(),
                Value<String> activeDays = const Value.absent(),
                Value<int> mealsPerDay = const Value.absent(),
                Value<String> mealTimesJson = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<String?> sex = const Value.absent(),
                Value<String> activityLevel = const Value.absent(),
                Value<String> goalPreset = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                email: email,
                displayName: displayName,
                weeklyBudgetCents: weeklyBudgetCents,
                activeDays: activeDays,
                mealsPerDay: mealsPerDay,
                mealTimesJson: mealTimesJson,
                weightKg: weightKg,
                heightCm: heightCm,
                age: age,
                sex: sex,
                activityLevel: activityLevel,
                goalPreset: goalPreset,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String email,
                Value<String?> displayName = const Value.absent(),
                Value<int> weeklyBudgetCents = const Value.absent(),
                Value<String> activeDays = const Value.absent(),
                Value<int> mealsPerDay = const Value.absent(),
                Value<String> mealTimesJson = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<String?> sex = const Value.absent(),
                Value<String> activityLevel = const Value.absent(),
                Value<String> goalPreset = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => UserProfilesCompanion.insert(
                id: id,
                email: email,
                displayName: displayName,
                weeklyBudgetCents: weeklyBudgetCents,
                activeDays: activeDays,
                mealsPerDay: mealsPerDay,
                mealTimesJson: mealTimesJson,
                weightKg: weightKg,
                heightCm: heightCm,
                age: age,
                sex: sex,
                activityLevel: activityLevel,
                goalPreset: goalPreset,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserProfilesTable, UserProfile>(table),
                  $$UserProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                dishesRefs = false,
                allergenTagsRefs = false,
                generatedPlansRefs = false,
                budgetEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (dishesRefs) db.dishes,
                    if (allergenTagsRefs) db.allergenTags,
                    if (generatedPlansRefs) db.generatedPlans,
                    if (budgetEntriesRefs) db.budgetEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (dishesRefs)
                        await $_getPrefetchedData<
                          UserProfile,
                          $UserProfilesTable,
                          Dishe
                        >(
                          currentTable: table,
                          referencedTable: $$UserProfilesTableReferences
                              ._dishesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UserProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).dishesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userProfileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (allergenTagsRefs)
                        await $_getPrefetchedData<
                          UserProfile,
                          $UserProfilesTable,
                          AllergenTag
                        >(
                          currentTable: table,
                          referencedTable: $$UserProfilesTableReferences
                              ._allergenTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UserProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).allergenTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userProfileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (generatedPlansRefs)
                        await $_getPrefetchedData<
                          UserProfile,
                          $UserProfilesTable,
                          GeneratedPlan
                        >(
                          currentTable: table,
                          referencedTable: $$UserProfilesTableReferences
                              ._generatedPlansRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UserProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).generatedPlansRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userProfileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (budgetEntriesRefs)
                        await $_getPrefetchedData<
                          UserProfile,
                          $UserProfilesTable,
                          BudgetEntry
                        >(
                          currentTable: table,
                          referencedTable: $$UserProfilesTableReferences
                              ._budgetEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UserProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userProfileId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (UserProfile, $$UserProfilesTableReferences),
      UserProfile,
      PrefetchHooks Function({
        bool dishesRefs,
        bool allergenTagsRefs,
        bool generatedPlansRefs,
        bool budgetEntriesRefs,
      })
    >;
typedef $$DishesTableCreateCompanionBuilder = DishesCompanion Function({
  Value<int> id,
  required int userProfileId,
  required String name,
  required int priceCents,
  Value<String?> cuisineTag,
  Value<String?> photoPath,
  Value<String> source,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> isDeleted,
});
typedef $$DishesTableUpdateCompanionBuilder = DishesCompanion Function({
  Value<int> id,
  Value<int> userProfileId,
  Value<String> name,
  Value<int> priceCents,
  Value<String?> cuisineTag,
  Value<String?> photoPath,
  Value<String> source,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isDeleted,
});

final class $$DishesTableReferences
    extends BaseReferences<_$AppDatabase, $DishesTable, Dishe> {
  $$DishesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UserProfilesTable _userProfileIdTable(_$AppDatabase db) =>
      db.userProfiles.createAlias('dishes__user_profile_id__user_profiles__id');

  $$UserProfilesTableProcessedTableManager get userProfileId {
    final $_column = $_itemColumn<int>('user_profile_id')!;

    final manager = $$UserProfilesTableTableManager(
      $_db,
      $_db.userProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userProfileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$IngredientsTable, List<Ingredient>>
  _ingredientsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ingredients,
    aliasName: 'dishes__id__ingredients__dish_id',
  );

  $$IngredientsTableProcessedTableManager get ingredientsRefs {
    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.dishId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ingredientsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DishAllergenTagsTable, List<DishAllergenTag>>
  _dishAllergenTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dishAllergenTags,
    aliasName: 'dishes__id__dish_allergen_tags__dish_id',
  );

  $$DishAllergenTagsTableProcessedTableManager get dishAllergenTagsRefs {
    final manager = $$DishAllergenTagsTableTableManager(
      $_db,
      $_db.dishAllergenTags,
    ).filter((f) => f.dishId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dishAllergenTagsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MealSlotsTable, List<MealSlot>>
  _mealSlotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealSlots,
    aliasName: 'dishes__id__meal_slots__dish_id',
  );

  $$MealSlotsTableProcessedTableManager get mealSlotsRefs {
    final manager = $$MealSlotsTableTableManager(
      $_db,
      $_db.mealSlots,
    ).filter((f) => f.dishId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealSlotsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MealSlotItemsTable, List<MealSlotItem>>
  _mealSlotItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealSlotItems,
    aliasName: 'dishes__id__meal_slot_items__dish_id',
  );

  $$MealSlotItemsTableProcessedTableManager get mealSlotItemsRefs {
    final manager = $$MealSlotItemsTableTableManager(
      $_db,
      $_db.mealSlotItems,
    ).filter((f) => f.dishId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealSlotItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DishesTableFilterComposer
    extends Composer<_$AppDatabase, $DishesTable> {
  $$DishesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cuisineTag => $composableBuilder(
    column: $table.cuisineTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableFilterComposer get userProfileId {
    final $$UserProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userProfileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableFilterComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ingredientsRefs(
    Expression<bool> Function($$IngredientsTableFilterComposer f) f,
  ) {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.dishId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dishAllergenTagsRefs(
    Expression<bool> Function($$DishAllergenTagsTableFilterComposer f) f,
  ) {
    final $$DishAllergenTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dishAllergenTags,
      getReferencedColumn: (t) => t.dishId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DishAllergenTagsTableFilterComposer(
            $db: $db,
            $table: $db.dishAllergenTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mealSlotsRefs(
    Expression<bool> Function($$MealSlotsTableFilterComposer f) f,
  ) {
    final $$MealSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealSlots,
      getReferencedColumn: (t) => t.dishId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotsTableFilterComposer(
            $db: $db,
            $table: $db.mealSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mealSlotItemsRefs(
    Expression<bool> Function($$MealSlotItemsTableFilterComposer f) f,
  ) {
    final $$MealSlotItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealSlotItems,
      getReferencedColumn: (t) => t.dishId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotItemsTableFilterComposer(
            $db: $db,
            $table: $db.mealSlotItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DishesTableOrderingComposer
    extends Composer<_$AppDatabase, $DishesTable> {
  $$DishesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cuisineTag => $composableBuilder(
    column: $table.cuisineTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableOrderingComposer get userProfileId {
    final $$UserProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userProfileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DishesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DishesTable> {
  $$DishesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cuisineTag => $composableBuilder(
    column: $table.cuisineTag,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$UserProfilesTableAnnotationComposer get userProfileId {
    final $$UserProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userProfileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ingredientsRefs<T extends Object>(
    Expression<T> Function($$IngredientsTableAnnotationComposer a) f,
  ) {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.dishId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> dishAllergenTagsRefs<T extends Object>(
    Expression<T> Function($$DishAllergenTagsTableAnnotationComposer a) f,
  ) {
    final $$DishAllergenTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dishAllergenTags,
      getReferencedColumn: (t) => t.dishId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DishAllergenTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.dishAllergenTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> mealSlotsRefs<T extends Object>(
    Expression<T> Function($$MealSlotsTableAnnotationComposer a) f,
  ) {
    final $$MealSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealSlots,
      getReferencedColumn: (t) => t.dishId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.mealSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> mealSlotItemsRefs<T extends Object>(
    Expression<T> Function($$MealSlotItemsTableAnnotationComposer a) f,
  ) {
    final $$MealSlotItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealSlotItems,
      getReferencedColumn: (t) => t.dishId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.mealSlotItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DishesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DishesTable,
          Dishe,
          $$DishesTableFilterComposer,
          $$DishesTableOrderingComposer,
          $$DishesTableAnnotationComposer,
          $$DishesTableCreateCompanionBuilder,
          $$DishesTableUpdateCompanionBuilder,
          (Dishe, $$DishesTableReferences),
          Dishe,
          PrefetchHooks Function({
            bool userProfileId,
            bool ingredientsRefs,
            bool dishAllergenTagsRefs,
            bool mealSlotsRefs,
            bool mealSlotItemsRefs,
          })
        > {
  $$DishesTableTableManager(_$AppDatabase db, $DishesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DishesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DishesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DishesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userProfileId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> priceCents = const Value.absent(),
                Value<String?> cuisineTag = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => DishesCompanion(
                id: id,
                userProfileId: userProfileId,
                name: name,
                priceCents: priceCents,
                cuisineTag: cuisineTag,
                photoPath: photoPath,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userProfileId,
                required String name,
                required int priceCents,
                Value<String?> cuisineTag = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String> source = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isDeleted = const Value.absent(),
              }) => DishesCompanion.insert(
                id: id,
                userProfileId: userProfileId,
                name: name,
                priceCents: priceCents,
                cuisineTag: cuisineTag,
                photoPath: photoPath,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DishesTable, Dishe>(table),
                  $$DishesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                userProfileId = false,
                ingredientsRefs = false,
                dishAllergenTagsRefs = false,
                mealSlotsRefs = false,
                mealSlotItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ingredientsRefs) db.ingredients,
                    if (dishAllergenTagsRefs) db.dishAllergenTags,
                    if (mealSlotsRefs) db.mealSlots,
                    if (mealSlotItemsRefs) db.mealSlotItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (userProfileId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.userProfileId,
                            referencedTable: $$DishesTableReferences
                                ._userProfileIdTable(db),
                            referencedColumn: $$DishesTableReferences
                                ._userProfileIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ingredientsRefs)
                        await $_getPrefetchedData<
                          Dishe,
                          $DishesTable,
                          Ingredient
                        >(
                          currentTable: table,
                          referencedTable: $$DishesTableReferences
                              ._ingredientsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DishesTableReferences(
                                db,
                                table,
                                p0,
                              ).ingredientsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.dishId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (dishAllergenTagsRefs)
                        await $_getPrefetchedData<
                          Dishe,
                          $DishesTable,
                          DishAllergenTag
                        >(
                          currentTable: table,
                          referencedTable: $$DishesTableReferences
                              ._dishAllergenTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DishesTableReferences(
                                db,
                                table,
                                p0,
                              ).dishAllergenTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.dishId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mealSlotsRefs)
                        await $_getPrefetchedData<
                          Dishe,
                          $DishesTable,
                          MealSlot
                        >(
                          currentTable: table,
                          referencedTable: $$DishesTableReferences
                              ._mealSlotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DishesTableReferences(
                                db,
                                table,
                                p0,
                              ).mealSlotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.dishId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mealSlotItemsRefs)
                        await $_getPrefetchedData<
                          Dishe,
                          $DishesTable,
                          MealSlotItem
                        >(
                          currentTable: table,
                          referencedTable: $$DishesTableReferences
                              ._mealSlotItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DishesTableReferences(
                                db,
                                table,
                                p0,
                              ).mealSlotItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.dishId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DishesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DishesTable,
      Dishe,
      $$DishesTableFilterComposer,
      $$DishesTableOrderingComposer,
      $$DishesTableAnnotationComposer,
      $$DishesTableCreateCompanionBuilder,
      $$DishesTableUpdateCompanionBuilder,
      (Dishe, $$DishesTableReferences),
      Dishe,
      PrefetchHooks Function({
        bool userProfileId,
        bool ingredientsRefs,
        bool dishAllergenTagsRefs,
        bool mealSlotsRefs,
        bool mealSlotItemsRefs,
      })
    >;
typedef $$IngredientsTableCreateCompanionBuilder =
    IngredientsCompanion Function({
      Value<int> id,
      required int dishId,
      required String name,
      Value<double> quantity,
      Value<String> unit,
      Value<double> calories,
      Value<double> proteinG,
      Value<double> carbsG,
      Value<double> fatG,
      Value<String?> micronutrientsJson,
      Value<int?> usdaFdcId,
      Value<bool> isCachedFromApi,
    });
typedef $$IngredientsTableUpdateCompanionBuilder =
    IngredientsCompanion Function({
      Value<int> id,
      Value<int> dishId,
      Value<String> name,
      Value<double> quantity,
      Value<String> unit,
      Value<double> calories,
      Value<double> proteinG,
      Value<double> carbsG,
      Value<double> fatG,
      Value<String?> micronutrientsJson,
      Value<int?> usdaFdcId,
      Value<bool> isCachedFromApi,
    });

final class $$IngredientsTableReferences
    extends BaseReferences<_$AppDatabase, $IngredientsTable, Ingredient> {
  $$IngredientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DishesTable _dishIdTable(_$AppDatabase db) =>
      db.dishes.createAlias('ingredients__dish_id__dishes__id');

  $$DishesTableProcessedTableManager get dishId {
    final $_column = $_itemColumn<int>('dish_id')!;

    final manager = $$DishesTableTableManager(
      $_db,
      $_db.dishes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dishIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get micronutrientsJson => $composableBuilder(
    column: $table.micronutrientsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usdaFdcId => $composableBuilder(
    column: $table.usdaFdcId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCachedFromApi => $composableBuilder(
    column: $table.isCachedFromApi,
    builder: (column) => ColumnFilters(column),
  );

  $$DishesTableFilterComposer get dishId {
    final $$DishesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dishId,
      referencedTable: $db.dishes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DishesTableFilterComposer(
            $db: $db,
            $table: $db.dishes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get micronutrientsJson => $composableBuilder(
    column: $table.micronutrientsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usdaFdcId => $composableBuilder(
    column: $table.usdaFdcId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCachedFromApi => $composableBuilder(
    column: $table.isCachedFromApi,
    builder: (column) => ColumnOrderings(column),
  );

  $$DishesTableOrderingComposer get dishId {
    final $$DishesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dishId,
      referencedTable: $db.dishes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DishesTableOrderingComposer(
            $db: $db,
            $table: $db.dishes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get proteinG =>
      $composableBuilder(column: $table.proteinG, builder: (column) => column);

  GeneratedColumn<double> get carbsG =>
      $composableBuilder(column: $table.carbsG, builder: (column) => column);

  GeneratedColumn<double> get fatG =>
      $composableBuilder(column: $table.fatG, builder: (column) => column);

  GeneratedColumn<String> get micronutrientsJson => $composableBuilder(
    column: $table.micronutrientsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get usdaFdcId =>
      $composableBuilder(column: $table.usdaFdcId, builder: (column) => column);

  GeneratedColumn<bool> get isCachedFromApi => $composableBuilder(
    column: $table.isCachedFromApi,
    builder: (column) => column,
  );

  $$DishesTableAnnotationComposer get dishId {
    final $$DishesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dishId,
      referencedTable: $db.dishes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DishesTableAnnotationComposer(
            $db: $db,
            $table: $db.dishes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientsTable,
          Ingredient,
          $$IngredientsTableFilterComposer,
          $$IngredientsTableOrderingComposer,
          $$IngredientsTableAnnotationComposer,
          $$IngredientsTableCreateCompanionBuilder,
          $$IngredientsTableUpdateCompanionBuilder,
          (Ingredient, $$IngredientsTableReferences),
          Ingredient,
          PrefetchHooks Function({bool dishId})
        > {
  $$IngredientsTableTableManager(_$AppDatabase db, $IngredientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dishId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> proteinG = const Value.absent(),
                Value<double> carbsG = const Value.absent(),
                Value<double> fatG = const Value.absent(),
                Value<String?> micronutrientsJson = const Value.absent(),
                Value<int?> usdaFdcId = const Value.absent(),
                Value<bool> isCachedFromApi = const Value.absent(),
              }) => IngredientsCompanion(
                id: id,
                dishId: dishId,
                name: name,
                quantity: quantity,
                unit: unit,
                calories: calories,
                proteinG: proteinG,
                carbsG: carbsG,
                fatG: fatG,
                micronutrientsJson: micronutrientsJson,
                usdaFdcId: usdaFdcId,
                isCachedFromApi: isCachedFromApi,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int dishId,
                required String name,
                Value<double> quantity = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> proteinG = const Value.absent(),
                Value<double> carbsG = const Value.absent(),
                Value<double> fatG = const Value.absent(),
                Value<String?> micronutrientsJson = const Value.absent(),
                Value<int?> usdaFdcId = const Value.absent(),
                Value<bool> isCachedFromApi = const Value.absent(),
              }) => IngredientsCompanion.insert(
                id: id,
                dishId: dishId,
                name: name,
                quantity: quantity,
                unit: unit,
                calories: calories,
                proteinG: proteinG,
                carbsG: carbsG,
                fatG: fatG,
                micronutrientsJson: micronutrientsJson,
                usdaFdcId: usdaFdcId,
                isCachedFromApi: isCachedFromApi,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IngredientsTable, Ingredient>(table),
                  $$IngredientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({dishId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (dishId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.dishId,
                        referencedTable: $$IngredientsTableReferences
                            ._dishIdTable(db),
                        referencedColumn: $$IngredientsTableReferences
                            ._dishIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientsTable,
      Ingredient,
      $$IngredientsTableFilterComposer,
      $$IngredientsTableOrderingComposer,
      $$IngredientsTableAnnotationComposer,
      $$IngredientsTableCreateCompanionBuilder,
      $$IngredientsTableUpdateCompanionBuilder,
      (Ingredient, $$IngredientsTableReferences),
      Ingredient,
      PrefetchHooks Function({bool dishId})
    >;
typedef $$NutritionCachesTableCreateCompanionBuilder =
    NutritionCachesCompanion Function({
      required String name,
      required double calories,
      required double proteinG,
      required double carbsG,
      required double fatG,
      Value<int?> usdaFdcId,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$NutritionCachesTableUpdateCompanionBuilder =
    NutritionCachesCompanion Function({
      Value<String> name,
      Value<double> calories,
      Value<double> proteinG,
      Value<double> carbsG,
      Value<double> fatG,
      Value<int?> usdaFdcId,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$NutritionCachesTableFilterComposer
    extends Composer<_$AppDatabase, $NutritionCachesTable> {
  $$NutritionCachesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usdaFdcId => $composableBuilder(
    column: $table.usdaFdcId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NutritionCachesTableOrderingComposer
    extends Composer<_$AppDatabase, $NutritionCachesTable> {
  $$NutritionCachesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usdaFdcId => $composableBuilder(
    column: $table.usdaFdcId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NutritionCachesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NutritionCachesTable> {
  $$NutritionCachesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get proteinG =>
      $composableBuilder(column: $table.proteinG, builder: (column) => column);

  GeneratedColumn<double> get carbsG =>
      $composableBuilder(column: $table.carbsG, builder: (column) => column);

  GeneratedColumn<double> get fatG =>
      $composableBuilder(column: $table.fatG, builder: (column) => column);

  GeneratedColumn<int> get usdaFdcId =>
      $composableBuilder(column: $table.usdaFdcId, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$NutritionCachesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NutritionCachesTable,
          NutritionCache,
          $$NutritionCachesTableFilterComposer,
          $$NutritionCachesTableOrderingComposer,
          $$NutritionCachesTableAnnotationComposer,
          $$NutritionCachesTableCreateCompanionBuilder,
          $$NutritionCachesTableUpdateCompanionBuilder,
          (
            NutritionCache,
            BaseReferences<
              _$AppDatabase,
              $NutritionCachesTable,
              NutritionCache
            >,
          ),
          NutritionCache,
          PrefetchHooks Function()
        > {
  $$NutritionCachesTableTableManager(
    _$AppDatabase db,
    $NutritionCachesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NutritionCachesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NutritionCachesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NutritionCachesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> name = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> proteinG = const Value.absent(),
                Value<double> carbsG = const Value.absent(),
                Value<double> fatG = const Value.absent(),
                Value<int?> usdaFdcId = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NutritionCachesCompanion(
                name: name,
                calories: calories,
                proteinG: proteinG,
                carbsG: carbsG,
                fatG: fatG,
                usdaFdcId: usdaFdcId,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String name,
                required double calories,
                required double proteinG,
                required double carbsG,
                required double fatG,
                Value<int?> usdaFdcId = const Value.absent(),
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => NutritionCachesCompanion.insert(
                name: name,
                calories: calories,
                proteinG: proteinG,
                carbsG: carbsG,
                fatG: fatG,
                usdaFdcId: usdaFdcId,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NutritionCachesTable, NutritionCache>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $NutritionCachesTable,
                    NutritionCache
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NutritionCachesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NutritionCachesTable,
      NutritionCache,
      $$NutritionCachesTableFilterComposer,
      $$NutritionCachesTableOrderingComposer,
      $$NutritionCachesTableAnnotationComposer,
      $$NutritionCachesTableCreateCompanionBuilder,
      $$NutritionCachesTableUpdateCompanionBuilder,
      (
        NutritionCache,
        BaseReferences<_$AppDatabase, $NutritionCachesTable, NutritionCache>,
      ),
      NutritionCache,
      PrefetchHooks Function()
    >;
typedef $$AllergenTagsTableCreateCompanionBuilder =
    AllergenTagsCompanion Function({
      Value<int> id,
      required int userProfileId,
      required String label,
    });
typedef $$AllergenTagsTableUpdateCompanionBuilder =
    AllergenTagsCompanion Function({
      Value<int> id,
      Value<int> userProfileId,
      Value<String> label,
    });

final class $$AllergenTagsTableReferences
    extends BaseReferences<_$AppDatabase, $AllergenTagsTable, AllergenTag> {
  $$AllergenTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UserProfilesTable _userProfileIdTable(_$AppDatabase db) => db
      .userProfiles
      .createAlias('allergen_tags__user_profile_id__user_profiles__id');

  $$UserProfilesTableProcessedTableManager get userProfileId {
    final $_column = $_itemColumn<int>('user_profile_id')!;

    final manager = $$UserProfilesTableTableManager(
      $_db,
      $_db.userProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userProfileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$DishAllergenTagsTable, List<DishAllergenTag>>
  _dishAllergenTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dishAllergenTags,
    aliasName: 'allergen_tags__id__dish_allergen_tags__allergen_tag_id',
  );

  $$DishAllergenTagsTableProcessedTableManager get dishAllergenTagsRefs {
    final manager = $$DishAllergenTagsTableTableManager(
      $_db,
      $_db.dishAllergenTags,
    ).filter((f) => f.allergenTagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dishAllergenTagsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AllergenTagsTableFilterComposer
    extends Composer<_$AppDatabase, $AllergenTagsTable> {
  $$AllergenTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableFilterComposer get userProfileId {
    final $$UserProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userProfileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableFilterComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> dishAllergenTagsRefs(
    Expression<bool> Function($$DishAllergenTagsTableFilterComposer f) f,
  ) {
    final $$DishAllergenTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dishAllergenTags,
      getReferencedColumn: (t) => t.allergenTagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DishAllergenTagsTableFilterComposer(
            $db: $db,
            $table: $db.dishAllergenTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AllergenTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $AllergenTagsTable> {
  $$AllergenTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableOrderingComposer get userProfileId {
    final $$UserProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userProfileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AllergenTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AllergenTagsTable> {
  $$AllergenTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  $$UserProfilesTableAnnotationComposer get userProfileId {
    final $$UserProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userProfileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> dishAllergenTagsRefs<T extends Object>(
    Expression<T> Function($$DishAllergenTagsTableAnnotationComposer a) f,
  ) {
    final $$DishAllergenTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dishAllergenTags,
      getReferencedColumn: (t) => t.allergenTagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DishAllergenTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.dishAllergenTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AllergenTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AllergenTagsTable,
          AllergenTag,
          $$AllergenTagsTableFilterComposer,
          $$AllergenTagsTableOrderingComposer,
          $$AllergenTagsTableAnnotationComposer,
          $$AllergenTagsTableCreateCompanionBuilder,
          $$AllergenTagsTableUpdateCompanionBuilder,
          (AllergenTag, $$AllergenTagsTableReferences),
          AllergenTag,
          PrefetchHooks Function({
            bool userProfileId,
            bool dishAllergenTagsRefs,
          })
        > {
  $$AllergenTagsTableTableManager(_$AppDatabase db, $AllergenTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AllergenTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AllergenTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AllergenTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userProfileId = const Value.absent(),
                Value<String> label = const Value.absent(),
              }) => AllergenTagsCompanion(
                id: id,
                userProfileId: userProfileId,
                label: label,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userProfileId,
                required String label,
              }) => AllergenTagsCompanion.insert(
                id: id,
                userProfileId: userProfileId,
                label: label,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AllergenTagsTable, AllergenTag>(table),
                  $$AllergenTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({userProfileId = false, dishAllergenTagsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (dishAllergenTagsRefs) db.dishAllergenTags,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (userProfileId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.userProfileId,
                            referencedTable: $$AllergenTagsTableReferences
                                ._userProfileIdTable(db),
                            referencedColumn: $$AllergenTagsTableReferences
                                ._userProfileIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (dishAllergenTagsRefs)
                        await $_getPrefetchedData<
                          AllergenTag,
                          $AllergenTagsTable,
                          DishAllergenTag
                        >(
                          currentTable: table,
                          referencedTable: $$AllergenTagsTableReferences
                              ._dishAllergenTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AllergenTagsTableReferences(
                                db,
                                table,
                                p0,
                              ).dishAllergenTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.allergenTagId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AllergenTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AllergenTagsTable,
      AllergenTag,
      $$AllergenTagsTableFilterComposer,
      $$AllergenTagsTableOrderingComposer,
      $$AllergenTagsTableAnnotationComposer,
      $$AllergenTagsTableCreateCompanionBuilder,
      $$AllergenTagsTableUpdateCompanionBuilder,
      (AllergenTag, $$AllergenTagsTableReferences),
      AllergenTag,
      PrefetchHooks Function({bool userProfileId, bool dishAllergenTagsRefs})
    >;
typedef $$DishAllergenTagsTableCreateCompanionBuilder =
    DishAllergenTagsCompanion Function({
      required int dishId,
      required int allergenTagId,
      Value<int> rowid,
    });
typedef $$DishAllergenTagsTableUpdateCompanionBuilder =
    DishAllergenTagsCompanion Function({
      Value<int> dishId,
      Value<int> allergenTagId,
      Value<int> rowid,
    });

final class $$DishAllergenTagsTableReferences
    extends
        BaseReferences<_$AppDatabase, $DishAllergenTagsTable, DishAllergenTag> {
  $$DishAllergenTagsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DishesTable _dishIdTable(_$AppDatabase db) =>
      db.dishes.createAlias('dish_allergen_tags__dish_id__dishes__id');

  $$DishesTableProcessedTableManager get dishId {
    final $_column = $_itemColumn<int>('dish_id')!;

    final manager = $$DishesTableTableManager(
      $_db,
      $_db.dishes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dishIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AllergenTagsTable _allergenTagIdTable(_$AppDatabase db) => db
      .allergenTags
      .createAlias('dish_allergen_tags__allergen_tag_id__allergen_tags__id');

  $$AllergenTagsTableProcessedTableManager get allergenTagId {
    final $_column = $_itemColumn<int>('allergen_tag_id')!;

    final manager = $$AllergenTagsTableTableManager(
      $_db,
      $_db.allergenTags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_allergenTagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DishAllergenTagsTableFilterComposer
    extends Composer<_$AppDatabase, $DishAllergenTagsTable> {
  $$DishAllergenTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$DishesTableFilterComposer get dishId {
    final $$DishesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dishId,
      referencedTable: $db.dishes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DishesTableFilterComposer(
            $db: $db,
            $table: $db.dishes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AllergenTagsTableFilterComposer get allergenTagId {
    final $$AllergenTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.allergenTagId,
      referencedTable: $db.allergenTags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AllergenTagsTableFilterComposer(
            $db: $db,
            $table: $db.allergenTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DishAllergenTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $DishAllergenTagsTable> {
  $$DishAllergenTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$DishesTableOrderingComposer get dishId {
    final $$DishesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dishId,
      referencedTable: $db.dishes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DishesTableOrderingComposer(
            $db: $db,
            $table: $db.dishes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AllergenTagsTableOrderingComposer get allergenTagId {
    final $$AllergenTagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.allergenTagId,
      referencedTable: $db.allergenTags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AllergenTagsTableOrderingComposer(
            $db: $db,
            $table: $db.allergenTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DishAllergenTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DishAllergenTagsTable> {
  $$DishAllergenTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$DishesTableAnnotationComposer get dishId {
    final $$DishesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dishId,
      referencedTable: $db.dishes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DishesTableAnnotationComposer(
            $db: $db,
            $table: $db.dishes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AllergenTagsTableAnnotationComposer get allergenTagId {
    final $$AllergenTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.allergenTagId,
      referencedTable: $db.allergenTags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AllergenTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.allergenTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DishAllergenTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DishAllergenTagsTable,
          DishAllergenTag,
          $$DishAllergenTagsTableFilterComposer,
          $$DishAllergenTagsTableOrderingComposer,
          $$DishAllergenTagsTableAnnotationComposer,
          $$DishAllergenTagsTableCreateCompanionBuilder,
          $$DishAllergenTagsTableUpdateCompanionBuilder,
          (DishAllergenTag, $$DishAllergenTagsTableReferences),
          DishAllergenTag,
          PrefetchHooks Function({bool dishId, bool allergenTagId})
        > {
  $$DishAllergenTagsTableTableManager(
    _$AppDatabase db,
    $DishAllergenTagsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DishAllergenTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DishAllergenTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DishAllergenTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> dishId = const Value.absent(),
                Value<int> allergenTagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DishAllergenTagsCompanion(
                dishId: dishId,
                allergenTagId: allergenTagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int dishId,
                required int allergenTagId,
                Value<int> rowid = const Value.absent(),
              }) => DishAllergenTagsCompanion.insert(
                dishId: dishId,
                allergenTagId: allergenTagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DishAllergenTagsTable, DishAllergenTag>(table),
                  $$DishAllergenTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({dishId = false, allergenTagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (dishId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.dishId,
                        referencedTable: $$DishAllergenTagsTableReferences
                            ._dishIdTable(db),
                        referencedColumn: $$DishAllergenTagsTableReferences
                            ._dishIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (allergenTagId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.allergenTagId,
                        referencedTable: $$DishAllergenTagsTableReferences
                            ._allergenTagIdTable(db),
                        referencedColumn: $$DishAllergenTagsTableReferences
                            ._allergenTagIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DishAllergenTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DishAllergenTagsTable,
      DishAllergenTag,
      $$DishAllergenTagsTableFilterComposer,
      $$DishAllergenTagsTableOrderingComposer,
      $$DishAllergenTagsTableAnnotationComposer,
      $$DishAllergenTagsTableCreateCompanionBuilder,
      $$DishAllergenTagsTableUpdateCompanionBuilder,
      (DishAllergenTag, $$DishAllergenTagsTableReferences),
      DishAllergenTag,
      PrefetchHooks Function({bool dishId, bool allergenTagId})
    >;
typedef $$GeneratedPlansTableCreateCompanionBuilder =
    GeneratedPlansCompanion Function({
      Value<int> id,
      required int userProfileId,
      required DateTime weekStartDate,
      required DateTime generatedAt,
      required int totalProjectedCostCents,
      Value<bool> isOverBudget,
      required int version,
      Value<bool> isActive,
      Value<String> planningFocus,
      Value<String> currencyCode,
    });
typedef $$GeneratedPlansTableUpdateCompanionBuilder =
    GeneratedPlansCompanion Function({
      Value<int> id,
      Value<int> userProfileId,
      Value<DateTime> weekStartDate,
      Value<DateTime> generatedAt,
      Value<int> totalProjectedCostCents,
      Value<bool> isOverBudget,
      Value<int> version,
      Value<bool> isActive,
      Value<String> planningFocus,
      Value<String> currencyCode,
    });

final class $$GeneratedPlansTableReferences
    extends BaseReferences<_$AppDatabase, $GeneratedPlansTable, GeneratedPlan> {
  $$GeneratedPlansTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserProfilesTable _userProfileIdTable(_$AppDatabase db) => db
      .userProfiles
      .createAlias('generated_plans__user_profile_id__user_profiles__id');

  $$UserProfilesTableProcessedTableManager get userProfileId {
    final $_column = $_itemColumn<int>('user_profile_id')!;

    final manager = $$UserProfilesTableTableManager(
      $_db,
      $_db.userProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userProfileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MealSlotsTable, List<MealSlot>>
  _mealSlotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealSlots,
    aliasName: 'generated_plans__id__meal_slots__generated_plan_id',
  );

  $$MealSlotsTableProcessedTableManager get mealSlotsRefs {
    final manager = $$MealSlotsTableTableManager(
      $_db,
      $_db.mealSlots,
    ).filter((f) => f.generatedPlanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealSlotsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BudgetEntriesTable, List<BudgetEntry>>
  _budgetEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetEntries,
    aliasName: 'generated_plans__id__budget_entries__generated_plan_id',
  );

  $$BudgetEntriesTableProcessedTableManager get budgetEntriesRefs {
    final manager = $$BudgetEntriesTableTableManager(
      $_db,
      $_db.budgetEntries,
    ).filter((f) => f.generatedPlanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GeneratedPlansTableFilterComposer
    extends Composer<_$AppDatabase, $GeneratedPlansTable> {
  $$GeneratedPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get weekStartDate => $composableBuilder(
    column: $table.weekStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalProjectedCostCents => $composableBuilder(
    column: $table.totalProjectedCostCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOverBudget => $composableBuilder(
    column: $table.isOverBudget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planningFocus => $composableBuilder(
    column: $table.planningFocus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableFilterComposer get userProfileId {
    final $$UserProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userProfileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableFilterComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> mealSlotsRefs(
    Expression<bool> Function($$MealSlotsTableFilterComposer f) f,
  ) {
    final $$MealSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealSlots,
      getReferencedColumn: (t) => t.generatedPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotsTableFilterComposer(
            $db: $db,
            $table: $db.mealSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> budgetEntriesRefs(
    Expression<bool> Function($$BudgetEntriesTableFilterComposer f) f,
  ) {
    final $$BudgetEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.generatedPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableFilterComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GeneratedPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $GeneratedPlansTable> {
  $$GeneratedPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get weekStartDate => $composableBuilder(
    column: $table.weekStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalProjectedCostCents => $composableBuilder(
    column: $table.totalProjectedCostCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOverBudget => $composableBuilder(
    column: $table.isOverBudget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planningFocus => $composableBuilder(
    column: $table.planningFocus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableOrderingComposer get userProfileId {
    final $$UserProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userProfileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GeneratedPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $GeneratedPlansTable> {
  $$GeneratedPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get weekStartDate => $composableBuilder(
    column: $table.weekStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalProjectedCostCents => $composableBuilder(
    column: $table.totalProjectedCostCents,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isOverBudget => $composableBuilder(
    column: $table.isOverBudget,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get planningFocus => $composableBuilder(
    column: $table.planningFocus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  $$UserProfilesTableAnnotationComposer get userProfileId {
    final $$UserProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userProfileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> mealSlotsRefs<T extends Object>(
    Expression<T> Function($$MealSlotsTableAnnotationComposer a) f,
  ) {
    final $$MealSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealSlots,
      getReferencedColumn: (t) => t.generatedPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.mealSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> budgetEntriesRefs<T extends Object>(
    Expression<T> Function($$BudgetEntriesTableAnnotationComposer a) f,
  ) {
    final $$BudgetEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.generatedPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GeneratedPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GeneratedPlansTable,
          GeneratedPlan,
          $$GeneratedPlansTableFilterComposer,
          $$GeneratedPlansTableOrderingComposer,
          $$GeneratedPlansTableAnnotationComposer,
          $$GeneratedPlansTableCreateCompanionBuilder,
          $$GeneratedPlansTableUpdateCompanionBuilder,
          (GeneratedPlan, $$GeneratedPlansTableReferences),
          GeneratedPlan,
          PrefetchHooks Function({
            bool userProfileId,
            bool mealSlotsRefs,
            bool budgetEntriesRefs,
          })
        > {
  $$GeneratedPlansTableTableManager(
    _$AppDatabase db,
    $GeneratedPlansTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GeneratedPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GeneratedPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GeneratedPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userProfileId = const Value.absent(),
                Value<DateTime> weekStartDate = const Value.absent(),
                Value<DateTime> generatedAt = const Value.absent(),
                Value<int> totalProjectedCostCents = const Value.absent(),
                Value<bool> isOverBudget = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String> planningFocus = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
              }) => GeneratedPlansCompanion(
                id: id,
                userProfileId: userProfileId,
                weekStartDate: weekStartDate,
                generatedAt: generatedAt,
                totalProjectedCostCents: totalProjectedCostCents,
                isOverBudget: isOverBudget,
                version: version,
                isActive: isActive,
                planningFocus: planningFocus,
                currencyCode: currencyCode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userProfileId,
                required DateTime weekStartDate,
                required DateTime generatedAt,
                required int totalProjectedCostCents,
                Value<bool> isOverBudget = const Value.absent(),
                required int version,
                Value<bool> isActive = const Value.absent(),
                Value<String> planningFocus = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
              }) => GeneratedPlansCompanion.insert(
                id: id,
                userProfileId: userProfileId,
                weekStartDate: weekStartDate,
                generatedAt: generatedAt,
                totalProjectedCostCents: totalProjectedCostCents,
                isOverBudget: isOverBudget,
                version: version,
                isActive: isActive,
                planningFocus: planningFocus,
                currencyCode: currencyCode,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GeneratedPlansTable, GeneratedPlan>(table),
                  $$GeneratedPlansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                userProfileId = false,
                mealSlotsRefs = false,
                budgetEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (mealSlotsRefs) db.mealSlots,
                    if (budgetEntriesRefs) db.budgetEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (userProfileId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.userProfileId,
                            referencedTable: $$GeneratedPlansTableReferences
                                ._userProfileIdTable(db),
                            referencedColumn: $$GeneratedPlansTableReferences
                                ._userProfileIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (mealSlotsRefs)
                        await $_getPrefetchedData<
                          GeneratedPlan,
                          $GeneratedPlansTable,
                          MealSlot
                        >(
                          currentTable: table,
                          referencedTable: $$GeneratedPlansTableReferences
                              ._mealSlotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GeneratedPlansTableReferences(
                                db,
                                table,
                                p0,
                              ).mealSlotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.generatedPlanId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (budgetEntriesRefs)
                        await $_getPrefetchedData<
                          GeneratedPlan,
                          $GeneratedPlansTable,
                          BudgetEntry
                        >(
                          currentTable: table,
                          referencedTable: $$GeneratedPlansTableReferences
                              ._budgetEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GeneratedPlansTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.generatedPlanId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GeneratedPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GeneratedPlansTable,
      GeneratedPlan,
      $$GeneratedPlansTableFilterComposer,
      $$GeneratedPlansTableOrderingComposer,
      $$GeneratedPlansTableAnnotationComposer,
      $$GeneratedPlansTableCreateCompanionBuilder,
      $$GeneratedPlansTableUpdateCompanionBuilder,
      (GeneratedPlan, $$GeneratedPlansTableReferences),
      GeneratedPlan,
      PrefetchHooks Function({
        bool userProfileId,
        bool mealSlotsRefs,
        bool budgetEntriesRefs,
      })
    >;
typedef $$MealSlotsTableCreateCompanionBuilder = MealSlotsCompanion Function({
  Value<int> id,
  required int generatedPlanId,
  required int dayIndex,
  required int slotIndex,
  required int dishId,
  required int plannedCostCents,
  Value<double> plannedCalories,
  Value<double> plannedProteinG,
  Value<double> plannedCarbsG,
  Value<double> plannedFatG,
  Value<double> servings,
  Value<String> mealStatus,
  Value<int?> actualCostCents,
  Value<String?> substituteName,
  Value<DateTime?> consumedAt,
});
typedef $$MealSlotsTableUpdateCompanionBuilder = MealSlotsCompanion Function({
  Value<int> id,
  Value<int> generatedPlanId,
  Value<int> dayIndex,
  Value<int> slotIndex,
  Value<int> dishId,
  Value<int> plannedCostCents,
  Value<double> plannedCalories,
  Value<double> plannedProteinG,
  Value<double> plannedCarbsG,
  Value<double> plannedFatG,
  Value<double> servings,
  Value<String> mealStatus,
  Value<int?> actualCostCents,
  Value<String?> substituteName,
  Value<DateTime?> consumedAt,
});

final class $$MealSlotsTableReferences
    extends BaseReferences<_$AppDatabase, $MealSlotsTable, MealSlot> {
  $$MealSlotsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GeneratedPlansTable _generatedPlanIdTable(_$AppDatabase db) => db
      .generatedPlans
      .createAlias('meal_slots__generated_plan_id__generated_plans__id');

  $$GeneratedPlansTableProcessedTableManager get generatedPlanId {
    final $_column = $_itemColumn<int>('generated_plan_id')!;

    final manager = $$GeneratedPlansTableTableManager(
      $_db,
      $_db.generatedPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_generatedPlanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DishesTable _dishIdTable(_$AppDatabase db) =>
      db.dishes.createAlias('meal_slots__dish_id__dishes__id');

  $$DishesTableProcessedTableManager get dishId {
    final $_column = $_itemColumn<int>('dish_id')!;

    final manager = $$DishesTableTableManager(
      $_db,
      $_db.dishes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dishIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MealSlotItemsTable, List<MealSlotItem>>
  _mealSlotItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealSlotItems,
    aliasName: 'meal_slots__id__meal_slot_items__meal_slot_id',
  );

  $$MealSlotItemsTableProcessedTableManager get mealSlotItemsRefs {
    final manager = $$MealSlotItemsTableTableManager(
      $_db,
      $_db.mealSlotItems,
    ).filter((f) => f.mealSlotId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealSlotItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BudgetEntriesTable, List<BudgetEntry>>
  _budgetEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetEntries,
    aliasName: 'meal_slots__id__budget_entries__meal_slot_id',
  );

  $$BudgetEntriesTableProcessedTableManager get budgetEntriesRefs {
    final manager = $$BudgetEntriesTableTableManager(
      $_db,
      $_db.budgetEntries,
    ).filter((f) => f.mealSlotId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MealSlotsTableFilterComposer
    extends Composer<_$AppDatabase, $MealSlotsTable> {
  $$MealSlotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get slotIndex => $composableBuilder(
    column: $table.slotIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedCostCents => $composableBuilder(
    column: $table.plannedCostCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get plannedCalories => $composableBuilder(
    column: $table.plannedCalories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get plannedProteinG => $composableBuilder(
    column: $table.plannedProteinG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get plannedCarbsG => $composableBuilder(
    column: $table.plannedCarbsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get plannedFatG => $composableBuilder(
    column: $table.plannedFatG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealStatus => $composableBuilder(
    column: $table.mealStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualCostCents => $composableBuilder(
    column: $table.actualCostCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get substituteName => $composableBuilder(
    column: $table.substituteName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get consumedAt => $composableBuilder(
    column: $table.consumedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GeneratedPlansTableFilterComposer get generatedPlanId {
    final $$GeneratedPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.generatedPlanId,
      referencedTable: $db.generatedPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GeneratedPlansTableFilterComposer(
            $db: $db,
            $table: $db.generatedPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DishesTableFilterComposer get dishId {
    final $$DishesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dishId,
      referencedTable: $db.dishes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DishesTableFilterComposer(
            $db: $db,
            $table: $db.dishes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> mealSlotItemsRefs(
    Expression<bool> Function($$MealSlotItemsTableFilterComposer f) f,
  ) {
    final $$MealSlotItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealSlotItems,
      getReferencedColumn: (t) => t.mealSlotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotItemsTableFilterComposer(
            $db: $db,
            $table: $db.mealSlotItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> budgetEntriesRefs(
    Expression<bool> Function($$BudgetEntriesTableFilterComposer f) f,
  ) {
    final $$BudgetEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.mealSlotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableFilterComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealSlotsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealSlotsTable> {
  $$MealSlotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get slotIndex => $composableBuilder(
    column: $table.slotIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedCostCents => $composableBuilder(
    column: $table.plannedCostCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get plannedCalories => $composableBuilder(
    column: $table.plannedCalories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get plannedProteinG => $composableBuilder(
    column: $table.plannedProteinG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get plannedCarbsG => $composableBuilder(
    column: $table.plannedCarbsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get plannedFatG => $composableBuilder(
    column: $table.plannedFatG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealStatus => $composableBuilder(
    column: $table.mealStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualCostCents => $composableBuilder(
    column: $table.actualCostCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get substituteName => $composableBuilder(
    column: $table.substituteName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get consumedAt => $composableBuilder(
    column: $table.consumedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GeneratedPlansTableOrderingComposer get generatedPlanId {
    final $$GeneratedPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.generatedPlanId,
      referencedTable: $db.generatedPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GeneratedPlansTableOrderingComposer(
            $db: $db,
            $table: $db.generatedPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DishesTableOrderingComposer get dishId {
    final $$DishesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dishId,
      referencedTable: $db.dishes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DishesTableOrderingComposer(
            $db: $db,
            $table: $db.dishes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealSlotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealSlotsTable> {
  $$MealSlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dayIndex =>
      $composableBuilder(column: $table.dayIndex, builder: (column) => column);

  GeneratedColumn<int> get slotIndex =>
      $composableBuilder(column: $table.slotIndex, builder: (column) => column);

  GeneratedColumn<int> get plannedCostCents => $composableBuilder(
    column: $table.plannedCostCents,
    builder: (column) => column,
  );

  GeneratedColumn<double> get plannedCalories => $composableBuilder(
    column: $table.plannedCalories,
    builder: (column) => column,
  );

  GeneratedColumn<double> get plannedProteinG => $composableBuilder(
    column: $table.plannedProteinG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get plannedCarbsG => $composableBuilder(
    column: $table.plannedCarbsG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get plannedFatG => $composableBuilder(
    column: $table.plannedFatG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<String> get mealStatus => $composableBuilder(
    column: $table.mealStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualCostCents => $composableBuilder(
    column: $table.actualCostCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get substituteName => $composableBuilder(
    column: $table.substituteName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get consumedAt => $composableBuilder(
    column: $table.consumedAt,
    builder: (column) => column,
  );

  $$GeneratedPlansTableAnnotationComposer get generatedPlanId {
    final $$GeneratedPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.generatedPlanId,
      referencedTable: $db.generatedPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GeneratedPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.generatedPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DishesTableAnnotationComposer get dishId {
    final $$DishesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dishId,
      referencedTable: $db.dishes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DishesTableAnnotationComposer(
            $db: $db,
            $table: $db.dishes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> mealSlotItemsRefs<T extends Object>(
    Expression<T> Function($$MealSlotItemsTableAnnotationComposer a) f,
  ) {
    final $$MealSlotItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealSlotItems,
      getReferencedColumn: (t) => t.mealSlotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.mealSlotItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> budgetEntriesRefs<T extends Object>(
    Expression<T> Function($$BudgetEntriesTableAnnotationComposer a) f,
  ) {
    final $$BudgetEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.mealSlotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealSlotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealSlotsTable,
          MealSlot,
          $$MealSlotsTableFilterComposer,
          $$MealSlotsTableOrderingComposer,
          $$MealSlotsTableAnnotationComposer,
          $$MealSlotsTableCreateCompanionBuilder,
          $$MealSlotsTableUpdateCompanionBuilder,
          (MealSlot, $$MealSlotsTableReferences),
          MealSlot,
          PrefetchHooks Function({
            bool generatedPlanId,
            bool dishId,
            bool mealSlotItemsRefs,
            bool budgetEntriesRefs,
          })
        > {
  $$MealSlotsTableTableManager(_$AppDatabase db, $MealSlotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealSlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealSlotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealSlotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> generatedPlanId = const Value.absent(),
                Value<int> dayIndex = const Value.absent(),
                Value<int> slotIndex = const Value.absent(),
                Value<int> dishId = const Value.absent(),
                Value<int> plannedCostCents = const Value.absent(),
                Value<double> plannedCalories = const Value.absent(),
                Value<double> plannedProteinG = const Value.absent(),
                Value<double> plannedCarbsG = const Value.absent(),
                Value<double> plannedFatG = const Value.absent(),
                Value<double> servings = const Value.absent(),
                Value<String> mealStatus = const Value.absent(),
                Value<int?> actualCostCents = const Value.absent(),
                Value<String?> substituteName = const Value.absent(),
                Value<DateTime?> consumedAt = const Value.absent(),
              }) => MealSlotsCompanion(
                id: id,
                generatedPlanId: generatedPlanId,
                dayIndex: dayIndex,
                slotIndex: slotIndex,
                dishId: dishId,
                plannedCostCents: plannedCostCents,
                plannedCalories: plannedCalories,
                plannedProteinG: plannedProteinG,
                plannedCarbsG: plannedCarbsG,
                plannedFatG: plannedFatG,
                servings: servings,
                mealStatus: mealStatus,
                actualCostCents: actualCostCents,
                substituteName: substituteName,
                consumedAt: consumedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int generatedPlanId,
                required int dayIndex,
                required int slotIndex,
                required int dishId,
                required int plannedCostCents,
                Value<double> plannedCalories = const Value.absent(),
                Value<double> plannedProteinG = const Value.absent(),
                Value<double> plannedCarbsG = const Value.absent(),
                Value<double> plannedFatG = const Value.absent(),
                Value<double> servings = const Value.absent(),
                Value<String> mealStatus = const Value.absent(),
                Value<int?> actualCostCents = const Value.absent(),
                Value<String?> substituteName = const Value.absent(),
                Value<DateTime?> consumedAt = const Value.absent(),
              }) => MealSlotsCompanion.insert(
                id: id,
                generatedPlanId: generatedPlanId,
                dayIndex: dayIndex,
                slotIndex: slotIndex,
                dishId: dishId,
                plannedCostCents: plannedCostCents,
                plannedCalories: plannedCalories,
                plannedProteinG: plannedProteinG,
                plannedCarbsG: plannedCarbsG,
                plannedFatG: plannedFatG,
                servings: servings,
                mealStatus: mealStatus,
                actualCostCents: actualCostCents,
                substituteName: substituteName,
                consumedAt: consumedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MealSlotsTable, MealSlot>(table),
                  $$MealSlotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                generatedPlanId = false,
                dishId = false,
                mealSlotItemsRefs = false,
                budgetEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (mealSlotItemsRefs) db.mealSlotItems,
                    if (budgetEntriesRefs) db.budgetEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (generatedPlanId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.generatedPlanId,
                            referencedTable: $$MealSlotsTableReferences
                                ._generatedPlanIdTable(db),
                            referencedColumn: $$MealSlotsTableReferences
                                ._generatedPlanIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (dishId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.dishId,
                            referencedTable: $$MealSlotsTableReferences
                                ._dishIdTable(db),
                            referencedColumn: $$MealSlotsTableReferences
                                ._dishIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (mealSlotItemsRefs)
                        await $_getPrefetchedData<
                          MealSlot,
                          $MealSlotsTable,
                          MealSlotItem
                        >(
                          currentTable: table,
                          referencedTable: $$MealSlotsTableReferences
                              ._mealSlotItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MealSlotsTableReferences(
                                db,
                                table,
                                p0,
                              ).mealSlotItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mealSlotId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (budgetEntriesRefs)
                        await $_getPrefetchedData<
                          MealSlot,
                          $MealSlotsTable,
                          BudgetEntry
                        >(
                          currentTable: table,
                          referencedTable: $$MealSlotsTableReferences
                              ._budgetEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MealSlotsTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mealSlotId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MealSlotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealSlotsTable,
      MealSlot,
      $$MealSlotsTableFilterComposer,
      $$MealSlotsTableOrderingComposer,
      $$MealSlotsTableAnnotationComposer,
      $$MealSlotsTableCreateCompanionBuilder,
      $$MealSlotsTableUpdateCompanionBuilder,
      (MealSlot, $$MealSlotsTableReferences),
      MealSlot,
      PrefetchHooks Function({
        bool generatedPlanId,
        bool dishId,
        bool mealSlotItemsRefs,
        bool budgetEntriesRefs,
      })
    >;
typedef $$MealSlotItemsTableCreateCompanionBuilder =
    MealSlotItemsCompanion Function({
      Value<int> id,
      required int mealSlotId,
      required int dishId,
      required int plannedCostCents,
      Value<double> plannedCalories,
      Value<double> plannedProteinG,
      Value<double> plannedCarbsG,
      Value<double> plannedFatG,
      Value<double> servings,
      Value<int> sortOrder,
    });
typedef $$MealSlotItemsTableUpdateCompanionBuilder =
    MealSlotItemsCompanion Function({
      Value<int> id,
      Value<int> mealSlotId,
      Value<int> dishId,
      Value<int> plannedCostCents,
      Value<double> plannedCalories,
      Value<double> plannedProteinG,
      Value<double> plannedCarbsG,
      Value<double> plannedFatG,
      Value<double> servings,
      Value<int> sortOrder,
    });

final class $$MealSlotItemsTableReferences
    extends BaseReferences<_$AppDatabase, $MealSlotItemsTable, MealSlotItem> {
  $$MealSlotItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MealSlotsTable _mealSlotIdTable(_$AppDatabase db) =>
      db.mealSlots.createAlias('meal_slot_items__meal_slot_id__meal_slots__id');

  $$MealSlotsTableProcessedTableManager get mealSlotId {
    final $_column = $_itemColumn<int>('meal_slot_id')!;

    final manager = $$MealSlotsTableTableManager(
      $_db,
      $_db.mealSlots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mealSlotIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DishesTable _dishIdTable(_$AppDatabase db) =>
      db.dishes.createAlias('meal_slot_items__dish_id__dishes__id');

  $$DishesTableProcessedTableManager get dishId {
    final $_column = $_itemColumn<int>('dish_id')!;

    final manager = $$DishesTableTableManager(
      $_db,
      $_db.dishes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dishIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MealSlotItemsTableFilterComposer
    extends Composer<_$AppDatabase, $MealSlotItemsTable> {
  $$MealSlotItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedCostCents => $composableBuilder(
    column: $table.plannedCostCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get plannedCalories => $composableBuilder(
    column: $table.plannedCalories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get plannedProteinG => $composableBuilder(
    column: $table.plannedProteinG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get plannedCarbsG => $composableBuilder(
    column: $table.plannedCarbsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get plannedFatG => $composableBuilder(
    column: $table.plannedFatG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$MealSlotsTableFilterComposer get mealSlotId {
    final $$MealSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealSlotId,
      referencedTable: $db.mealSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotsTableFilterComposer(
            $db: $db,
            $table: $db.mealSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DishesTableFilterComposer get dishId {
    final $$DishesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dishId,
      referencedTable: $db.dishes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DishesTableFilterComposer(
            $db: $db,
            $table: $db.dishes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealSlotItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealSlotItemsTable> {
  $$MealSlotItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedCostCents => $composableBuilder(
    column: $table.plannedCostCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get plannedCalories => $composableBuilder(
    column: $table.plannedCalories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get plannedProteinG => $composableBuilder(
    column: $table.plannedProteinG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get plannedCarbsG => $composableBuilder(
    column: $table.plannedCarbsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get plannedFatG => $composableBuilder(
    column: $table.plannedFatG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$MealSlotsTableOrderingComposer get mealSlotId {
    final $$MealSlotsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealSlotId,
      referencedTable: $db.mealSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotsTableOrderingComposer(
            $db: $db,
            $table: $db.mealSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DishesTableOrderingComposer get dishId {
    final $$DishesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dishId,
      referencedTable: $db.dishes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DishesTableOrderingComposer(
            $db: $db,
            $table: $db.dishes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealSlotItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealSlotItemsTable> {
  $$MealSlotItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get plannedCostCents => $composableBuilder(
    column: $table.plannedCostCents,
    builder: (column) => column,
  );

  GeneratedColumn<double> get plannedCalories => $composableBuilder(
    column: $table.plannedCalories,
    builder: (column) => column,
  );

  GeneratedColumn<double> get plannedProteinG => $composableBuilder(
    column: $table.plannedProteinG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get plannedCarbsG => $composableBuilder(
    column: $table.plannedCarbsG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get plannedFatG => $composableBuilder(
    column: $table.plannedFatG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$MealSlotsTableAnnotationComposer get mealSlotId {
    final $$MealSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealSlotId,
      referencedTable: $db.mealSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.mealSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DishesTableAnnotationComposer get dishId {
    final $$DishesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dishId,
      referencedTable: $db.dishes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DishesTableAnnotationComposer(
            $db: $db,
            $table: $db.dishes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealSlotItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealSlotItemsTable,
          MealSlotItem,
          $$MealSlotItemsTableFilterComposer,
          $$MealSlotItemsTableOrderingComposer,
          $$MealSlotItemsTableAnnotationComposer,
          $$MealSlotItemsTableCreateCompanionBuilder,
          $$MealSlotItemsTableUpdateCompanionBuilder,
          (MealSlotItem, $$MealSlotItemsTableReferences),
          MealSlotItem,
          PrefetchHooks Function({bool mealSlotId, bool dishId})
        > {
  $$MealSlotItemsTableTableManager(_$AppDatabase db, $MealSlotItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealSlotItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealSlotItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealSlotItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> mealSlotId = const Value.absent(),
                Value<int> dishId = const Value.absent(),
                Value<int> plannedCostCents = const Value.absent(),
                Value<double> plannedCalories = const Value.absent(),
                Value<double> plannedProteinG = const Value.absent(),
                Value<double> plannedCarbsG = const Value.absent(),
                Value<double> plannedFatG = const Value.absent(),
                Value<double> servings = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => MealSlotItemsCompanion(
                id: id,
                mealSlotId: mealSlotId,
                dishId: dishId,
                plannedCostCents: plannedCostCents,
                plannedCalories: plannedCalories,
                plannedProteinG: plannedProteinG,
                plannedCarbsG: plannedCarbsG,
                plannedFatG: plannedFatG,
                servings: servings,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int mealSlotId,
                required int dishId,
                required int plannedCostCents,
                Value<double> plannedCalories = const Value.absent(),
                Value<double> plannedProteinG = const Value.absent(),
                Value<double> plannedCarbsG = const Value.absent(),
                Value<double> plannedFatG = const Value.absent(),
                Value<double> servings = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => MealSlotItemsCompanion.insert(
                id: id,
                mealSlotId: mealSlotId,
                dishId: dishId,
                plannedCostCents: plannedCostCents,
                plannedCalories: plannedCalories,
                plannedProteinG: plannedProteinG,
                plannedCarbsG: plannedCarbsG,
                plannedFatG: plannedFatG,
                servings: servings,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MealSlotItemsTable, MealSlotItem>(table),
                  $$MealSlotItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mealSlotId = false, dishId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (mealSlotId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.mealSlotId,
                        referencedTable: $$MealSlotItemsTableReferences
                            ._mealSlotIdTable(db),
                        referencedColumn: $$MealSlotItemsTableReferences
                            ._mealSlotIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (dishId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.dishId,
                        referencedTable: $$MealSlotItemsTableReferences
                            ._dishIdTable(db),
                        referencedColumn: $$MealSlotItemsTableReferences
                            ._dishIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MealSlotItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealSlotItemsTable,
      MealSlotItem,
      $$MealSlotItemsTableFilterComposer,
      $$MealSlotItemsTableOrderingComposer,
      $$MealSlotItemsTableAnnotationComposer,
      $$MealSlotItemsTableCreateCompanionBuilder,
      $$MealSlotItemsTableUpdateCompanionBuilder,
      (MealSlotItem, $$MealSlotItemsTableReferences),
      MealSlotItem,
      PrefetchHooks Function({bool mealSlotId, bool dishId})
    >;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  required String entityTable,
  required int entityId,
  required String operation,
  required String payloadJson,
  Value<bool> dirtyFlag,
  required DateTime queuedAt,
  Value<DateTime?> syncedAt,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  Value<String> entityTable,
  Value<int> entityId,
  Value<String> operation,
  Value<String> payloadJson,
  Value<bool> dirtyFlag,
  Value<DateTime> queuedAt,
  Value<DateTime?> syncedAt,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityTable => $composableBuilder(
    column: $table.entityTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirtyFlag => $composableBuilder(
    column: $table.dirtyFlag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get queuedAt => $composableBuilder(
    column: $table.queuedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityTable => $composableBuilder(
    column: $table.entityTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirtyFlag => $composableBuilder(
    column: $table.dirtyFlag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get queuedAt => $composableBuilder(
    column: $table.queuedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityTable => $composableBuilder(
    column: $table.entityTable,
    builder: (column) => column,
  );

  GeneratedColumn<int> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dirtyFlag =>
      $composableBuilder(column: $table.dirtyFlag, builder: (column) => column);

  GeneratedColumn<DateTime> get queuedAt =>
      $composableBuilder(column: $table.queuedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entityTable = const Value.absent(),
                Value<int> entityId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<bool> dirtyFlag = const Value.absent(),
                Value<DateTime> queuedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                entityTable: entityTable,
                entityId: entityId,
                operation: operation,
                payloadJson: payloadJson,
                dirtyFlag: dirtyFlag,
                queuedAt: queuedAt,
                syncedAt: syncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entityTable,
                required int entityId,
                required String operation,
                required String payloadJson,
                Value<bool> dirtyFlag = const Value.absent(),
                required DateTime queuedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                entityTable: entityTable,
                entityId: entityId,
                operation: operation,
                payloadJson: payloadJson,
                dirtyFlag: dirtyFlag,
                queuedAt: queuedAt,
                syncedAt: syncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncQueueTable, SyncQueueData>(table),
                  BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;
typedef $$BudgetEntriesTableCreateCompanionBuilder =
    BudgetEntriesCompanion Function({
      Value<int> id,
      required int userProfileId,
      Value<int?> generatedPlanId,
      Value<int?> mealSlotId,
      required int amountCents,
      required String label,
      required DateTime occurredAt,
      required DateTime createdAt,
    });
typedef $$BudgetEntriesTableUpdateCompanionBuilder =
    BudgetEntriesCompanion Function({
      Value<int> id,
      Value<int> userProfileId,
      Value<int?> generatedPlanId,
      Value<int?> mealSlotId,
      Value<int> amountCents,
      Value<String> label,
      Value<DateTime> occurredAt,
      Value<DateTime> createdAt,
    });

final class $$BudgetEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $BudgetEntriesTable, BudgetEntry> {
  $$BudgetEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserProfilesTable _userProfileIdTable(_$AppDatabase db) => db
      .userProfiles
      .createAlias('budget_entries__user_profile_id__user_profiles__id');

  $$UserProfilesTableProcessedTableManager get userProfileId {
    final $_column = $_itemColumn<int>('user_profile_id')!;

    final manager = $$UserProfilesTableTableManager(
      $_db,
      $_db.userProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userProfileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GeneratedPlansTable _generatedPlanIdTable(_$AppDatabase db) => db
      .generatedPlans
      .createAlias('budget_entries__generated_plan_id__generated_plans__id');

  $$GeneratedPlansTableProcessedTableManager? get generatedPlanId {
    final $_column = $_itemColumn<int>('generated_plan_id');
    if ($_column == null) return null;
    final manager = $$GeneratedPlansTableTableManager(
      $_db,
      $_db.generatedPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_generatedPlanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MealSlotsTable _mealSlotIdTable(_$AppDatabase db) =>
      db.mealSlots.createAlias('budget_entries__meal_slot_id__meal_slots__id');

  $$MealSlotsTableProcessedTableManager? get mealSlotId {
    final $_column = $_itemColumn<int>('meal_slot_id');
    if ($_column == null) return null;
    final manager = $$MealSlotsTableTableManager(
      $_db,
      $_db.mealSlots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mealSlotIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BudgetEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetEntriesTable> {
  $$BudgetEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableFilterComposer get userProfileId {
    final $$UserProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userProfileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableFilterComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GeneratedPlansTableFilterComposer get generatedPlanId {
    final $$GeneratedPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.generatedPlanId,
      referencedTable: $db.generatedPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GeneratedPlansTableFilterComposer(
            $db: $db,
            $table: $db.generatedPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MealSlotsTableFilterComposer get mealSlotId {
    final $$MealSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealSlotId,
      referencedTable: $db.mealSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotsTableFilterComposer(
            $db: $db,
            $table: $db.mealSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetEntriesTable> {
  $$BudgetEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableOrderingComposer get userProfileId {
    final $$UserProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userProfileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GeneratedPlansTableOrderingComposer get generatedPlanId {
    final $$GeneratedPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.generatedPlanId,
      referencedTable: $db.generatedPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GeneratedPlansTableOrderingComposer(
            $db: $db,
            $table: $db.generatedPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MealSlotsTableOrderingComposer get mealSlotId {
    final $$MealSlotsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealSlotId,
      referencedTable: $db.mealSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotsTableOrderingComposer(
            $db: $db,
            $table: $db.mealSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetEntriesTable> {
  $$BudgetEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UserProfilesTableAnnotationComposer get userProfileId {
    final $$UserProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userProfileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GeneratedPlansTableAnnotationComposer get generatedPlanId {
    final $$GeneratedPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.generatedPlanId,
      referencedTable: $db.generatedPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GeneratedPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.generatedPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MealSlotsTableAnnotationComposer get mealSlotId {
    final $$MealSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealSlotId,
      referencedTable: $db.mealSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.mealSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetEntriesTable,
          BudgetEntry,
          $$BudgetEntriesTableFilterComposer,
          $$BudgetEntriesTableOrderingComposer,
          $$BudgetEntriesTableAnnotationComposer,
          $$BudgetEntriesTableCreateCompanionBuilder,
          $$BudgetEntriesTableUpdateCompanionBuilder,
          (BudgetEntry, $$BudgetEntriesTableReferences),
          BudgetEntry,
          PrefetchHooks Function({
            bool userProfileId,
            bool generatedPlanId,
            bool mealSlotId,
          })
        > {
  $$BudgetEntriesTableTableManager(_$AppDatabase db, $BudgetEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userProfileId = const Value.absent(),
                Value<int?> generatedPlanId = const Value.absent(),
                Value<int?> mealSlotId = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BudgetEntriesCompanion(
                id: id,
                userProfileId: userProfileId,
                generatedPlanId: generatedPlanId,
                mealSlotId: mealSlotId,
                amountCents: amountCents,
                label: label,
                occurredAt: occurredAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userProfileId,
                Value<int?> generatedPlanId = const Value.absent(),
                Value<int?> mealSlotId = const Value.absent(),
                required int amountCents,
                required String label,
                required DateTime occurredAt,
                required DateTime createdAt,
              }) => BudgetEntriesCompanion.insert(
                id: id,
                userProfileId: userProfileId,
                generatedPlanId: generatedPlanId,
                mealSlotId: mealSlotId,
                amountCents: amountCents,
                label: label,
                occurredAt: occurredAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetEntriesTable, BudgetEntry>(table),
                  $$BudgetEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                userProfileId = false,
                generatedPlanId = false,
                mealSlotId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (userProfileId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.userProfileId,
                            referencedTable: $$BudgetEntriesTableReferences
                                ._userProfileIdTable(db),
                            referencedColumn: $$BudgetEntriesTableReferences
                                ._userProfileIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (generatedPlanId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.generatedPlanId,
                            referencedTable: $$BudgetEntriesTableReferences
                                ._generatedPlanIdTable(db),
                            referencedColumn: $$BudgetEntriesTableReferences
                                ._generatedPlanIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (mealSlotId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.mealSlotId,
                            referencedTable: $$BudgetEntriesTableReferences
                                ._mealSlotIdTable(db),
                            referencedColumn: $$BudgetEntriesTableReferences
                                ._mealSlotIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$BudgetEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetEntriesTable,
      BudgetEntry,
      $$BudgetEntriesTableFilterComposer,
      $$BudgetEntriesTableOrderingComposer,
      $$BudgetEntriesTableAnnotationComposer,
      $$BudgetEntriesTableCreateCompanionBuilder,
      $$BudgetEntriesTableUpdateCompanionBuilder,
      (BudgetEntry, $$BudgetEntriesTableReferences),
      BudgetEntry,
      PrefetchHooks Function({
        bool userProfileId,
        bool generatedPlanId,
        bool mealSlotId,
      })
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$DishesTableTableManager get dishes =>
      $$DishesTableTableManager(_db, _db.dishes);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db, _db.ingredients);
  $$NutritionCachesTableTableManager get nutritionCaches =>
      $$NutritionCachesTableTableManager(_db, _db.nutritionCaches);
  $$AllergenTagsTableTableManager get allergenTags =>
      $$AllergenTagsTableTableManager(_db, _db.allergenTags);
  $$DishAllergenTagsTableTableManager get dishAllergenTags =>
      $$DishAllergenTagsTableTableManager(_db, _db.dishAllergenTags);
  $$GeneratedPlansTableTableManager get generatedPlans =>
      $$GeneratedPlansTableTableManager(_db, _db.generatedPlans);
  $$MealSlotsTableTableManager get mealSlots =>
      $$MealSlotsTableTableManager(_db, _db.mealSlots);
  $$MealSlotItemsTableTableManager get mealSlotItems =>
      $$MealSlotItemsTableTableManager(_db, _db.mealSlotItems);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$BudgetEntriesTableTableManager get budgetEntries =>
      $$BudgetEntriesTableTableManager(_db, _db.budgetEntries);
}
