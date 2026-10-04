# NutriWallet Implementation Plan

## Phase 1 Starting Point

The application uses Supabase as its only production authentication and service runtime. Drift remains the signed-in device cache and queue, while all authentication, nutrition, vision, smart-plan, and synchronization requests use authenticated Supabase services.

## Architecture

The application uses a feature-first layout with Riverpod providers at the presentation boundary and Drift as the authenticated device cache. Repositories persist device state and enqueue authenticated Supabase synchronization. GoRouter owns top-level navigation while feature screens remain independent of routing details.

```text
lib/
  main.dart
  app.dart
  core/                 # theme, constants, routing, utilities, network
  data/local/           # Drift database, tables, DAOs, repositories
  data/remote/          # auth, vision, nutrition, sync interfaces/implementations
  features/             # auth, onboarding, profile, dishes, planner, budget, settings
  shared/               # reusable widgets and view models
test/unit/              # pure calculators, repositories, auth, planner
test/widget/            # key screen and empty-state tests
test/integration/       # happy-path flows
```

## Package Versions

These are the intended direct dependencies for the initial implementation. Versions use caret constraints so compatible patch releases may be selected by `pub`.

| Package | Version | Purpose |
| --- | --- | --- |
| `flutter_riverpod` | `^2.6.1` | Reactive application state |
| `drift` | `^2.28.1` | SQLite database and typed queries |
| `sqlite3_flutter_libs` | `^0.5.28` | Native SQLite runtime |
| `go_router` | `^16.2.4` | Declarative navigation |
| `image_picker` | `^1.2.0` | Camera/gallery dish capture |
| `dio` | `^5.8.0+1` | Optional remote HTTP client |
| `connectivity_plus` | `^6.1.5` | Network availability gate |
| `flutter_local_notifications` | `^22.3.0` | Meal reminders |
| `workmanager` | `^0.10.10` | Background plan regeneration |
| `fl_chart` | `^1.1.1` | Budget and nutrition charts |
| `supabase_flutter` | `^2.9.1` | Optional auth, sync, and proxy backend |
| `intl` | `^0.20.2` | Currency/date formatting |
| `path` | `^1.9.1` | Database path handling |
| `timezone` | `^0.11.1` | Timezone-aware reminder scheduling |
| `uuid` | `^4.5.1` | Stable local entity identifiers |

Development dependencies: `flutter_test`, `flutter_lints ^6.0.0`, `drift_dev ^2.28.1`, and `build_runner ^2.7.1`.

## Drift Schema

All tables use integer primary keys locally and foreign keys with cascade behavior where child records cannot exist without their parent. Monetary values are stored as integer cents to avoid floating-point budget errors. Timestamps are UTC `DateTime` values.

| Table | Columns and relations |
| --- | --- |
| `UserProfiles` | `id`, `email`, `displayName`, `weeklyBudgetCents`, `activeDays` (JSON), `mealsPerDay`, optional body metrics, `sex`, `activityLevel`, `goalPreset`, `createdAt`, `updatedAt` |
| `Dishes` | `id`, `userProfileId` FK, `name`, `priceCents`, optional `cuisineTag`/`photoPath`, `source`, `createdAt`, `updatedAt`, `isDeleted` |
| `Ingredients` | `id`, `dishId` FK, `name`, `quantity`, `unit`, calorie/macro values, optional micronutrient JSON and USDA ID, `isCachedFromApi` |
| `NutritionCaches` | normalized ingredient name primary key, calorie/macro values, optional USDA ID, `cachedAt`; permanent cross-dish lookup cache |
| `AllergenTags` | `id`, `userProfileId` FK, `label` |
| `DishAllergenTags` | composite association between `Dishes` and `AllergenTags` |
| `GeneratedPlans` | `id`, `userProfileId` FK, `weekStartDate`, `generatedAt`, projected cost, over-budget flag, version |
| `MealSlots` | `id`, `generatedPlanId` FK, `dishId` FK, `dayIndex`, `slotIndex`, planned cost/calories |
| `SyncQueue` | `id`, entity table/key, operation, JSON payload, queued timestamp, dirty flag, optional synced timestamp |

Dish queries will expose reactive/allergen-safe, price-range, and nutrient-range methods. Indexes are planned for profile ownership, dish price, dish deletion state, and ingredient dish/nutrient lookup.

## Build Order

1. **Phase 1, Foundation:** scaffold Flutter, theme, routing, Supabase auth/session, Drift schema/DAOs, profile setup, manual dish CRUD, and Phase 1 tests.
2. **Phase 2, Core Intelligence:** fake/real-service interfaces, image/OCR entry points, cached nutrition lookup, planning algorithm, nutrition calculators, budget calculations, and tests.
3. **Phase 3, Integration:** dashboard, weekly plan persistence/history, budget charts, regeneration, and end-to-end flows.
4. **Phase 4, Offline Operations:** notifications, background scheduling, dirty-queue sync, last-write-wins conflict handling, and settings hub.
5. **Phase 5, Verification:** accessibility/design sweep, performance checks, offline walkthrough, full test suite, defect log, and production configuration documentation.

## Decisions

- Supabase configuration is required for every production build and is supplied through `--dart-define` only.
- `DishAllergenTags` is a join table so a user's exclusion labels and dish metadata remain distinct.
- Budget values are integer cents throughout persistence and planning; no running total uses unrounded floating-point currency.
- Supabase credentials will be supplied through `--dart-define` only and never committed.
- Production providers call Supabase Edge Functions and do not expose third-party keys to the client.
- Notification and background scheduling use the current local plugins, with the weekly worker callback isolated so plan regeneration can be expanded without changing the UI.
