# Draft: Meals AI Entry and UI Improvements

## Requirements (confirmed)
- User wants the bottom tab bar area expanded to cover the remaining visible height / avoid the floating gap shown in the screenshot.
- User wants the Add Meal modal/dialog to be opaque; current presentation appears too transparent over the Meals screen.
- User wants an AI assistant for adding meals with predefined dropdowns.
- User wants calories fixed/calculated automatically rather than manually inconsistent.
- User wants a database of famous Indian foods with all nutrition parameters and typeahead lookup while typing.
- User wants touch controls on all numeric boxes to increase/decrease values.
- User wants an option to add meal media (video/image) instead of typing, where AI extracts relevant nutrition information.
- AI image/video extraction should target Android/iOS only for the first planned version.

## Technical Decisions
- Planning only: no implementation will be performed in this session. A work plan will be generated after requirements are clear.
- Existing stack is Flutter/Dart with Firestore dependencies already present.
- Existing project convention from AGENTS.md: no new state management libraries unless discussed; use `setState`, centralized `AppColors`, package-relative imports, and Flutter tests/analyze commands.
- Media/AI platform scope: Android/iOS only, so native media picker and mobile-only OCR options are acceptable.

## Research Findings
- `lib/presentation/screens/home_screen.dart`: bottom navigation is a `Container` with row-based custom tabs and FAB on Meals tab.
- `lib/presentation/screens/home_screen.dart`: Add Meal uses `showModalBottomSheet`, `backgroundColor: bgCard`, and local `TextEditingController`s.
- `lib/presentation/screens/meals_screen.dart`: Meals screen streams meals and today's metrics from `FirestoreService`, calculates macro totals from actual meals, and renders empty/list states.
- `pubspec.yaml`: Dependencies include Flutter, Firebase Core, Cloud Firestore, charts, intl, and smooth page indicator. No visible image/video picker or AI SDK dependency yet.
- Background research launched:
  - Explore current meal/model/Firestore/UI patterns.
  - Explore test infrastructure and Firebase mocking coverage.
  - Librarian research for Flutter media picker, autocomplete/dropdown, seeded local database, and AI extraction architecture.
- Test infrastructure result: Flutter widget testing is already configured with `flutter_test`, `flutter_lints`, Firebase mock setup in `test/test_helper.dart`, smoke/dashboard tests, and `FirestoreService.setTestInstance` pattern. No CI was found. Recommendation: feature work is TDD-ready using `flutter test` and `flutter analyze` locally.
- Meal feature pattern result:
  - `lib/core/models/meal.dart` has `Meal` with `id`, `name`, `calories`, `description`, `proteinGrams`, `carbsGrams`, `fatGrams`, `createdAt`, plus `fromJson`, `toFirestore`, and `copyWith` conventions.
  - `lib/core/services/firestore_service.dart` streams meals, adds meals, deletes meals under `users/{userId}/meals`, currently using a hardcoded demo user.
  - `lib/presentation/screens/home_screen.dart` owns the Add Meal bottom sheet and custom bottom nav/FAB.
  - `lib/presentation/screens/meals_screen.dart` renders nutrition header, macro totals, AI insight, hero card, and meal list.
  - Important discovered issue: meal model stores `createdAt`, while Firestore meal query reportedly orders by `timestamp`; plan must inspect/fix or preserve data compatibility deliberately.
  - Natural integration points: extend `Meal`, add food catalog/search service methods, extract Add Meal sheet into focused widgets if it grows, follow `AppColors`/`setState` conventions.
- AI/media research result:
  - Recommended v1: photo-first hybrid — `image_picker` for photo/video selection, on-device OCR where viable, backend AI or mocked service for normalization/fallback.
  - For searchable dropdowns, use Flutter built-in `Autocomplete`/`RawAutocomplete` or add `dropdown_search` if async popup features are needed.
  - For local food DB, recommended production path is prepopulated Drift/SQLite with aliases/synonyms, serving units, and indexed/FTS search; simpler v1 could use seeded Dart data or Firestore catalog.
  - Privacy/permissions: avoid deprecated Android storage permission assumptions; media picker files may be temporary; ML Kit text recognition is mobile-only, not web/desktop.

## Open Questions
- Should AI extraction be real API-backed now, mocked with clean extension points, or hybrid?
- Should the Indian food database be local seeded data inside the app, Firestore-seeded shared data, SQLite/Drift, or a staged approach?
- What exact visual behavior is expected for “expand the tab bar below to cover remaining height” — taller bottom nav, sheet covering to bottom, or eliminating the translucent overlay gap?
- Should media upload support both image and video in the first version, or image first with video placeholder?

## Scope Boundaries
- INCLUDE: Meals UI, Add Meal bottom sheet/modal, nutrition inputs, food suggestions, calorie auto-calculation, media-based AI entry path.
- EXCLUDE: Full production AI backend, authentication/user-specific multi-device sync changes, broad app-wide navigation redesign unless explicitly approved.

## Test Strategy Decision
- **Infrastructure exists**: YES — `flutter_test`, Firebase mocking helper, representative widget tests.
- **Automated tests**: Pending user decision. TDD is recommended because the infrastructure exists.
- **Agent-Executed QA**: ALWAYS required in the final work plan.

## Visual Companion
- User accepted visual companion for UI-heavy planning. Use browser visuals only for questions where seeing layout/mockups is better than text.
