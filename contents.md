# NutriWallet Contents

This document is the implementation inventory for the current NutriWallet app. It describes behavior that exists in the repository, where it is implemented, the algorithms used, and the boundaries between the Flutter client, local SQLite cache, Supabase, and third-party providers.

Status date: 2026-10-08

## 1. Product Summary

NutriWallet is a connected Flutter application for planning meals around a user's food budget and nutrition goals. The app lets an authenticated user:

- Complete an onboarding and planning profile.
- Store a personal dish library with prices and ingredients.
- Enrich ingredients with USDA nutrition data through an authenticated proxy.
- Capture a dish photo or printed menu/receipt image and receive Gemini ingredient suggestions.
- Maintain allergy and ingredient exclusions.
- Generate a validated weekly meal plan using AI recommendations plus a deterministic local planner.
- Save versioned plans and choose one active plan.
- Track projected plan cost separately from actual grocery spending.
- Check in planned meals as eaten, substituted, or skipped.
- Set recurring daily times for each meal and schedule reminders from the active plan.
- Add optional dish components to a meal and aggregate their cost and nutrition.
- View current and next scheduled meals with quick check-in actions in both Plan and Budget.
- Prioritize the next planned meal and auto-skip earlier unconfirmed meals within one hour of it, including linked budget cleanup.
- Queue local changes and push them to Supabase when connectivity is available.

Production authentication and remote services require Supabase configuration. The application fails during startup when `SUPABASE_URL` or `SUPABASE_ANON_KEY` is missing.

## 2. Technology And Runtime

### Client

- Flutter and Dart.
- Riverpod for dependency injection and reactive state.
- GoRouter for top-level navigation.
- Drift over SQLite for typed local persistence.
- Dio for authenticated HTTP calls to Supabase Edge Functions.
- SharedPreferences for onboarding, currency, and notification preferences.
- `image_picker` for camera and gallery input.
- `fl_chart` for planned-versus-actual budget visualization.
- `flutter_local_notifications` and `timezone` for local reminders.
- `flutter_timezone` for device timezone detection.
- Workmanager for weekly background plan regeneration.

### Server

- Supabase Auth for email/password authentication and sessions.
- Supabase Edge Functions for authentication checks, USDA lookup, Gemini vision, Gemini plan recommendations, and sync writes.
- Supabase Postgres tables, row-level security, triggers, indexes, and security-definer RPC functions.
- USDA FoodData Central as the nutrition provider.
- Gemini as the vision and smart-plan provider.

### Platform configuration

- Android declares Internet and notification permissions.
- iOS declares camera and photo-library usage descriptions.
- iOS declares background fetch and the Workmanager task identifier.
- Android and iOS are configured for local notification scheduling.
- iOS notification permission requests and device timezone initialization run before scheduling.
- The repository is configured for Android API 24+ and iOS 15+; Android API 36 emulator validation is recorded, while iOS build and runtime validation remain open.
- iOS cannot be built in the current Windows environment; Xcode/macOS validation remains required.

## 3. Application Startup And Dependency Graph

Main files: `lib/main.dart`, `lib/app.dart`, `lib/core/providers.dart`.

Startup sequence:

1. Flutter bindings are initialized.
2. SharedPreferences is opened.
3. `SUPABASE_URL` and `SUPABASE_ANON_KEY` are read from compile-time Dart defines.
4. Startup throws a `StateError` if either define is empty.
5. Supabase is initialized with the URL and publishable key.
6. Riverpod starts with the SharedPreferences instance overridden into the provider graph.
7. The app starts at `/splash`.
8. The connectivity sync coordinator starts in the application widget and attempts an initial sync when online.

The provider graph constructs:

- A persistent Drift `AppDatabase`.
- Profile, dish, meal-plan, and budget repositories.
- Nutrition cache, vision, smart-plan, and sync services.
- Supabase-authenticated Dio clients that attach the current Supabase access token to each request.
- Notification and Workmanager schedulers.
- Currency and notification preference adapters.

## 4. Navigation And Screens

Routes are declared in `lib/core/routing/app_router.dart`.

