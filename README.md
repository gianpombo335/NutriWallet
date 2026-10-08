# NutriWallet

NutriWallet is a connected Flutter app for planning meals around nutrition goals and a real food budget. It combines a personal dish library, nutrition enrichment, allergy-aware planning, budget tracking, meal check-ins, reminders, and Supabase-backed synchronization.

The app uses Drift/SQLite as a local-first cache and durable outbound sync queue for the signed-in account. It is not a standalone offline app: Supabase configuration is required at startup, and nutrition lookup, image recognition, smart-plan recommendations, authentication, and synchronization use connected services.

## Features

- Email/password authentication with confirmation and resend flows.
- Onboarding and editable nutrition, activity, budget, and planning profiles.
- Manual dish creation and editing with ingredient nutrition enrichment.
- Camera, gallery, menu, and receipt recognition through an authenticated Gemini proxy.
- Profile-level allergy and ingredient exclusions with hard planner filtering.
- AI-assisted weekly meal planning with deterministic local validation and fallback planning.
- Versioned plan history, active-plan selection, serving adjustment, and live meal check-ins.
- Configurable daily meal times with current/next meal reminders.
- The next planned meal is prioritized; overdue unconfirmed meals are auto-skipped one hour before the next meal.
- Optional multiple dishes per meal with aggregated nutrition and cost.
- Planned-versus-actual budget tracking with USD, PHP, EUR, GBP, and JPY display formats, plus linked meal outcomes.
- Local reminder scheduling and weekly background plan regeneration.
- Durable outbound sync with connectivity retry and timestamp-based conflict handling.

## Platform Status

| Platform | Configuration | Validation status |
| --- | --- | --- |
| Android API 24+ | Configured | Android API 36 emulator build and connected smoke flow validated; physical-device and broad-version coverage remain open. |
| iOS 15+ | Configured with camera, photo-library, notification, and background-task metadata | Compatibility is technically supported by the project configuration, but iOS has not been built or runtime-tested. macOS and Xcode are required for validation. |

Android is currently the only platform tested. Do not treat the iOS configuration as tested support until an iOS build and device or simulator smoke test have passed.

## Setup

Requirements:

- Flutter 3.47.5 or newer on the stable channel.
- Dart 3.13 or newer.
- Android API 24+ or iOS 15+.
- A configured Supabase project with the required Edge Functions and provider secrets.

Install dependencies and generate Drift sources:

```text
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

Every app build requires the Supabase project URL and publishable key through Dart defines:

```text
flutter run --dart-define=SUPABASE_URL=https://project.supabase.co --dart-define=SUPABASE_ANON_KEY=...
flutter build apk --release --dart-define=SUPABASE_URL=https://project.supabase.co --dart-define=SUPABASE_ANON_KEY=...
```

The app displays a configuration error instead of starting when either define is missing. Third-party provider keys must remain server-side in Supabase Edge Functions.

For a production Android release on Windows, set `SUPABASE_URL`, `SUPABASE_ANON_KEY`, and these signing variables:

- `NUTRIWALLET_KEYSTORE_PATH`
- `NUTRIWALLET_KEYSTORE_PASSWORD`
- `NUTRIWALLET_KEY_ALIAS`
- `NUTRIWALLET_KEY_PASSWORD`

Then run `./build_release.ps1`. The script refuses missing production signing configuration and validates the generated APK signature or App Bundle structure.

## Architecture

- `lib/core`: design tokens, theme, providers, routing, and shared utilities.
- `lib/data/local`: Drift tables, migrations, DAOs, and the local cache.
- `lib/data/repositories`: profile, dish, plan, budget, and sync use cases.
- `lib/data/remote`: authenticated Supabase proxy services and sync.
- `lib/features`: onboarding, authentication, profiles, dishes, planning, budget, notifications, and settings.
- `test/unit`, `test/widget`, and `test/integration`: automated behavior and regression coverage.
- `supabase/functions`: authenticated nutrition, vision, smart-plan, and sync Edge Functions.
- `supabase/migrations`: Postgres schema, RLS policies, and conflict-handling RPCs.

## Backend Services

Supabase provides email authentication, authenticated Edge Function access, Postgres persistence, row-level security, and synchronization. USDA FoodData Central supplies nutrition lookup through a server-side proxy. Gemini supplies image recognition and smart-plan recommendations through server-side proxies. Provider secrets are never embedded in the Flutter client.

## Validation

The latest recorded validation includes:

```text
flutter analyze
dart run build_runner build
dart format --output=none --set-exit-if-changed lib test
  flutter test --coverage                  # 60 local tests
flutter build apk --debug
flutter build apk --release
flutter build appbundle --release
npx supabase db lint --linked
npx supabase functions list               # four expected functions ACTIVE
```

Connected Android API 36 emulator smoke coverage includes sign-in, profile setup, manual dish creation, USDA nutrition enrichment, photo recognition, Gemini planning, plan history/detail, serving adjustment, budget expenses, meal check-in controls, notification permission and scheduling, sync, and sign-out/re-login. No fatal application exception was observed in the recorded launch log scan.

Release artifacts recorded in the latest validation were debug-signed because no production keystore was configured. The production release script correctly rejects debug signing.

## Current Limitations

- iOS has not been built or runtime-tested; macOS and Xcode validation are still required.
- Android physical-device testing and broader Android-version coverage remain open.
- Real confirmation-email delivery still needs a mailbox smoke test.
- Notification delivery and weekly background execution have not been verified; Settings now schedules future active-plan meal reminders.
- Sync currently pushes local changes outbound; remote-to-local pull and merge for new devices are not implemented.
- Dish photos are stored as local file paths and are not uploaded to Supabase Storage.
- Recognition requires a network connection and has no native ML Kit fallback.
- The newest meal-schedule and budget-link migrations were applied remotely; migration-list inspection requires the linked database password.
- Production signing, privacy text, accessibility, and large-library performance still need review.

## Documentation

- [`contents.md`](contents.md): authoritative implementation inventory.
- [`PROGRESS.md`](PROGRESS.md): verification log, known warnings, and remaining work.
- [`SPRINT.md`](SPRINT.md): ordered sprint and feature summary.
- [`PLAN.md`](PLAN.md): original implementation plan when present in the working tree or repository history.
