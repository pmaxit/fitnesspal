# Dashboard Redesign — Design Spec

**Date:** 2026-05-15
**Status:** Approved (pending writing-plans handoff)
**Scope:** Single-screen visual + data redesign of `lib/presentation/screens/dashboard_screen.dart`
**Reference:** Target mockup provided by user (5-tab dark dashboard, Maya, Apr 14 2026)

---

## 1. Goal

Rebuild the home (Dashboard) screen so its visual and information hierarchy match the supplied mockup, while wiring every metric in the mockup to real Firestore-backed data instead of inline constants.

The mockup shows:

1. A personal greeting block with a date/status subtitle and two icon actions.
2. A "Your Trajectory" card with a centered body silhouette, four body stats positioned around it, a Today / +4 wk / +12 wk period selector, and a motivational footer.
3. A "Today's Rings" 2×2 grid for Calories, Water, Habits, Energy.
4. The existing 5-tab bottom navigation (kept unchanged).

Removed from the existing dashboard: the wellness-score ring hero, the standalone AI insight banner, the "Today's Plan" gradient CTA, and the "AI Coach" header chip.

## 2. Non-Goals

- Routing, navigation, or new screens.
- Authentication or multi-user support.
- Functional projection math for +4 wk / +12 wk (visual selector only this pass).
- Changes to Activity / Meals / Habits / Profile screens.
- Bottom-nav icon redesign.
- New external dependencies or state management libraries (`setState` stays).
- Onboarding flow for new body-composition fields (defaults will live in seed data; production-grade entry UI is future work).

## 3. Architecture Overview

```
DashboardScreen (StatefulWidget)
├── streams: profile, todayMetric, habits          ← FirestoreService
├── _DashboardHeader                                (greeting + actions)
├── _TrajectoryCard                                 (replaces _HeroWellnessCard)
│   ├── _BodySilhouette         (existing painter, scaled up + glow dots overlay)
│   ├── _BodyStatLabels         (4 stats in Stack/Positioned)
│   └── _PeriodPillSelector     (Today / +4 wk / +12 wk)
└── _TodayRingsSection
    └── _RingCard × 4           (Calories, Water, Habits, Energy)
```

All components are file-private classes inside `dashboard_screen.dart`. No new widget files are created — the existing `ProgressRing` is reused.

Stream wiring follows the pattern already in `_DashboardScreenState`: one `StreamSubscription` per data source, cancelled in `dispose()`.

## 4. Data Model Changes

### 4.1 `UserProfile` (`lib/core/models/user_profile.dart`)

Add three slow-changing body-composition fields. These belong on the user, not the daily metric, because they change on the order of weeks.

```dart
final double weightLb;   // 178
final double bodyFatPct; // 22
final double muscleLb;   // 138
```

All three are non-nullable with sensible defaults in the constructor (`weightLb = 0`, `bodyFatPct = 0`, `muscleLb = 0`) so existing seeded profiles without these fields keep deserializing. `fromJson`, `fromFirestore`, `toFirestore`, and `copyWith` are all updated.

### 4.2 `DailyMetric` (`lib/core/models/daily_metric.dart`)

Add four daily-varying fields:

```dart
final int recoveryPct;     // 72   (0..100)
final double energyScore;  // 7.2  (0..10)
final int calorieTarget;   // 2100 (denominator for the calories ring)
final int waterTarget;     // 8    (denominator for the water ring)
```

Defaults: `recoveryPct = 0`, `energyScore = 0`, `calorieTarget = 2000`, `waterTarget = 8`. Backward-compatible deserialization (existing seeded docs without these keys still decode).

`fromJson`, `fromFirestore`, `toFirestore`, and `copyWith` all updated.

### 4.3 No new collections, no new service methods

The dashboard reads from streams that already exist:

- `streamUserProfile()` → `weightLb`, `bodyFatPct`, `muscleLb`, `name`
- `streamTodayMetric()` → `calories`, `calorieTarget`, `waterCups`, `waterTarget`, `recoveryPct`, `energyScore`
- `streamHabits()` → list, then derive `completed / total`

A third subscription (`_habitsSub`) is added to `_DashboardScreenState`.

## 5. Layout Specification

Wrapping `Scaffold` and `SafeArea` are unchanged. Vertical padding stays 20 horizontal / 8 top. All section-to-section gaps are 24.

### 5.1 Header

Flat (no card). Padded column, 20 horizontal.