| Route | Screen | Purpose |
| --- | --- | --- |
| `/splash` | `SplashScreen` | Resolve onboarding and session state. |
| `/onboarding` | `OnboardingScreen` | Explain the product and select display currency. |
| `/auth` | `AuthScreen` | Register, confirm email, resend confirmation, sign in, and handle auth errors. |
| `/setup` | `ProfileSetupScreen` | Create the initial budget, schedule, metrics, activity, and nutrition goal profile. |
| `/profile/edit` | `ProfileEditScreen` | Edit budget, active days, meals per day, metrics, sex, activity, and goal. |
| `/home` | `HomeScreen` | Main shell with Dishes, Plan, Budget, and Settings tabs. |
| `/dishes/new` | `AddDishScreen` | Create a dish manually and enrich ingredients. |
| `/dishes/capture` | `DishCaptureScreen` | Capture a dish or menu/receipt image and review AI recognition. |
| `/dishes/:id` | `DishDetailScreen` | View a dish, inspect allergy warnings, edit it, or remove it with confirmation. |
| `/dishes/:id/edit` | `AddDishScreen` | Edit an existing dish's name, price, cuisine, and ingredients. |
| `/plans/history` | `PlanHistoryScreen` | Browse versioned generated plans. |
| `/plans/history/:id` | `PlanHistoryDetailScreen` | Inspect slots and set a historical plan active. |

The splash screen routes signed-out users to onboarding until the onboarding preference is set, then to auth. Signed-in users without a local profile go to setup; users with a profile go to home.

## 5. Authentication

Implementation: `lib/data/repositories/auth_repository.dart` and `lib/features/auth/auth_screen.dart`.

Features:

- Email normalization by trimming and lowercasing.
- Basic email validation in the UI and repository-level validation.
- Registration requires at least eight password characters in the client.
- Sign-in accepts any non-empty password and lets Supabase enforce the configured policy.
- Confirmation-required registration state.
- Resend confirmation email action.
- A 60-second client cooldown after rate-limit errors.
- Password visibility toggle.
- Friendly mapping for common Supabase errors: existing account, disabled signup, rate limiting, network failure, confirmation requirement, password rejection, and invalid key.
- Sign-out and local profile-provider invalidation.
- Sign-out flushes pending sync records before clearing local account data.

The production implementation uses `SupabaseAuthRepository` backed by `SupabaseClient`. There is no local password-authentication provider in the current provider graph.

## 6. Onboarding And Profile System

Implementations: `OnboardingScreen`, `ProfileSetupScreen`, `ProfileEditScreen`, `ProfileDao`, and the `UserProfiles` table.

Onboarding stores:

- Completion state in SharedPreferences.
- Display currency from USD, PHP, EUR, GBP, and JPY.

Profile setup stores:

- Weekly budget in integer cents.
- Active planning days as a comma-separated day-index string, where Monday is `1` and Sunday is `7`.
- Meals per day, selectable from 2 through 5.
- A daily meal-time schedule with one editable time per meal.
- Nutrition goal: balanced, cutting, bulking, high protein, or keto.
- Weight in kilograms, height in centimeters, age, and sex.
- Activity level: sedentary, light, moderate, active, or very active.

Profile editing additionally validates that at least one active day remains selected. Profile updates are scoped to the selected profile ID and are queued for sync.

The local schema also supports `displayName`, although the current setup UI does not collect it.

## 7. Dish Library

Implementations: `lib/features/dish_library/*`, `DishRepository`, `DishDao`, and the `Dishes`/`Ingredients` tables.

Dish fields:

- Name.
- Price per serving in cents.
- Optional cuisine tag.
- Optional local photo path.
- Source, normally `manual` or `ai`.
- Created and updated timestamps.
- Soft-delete flag.

Ingredient fields:

- Name, quantity, and unit.
- Calories, protein, carbohydrates, and fat.
- Optional micronutrients JSON and USDA FDC ID.
- Whether the values came from an API cache.

Behavior:

- Manual creation accepts a name and non-negative price; ingredients are optional.
- Ingredient names are comma-separated in the manual form.
- Each new or renamed ingredient is looked up before persistence when possible.
- Existing ingredient nutrition is preserved during edits when the normalized name is unchanged.
- A failed nutrition lookup does not block saving; missing values are stored as zero and the UI reports that nutrition is pending.
- Existing dishes can be edited in one local transaction; removed, updated, and new ingredient rows are queued for sync.
- Dish lists stream active, non-deleted dishes ordered by update time.
- Dish detail displays price and ingredient calories.
- Removal is confirmed in the UI and implemented as a local soft delete.
- Every local dish and ingredient write is added to the durable sync queue.
- Dish library cards and detail screens show profile-exclusion warnings and can display stored dish photos.
- Price-range and nutrient-range query methods exist in `DishDao`.

## 8. Photo And Menu Recognition

Implementation: `DishCaptureScreen` and `SupabaseEdgeVisionAiService`.

