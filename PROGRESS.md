# NutriWallet Progress

Last updated: 2026-10-01

## Overall Status

The app is a connected Android app backed by Supabase. Drift remains the authenticated device cache and sync queue; Supabase provides email/password Auth, nutrition, vision, smart-plan, and sync services. Connected sign-up requires email confirmation, and the app provides a confirmation/resend step before sign-in and profile setup. Connected device end-to-end coverage and final platform polish remain.

## Resume Here

Current baseline: analyzer, code generation, formatting, coverage tests, and connected Android debug build pass. The current test suite has 43 passing tests. The API 36 Android emulator is available; authenticated app flows, including opening a real confirmation email, remain unverified on-device.

Latest completed work: polished auth form and validation, Supabase email-confirmation/resend flow, profile-cache invalidation on auth changes, persisted onboarding completion, and widget coverage for cloud confirmation, sign-in routing, and onboarding.

Recommended next task: smoke-test connected sign-up -> email confirmation -> sign-in -> profile setup on the Android emulator using a test mailbox, then verify authenticated Gemini planning, photo recognition, and sync.

After device testing: add full authenticated end-to-end coverage, then perform iOS, accessibility, performance, signing, and release checks.

Latest release APK: `build/app/outputs/flutter-apk/app-release.apk`

Latest local release APK SHA-256: `E86FFDF5BC8927A54F13C1436DEF5F58A554003E8ED1FCD3CFBC5EE493B214B8`

Previously verified connected APK SHA-256: `9C60124135249B00BF91F8C7D8ED9D837AFC7C6E36F120D635673B99A0F79EAA`

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
- [x] Automatic sync retry on connectivity restoration
- [x] Supabase sync-record migration and authenticated sync proxy
- [x] Migrated Edge Function auth to Supabase publishable/secret keys and redeployed all four functions
- [x] USDA nutrition and Gemini vision proxy Edge Functions
- [x] Local meal reminder scheduling
- [x] Weekly Workmanager plan regeneration callback
- [x] Background regeneration uses stored profile nutrition metrics
- [x] Weekly budget analytics filtering
- [x] Android notification permission and core-library desugaring configuration
- [x] `PLAN.md` and `README.md`

## Verification

Last verified successfully:

```text
flutter analyze
dart run build_runner build
dart format --output=none --set-exit-if-changed lib test
flutter test                 # 43 tests passed
flutter test --coverage      # 43 tests passed
flutter build apk --debug    # passed
flutter build apk --release --build-name=1.0.0 --build-number=1  # passed
flutter build apk --release --build-name=1.0.0 --build-number=1 --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...  # passed
```

APK output:

```text
build/app/outputs/flutter-apk/app-debug.apk
build/app/outputs/flutter-apk/app-release.apk
```

Latest local release APK:

- Size: 126.4 MB
- SHA-256: `37DE22DBE83F311058BB58C49AF069D25C44FA518F9A296AF127DF8B0DEA5FAF`

## Known Warnings And Errors

- Workmanager currently emits a non-fatal warning because `workmanager_android` still applies the legacy Kotlin Gradle Plugin. The APK build succeeds. Upgrade the plugin or migrate the Android project when a compatible release is available.
- Release shrinking is disabled for the demo artifact because R8 reports optional ML Kit language bindings that are not bundled with the Latin recognizer. Production builds should add the appropriate ML Kit language dependencies or targeted keep rules before re-enabling shrinking.
- Supabase Auth is implemented and project credentials are configured, but authenticated Flutter sign-in and proxy calls have not been exercised on a device.
- Supabase email confirmation is now required for connected sign-up. The app handles confirmation-required responses and resend requests; completing the email link and authenticated flow still needs a real-device/mailbox smoke test.
- USDA, Gemini vision, smart-plan, and sync Edge Functions are deployed and provider smoke tests pass. Authenticated end-to-end app flows remain untested.
- The default sync endpoint is in-memory when running without Supabase defines; configured builds use the deployed Supabase sync endpoint.
- Supabase mirror tables, RLS policies, and atomic server-side conflict handling are deployed; accepted dish and budget syncs now hydrate typed tables, while the remaining entity types stay in `sync_records`.
- Existing local databases migrate to active-plan tracking without losing plan history.
- Budget actuals are independent from plan cost, can optionally link to the active plan, and can be removed to correct mistakes.
- Supabase Dart defines are mandatory; missing configuration now stops startup with a configuration error.
- Profile setup now awaits persistence, prevents duplicate saves, validates the budget, and reports expired sessions or database errors visibly.
- Profile edits now update only the selected profile instead of issuing an unscoped table update.
- Supabase signup errors now expose actionable messages instead of the generic failure text; the connected Auth endpoint was validated with the configured public key.
- Auth rate-limit responses now disable the submit action for 60 seconds to prevent repeated retries from extending the lockout.
- iOS has not been built or tested in this Windows environment.
- Connected photo and menu recognition requires an authenticated network connection; failed requests expose retry states.
- Android API 36 emulator is available and a connected debug APK previously initialized Supabase, but authenticated device workflows remain untested.
- Deno is not installed in this environment, so Supabase Edge Function TypeScript could not be locally type-checked during this pass; deployed function smoke-test results remain historical.
- The legacy JWT-based API keys were disabled on 2026-09-30. The connected client uses a publishable key, and all four Edge Functions use the modern publishable/secret key environment.