| Element | Style | Source |
|---|---|---|
| Eyebrow `GOOD MORNING` | 11px w700, letterSpacing 1.5, `darkFg3` | constant (time-of-day variant is future work) |
| Title `Hi, ${name}` | `textTheme.displayLarge` (32px w900) | `profile.name` |
| Subtitle `Tuesday · April 14 · steady week so far` | 13px w400, `darkFg2` | `DateFormat('EEEE · MMMM d')` via `intl` (already a dependency) + static status copy |
| Action 1 — Sparkle | 44×44, radius 12, 1px `darkBorderStrong`, fill `darkBgCard`, icon `Icons.auto_awesome` accent | tap = no-op |
| Action 2 — Bell | Same shell, icon `Icons.notifications_outlined`, 9×9 accent dot top-right | tap = no-op |

Actions are right-aligned in a `Row` next to the title block.

### 5.2 Trajectory Card

`Container` with `darkBgCard`, radius `radius3xl` (20), 1px `darkBorder`, soft top radial gradient (current hero card's `Color.fromARGB(18, 16, 185, 129)` overlay is reused). Padding 20 all sides.

Children, top-to-bottom:

1. **Top row** — `YOUR TRAJECTORY` eyebrow (left) and an `AI` pill (right). The pill is `accentSoft2` background with a 1px `accent` border, 8×3 padding, radius 999, containing `Icons.auto_awesome` (10px) and the text "AI" (10px w700 accent).
2. **Title block** — `Where you are today` (24px w700, `darkFg1`) followed by `Apr 14, 2026` (12px w400, `darkFg3`). Date formatted from `DateTime.now()` via `intl`.
3. **Silhouette stage** — fixed height 240, `Stack`:
   - Center: `CustomPaint` with the existing `_BodySilhouettePainter`, sized 140×220, color `darkFg2.withOpacity(0.18)`.
   - Four green glow dots overlaid: 14px diameter circles, radial gradient from `accent.withOpacity(0.7)` to transparent. Positioned at approximate body landmarks via fractional coordinates of the silhouette stage (`(x%, y%)` of the 140×220 box): left-shoulder `(32%, 22%)`, right-shoulder `(64%, 30%)`, mid-quad `(60%, 70%)`, left-hip `(38%, 56%)`. These are decorative — no data binding.
   - Four absolute-positioned `_BodyStatLabel`s using `Positioned`:
     - Top-left: `MUSCLE` eyebrow + `138lb` (15px w800)
     - Top-right: `RECOVERY` eyebrow + `72%` (15px w800)
     - Bottom-left: `BODY FAT` eyebrow + `22%`
     - Bottom-right: `WEIGHT` eyebrow + `178lb`
   - Unit text uses a smaller (10px) accent suffix, matching the existing `_bodyMetric` helper style.
4. **Period selector** — full-width `Container` with `darkBgPill` background, radius 999, height 40. Three equal `Expanded` tap targets. Active pill = filled `accent` with white 14px w600 text. Inactive = transparent with `darkFg2` text. Initial selection: `Today`. State held in `_selectedPeriod` (`enum TrajectoryPeriod { today, fourWeek, twelveWeek }`).
5. **Footer copy** — `Stay consistent to reach your goals — your body adapts daily.` 13px w400, `darkFg2`, 1.4 line-height.

### 5.3 Today's Rings Section

Section header row: `TODAY'S RINGS` eyebrow on the left, `View all >` link (accent, 13px w600) on the right. Tap on `View all` is a no-op for now.

Below: 2×2 grid built with two `Row`s (matching the existing metric grid pattern). Each `_RingCard` is a `Container` with `darkBgCard`, radius 16, 1px `darkBorder`, padding 14.

Card internal layout — `Row(crossAxisAlignment: center)`:

- **Left**: `ProgressRing` 56×56, strokeWidth 6, no glow, `trackColor: 0x33FFFFFF` (dark) / `0x1A000000` (light). The `centerWidget` is overridden so the ring shows no center text by default, except the Energy card, which uses a face `Icon` (`Icons.sentiment_satisfied`, 24px, accent).
- **Right** (`Expanded` Column, crossAxis start):
  - Label eyebrow — 10px w700 letterSpacing 1.2 `darkFg3`
  - Value line — `RichText` with bold primary number + smaller secondary unit/denominator (matches the existing `_bodyMetric` value style)
  - Sub line — optional small caption, 11px `darkFg3` (`of 2,100 kcal`, `3 to go`, etc.)

Four card configs:

| Card | Ring color | Progress | Primary value | Secondary | Sub |
|---|---|---|---|---|---|
| Calories | accent | `calories / calorieTarget` | `1,430` | — | `of 2,100 kcal` |
| Water | `#06B6D4` (new file-private const `_waterRingColor`) | `waterCups / waterTarget` | `5/8` | `glasses` | `3 to go` (= `max(0, target - cups)`) |
| Habits | accent | `habitsCompleted / habitsTotal` | `6/8` | — | (empty when complete; otherwise `${remaining} to go`) |
| Energy | accent | `energyScore / 10` | `7.2` | `/10` | (empty) |

Number formatting uses the existing `_formatNumber` helper for calories.

### 5.4 Removed Elements

- `_HeroWellnessCard` class and its `_WellnessScoreRing` — replaced by `_TrajectoryCard`.
- `_MetricCard` class — replaced by `_RingCard` (different layout).
- "AI Coach" chip in the header.
- The standalone AI insight `Container` block above "Today's Plan".
- "Today's Plan" gradient button.
- "Start with a 20-min morning recovery flow →" suggestion text.
- File-private constants `_emeraldGradientStart`, `_emeraldGradientEnd`, `_glowColor`, `_scoreRingTrackColor` — all only referenced by removed components, so all are deleted.

## 6. Seed Data Updates

`lib/core/services/seed_data.dart`:

- `UserProfile`: add `weightLb: 178, bodyFatPct: 22, muscleLb: 138`.
- Today's `DailyMetric`: add `recoveryPct: 72, energyScore: 7.2, calorieTarget: 2100, waterTarget: 8`. Update `calories: 1430` (was 1742) and `waterCups: 5` (was 6) so the rings match the mockup.
- Habits: replace the seeded habit list with **8 habits total**, **exactly 6 with `isCompleted: true`**, so the Habits ring renders `6/8` like the mockup. Suggested names: Morning Run, Read 30 min, Meditation, Hydration, Vitamins, Steps Goal, Stretching, Journal. Names are flexible; the 8/6 counts are locked.

The AI insight string can stay on `DailyMetric` (used elsewhere in the app), but the dashboard no longer renders it.

## 7. Test Updates

Existing tests reference text strings that are being removed:

### `test/dashboard_screen_test.dart`

- `expect(find.text('AI Coach'), findsWidgets)` → `expect(find.text('GOOD MORNING'), findsOneWidget)`.
- Drop the `find.text("Today's Plan")` and `Sleep` / `Steps` / `Water` assertions in the loading-state test.
- Add a new test: with a fake firestore that emits a populated `UserProfile` and `DailyMetric`, the trajectory card shows `138lb`, `22%`, `178lb`, and `72%`.

### `test/widget_test.dart`

- The smoke test (`'Hi Maya'` not found, `'Home'` found) is unaffected.

### `test/dashboard_screen_test.dart` HomeScreen group

- The `'AI Coach'` finder used to confirm "we are on Home" → swap to `'GOOD MORNING'` or `'YOUR TRAJECTORY'`.

`FakeFirestoreService` in `test_helper.dart` already returns `null` / `[]` for everything — no change required, only the assertions move.

## 8. Files Touched

| File | Change |
|---|---|
| `lib/core/models/user_profile.dart` | + 3 fields, updated factories |
| `lib/core/models/daily_metric.dart` | + 4 fields, updated factories |
| `lib/core/services/seed_data.dart` | Updated profile, metric, and habits seeds |
| `lib/presentation/screens/dashboard_screen.dart` | Full rewrite of build tree; existing `_BodySilhouettePainter` reused |
| `test/dashboard_screen_test.dart` | Update assertions; add trajectory-data test |
| `docs/superpowers/specs/2026-05-15-dashboard-redesign-design.md` | This file |

No file is deleted. No new file is created outside of this spec.

## 9. Verification

1. `flutter analyze` — clean.
2. `flutter test` — all green (existing + new trajectory test).
3. `flutter run -d <device>` and visually compare against the mockup. Checklist:
   - Eyebrow `GOOD MORNING` + Hi, Maya + correct date subtitle.
   - Two rounded-square action buttons, bell with green dot.
   - Trajectory card with `YOUR TRAJECTORY` eyebrow, title + date, AI pill top-right.
   - Body silhouette centered, larger than before, four green glow dots, four labels positioned around it.
   - Period pill selector active=Today, switching is interactive.
   - Footer motivational copy renders.
   - `TODAY'S RINGS` header with `View all >` link.
   - Four ring cards: Calories 1,430 / 2,100 kcal, Water 5/8 (cyan ring), Habits 6/8, Energy 7.2/10 with face icon.
   - No "Today's Plan" button, no standalone AI insight banner.

## 10. Open / Deferred Items

- **Projection math** for +4 wk / +12 wk: the selector is visual-only. Wiring it up to projected metrics is a follow-up.
- **Body-composition entry UI**: seed-only this pass; a Profile-screen editor is future work.
- **Time-of-day greeting**: `GOOD MORNING` is static. Switching to `GOOD AFTERNOON` / `GOOD EVENING` based on `DateTime.now().hour` is a trivial follow-up.
- **Bottom-nav icons**: untouched. The mock's icons are close enough that changing them is cosmetic only.