Input paths:

- Camera capture.
- Gallery selection.
- Printed menu or receipt image selection.

Image handling:

- Picked images are reduced to quality 80 and bounded to 1280 by 1280 for dish capture.
- The client base64-encodes the image and sends its MIME type to the authenticated `vision-recognize` Edge Function.
- PNG and WebP receive explicit MIME types; other extensions default to JPEG.

Recognition output:

- Suggested meal name.
- Ingredient list.
- Cuisine.
- Allergen terms.

Review behavior:

- The user must review the recognized result before saving.
- Ingredients can be removed or added.
- The name and price can be edited.
- Corrected ingredients are individually sent through nutrition lookup.
- Recognition failures show a message and retry action.
- HTTP 401, 422, and 5xx responses receive specific user-facing messages.
- AI-created dishes are saved with source `ai` and the local photo path.

The current repository uses the Gemini proxy for recognition. There is no ML Kit dependency or native ML Kit fallback in the current `pubspec.yaml` or client source.

## 9. Nutrition Services And Algorithms

Implementations: `lib/features/nutrition_goal/domain/nutrition_models.dart` and `lib/data/remote/nutrition_lookup_service.dart`.

### Nutrition lookup cache algorithm

1. Trim, lowercase, and collapse whitespace in the ingredient name.
2. Read the normalized name from the local `NutritionCaches` table.
3. Return the cached result when present.
4. Otherwise call the authenticated USDA proxy.
5. Store successful calories, macros, and USDA FDC ID under the normalized name.
6. Return the result to the caller.

The cache uses the normalized ingredient name as its primary key and is updated on conflict.

### BMI

For weight `w` in kilograms and height `h` in centimeters:

```text
heightMeters = h / 100
BMI = w / (heightMeters * heightMeters)
```

Non-positive height returns zero.

### BMR

The app uses the Mifflin-St Jeor estimate:

```text
base = 10 * weightKg + 6.25 * heightCm - 5 * age
male BMR   = base + 5
female BMR = base - 161
```

### TDEE

```text
TDEE = BMR * activityMultiplier
```

Activity multipliers:

- Sedentary: `1.2`
- Light: `1.375`
- Moderate: `1.55`
- Active: `1.725`
- Very active: `1.9`

### Goal targets

Calories are calculated as `TDEE * calorieFactor`. Macro grams are then calculated from calorie ratios:

```text
proteinG = calories * proteinRatio / 4
carbsG   = calories * carbsRatio / 4
fatG     = calories * fatRatio / 9
```

Goal presets:

| Goal | Calorie factor | Protein ratio | Carb ratio | Fat ratio |
| --- | ---: | ---: | ---: | ---: |
| Balanced | 1.00 | 0.30 | 0.40 | 0.30 |
| Cutting | 0.80 | 0.35 | 0.35 | 0.30 |
| Bulking | 1.15 | 0.30 | 0.45 | 0.25 |
| High protein | 1.00 | 0.40 | 0.30 | 0.30 |
| Keto | 1.00 | 0.25 | 0.05 | 0.70 |

If body metrics are incomplete, foreground and background planning use fallback weekly targets of 2000 calories, 150 g protein, 200 g carbohydrates, and 67 g fat before multiplying by the number of active days.

## 10. Allergy And Exclusion System

Implementations: `ProfileDao`, the Settings allergy editor, `MealPlanningEngine`, and smart-plan validation.

- Exclusions are trimmed, lowercased, and deduplicated per profile.
- A dish's searchable text is its name plus ingredient names.
- Shared matching normalizes whole words and phrases, avoiding simple substring false positives such as `nut` matching `coconut`.
- Exclusion filtering is a hard pre-filter, not merely a score penalty.
- Gemini recommendations are independently checked against the same name-and-ingredient matching rule.
- A dish that matches an exclusion cannot be selected by the deterministic planner or accepted from Gemini.
- Adding and removing exclusions creates sync queue records.

The local schema includes `DishAllergenTags`, but the current UI and planner use profile-level exclusion labels directly.

## 11. Meal Planning System

Implementations: `MealPlanningEngine`, `PlannerDish`, `MealSlotComponent`, `GeneratedMealPlan`, `WeeklyPlanScreen`, and `GeminiSmartPlanService`.

Supported planning focuses:

- Balanced: practical cost, nutrition, and variety.
- Budget first: stronger preference for low-cost dishes.
- High protein: stronger protein preference.
- Maximum variety: penalize reuse and seek distinct dishes.
- Simple rotation: favor a small repeatable set.

