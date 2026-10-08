# NutriWallet Progress

Last updated: 2026-10-08

## Overall Status

The app is a connected Flutter app backed by Supabase. Drift remains the authenticated device cache and sync queue; Supabase provides email/password Auth, nutrition, vision, smart-plan, and sync services. Connected sign-up requires email confirmation, and the app provides a confirmation/resend step before sign-in and profile setup. Dish editing, profile-based allergy indicators, notification timezone/permission handling, sync conflict hardening, CI checks, and release artifact validation are implemented. Android production signing, cloud pull/hydration, iOS build/runtime testing, real confirmation-email testing, physical-device coverage, and final platform polish remain.

## Resume Here

Current baseline: analyzer, code generation, formatting, tests, configured Android debug/release compilation, connected service smoke, Android emulator UI smoke, linked schema lint, and deployed Edge Function validation pass. The current test suite has 61 passing tests, including the connected service smoke. The APK/AAB produced in this environment are debug-signed because no production keystore is configured; the release script correctly refuses to create a production artifact without signing variables. Real confirmation-email delivery, cloud pull/hydration, physical-device coverage, and iOS validation remain open.

Latest completed work: configurable meal schedules, next-prioritized meal dashboards with one-hour auto-skip reconciliation, shared meal check-in actions, multi-dish meals, connected service and emulator smoke coverage, budget-link conflict handling, dish editing with ingredient sync, profile-based allergy warnings, shared allergy matching, safe sign-out queue flushing, special-RPC conflict timestamps, local-date budget fixes, iOS notification permission/timezone setup, background-plan metadata preservation, CI quality automation, and hardened Android release validation.

Recommended next task: configure the production Android keystore, then perform physical Android notification/camera validation and iOS validation on macOS.

After device testing: add full authenticated end-to-end coverage, then perform iOS, accessibility, performance, signing, and release checks.

Latest local release APK: `build/app/outputs/flutter-apk/app-release.apk`

Latest local release APK size: 68.0 MB

Latest local release APK SHA-256: `6F1C7D9648D82F8D4B2EED0228798B6D84EB06C1F7FFDCECAE36E58A5AF23C31`

Latest local release App Bundle: `build/app/outputs/bundle/release/app-release.aab`

Latest local release App Bundle size: 64.7 MB

Latest local release App Bundle SHA-256: `0AF667BE56B5231AEA6A5EDB95440649F56552ED9CDF44104E54F7E32B53C9ED`

Previous local release APK SHA-256: `F233FADEE9362CF6AEC975C445B27CEC412779B2DD7C8BE60D472C1425083033`

Previously recorded connected release APK SHA-256: `E86FFDF5BC8927A54F13C1436DEF5F58A554003E8ED1FCD3CFBC5EE493B214B8`

Earlier connected release APK SHA-256: `9C60124135249B00BF91F8C7D8ED9D837AFC7C6E36F120D635673B99A0F79EAA`

## Completed

