# Learnings

## Task 1 — Dashboard Contract & Layout Foundation

### Completed
- Refactored `DashboardScreen` from a content-heavy widget (avatar, ring tiles, AI card, quick log, BMI card, RingPainter) to a clean layout skeleton
- Preserved constructor: `DashboardScreen({Key? key, required this.isDarkMode})`
- Preserved parent wiring in `home_screen.dart`: `DashboardScreen(isDarkMode: isDark)`

### Structure
- `Scaffold` with `backgroundColor: AppColors.darkBgApp` (Color(0xFF020617))
- `SafeArea` > `SingleChildScrollView` > `Column` with `CrossAxisAlignment.start`
- 4 commented placeholder sections: Header Area, Hero Card Area, Metric Grid Area, CTA Area
- Standard horizontal padding: `EdgeInsets.symmetric(horizontal: 20)`
- Standard section spacing: `SizedBox(height: 24)`
- Bottom padding: `SizedBox(height: 32)`

### Removed
- `AvatarWidget` import and usage
- `ProgressRing` / `RingPainter` import and usage
- All private methods: `_ringTile`, `_aiCard`, `_quickLogRow`, `_quickLogTile`, `_bmiCard`
- `RingPainter` class (still exists in `progress_ring.dart` for other screens)

### Gotchas
- The `write` tool did not properly overwrite the file (leftover content persisted). Had to use `cat >` via bash to get a clean write.
- The `edit` tool with `oldString` matching can match the wrong occurrence if the file has duplicate content. Always verify the final file after edits.
- Pre-existing warning in `home_screen.dart`: unused `fg3` variable (line 35) — not introduced by this task.

## Task 2 — Static Data Restoration

### Completed
- Added `import 'package:fitnesspal/presentation/widgets/progress_ring.dart'`
- Added file-private color constants: `_emeraldGradientStart`, `_emeraldGradientEnd`, `_glowColor`, `_scoreRingTrackColor`
- Added `_MetricCardData` class with `label`, `value`, `unit`, `progress`, `trend` fields
- Added `_DashboardData` class with all static mock values (greeting, date, wellnessScore, aiInsight, etc.)
- Added `_WellnessScoreRing` StatelessWidget wrapping `ProgressRing` (size 140, strokeWidth 10, glow, bold 42pt score "84")
- All classes/file-private constants prefixed with `_` to avoid namespace pollution

### Notes
- `ProgressRing.centerWidget` replaces the default value+unit display with custom centered text
- Warnings for `unused_element`/`unused_field` on static data are expected — consumption happens in Wave 2
- `_WellnessScoreRing` takes `bool isDarkMode` for future conditional theming (dark/light toggle)
- `_DashboardData` uses `static const` for all fields — no runtime computation needed

## Task 5 — Header, Notification, and AI Assistant Button

### Completed
- Replaced Header Area placeholder with

## Task 9 — Integration Polish & Theme Consistency

### Completed
- Added `final isDark = isDarkMode;` variable in `DashboardScreen.build()`
- Fixed Scaffold `backgroundColor` to use `isDark ? AppColors.darkBgApp : AppColors.lightBgApp`
- Fixed notification bell icon: `color` now uses `isDark` conditional
- Fixed `_HeroWellnessCard` instantiation: removed `const`, passes `isDark` instead of hardcoded `true`
- Fixed `_WellnessScoreRing` instantiation inside hero card: removed `const`, passes `isDark`
- Fixed `_WellnessScoreRing` widget: uses `isDarkMode` for score text color and `trackColor`
- Fixed `_HeroWellnessCard` background/border/divider colors: all use `isDark` conditionals
- Fixed CTA section AI insight text color and suggestion text color: use `isDark` conditionals
- Added `isDarkMode` parameter to `_MetricCard` and fixed all its colors (bg, border, label, value, trend, track)
- Passed `isDarkMode` to all 4 `_MetricCard` instances
- Added subtle `boxShadow` to hero card (`darkShadowMd`/`lightShadowMd`, blur 24, offset 0,6)
- Added subtle `boxShadow` to metric cards (`darkShadowSm`/`lightShadowSm`, blur 12, offset 0,3)

### Changes made to dashboard_screen.dart
| Location | Change |
|----------|--------|
| Line 82 | Added `final isDark = isDarkMode;` |
| Line 84 | `AppColors.darkBgApp` → `isDark ? ... : ...` |
| Line 114 | `AppColors.darkFg1` → `isDark ? ... : ...` |
| Line 193 | `const _HeroWellnessCard(isDarkMode: true)` → `_HeroWellnessCard(isDarkMode: isDark)` |
| Line 194 | Removed `const` |
| Lines 470-474 | `AppColors.darkBgCard`/`darkBorder` → conditional |
| Lines 475-481 | Added `boxShadow` with `darkShadowMd`/`lightShadowMd` |
| Line 515 | `const _WellnessScoreRing(isDarkMode: true)` → `_WellnessScoreRing(isDarkMode: isDark)` |
| Line 570 | `AppColors.darkBorder` → `isDark ? ... : ...` |
| Lines 700-703 | `_scoreRingTrackColor` → `isDarkMode ? _scoreRingTrackColor : AppColors.lightBorder` |
| Line 713 | `Colors.white` → `isDarkMode ? Colors.white : AppColors.darkFg1` |
| Lines 722-725 | Added `isDarkMode` param to `_MetricCard` |
| Lines 730-734 | All colors conditional on `isDarkMode`, added `boxShadow` |