## Remaining Work

### High Priority

- [x] Add automatic sync on connectivity restoration
- [x] Deploy and smoke-test Supabase Edge Functions for vision, USDA lookup, and sync
- [x] Complete the Supabase/Postgres app schema and server-side `updated_at` conflict handling
- [x] Implement typed hydration envelopes for profile, ingredient, allergen, plan, and meal-slot sync records
- [x] Apply and remotely verify the complete typed-sync migration
- [ ] Smoke-test confirmation-enabled Supabase sign-up -> email confirmation -> sign-in -> profile setup on Android
- [ ] Validate authenticated Gemini smart-plan requests on a physical device
- [x] Make background regeneration use stored profile metrics and exclusions exactly like foreground generation
- [x] Add integration tests for register -> sign in -> add dish -> generate -> sign out -> sign in
- [x] Add integration tests for offline dish creation -> reconnect -> sync

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
- [ ] Remove or resolve the Workmanager Kotlin warning
- [ ] Review release signing, privacy text, and production environment setup

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
- `lib/core/currency/app_currency.dart`: persisted currency options and formatting
- `lib/features/notifications/background_plan_scheduler.dart`: weekly worker

## Update Log

### 2026-09-12

- Built a debug-signed release demo APK with NutriWallet branding and verified the final artifact.
- Disabled release shrinking for the demo because R8 could not resolve optional ML Kit language bindings.
- Added concrete ML Kit image-labeling and OCR services with fixture fallbacks.
- Added optional Supabase Auth with local fallback.
- Added generated-plan calorie, protein, carbohydrate, and fat totals with target comparison in the Weekly Plan screen.
- Added actual budget entries, planned-vs-actual charting, local reminders, and weekly background regeneration.
- Added durable sync queue and last-write-wins service seam.
- Added automatic reconnect sync, weekly budget filtering, Supabase migrations, and authenticated USDA/Gemini/sync Edge Functions.
- Re-ran analyzer, tests, and Android debug build successfully.
- Added profile-aware background targets and deployed authenticated USDA, Gemini, and sync Edge Functions.
- Applied the `sync_records` Supabase migration and verified provider responses through the deployed proxies.
- Added full profile editing and generated-plan history/detail screens with repository coverage.
- Added persisted notification preferences, cancellation controls, OCR fallback/retry messaging, and local happy-path integration coverage.
- Added testable connectivity restoration sync and Android notification permission requests; 29 tests and Android builds pass.
- Added the Supabase mirror schema, ownership policies, updated-at triggers, and atomic sync conflict RPC; deployed sync-push version 5.
- Added typed Supabase hydration for dish and budget sync records; deployed sync-push version 6 and rebuilt the Android artifacts.
- Added explicit local/cloud mode labels, bounded photo uploads, nutrition failure recovery, and a connected release APK using the configured Supabase project.
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
- The app flow is covered with test doubles; real Supabase email delivery/confirmation and authenticated sign-in have not yet been exercised on a device.
- Fixed all planning focuses to use Gemini with focus-specific instructions, strict slot/ID/exclusion validation, and deployed `plan-generate` updates.
- Added onboarding currency selection, direct captured-dish navigation to the dishes menu, budget limit editing, dated/editable expenses, active-plan meal check-ins, substitute meal cost tracking, and persisted meal consumption state.
- Applied the remote `20261001000100_meal_consumption_tracking.sql` migration and redeployed `sync-push`; connected debug APK build passes after the changes.
- Added plan/budget integrity migration `20261001000200` plus RPC cleanup `20261001000300`; linked schema lint passes with no errors.
- Added strict trusted Gemini response validation, retry behavior, focus/goal checks, persisted plan focus/currency metadata, duplicate-safe substitute expenses, and expanded meal-plan/Gemini regression coverage. `flutter test --coverage` now passes 43 tests.

## Update Rules

When continuing work:

1. Move an item from `Remaining Work` to active work before editing.
2. Record new errors under `Known Warnings And Errors` with the command and affected file/package.
3. Check off work only after code and verification are complete.
4. Add a dated entry to `Update Log` after each meaningful milestone.
5. Keep this file factual; distinguish implemented code, local fakes, and deployed services.
