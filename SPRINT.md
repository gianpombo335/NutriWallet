# NutriWallet Sprint Overview

NutriWallet is a connected Flutter app for planning meals around nutrition goals and a real food budget. This document summarizes the implemented work in order and explains how the major features operate together.

## Sprint Outcome

The project has progressed from an empty Flutter foundation to a functional Flutter application backed by Supabase, with Drift retained as the signed-in device cache and sync queue. Android code paths are validated locally and release automation now blocks unsigned production artifacts.

The core user journey is implemented:

1. Create an account or sign in.
2. Complete a nutrition and budget profile.
3. Add dishes manually or from a photo.
4. Enrich ingredients with nutrition data.
5. Set allergies and planning preferences.
6. Generate and review a weekly meal plan.
7. Track planned and actual food spending.
8. Receive reminders and regenerate plans in the background.
9. Synchronize local changes when connectivity is available.

## Implementation Order

### 1. Foundation

The app uses Flutter with a feature-first structure.

- Riverpod manages application state.
- GoRouter manages top-level navigation.
- Shared theme components provide the NutriWallet design system.
- GitHub Actions checks cover formatting, analyzer, Drift generation, tests, coverage, Android packaging, and Edge Function type checking.
- Core, local data, remote services, repositories, and feature screens are separated.

This structure keeps Supabase service implementations behind interfaces without coupling screens to transport details.

### 2. Local Data And Authentication

Drift provides the local SQLite database and typed queries. The database contains profiles, dishes, ingredients, allergens, generated plans, meal slots, budget records, nutrition caches, and synchronization records.

The local database supports:

- Database migrations
- Foreign keys and cascading relationships
- Integer-cent monetary storage
- Durable outbound synchronization records

All production authentication uses Supabase email/password sessions. Both `SUPABASE_URL` and `SUPABASE_ANON_KEY` are required at startup.

### 3. Onboarding And Profiles

Onboarding stores the values required for personalized planning:

- Display name
- Weekly budget
- Active days
- Meals per day
- Sex and body metrics
- Activity level
- Goal preset
- Display currency

Profile data is validated before saving. Updates are scoped to the selected profile and errors are shown instead of being silently ignored.

### 4. Dish Library

Users can create, edit, and remove dishes. The edit flow updates name, price, cuisine, and ingredients while preserving nutrition for unchanged ingredients. Dishes store prices, names, cuisine information, photos, sources, and ingredients.

Dish cards and detail screens show a warning when saved profile exclusions match the dish name or ingredients. Matching uses normalized whole-word and phrase tokens to avoid simple substring false positives.

Ingredients store quantities, units, calories, macros, and optional external nutrition identifiers. Dish removal uses soft deletion so the action can be synchronized safely.

### 5. Photo Capture And Recognition

Dish creation can start from a camera or gallery image.

The recognition flow works as follows:

1. The user selects or captures an image.
2. A vision provider proposes a meal name and ingredients.
3. The authenticated Gemini proxy returns a proposed meal name, ingredients, cuisine, and allergen terms.
4. The user edits or removes proposed ingredients.
5. Nutrition values refresh for corrected ingredients.
6. The dish is saved only after the user confirms it.

Loading, retry, and error states are implemented. Connected vision requests use a Supabase Edge Function so provider credentials remain server-side.

### 6. Nutrition Services

Nutrition lookup uses a layered approach:

1. Check the normalized device cache.
2. Use the authenticated USDA proxy.
3. Normalize and persist successful results.
4. Report failed lookups as pending so the user can correct or re-edit the ingredient.

The nutrition domain calculates BMI, BMR, TDEE, and targets for balanced, cutting, bulking, high-protein, and keto goals.

### 7. Allergies And Exclusions

Allergen labels are stored on the user's profile. Shared matching logic compares normalized profile exclusions against dish names and ingredient names for library/detail warnings and planner filtering.

The existing `DishAllergenTags` join table is reserved for future explicit per-dish allergen confirmation; AI-reported allergen terms are not treated as authoritative medical data.

The planner applies hard exclusion filtering before scoring dishes. A dish that violates an exclusion cannot be selected because it is cheap or nutritionally suitable.

### 8. Meal Planning

The planning engine validates and scores plans on the device after receiving the available authenticated data. It considers:

- Nutrition targets
- Weekly budget
- Active days
- Meals per day
- Allergies and exclusions
- Dish nutrition and prices
- Planning focus

Supported planning focuses are balanced, budget, protein, variety, and simple rotation.

The engine filters invalid dishes, scores candidates, avoids consecutive repeats, and applies a local-search refinement pass. Costs are rounded to currency subunits before totals are accumulated.