### Spacing audit
- Line 96: `SizedBox(height: 8)` — top header gap ✓
- Line 189: `SizedBox(height: 24)` — after header, before hero ✓
- Line 197: `SizedBox(height: 24)` — after hero, before metric grid ✓
- Line 246: `SizedBox(height: 24)` — after metric grid, before CTA ✓
- Line 360: `SizedBox(height: 32)` — bottom scroll clearance ✓

### AI insight text verification
- Line 290 (CTA section): `_DashboardData.aiInsight` ✓
- Line 613 (hero card): `_DashboardData.aiInsight` ✓

### WellnessScoreRing verification
- Size: 140px — prominent on mobile without crowding
- Score: "84" at fontSize 42, fontWeight 900 — highly visible
- Theme-aware track color and text color

### Gotchas
- `_MetricCard` and `_WellnessScoreRing` originally didn't use their `isDarkMode` parameter at all — the constructor accepted it but `build()` ignored it
- The `_scoreRingTrackColor` (semi-transparent white) was invisible on light backgrounds; fixed with `isDarkMode ? _scoreRingTrackColor : AppColors.lightBorder`
- Removing `const` from widget instantiation is required when passing a runtime variable (non-const value)
- `ProgressRing.trackColor` has a theme-aware default fallback (`isDark ? AppColors.darkBorder : AppColors.lightBorder`) but it's bypassed when `trackColor` is explicitly passed as non-null

## Task 10 — Widget Tests

### Completed
- Created `test/dashboard_screen_test.dart` with two test groups:
  1. `DashboardScreen` — asserts greeting ("Hi Maya"), wellness score ("84"), CTA ("Today's Plan"), AI insight, and metric card labels ("Calories", "Sleep", "Steps", "Water")
  2. `HomeScreen` bottom nav — asserts all 5 tab labels ("Home", "Activity", "Meals", "Habits", "Profile")
- Fixed `test/widget_test.dart` — replaced broken `MyApp` test with `FitnessPalApp` smoke test

### Gotchas
- `HomeScreen` constructor requires non-null `onThemeToggle` and `onDensityToggle` callbacks — pass `() {}` in tests, not `null`
- "Sleep" text appears twice in `DashboardScreen`: once in body metrics (`_bodyMetric` inside `_HeroWellnessCard`) and once as a metric card label — use `findsWidgets` instead of `findsOneWidget`
- AI insight text "Your recovery is improving after better sleep consistency." appears twice in the widget tree (likely due to MaterialApp rendering) — use `findsWidgets` for `textContaining` assertions
- `DashboardScreen` and `HomeScreen` must be wrapped in `MaterialApp` for `Theme.of(context)` to work in tests
- All 3 tests pass with `flutter test` — no network or external dependencies

## Task 11 — Analyzer/Test Cleanup & Evidence Prep

### Completed
- Ran `flutter analyze` — fixed the `unused_field` warning for `_DashboardData.bodyMetrics` by removing the unused field
- Fixed `_WellnessScoreRing` to use `_DashboardData.wellnessScore` instead of hardcoded `84`
- `flutter analyze` now has 0 errors, 0 new warnings in dashboard code (pre-existing warnings in `activity_screen.dart` and `main.dart` remain)
- `flutter test` passes 3/3 ✅
- Created `.sisyphus/evidence/` directory with 12 QA evidence files covering all tasks
- LSP diagnostics clean on all source and test files

### Evidence Files Created
- `task-1-home-dashboard-renders.txt` — constructor verification
- `task-1-route-scope.txt` — no detached demo route
- `task-2-static-values.txt` — all static values and their widget tree usage
- `task-2-no-live-data.txt` — no live data wiring
- `task-3-progress-implementation.txt` — ProgressRing reuse
- `task-4-bottom-nav.txt` — 5 tabs with Home active
- `task-5-header-taps.txt` — inert tap handlers
- `task-8-cta-tap.txt` — safe CTA tap
- `task-10-flutter-test.txt` — test output
- `task-10-test-coverage.txt` — test assertions list
- `task-11-analyze-test.txt` — final analyze + test output
- `task-11-scope-check.txt` — no scope creep verification

### Gotchas
- `_DashboardData.bodyMetrics` was defined as `static const` but never used in the widget tree — the body metrics in `_HeroWellnessCard` are hardcoded inline. Removed unused field to fix warning.
- `_WellnessScoreRing` hardcoded `84` instead of referencing `_DashboardData.wellnessScore` — fixed to use the static field.
- The `unused_field` warning is treatable as a warning by `flutter analyze`, not an error. Still worth fixing to keep the dashboard code clean.
- Evidence files should be plain text, not markdown, and should contain concrete verification assertions, not vague statements.