### End-to-end plan generation

1. Load active dishes and aggregate each dish's ingredient nutrition.
2. Load profile exclusions and active day indexes.
3. Calculate weekly nutrition targets by multiplying daily targets by active-day count.
4. Ask the authenticated Gemini plan proxy for a preferred sequence of dish IDs.
5. Require an exact number of slots: `activeDays * mealsPerDay`.
6. Reject unknown IDs, excluded dishes, malformed output, over-budget output, insufficient high-protein output, or insufficient variety output.
7. Feed valid preferred IDs into the deterministic local planner.
8. Recalculate cost, nutrition, slot count, and focus-specific constraints locally.
9. Persist the generated plan and meal slots as a new version.

If the online recommendation is unavailable, the current `WeeklyPlanScreen` continues with the deterministic local planner and reports only remote recommendation failures when relevant. The deterministic engine is also used for background regeneration and direct tests.

### Hard filtering

Before scoring, the engine removes every dish whose name or ingredient list contains an exclusion term.

### Currency rounding

Each dish price is converted to cents first:

```text
roundedPriceCents = round(price * 100)
```

All budget comparisons and plan totals use these integer cents.

### Greedy assignment

For each active day and meal slot:

1. Keep only candidates affordable under the remaining budget.
2. Prefer a candidate different from the immediately previous assignment when possible.
3. Score every candidate.
4. Select the highest-scoring candidate.
5. Subtract its cost from the remaining budget.
6. Subtract its nutrition from the remaining target, clamping each remaining nutrient at zero.
7. Increment the candidate's use count.

Candidate score:

```text
fit * 3
+ value * 100
+ budgetSafety
+ focusBonus
+ aiPreferenceBonus
- usedCount * repeatPenalty
```

Where:

- `fit` is the average of four nutrient fit values for calories, protein, carbs, and fat.
- A nutrient at or below its remaining target scores `actual / desired`.
- A nutrient above target scores `1 - ((actual - desired) / desired)`, clamped to zero.
- `value = (proteinG * 4 + carbsG * 2 + fatG) / roundedPriceCents`.
- `budgetSafety = 1 - dishCost / remainingBudget`.
- Budget focus adds `budgetSafety * 2`.
- High-protein focus adds `proteinG / 40`.
- Variety focus adds `-usedCount * 0.6`.
- Simple rotation adds a reuse bonus and uses a low repeat penalty; its refinement objective rewards a compact dish set.
- Variety uses a repeat penalty of `1.1`; other focuses use `0.75`.
- Valid Gemini preference order receives a bonus that decreases with its list position.

### Local-search refinement

After greedy assignment, up to four refinement iterations run by default:

1. Calculate the current objective.
2. Try replacing each assignment with each candidate.
3. Reject replacements that exceed the budget or create an adjacent repeat.
4. Keep a replacement only when the objective improves by more than `0.0001`.
5. Stop when no improvement exists or the iteration limit is reached.

The refinement objective is:

```text
average nutrition fit against the target + (uniqueDishes / assignmentCount) * 0.45
```

### Plan result and UI validation

The result contains assignments, total cost, and an over-budget flag. The weekly plan UI additionally requires:

- Exact expected slot count.
- No over-budget result.
- At least 70% of the requested protein target for high-protein focus.
- At least two distinct dishes for variety focus when more than one slot exists.

The plan UI displays projected cost, budget status, slot count, total calories, protein, carbs, and fat against targets, grouped by day.

Each meal slot starts with one generated dish and can contain optional additional dish components. Components have independent servings and snapshots, while the meal slot and weekly plan aggregate their costs and nutrition.

## 12. AI Smart-Plan Validation

Implementation: `GeminiSmartPlanService` and `supabase/functions/plan-generate/index.ts`.

Request contents include:

- Focus.
- Budget in currency minor units.
- Active days and meals per day.
- Exclusions.
- Currency code.
- Nutrition targets.
- Full dish IDs, prices, nutrition, names, and ingredients.

The client retries the request once after a 250 ms delay. A response is accepted only if:

- `dish_ids` is a list of numeric IDs.
- The list length exactly equals requested slots.
- Every ID exists in the supplied dish list.
- No selected dish matches an exclusion.

The server additionally checks:

- Total selected price does not exceed budget.
- High-protein focus reaches at least 70% of protein target.
- Variety focus selects at least two distinct IDs when possible.

The model is advisory. The deterministic local planner remains the final source of the persisted assignments.