- [x] Flutter project scaffold and feature-first structure
- [x] Riverpod providers and GoRouter navigation
- [x] NutriWallet design system and reusable theme
- [x] Drift SQLite database with foreign keys and migrations
- [x] Profile, dish, ingredient, allergen, plan, meal-slot, cache, budget, and sync tables
- [x] Required Supabase Auth configured by `SUPABASE_URL` and `SUPABASE_ANON_KEY`
- [x] Onboarding, authentication, profile setup, dashboard shell, settings, and dish screens
- [x] Manual dish creation with ingredient nutrition enrichment
- [x] Camera/gallery dish capture using `image_picker`
- [x] AI meal naming with editable ingredient correction before saving
- [x] Confirmed dish removal with soft-delete and sync queue support
- [x] Existing dish editing for name, price, cuisine, and ingredients
- [x] Profile-based allergy warning indicators in dish library and detail
- [x] Supabase Gemini vision proxy implementation
- [x] Permanent normalized nutrition cache in SQLite
- [x] BMR, TDEE, BMI, and balanced/cutting/bulking/high-protein/keto targets
- [x] Persisted currency selection with USD, PHP, EUR, GBP, and JPY display formats
- [x] Meal planner hard exclusion filtering
- [x] Consecutive-meal repeat avoidance with variety scoring
- [x] Greedy budget/nutrition scoring
- [x] Currency-subunit rounding before cost accumulation
- [x] Local-search refinement pass
- [x] Versioned generated-plan persistence
- [x] Persisted active-plan selection separate from plan history
- [x] Planning focus selection with balanced, budget, protein, variety, and simple-rotation modes
- [x] AI-assisted plan recommendations with authenticated proxy and validation
- [x] Manual plan regeneration
- [x] Weekly plan calorie and macro summary against nutrition targets
- [x] Allergy/exclusion editor
- [x] Actual grocery spend entries
- [x] Planned-vs-actual budget chart
- [x] Independent actual-spend tracking, optional plan linking, and expense removal
- [x] Full profile editing and generated-plan history/detail screens
- [x] Persisted notification preferences and cancellation controls
- [x] Recognition loading and retry states
- [x] Persistent sync queue with dirty flags
- [x] Last-write-wins authenticated sync endpoint
- [x] Last-write-wins hardening for plan, budget, and meal-consumption RPCs
- [x] Automatic sync retry on connectivity restoration
- [x] Supabase sync-record migration and authenticated sync proxy
- [x] Migrated Edge Function auth to Supabase publishable/secret keys and redeployed all four functions
- [x] USDA nutrition and Gemini vision proxy Edge Functions
- [x] Local meal reminder scheduling
- [x] Weekly Workmanager plan regeneration callback
- [x] Background regeneration uses stored profile nutrition metrics
- [x] Weekly budget analytics filtering
- [x] Android notification permission and core-library desugaring configuration
- [x] iOS 15 deployment target, camera/photo permissions, and Workmanager launch registration configuration
- [x] Android release version/signing gate and APK/AAB artifact validation script
- [x] GitHub Actions Flutter, Deno, Android package, and optional Supabase checks
- [x] Printed menu/receipt image capture with Gemini recognition
- [x] Shared whole-word allergy matching for dish warnings, planner filtering, and Gemini validation
- [x] Active-plan meal check-ins (eaten, substitute, skipped) with duplicate-safe linked budget entries
- [x] Live current/next meal dashboards with quick check-in actions in Plan and Budget
- [x] Next-meal priority with one-hour overdue auto-skip and linked budget cleanup
- [x] Persisted meal-slot macro snapshots and adjustable servings
- [x] Safe sign-out that flushes pending sync records before clearing local data
- [x] Gemini plan-response retry (one retry after 250 ms)
- [x] `PLAN.md`, `README.md`, `SPRINT.md`, and `contents.md`

## Verification

Last verified successfully:

```text
flutter analyze
dart run build_runner build
dart format --output=none --set-exit-if-changed lib test
 flutter test --coverage      # 61 tests passed, including connected smoke
flutter build apk --debug    # passed
 flutter build apk --release --build-name=1.0.0 --build-number=4 --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...  # compiled; debug-signed local artifact
 flutter build appbundle --release --build-name=1.0.0 --build-number=4 --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...  # compiled; debug-signed local artifact
 npx supabase migration list --linked  # requires SUPABASE_DB_PASSWORD for CLI login inspection
 npx supabase db lint --linked  # no schema errors
npx supabase functions list  # four expected functions ACTIVE
```

APK output:

```text
build/app/outputs/flutter-apk/app-debug.apk
build/app/outputs/flutter-apk/app-release.apk
```

Latest local release APK:

- Size: 68.0 MB
- SHA-256: `6F1C7D9648D82F8D4B2EED0228798B6D84EB06C1F7FFDCECAE36E58A5AF23C31`

Latest local release App Bundle:

- Size: 64.7 MB
- SHA-256: `0AF667BE56B5231AEA6A5EDB95440649F56552ED9CDF44104E54F7E32B53C9ED`

## Known Warnings And Errors

