# NutriWallet

NutriWallet is a connected Flutter app for planning meals around a real food budget. It includes Supabase email authentication, profile setup, a dish library, cloud nutrition and vision services, allergy-aware meal planning, budget tracking, reminders, and authenticated synchronization. A local database is retained as the device cache for the signed-in account.

## Run The App

Requirements:

- Flutter 3.47 or newer on the stable channel
- Dart 3.13 or newer
- Android API 26+ or iOS 13+

```text
flutter pub get
dart run build_runner build
flutter analyze
flutter test
flutter run --dart-define=SUPABASE_URL=https://project.supabase.co --dart-define=SUPABASE_ANON_KEY=...
```

Every app build requires the Supabase project URL and publishable key through Dart defines:

```text
flutter run --dart-define=SUPABASE_URL=https://project.supabase.co --dart-define=SUPABASE_ANON_KEY=...
flutter build apk --release --dart-define=SUPABASE_URL=https://project.supabase.co --dart-define=SUPABASE_ANON_KEY=...
```

The app fails at startup when either define is missing. Authentication, nutrition lookup, vision recognition, smart-plan recommendations, and synchronization use the deployed Supabase services.

## Architecture

- `lib/core`: design tokens, theme, providers, and routing.
- `lib/data/local`: Drift tables and DAOs. Writes happen here first.
- `lib/data/repositories`: authenticated profile, dish, budget, and generated-plan use cases.
- `lib/data/remote`: Supabase proxy services and authenticated synchronization.
- `lib/features`: onboarding, auth, profile setup, dish library, home shell, budget, planner, and settings screens.
- `test/unit` and `test/widget`: Phase 1 behavior and regression coverage.

`PLAN.md` contains the complete schema, package plan, architecture decisions, and later build phases.

## Remote Services

Supabase Auth, Gemini vision, USDA FoodData Central, notifications, background scheduling, and synchronization are separated behind service interfaces.

For connected builds, provide the Supabase project URL and publishable key through Dart defines or an untracked environment wrapper, for example:

```text
flutter run --dart-define=SUPABASE_URL=https://project.supabase.co --dart-define=SUPABASE_ANON_KEY=...
```

Registration and sign-in use Supabase Auth. Sign-up sends an email confirmation link; confirm the address, return to the app, and sign in to continue to profile setup. A resend action is available if needed.

Vision and USDA provider keys must remain server-side in Supabase Edge Functions. The Flutter client should call only the proxy interfaces and must never contain third-party provider secrets.

## Current Limitations

- Photo and menu recognition use the authenticated Gemini proxy; failed requests show a retry state rather than switching providers.
- Budget entries and the planned-vs-actual chart are implemented; analytics now scopes entries to the active week.
- Native notifications and weekly Workmanager regeneration are implemented. USDA, Gemini vision, and sync proxy Edge Functions are deployed; authenticated end-to-end app testing remains pending. Pending device writes remain queued until the authenticated sync endpoint accepts them.