## 13. Plan Persistence And History

Implementation: `MealPlanRepository` and `GeneratedPlans`/`MealSlots`.

- Saving occurs in a Drift transaction.
- The next version is previous maximum version plus one.
- Saving a new plan deactivates all previous plans for that profile.
- The new plan is marked active.
- Each assignment becomes a `MealSlots` row.
- The previous active plan update and new plan/slot inserts are queued for sync.
- History is ordered by descending version.
- A historical plan can be selected as active without deleting history.
- Plan lookups are scoped by profile for history detail and activation.
- Stored metadata includes planning focus and currency code.

When an active saved plan is restored, its slots are joined back to local dishes and ingredients to rebuild planner models and nutrition totals.

## 14. Meal Consumption And Check-In

Implementations: `MealCheckInFlow`, `MealStatusDashboard`, `MealPlanRepository`, `BudgetRepository`, and `MealSlots` fields.

Valid statuses:

- `planned`
- `eaten`
- `substitute`
- `skipped`

Rules:

- Substitute status requires a non-empty substitute name and non-negative actual cost.
- Skipped status cannot include substitute details.
- Eaten-as-planned uses the planned cost as actual cost.
- Substitute flow records a name, amount, and consumed date.
- Skipped flow records no actual cost.
- A meal status update is scoped through the profile owning the plan.
- Check-in writes a matching budget entry through an upsert-by-meal-slot path.
- The database has a unique remote index so one meal slot cannot create duplicate linked expenses.
- The Plan and Budget dashboards prioritize the nearest future planned meal.
- When the next planned meal is within one hour, earlier unconfirmed planned meals are auto-skipped and linked budget entries are removed.

## 15. Budget System

Implementations: `BudgetScreen`, `BudgetRepository`, `BudgetDao`, `BudgetCalculator`, and `BudgetEntries`.

Features:

- Set or adjust the weekly budget.
- Record grocery expenses with amount, label, and date.
- Edit and delete expenses.
- Optionally link an expense to the active generated plan.
- View only entries in the current Monday-to-Monday local calendar week, stored as UTC timestamps.
- Filter entries to those linked to the active plan.
- Compare projected plan cost with actual spending.
- View linked actual spend against active-plan projection.
- Record planned meal consumption and substitute costs.
- Highlight the current and next unchecked scheduled meals.
- Prioritize the next future planned meal and auto-skip earlier unconfirmed meals within one hour of it.
- Show quick Eaten, Substitute, and Skip actions in the Plan dashboard and Budget timeline.
- Edit meal outcomes and linked meal expenses from the timeline.
- Use USD, PHP, EUR, GBP, or JPY display symbols.

Budget totals are integer cents. Currency selection changes display formatting only; it does not perform exchange-rate conversion.

The planned-versus-actual chart normalizes planned and actual values against the maximum of budget, planned, actual, and one unit, then renders two bars with `fl_chart`.

`BudgetCalculator.summarize` sums rounded planner dish cents and reports total, budget, over-budget state, and remaining cents.

## 16. Local Notifications And Background Work

### Meal reminders

Implementation: `notification_service.dart`.

- Notification preference defaults to enabled.
- Preference is persisted in SharedPreferences.
- Time zones are initialized before scheduling.
- Android requests notification permission.
- Android uses a high-importance `meal_reminders` channel.
- iOS uses Darwin notification settings.
- Reminders use timezone-aware scheduled dates for future slots in the active plan.
- Reminders can be cancelled by ID.

Settings schedules future meal slots from the active plan using stable day/meal reminder IDs.

### Weekly regeneration

Implementation: `background_plan_scheduler.dart`.

- Workmanager task name: `nutriwallet_weekly_plan_regeneration`.
- Frequency: every seven days.
- Initial delay: seven days.
- Existing periodic work is replaced.
- The callback opens the persistent database and processes stored profiles.
- It uses the same stored body metrics, activity, goal, active days, meals per day, exclusions, budget, and local dish library as foreground planning.
- It creates a next-week plan for each profile with available dishes.
- The database is closed in a `finally` block.
- Settings can schedule or cancel the worker.
- Disabling reminders cancels both the local reminder and weekly regeneration.

## 17. Local Data Model

Implementation: `lib/data/local/database.dart`, schema version 9.

All local tables use integer IDs where applicable, foreign keys, and UTC timestamps. Foreign keys are explicitly enabled before the database opens.