- Workmanager currently emits a non-fatal warning because `workmanager_android` still applies the legacy Kotlin Gradle Plugin. The APK build succeeds. Upgrade the plugin or migrate the Android project when a compatible release is available.
- Release shrinking remains disabled for the demo artifact; the current client has no ML Kit dependency, so any future ML Kit integration should add its required language dependencies or targeted keep rules before shrinking is enabled.
- Supabase Auth is implemented and authenticated Flutter sign-in, profile setup, and service-backed proxy calls were exercised on the API 36 Android emulator.
- Supabase email confirmation is now required for connected sign-up. The app handles confirmation-required responses and resend requests; completing the email link still needs a real mailbox smoke test.
- USDA nutrition, Gemini vision, smart-plan, and sync Edge Functions are deployed and the connected emulator exercised nutrition lookup, photo recognition, planning, and sync actions.
- Supabase defines are mandatory for every build; there is no in-memory or local-only sync endpoint in the current provider graph. All builds use the deployed Supabase sync endpoint.
- Supabase mirror tables, RLS policies, and atomic server-side conflict handling are deployed; typed RPCs hydrate profiles, dishes, ingredients, allergens, generated plans, meal slots, and budget entries. Meal schedule, multi-dish component, and budget-link conflict migrations are applied remotely.
- Dish photos are stored as local file paths only; they are not uploaded to Supabase Storage.
- Settings schedules future reminders for the active plan's configured meal times; notification delivery has not been verified on a device.
- The local migration set includes the meal schedule, component, and budget-link conflict migrations; linked schema lint reports no errors, while migration-list inspection requires `SUPABASE_DB_PASSWORD`.
- Existing local databases migrate to active-plan tracking without losing plan history.
- Budget actuals are independent from plan cost, can optionally link to the active plan, and can be removed to correct mistakes.
- Supabase Dart defines are mandatory; missing configuration now stops startup with a configuration error.
- Profile setup now awaits persistence, prevents duplicate saves, validates the budget, and reports expired sessions or database errors visibly.
- Profile edits now update only the selected profile instead of issuing an unscoped table update.
- Supabase signup errors now expose actionable messages instead of the generic failure text; the connected Auth endpoint was validated with the configured public key.
- Auth rate-limit responses now disable the submit action for 60 seconds to prevent repeated retries from extending the lockout.
- The checked-in `supabase/config.toml` now enables email confirmations; verify the linked project's Auth setting before the device smoke test.
- iOS has not been built or tested in this Windows environment.
- `flutter build ios --no-codesign` cannot run on this Windows environment because the Flutter CLI exposes iOS builds only on macOS; Xcode is required.
- iOS configuration now includes an iOS 15 target, camera/photo-library usage descriptions, background fetch metadata, and Workmanager launch/plugin registration; native build, permissions, notifications, and background execution remain unverified.
- Connected photo and menu recognition requires an authenticated network connection; failed requests expose retry states.
- The current photo/menu recognition path uses the authenticated Gemini proxy and retry states; no ML Kit dependency is present in the current `pubspec.yaml`.
- Android API 36 emulator is available and the connected debug APK completed the main authenticated smoke path without a fatal app exception.
- Deno and Docker are not installed in this environment, so Edge Function type checks and local Supabase migration lint are delegated to CI; linked remote schema lint passed.
- The legacy JWT-based API keys were disabled on 2026-09-30. The connected client uses a publishable key, and all four Edge Functions use the modern publishable/secret key environment.

## Remaining Work

### High Priority

- [x] Add automatic sync on connectivity restoration
- [x] Deploy and smoke-test Supabase Edge Functions for vision, USDA lookup, and sync
- [x] Complete the Supabase/Postgres app schema and server-side `updated_at` conflict handling
- [x] Implement typed hydration envelopes for profile, ingredient, allergen, plan, and meal-slot sync records
- [x] Apply and remotely verify the complete typed-sync migration
- [ ] Smoke-test confirmation-enabled Supabase sign-up -> email confirmation -> sign-in -> profile setup on Android
- [x] Validate authenticated Gemini smart-plan requests on the Android emulator
- [x] Make background regeneration use stored profile metrics and exclusions exactly like foreground generation
- [x] Add local integration coverage for register -> sign in -> add dish -> generate -> sign out -> sign in using test doubles
- [x] Add local integration coverage for offline dish creation -> reconnect -> sync using a fake endpoint
- [x] Add CI checks for Flutter, Drift generation, coverage, Android packaging, Edge Function type checks, and optional linked Supabase validation
- [x] Harden specialized sync RPCs with timestamp conflict handling
- [ ] Implement authenticated remote-to-local pull/hydration for new devices and local recovery
- [x] Apply and remotely verify the meal schedule, component, and budget-link conflict migrations
- [ ] Verify the linked project's Auth email-confirmation setting matches the checked-in `supabase/config.toml`

### Medium Priority

- [x] Add full profile editing for weekly budget, active days, meals per day, sex, metrics, and goal preset
- [x] Add generated-plan history/drill-down screen
- [x] Add actual weekly budget filtering to analytics rather than showing all entries
- [x] Add loading/skeleton states around remote recognition and clearer retry banners
- [x] Add notification preference persistence and cancellation UI
- [x] Verify Android notification permission request wiring for API 33+

### Final Quality Pass