The result includes meal slots, projected cost, calorie totals, macro totals, and over-budget status.

Every planning focus requests Gemini recommendations through the authenticated proxy. Responses must contain the exact requested slots and valid, non-excluded dish IDs; the device planner then enforces budget, nutrition, variety, and focus constraints before persistence.

### 9. Plan Storage And History

Generated plans are stored as versioned records with their meal slots. Users can view plan history and plan details.

The active plan is stored separately from historical plans, allowing plan switching without deleting previous generations. Manual regeneration creates a new version.

### 10. Budget Tracking

The budget feature separates planned costs from actual spending:

- Planned cost comes from the generated meal plan.
- Actual grocery expenses are entered independently.
- Expenses can optionally link to the active plan.
- Expenses can be removed to correct mistakes.
- Analytics filter entries to the active week.
- Charts compare planned and actual spending.
- USD, PHP, EUR, GBP, and JPY formatting is supported.

This keeps real grocery corrections from changing the planner's projected cost.

### 11. Notifications And Background Regeneration

Local notifications provide meal reminders. Preferences are persisted, and scheduled reminders can be cancelled.

Workmanager runs weekly regeneration. The background worker uses stored profile metrics and exclusions so background plans follow the same rules as foreground plans.

Android notification permission handling is configured for newer Android versions.
iOS notification permission requests and device timezone initialization are configured before scheduling.
Background regeneration preserves currency/planning-focus metadata and skips incomplete or over-budget plans.

### 12. Synchronization

Local writes happen first. Changes are added to a durable sync queue with dirty flags and retry information.

When connectivity is restored, synchronization retries automatically. Connected builds use authenticated Supabase proxy functions and timestamp-based last-write-wins conflict handling.

Supabase currently includes:

- Email/password authentication
- Vision recognition proxy
- USDA nutrition proxy
- Gemini smart-plan proxy
- Authenticated sync proxy
- Postgres mirror tables, ownership policies, update triggers, and conflict handling

Typed queue envelopes and server mirror writes cover profiles, dishes, ingredients, allergens, generated plans, meal slots, and budget entries. The local conflict-hardening migration adds last-write-wins checks to specialized plan, budget, and consumption RPCs. Remote-to-local pull/hydration is still not implemented.

## Current Verification

The current implementation has passed:

- `flutter analyze`
- `dart run build_runner build`
- Dart formatting check
- `flutter test --coverage` with 55 passing tests
- Android debug APK build
- Android release APK build
- Connected Android release APK and App Bundle compilation with Supabase defines; local artifacts are debug-signed pending a production keystore
- Linked Supabase schema lint with no errors
- Linked Supabase schema lint with no errors; new migration parity requires the linked database password
- All four expected Supabase Edge Functions reported ACTIVE
- Android API 36 release launch completed without a fatal app exception
- `npm ci` completed with zero reported vulnerabilities

The latest local release artifacts are:

- APK: `build/app/outputs/flutter-apk/app-release.apk` (67.1 MB, SHA-256 `477C7D2D4D35D9CF2ADD5E429644BFC5305966C55ECBD16A31214B63DC8F8A69`)
- App Bundle: `build/app/outputs/bundle/release/app-release.aab` (64.0 MB, SHA-256 `9E49EEF6C56507EBDE8C2C15835CEC1A78412C522213D88C46B1953DFE8D8437`)

## Remaining Sprint Work

The main remaining work is verification and release hardening:

- Smoke-test connected sign-up -> email confirmation -> sign-in -> profile setup with a real mailbox.
- Repeat authenticated flows on a physical Android device.
- Test notification delivery and weekly background execution, not only permission/scheduling setup.
- Add broader authenticated end-to-end tests.
- Build and test iOS on macOS.
- Run accessibility and text-scaling checks.
- Profile planner performance with larger dish libraries.
- Resolve or document the Workmanager Kotlin warning.
- Review signing, privacy text, and production environment configuration.
- Configure a production Android keystore and produce a non-debug-signed APK/AAB.
- Apply and verify `20261006000300_sync_conflict_hardening.sql` on the linked Supabase project.
- Implement authenticated cloud pull/hydration for new devices and local recovery.

## Runtime

The Supabase project URL and publishable key are required for every build. Authentication and proxy-backed services use the configured Supabase project; Drift stores the signed-in account's device cache and pending sync queue. Production Android builds additionally require the four `NUTRIWALLET_*` keystore variables documented in `README.md`.

## Reference Documents

- `PLAN.md` contains the architecture, schema, package plan, and original build phases.
- `README.md` contains setup instructions and project limitations.
- `PROGRESS.md` is the detailed implementation status and verification log.