| Table | Purpose | Important relationships |
| --- | --- | --- |
| `UserProfiles` | User planning profile and budget. | Parent of dishes, allergens, plans, and budget entries. |
| `Dishes` | Dish library records. | Belongs to a profile; cascades to ingredients. |
| `Ingredients` | Per-dish nutrition data. | Belongs to a dish. |
| `NutritionCaches` | Normalized ingredient lookup cache. | Name is the primary key. |
| `AllergenTags` | Profile-level exclusion terms. | Belongs to a profile. |
| `DishAllergenTags` | Optional dish/allergen join table. | Composite key of dish and tag. |
| `GeneratedPlans` | Versioned projected plans. | Belongs to a profile. |
| `MealSlots` | Day/meal assignments and consumption state. | Belongs to a generated plan and references a primary dish. |
| `MealSlotItems` | Optional dish components for each meal slot. | Belongs to a meal slot and references a dish. |
| `SyncQueue` | Durable outbound changes. | Stores entity, operation, JSON payload, and dirty/synced state. |
| `BudgetEntries` | Actual spending. | Belongs to a profile; can reference a plan and meal slot. |

Migration history:

- Version 1: base tables.
- Version 2: nutrition cache.
- Version 3: budget entries.
- Version 4: active plan state and migration of newest plan per profile.
- Version 5: meal consumption fields.
- Version 6: meal-slot link on budget entries.
- Version 7: planning focus and currency metadata.
- Version 8: persisted meal-slot macro snapshots and servings.
- Version 9: persisted meal times and multi-dish meal-slot components.

## 18. Repository And Write Semantics

The app follows local-first write semantics:

1. Validate input in the UI or repository.
2. Write to Drift first.
3. Enqueue an operation containing a JSON payload.
4. Keep the queue item dirty until the remote endpoint confirms acceptance or conflict.

Repositories:

- `AuthRepository`: Supabase registration, sign-in, confirmation resend, and sign-out.
- `DishRepository`: active dish streams, profile-scoped lookup, dish creation/editing, ingredient creation/update/removal, and soft deletion.
- `MealPlanRepository`: versioning, active-plan switching, slot persistence, slot consumption, history, and restoration.
- `BudgetRepository`: expense CRUD, actual totals, linked meal-slot expense upsert, and meal reset on deletion.

## 19. Synchronization System

Implementations: `SyncQueueRepository`, `SyncService`, `ConnectivitySyncCoordinator`, `SupabaseSyncEndpoint`, and `sync-push`.

Queue behavior:

- Queue records are ordered by `queuedAt` and local queue ID.
- Only dirty records are selected.
- Each item is pushed sequentially.
- Accepted records are marked clean with a UTC `syncedAt` timestamp.
- Server-reported conflicts are also marked confirmed because server-side last-write-wins has selected the newer remote value.
- Exceptions leave the record dirty for a later retry.
- Sign-out attempts a queue flush and refuses to clear local account data while pending writes remain.

Connectivity behavior:

- An initial connectivity check runs at startup.
- The coordinator subscribes to connectivity changes.
- Any non-`none` connectivity result can trigger sync.
- Concurrent sync attempts are suppressed.

Conflict algorithm:

- Supabase stores a per-user, per-entity `updated_at` value in `sync_records`.
- If the stored remote timestamp is newer than the incoming timestamp, the RPC returns `conflict = true` and does not overwrite the remote record.
- Otherwise the incoming payload replaces the stored sync record.
- Typed RPC handlers hydrate supported mirror tables.
- Specialized plan, budget, and meal-consumption RPCs now perform the same timestamp conflict check and write `sync_records` envelopes.

Current boundary:

- The client implements durable outbound push and retry.
- The current client source does not implement a remote-to-local pull or merge operation. Cross-device data hydration is performed by server-side typed mirror writes, but a second device would need a pull path to populate its local Drift database.

## 20. Supabase Edge Functions

All Edge Functions require an authenticated bearer session through `_shared/auth.ts`, which validates the session by calling Supabase Auth's `/auth/v1/user` endpoint.

### `nutrition-lookup`

- Accepts POST only.
- Requires an authenticated user and `USDA_API_KEY`.
- Normalizes the ingredient query.
- Calls USDA FoodData Central.
- Prefers a food containing recognized calorie and protein nutrient IDs.
- Maps USDA nutrient IDs to calories, protein, carbs, fat, and FDC ID.
- Returns 204 when no food is found.

### `vision-recognize`