- [ ] Build and smoke-test iOS on macOS
- [ ] Run accessibility contrast and text-scaling checks
- [ ] Profile planner performance with 50 dishes and a full seven-day plan
- [ ] Add end-to-end tests for allergy exclusion, goal switching, photo capture, budget chart, and notifications
- [ ] Validate connected photo recognition and authenticated sync on a physical Android device
- [ ] Test notification delivery and weekly background execution, not only permission/scheduling setup
- [ ] Remove or resolve the Workmanager Kotlin warning
- [ ] Review release signing, privacy text, and production environment setup
- [ ] Configure production Android keystore and produce a non-debug-signed APK/AAB

## Important Files

- `PLAN.md`: architecture, schema, package plan, and design decisions
- `README.md`: setup, architecture, services, and limitations
- `lib/features/meal_planner/domain/meal_planning_engine.dart`: pure planning algorithm
- `lib/features/nutrition_goal/domain/nutrition_models.dart`: calculators and goal presets
- `lib/data/local/database.dart`: Drift schema and migrations
- `lib/data/remote/nutrition_lookup_service.dart`: device cache and USDA proxy service
- `lib/data/remote/smart_plan_service.dart`: Gemini recommendation service with strict response validation
- `lib/data/remote/vision_ai_service.dart`: authenticated vision proxy service
- `lib/data/remote/sync_service.dart`: durable queue and last-write-wins seam
- `supabase/migrations/20260912000200_app_schema.sql`: Supabase mirror schema, RLS, and conflict RPC
- `supabase/migrations/20260917000100_complete_typed_sync.sql`: complete typed-sync RPC and generated-plan active state
- `supabase/functions/plan-generate/index.ts`: authenticated Gemini plan recommendation proxy
- `supabase/migrations/20261006000300_sync_conflict_hardening.sql`: timestamp conflict hardening for plan, budget, and meal-consumption RPCs
- `lib/core/currency/app_currency.dart`: persisted currency options and formatting
- `contents.md`: implementation inventory and authoritative description of app behavior
- `SPRINT.md`: ordered sprint summary
- `lib/features/notifications/background_plan_scheduler.dart`: weekly worker

## Update Log

### 2026-10-08

- Added a live current/next meal dashboard to Plan with direct Eaten, Substitute, and Skip actions.
- Added the same quick meal outcomes to the Budget meal timeline while keeping spend analytics primary.
- Prioritized the next planned meal and auto-skipped overdue planned meals within one hour of that next meal, including linked budget cleanup.
- Replaced misleading loading/empty states and translucent dashboard surfaces with explicit loading/error states and opaque cards.
- Shared the meal check-in flow between Plan and Budget and connected it to the existing atomic linked-expense transaction.
- Added reactive meal-slot streams, dashboard widget coverage, and online check-in regression coverage.
- `flutter analyze`, formatting, `flutter test --coverage` (61 tests including connected smoke), debug APK, release APK `1.0.0+4`, release AAB `1.0.0+4`, and Android API 36 real-account smoke passed.

### 2026-09-12

- Built a debug-signed release demo APK with NutriWallet branding and verified the final artifact.
- Disabled release shrinking for the demo because R8 could not resolve optional ML Kit language bindings.
- Added concrete ML Kit image-labeling and OCR services with fixture fallbacks (later removed: photo and menu recognition now use only the authenticated Gemini proxy and no ML Kit dependency remains).
- Added optional Supabase Auth with local fallback (superseded: local/demo providers were removed on 2026-10-01 and Supabase is now required).
- Added generated-plan calorie, protein, carbohydrate, and fat totals with target comparison in the Weekly Plan screen.
- Added actual budget entries, planned-vs-actual charting, local reminders, and weekly background regeneration.
- Added durable sync queue and last-write-wins service seam.
- Added automatic reconnect sync, weekly budget filtering, Supabase migrations, and authenticated USDA/Gemini/sync Edge Functions.
- Re-ran analyzer, tests, and Android debug build successfully.
- Added profile-aware background targets and deployed authenticated USDA, Gemini, and sync Edge Functions.
- Applied the `sync_records` Supabase migration and verified provider responses through the deployed proxies.
- Added full profile editing and generated-plan history/detail screens with repository coverage.
- Added persisted notification preferences, cancellation controls, OCR fallback/retry messaging (the OCR fallback was later removed with ML Kit), and local happy-path integration coverage.
- Added testable connectivity restoration sync and Android notification permission requests; 29 tests and Android builds pass.
- Added the Supabase mirror schema, ownership policies, updated-at triggers, and atomic sync conflict RPC; deployed sync-push version 5.
- Added typed Supabase hydration for dish and budget sync records; deployed sync-push version 6 and rebuilt the Android artifacts.
- Added explicit local/cloud mode labels (local mode was later removed), bounded photo uploads, nutrition failure recovery, and a connected release APK using the configured Supabase project.
- Fixed onboarding step-three save handling, Supabase email-confirmation routing, and silent async failures across auth, profile editing, planning, sync, and reminders; 30 tests pass.
- Added actionable Supabase Auth error mapping and rebuilt the connected APK; 31 tests pass.
- Configured the linked Supabase project for standard email/password sessions and rebuilt the connected APK; rate limiting remains enabled.
- Added persisted currency selection including Philippine pesos, corrected profile update scoping, improved planner variety, and rebuilt the connected APK with 36 tests passing.
- Added active-plan persistence, selectable planning focuses, Gemini smart-plan recommendations, and independent adjustable budget actuals; deployed `plan-generate` and rebuilt the connected APK.
- Added AI meal naming, editable ingredient chips with nutrition refresh, and confirmed dish removal; deployed vision-recognize and rebuilt the connected APK with 32 tests passing.