- Accepts POST only.
- Requires an authenticated user and `GEMINI_API_KEY`.
- Tries the configured Gemini model, then known fallback models for 400/404 model errors.
- Sends base64 image data and MIME type.
- Requests JSON-only meal name, ingredients, cuisine, and allergens.
- Strips JSON code fences before parsing.
- Rejects malformed JSON and empty ingredient lists.

### `plan-generate`

- Accepts POST only.
- Requires an authenticated user and `GEMINI_API_KEY`.
- Builds focus-specific instructions and sends the supplied dishes and constraints.
- Tries configured and fallback Gemini models.
- Requires exact JSON shape `{"dish_ids":[number]}`.
- Rejects unknown IDs, excluded dishes, wrong slot count, over-budget output, low-protein high-protein output, and insufficient variety output.

### `sync-push`

- Accepts POST only.
- Requires an authenticated user.
- Uses a Supabase secret key only inside the Edge Function for server-side REST/RPC calls.
- Routes generated plans through timestamp-hardened `apply_generated_plan`.
- Routes meal consumption updates through timestamp-hardened `apply_meal_slot_consumption`.
- Routes linked budget entries through timestamp-hardened `apply_budget_entry`.
- Routes other entities through `apply_sync_record`.
- Returns accepted/conflict status to the client.

Third-party provider secrets are not embedded in the Flutter client.

## 21. Supabase Database System

The migrations in `supabase/migrations` (see `PROGRESS.md` for applied and pending status) create and evolve:

- `sync_records` for timestamped entity envelopes.
- User profiles, dishes, ingredients, nutrition cache, allergen tags, generated plans, meal slots, and budget entries.
- Owner indexes and plan/budget indexes.
- `updated_at` triggers for profiles and dishes.
- Row-level security on user-owned tables.
- A read policy for authenticated nutrition cache access.
- Security-definer RPC functions with execute access restricted to `service_role`.
- Typed hydration for profiles, dishes, ingredients, allergens, plans, meal slots, and budget entries.
- Active-plan uniqueness behavior.
- Meal status constraints.
- Unique linked budget entry per user and meal slot.
- Conflict hardening for specialized plan, budget, and meal-consumption RPCs.

The linked project schema lint passes. The latest migrations are applied remotely; migration-list inspection requires the linked database password.

## 22. Currency System

Implementation: `lib/core/currency/app_currency.dart`.

Supported display currencies:

- USD, symbol `$`.
- PHP, Philippine peso symbol.
- EUR, euro symbol.
- GBP, pound sterling symbol.
- JPY, yen symbol.

The source defines the display glyph for each supported currency. `formatCents` divides by 100 and renders exactly two decimal places. Currency selection is persisted and affects display labels and plan metadata only; no exchange-rate conversion is performed.

## 23. Design And Presentation System

Implementations: `lib/core/theme`, `lib/core/constants`, and feature screens.

- Material `MaterialApp.router` shell.
- NutriWallet green primary visual language.
- Shared page, item, section, and small spacing constants.
- Reusable cards, chips, progress indicators, dialogs, bottom sheets, and navigation destinations.
- Responsive list/grid layouts appropriate for mobile and larger widths.
- Loading, empty, retry, validation, success, and error states in the primary flows.
- Currency-aware labels throughout budget, dish, plan, and profile screens.

## 24. Automated Test Coverage

The repository contains unit, widget, and integration tests.

Coverage areas:

- Nutrition BMR, TDEE, BMI, and goal targets.
- Currency formatting.
- Budget repository CRUD and current-week filtering.
- Dish creation, ingredient relations, price queries, and soft deletion.
- Profile persistence and scoped updates.
- Meal-plan generation, rounding, budget handling, exclusion filtering, and repeat avoidance.
- Plan persistence, versioning, active selection, consumption, and nutrition summaries.
- Nutrition cache reuse.
- Gemini response validation and retry implementation (direct retry test coverage remains limited).
- Sync queue confirmation, conflict handling, and connectivity retry.
- Auth registration, confirmation-required state, sign-in routing, and password validation.
- Onboarding and dish detail widget behavior.
- Authenticated happy-path flow using test doubles.

## 25. Validation Performed

The following checks passed during this scan:

```text
flutter analyze
No issues found.

dart run build_runner build
Completed; generated outputs were current.

dart format --output=none --set-exit-if-changed lib test
Passed; 71 files checked and none changed.

flutter test --coverage
Passed; 61 tests passed, including the connected service smoke.

flutter build apk --debug
Passed; build/app/outputs/flutter-apk/app-debug.apk.

flutter build apk --release --build-name=1.0.0 --build-number=4
Passed compilation; local artifact is debug-signed pending production keystore configuration.

flutter build appbundle --release --build-name=1.0.0 --build-number=4
Passed compilation; local artifact is debug-signed pending production keystore configuration.

powershell -ExecutionPolicy Bypass -File .\build_release.ps1 -Artifact apk
Correctly refuses to run when production signing variables are missing.

npx supabase migration list --linked
Requires `SUPABASE_DB_PASSWORD` for CLI login inspection after the latest migrations.

npx supabase db lint --linked
Passed; no schema errors found.

npx supabase functions list
Passed; vision-recognize, sync-push, nutrition-lookup, and plan-generate are ACTIVE.

npm ci
Passed; no vulnerabilities reported.

GitHub Actions
Added Flutter, Drift, coverage, Android package, Deno, and optional Supabase validation jobs.
```

The Android build emits a non-fatal warning because `workmanager_android` still applies the legacy Kotlin Gradle Plugin. The iOS build was not run because iOS builds require macOS and Xcode.

Connected Android smoke validation also passed sign-in, profile setup, manual dish creation, USDA nutrition enrichment, Gemini planning, plan history/detail, serving adjustment, budget expense tracking, meal check-in controls, notification permission/scheduling, sync action, sign-out/re-login, and photo recognition. No fatal application exception appeared in the emulator log scan.

## 26. Known Limitations And Open Verification

- Authenticated email delivery and confirmation should still be smoke-tested with a real mailbox on Android.
- Authenticated Gemini planning, photo recognition, and sync have been exercised on the emulator; physical Android validation remains open.
- The client has outbound sync but no remote-to-local pull/merge implementation.
- Local photo paths are stored with dishes; the current source does not upload images to Supabase Storage.
- Native ML Kit fallback is not implemented in the current source.
- The checked-in Supabase config enables email confirmations; the linked project's setting must still be verified for the intended environment.
- iOS native build, notification delivery, camera access, and Workmanager execution remain unverified on Windows.
- Accessibility, text scaling, and planner performance with large dish libraries need dedicated validation.
- Production release signing is not configured in this environment. The hardened release script refuses missing keystore variables and rejects debug-signed APKs.
- The latest migrations were applied with `supabase db push`; migration-list inspection requires the linked database password.
- Notification delivery and weekly background execution have not been verified; only permission and scheduling setup have.
- Workmanager still emits a non-fatal legacy Kotlin Gradle Plugin warning on Android builds.
- Settings schedules future reminders for active-plan meals using configured daily meal times; device delivery still needs verification.
- One-hour auto-skip reconciliation runs while Plan or Budget is active; it is not performed by the background worker.
- Release shrinking is disabled for the current artifacts.
- Privacy text and production environment configuration still need review.
- Real-account service smoke coverage now exercises authentication, USDA, Gemini planning, plan/component sync, and meal check-in sync. Camera recognition, notification delivery, and long-running background execution still need dedicated device coverage.

## 27. Source Map

| Area | Primary files |
| --- | --- |
| Startup and providers | `lib/main.dart`, `lib/app.dart`, `lib/core/providers.dart` |
| Routing | `lib/core/routing/app_router.dart` |
| Local schema | `lib/data/local/database.dart` |
| DAOs | `lib/data/local/daos/*.dart` |
| Repositories | `lib/data/repositories/*.dart` |
| Nutrition algorithms | `lib/features/nutrition_goal/domain/nutrition_models.dart` |
| Planning algorithm | `lib/features/meal_planner/domain/meal_planning_engine.dart` |
| Planning models | `lib/features/meal_planner/domain/planner_models.dart` |
| Remote services | `lib/data/remote/*.dart` |
| Screens | `lib/features/**/*.dart` |
| Notifications | `lib/features/notifications/*.dart` |
| Supabase functions | `supabase/functions/**/*.ts` |
| Supabase schema and RPC | `supabase/migrations/*.sql` |
| CI and release automation | `.github/workflows/quality.yml`, `build_release.ps1` |
| Automated tests | `test/unit`, `test/widget`, `test/integration` |

## 28. Related Documents

- `SPRINT.md`: ordered sprint summary of how the features were built and fit together.
- `PROGRESS.md`: detailed checklist, verification log, known warnings, and remaining work.
- `PLAN.md`: architecture, schema, package plan, and original build phases.
- `README.md`: setup instructions and project limitations.

This document is the authoritative description of what the app contains. If another document differs about app behavior, this one takes precedence.