### 2026-09-16

- Re-ran `flutter analyze` successfully with no issues.
- Re-ran `dart run build_runner build`; generated code was already up to date.
- Re-ran `flutter test`; 35 tests passed.
- Rebuilt Android debug and local release APKs successfully.
- Verified the local release APK size and SHA-256.
- No Android device or emulator was available, so physical-device smoke testing remains open.
- Ran dependency resolution, formatting checks, and the full test suite with coverage; 35 tests passed and no Dart files required formatting changes.
- Rebuilt Android debug and local release APKs again; both artifacts completed successfully.
- Confirmed no Android device or emulator is available, and Deno is not installed for local Edge Function type checking.

### 2026-09-17

- Resolved dependencies successfully; 22 packages have newer versions outside the current constraints.
- Confirmed Dart formatting with no changes required.
- Re-ran analyzer and Drift code generation successfully with no issues or generated-file changes.
- Ran the complete test suite with coverage; 35 tests passed.
- Rebuilt Android debug and local release APKs successfully.
- Confirmed no Android device or emulator is available, and Deno is not installed for local Edge Function type checking.
- Added typed sync queue envelopes for profiles, ingredients, allergens, generated plans, and meal slots, including active-plan changes.
- Added the complete typed-sync Supabase migration; linked schema lint passes, but the migration remains unapplied remotely.
- Added queue-order regression assertions and rebuilt the Android debug and local release APKs; 35 tests pass.
- Latest local release APK SHA-256: `71316988E3D006545D61B8D5ABFE529D155613897E2D9B0C9BEE18655E80DF58`.

### 2026-09-30

- Re-ran dependency resolution, Drift generation, analyzer, formatting, and coverage tests; all 35 tests pass.
- Rebuilt Android debug and release APKs; Flutter compatibility suggestions pass. Installed and launched the release build on the API 36 emulator with no fatal application exception in the recent log scan.
- Built and launched a connected debug APK using the project publishable key; Supabase initialization completed and the Auth health endpoint returned HTTP 200. After JWT-based API keys were disabled, a publishable-key request to the nutrition cache REST endpoint returned HTTP 200.
- Confirmed the linked NutriWallet project has all four expected Edge Functions active and the Gemini/USDA secrets configured.
- Updated sync-push to use `SUPABASE_SECRET_KEYS` and shared Edge Function auth to use `SUPABASE_PUBLISHABLE_KEYS`; redeployed all four functions (vision-recognize v13, sync-push v14, nutrition-lookup v17, plan-generate v8). The user then disabled JWT-based API keys.
- After transient database-login timeouts, `npx supabase migration list --linked` confirmed all four local migrations match remote, including `20260917000100_complete_typed_sync.sql`. `npx supabase db lint --linked` passed with no schema errors.
- Latest local release APK SHA-256: `E86FFDF5BC8927A54F13C1436DEF5F58A554003E8ED1FCD3CFBC5EE493B214B8`.

### 2026-10-01

- Updated cloud sign-up handling for required email confirmation, including a dedicated inbox state, resend action, and return-to-sign-in path.
- Polished login with form validation, password visibility and confirmation, and sign-in that honors the configured Supabase password policy instead of enforcing the sign-up minimum.
- Persisted onboarding completion, routed returning signed-out users directly to auth, and invalidated cached profile state on auth changes.
- Added repository and widget regression tests for confirmation-required signup, resend, sign-in routing, password mismatch, onboarding, and budget expense editing. Removed local/demo runtime providers and validated the connected APK on the API 36 emulator. `flutter analyze`, formatting, `flutter test --coverage` (41 tests), and connected `flutter build apk --debug` pass.
- The app flow is covered with test doubles; real Supabase email delivery/confirmation had not yet been exercised on a device. Authenticated sign-in has since been exercised on the API 36 emulator (see Known Warnings And Errors); real email delivery and physical-device sign-in remain open.
- Fixed all planning focuses to use Gemini with focus-specific instructions, strict slot/ID/exclusion validation, and deployed `plan-generate` updates.
- Added onboarding currency selection, direct captured-dish navigation to the dishes menu, budget limit editing, dated/editable expenses, active-plan meal check-ins, substitute meal cost tracking, and persisted meal consumption state.
- Applied the remote `20261001000100_meal_consumption_tracking.sql` migration and redeployed `sync-push`; connected debug APK build passes after the changes.
- Added plan/budget integrity migration `20261001000200` plus RPC cleanup `20261001000300`; linked schema lint passes with no errors.
- Added strict trusted Gemini response validation, retry behavior, focus/goal checks, persisted plan focus/currency metadata, duplicate-safe substitute expenses, and expanded meal-plan/Gemini regression coverage (direct retry-behavior coverage remains limited). `flutter test --coverage` now passes 43 tests.

### 2026-10-04

- Re-ran Flutter 3.47.5 validation: Drift generation, analyzer, formatting, and `flutter test --coverage` pass; all 43 tests pass.
- Rebuilt Android debug and local release APKs successfully. The current local release APK is 50.8 MB with SHA-256 `F233FADEE9362CF6AEC975C445B27CEC412779B2DD7C8BE60D472C1425083033`.
- Verified with `npx supabase migration list --linked` that all seven local migrations match the linked project.
- Confirmed the current iOS 15 target, camera/photo permissions, and Workmanager launch registration configuration. iOS remains unbuilt and untested on this Windows environment.
- Attempted linked Supabase schema lint; it was blocked by `cli_login_postgres` password authentication and produced no schema-error result.
- Attempted `flutter build ios --no-codesign`; the Windows Flutter toolchain does not expose an iOS build command, so an Xcode/macOS build remains required.

### 2026-10-06

- Re-ran dependency resolution, Drift generation, formatting, analyzer, and `flutter test --coverage`; all 55 tests passed.
- Built local Android release APK/AAB artifacts with version `1.0.0+2`; APK is 67.1 MB with SHA-256 `477C7D2D4D35D9CF2ADD5E429644BFC5305966C55ECBD16A31214B63DC8F8A69`, and AAB is 64.0 MB with SHA-256 `9E49EEF6C56507EBDE8C2C15835CEC1A78412C522213D88C46B1953DFE8D8437`. The APK grew from the 50.8 MB artifact recorded on 2026-10-04; the cause has not been investigated.
- Verified APK package ID/version, AAB structure, and APK signature validation. The local artifacts are debug-signed because production keystore variables are not configured; `build_release.ps1` correctly refuses the production build.
- Added GitHub Actions quality automation for Flutter, Drift, coverage, Android packaging, Deno Edge Function checks, and optional linked Supabase validation.
- Added dish editing, profile-based allergy indicators, shared token matching, saved-plan snapshot protection, safe sign-out sync flushing, notification timezone/permission handling, budget date/link fixes, and UI error states.
- Added local `20261006000300_sync_conflict_hardening.sql`; linked schema lint passed, but migration parity/application requires `SUPABASE_DB_PASSWORD`. The 2026-10-04 lint attempt had been blocked by `cli_login_postgres` password authentication; this run passed, while `migration list` still requires the password.
- Android API 36 release launch completed without a fatal app exception. Real confirmation-email delivery, physical-device validation, iOS validation, background delivery, production signing, cloud pull/hydration, and accessibility checks remain open.
- Added `contents.md` (implementation inventory) and `SPRINT.md`, and aligned all three documents; `contents.md` is the authoritative description of app behavior.

## Update Rules

When continuing work:

1. Move an item from `Remaining Work` to active work before editing.
2. Record new errors under `Known Warnings And Errors` with the command and affected file/package.
3. Check off work only after code and verification are complete.
4. Add a dated entry to `Update Log` after each meaningful milestone.
5. Keep this file factual; distinguish implemented code, local fakes, and deployed services.
6. Keep `SPRINT.md` and `contents.md` consistent with this file. If they differ about app behavior, `contents.md` is authoritative.
