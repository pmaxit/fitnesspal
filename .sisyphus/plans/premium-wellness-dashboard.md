# Premium Wellness Dashboard Home Screen

## TL;DR

> **Quick Summary**: Replace the current Flutter home dashboard with a premium, dark, iOS-inspired AI wellness dashboard using static polished mock data and existing app conventions. Keep the implementation scoped to the real Home tab experience, with reusable visual widgets, tests-after, and agent-executed mobile visual QA.
>
> **Deliverables**:
> - Real Home/Dashboard screen upgraded to premium dark wellness UI
> - Hero wellness score card with body silhouette, metrics, AI insight, and Today’s Plan CTA
> - Four secondary metric cards with progress rings and trends
> - Bottom navigation remains five tabs with Home active emerald highlight
> - Targeted Flutter widget tests and evidence-backed visual QA
>
> **Estimated Effort**: Medium
> **Parallel Execution**: YES - 3 implementation waves + final verification
> **Critical Path**: Task 1 → Task 3 → Task 6 → Task 9 → Final Verification

---

## Context

### Original Request
Create a premium modern mobile app onboarding/dashboard screen for an AI-powered wellness app called “FitnessPal”, specifically a Home Dashboard Screen. The screen must feel motivating, healthy, calm, in control, and guided by AI. It must use a dark deep navy/black theme, emerald accent, glassmorphism, soft glow lighting, elegant typography, rounded cards, premium hierarchy, and a high-end fitness startup aesthetic similar to Apple Fitness+, Whoop, Oura, and Levels.

### Interview Summary
**Key Discussions**:
- Screen placement: Build as the real app Home screen, not a standalone demo.
- Data source: Use static premium mock data for visual presentation.
- Test strategy: Tests after implementation using existing Flutter test infrastructure.
- QA strategy: Agent-executed mobile visual QA is mandatory, with screenshots/evidence.

**Research Findings**:
- Project is Flutter/Dart.
- `lib/presentation/screens/dashboard_screen.dart` is the current dashboard and most direct implementation target.
- `lib/presentation/screens/home_screen.dart` owns tab wiring and custom bottom navigation.
- `lib/presentation/app.dart` passes `isDarkMode` and density settings into `HomeScreen`.
- `lib/core/theme/app_theme.dart` contains Material 3 theme and radius tokens.
- `lib/core/theme/colors.dart` uses dark background `#020617`, dark card `rgba(30,41,59,0.55)`, and current emerald-like accent `#10B981`.
- `lib/presentation/widgets/progress_ring.dart` exists and should be reused/adapted where feasible.
- `lib/presentation/widgets/avatar_widget.dart` exists and may provide body visualization reference, but must not force a cartoonish look.
- Test infrastructure exists through `flutter_test`, `flutter_lints`, `analysis_options.yaml`, and `test/`.

### Metis Review
**Identified Gaps** (addressed):
- Dark-only vs app theme support: Default is to preserve the existing `isDarkMode` contract while optimizing the dashboard for the requested dark premium design. Light mode may use safe fallback colors but is not a separate visual-design deliverable.
- Accent mismatch: User requested `#22C58B style`; codebase has `#10B981`. Use the app accent token where possible, but introduce local emerald gradient stops only inside this dashboard if needed for visual fidelity.
- Navigation scope: Preserve existing custom bottom nav architecture from `home_screen.dart`; do not replace it with `BottomNavigationBar`.
- Visual QA gap: No golden/E2E framework confirmed, so use Flutter widget tests plus agent-executed screenshot QA.
- Static data: Lock down that values are static curated UI data, not service/model integration.

---

## Work Objectives

### Core Objective
Upgrade FitnessPal’s actual Home dashboard into a premium, production-quality Flutter mobile UI that communicates AI-guided wellness through a calm dark aesthetic, emerald glow accents, rich card hierarchy, and polished static health metrics.

### Concrete Deliverables
- `lib/presentation/screens/dashboard_screen.dart` redesigned as the premium Home dashboard while preserving its public constructor contract.
- Supporting private widgets or extracted widgets for hero card, body silhouette, metric chips, CTA, metric mini cards, and AI insight messaging.
- `lib/presentation/screens/home_screen.dart` only adjusted if required to preserve/confirm bottom nav labels and Home active state.
- `test/` widget test coverage for key static content and navigation/dashboard presence.
- Evidence files under `.sisyphus/evidence/` for visual QA scenarios.

### Definition of Done
- [ ] `flutter analyze` completes with no new errors.
- [ ] `flutter test` passes.
- [ ] Home tab displays “Hi Maya”, the wellness score `84`, “Today’s Plan”, AI insight text, all four metric cards, and five bottom tabs.
- [ ] Dashboard visually uses dark navy/black, emerald accent/glow, rounded glassmorphism-style cards, high spacing quality, and no cartoon/generic fitness-icon look.
- [ ] Agent-executed mobile visual QA screenshots are captured and saved.

### Must Have
- Real Home dashboard route/screen, not a standalone demo.
- Static mock data only.
- Greeting: “Hi Maya”.
- Small date/weather/activity summary below greeting.
- Notification affordance and AI assistant floating button.
- Large wellness overview hero card.
- Circular wellness score indicator with example score `84`.
- Human body silhouette visualization with nearby metrics: Weight, Body fat %, Sleep hours, Recovery.
- AI insight: “Your recovery is improving after better sleep consistency.”
- Emerald gradient CTA: “Today’s Plan”.
- Four metric mini cards: Calories, Sleep, Steps, Water intake.
- Each mini card has circular progress ring, numeric value, and trend indicator.
- Bottom nav: Home, Activity, Meals, Habits, Profile; Home active with emerald highlight.

### Must NOT Have (Guardrails)
- Do not introduce live API/service/model wiring for dashboard data.
- Do not build extra onboarding screens or multi-screen flows.
- Do not replace existing app-wide navigation architecture unless strictly necessary.
- Do not use bright colors outside restrained emerald accents.
- Do not use generic fitness icon clutter.
- Do not make the body silhouette cartoonish.
- Do not add large third-party UI dependencies for glassmorphism/glow unless already present and necessary.
- Do not remove the `isDarkMode` constructor contract used by parent screens.

---

## Verification Strategy (MANDATORY)

> **ZERO HUMAN INTERVENTION** - ALL verification is agent-executed. No exceptions.
> Acceptance criteria requiring "user manually tests/confirms" are FORBIDDEN.

### Test Decision
- **Infrastructure exists**: YES
- **Automated tests**: Tests-after
- **Framework**: Flutter widget tests via `flutter test`
- **If TDD**: Not applicable. Tests are added after implementation.

### QA Policy
Every task MUST include agent-executed QA scenarios.
Evidence saved to `.sisyphus/evidence/task-{N}-{scenario-slug}.{ext}`.

- **Frontend/UI**: Use Flutter run/build plus browser/emulator/screenshot tooling where available. Capture screenshots and DOM/semantic/text evidence when possible.
- **Widget Tests**: Use `flutter test` for static labels, navigation text, CTA, and metric presence.
- **Static Analysis**: Use `flutter analyze`.
- **Library/Module**: Use direct Flutter/Dart test commands for widget helpers.

---

## Execution Strategy

### Parallel Execution Waves

> Maximize throughput by grouping independent tasks into parallel waves.
> Each wave completes before the next begins.

```text
Wave 1 (Foundation + reusable UI primitives):
├── Task 1: Dashboard contract and layout foundation [visual-engineering]
├── Task 2: Premium visual tokens and static data model [quick]
├── Task 3: Progress and glow primitives audit/adaptation [quick]
└── Task 4: Bottom navigation preservation check [quick]

Wave 2 (Core visual sections, MAX PARALLEL):
├── Task 5: Header, notification, and AI assistant button (depends: 1, 2) [visual-engineering]
├── Task 6: Hero wellness card, score ring, and silhouette (depends: 1, 2, 3) [visual-engineering]
├── Task 7: Metric mini-card grid (depends: 1, 2, 3) [visual-engineering]
└── Task 8: CTA and adaptive AI messaging polish (depends: 1, 2) [visual-engineering]

Wave 3 (Integration + tests + polish):
├── Task 9: Full screen integration and responsive iPhone portrait polish (depends: 5, 6, 7, 8) [visual-engineering]
├── Task 10: Flutter widget tests after implementation (depends: 9) [quick]
└── Task 11: Analyzer/test cleanup and evidence prep (depends: 9, 10) [quick]

Wave FINAL (After ALL tasks — 4 parallel reviews, then user okay):
├── Task F1: Plan compliance audit (oracle)
├── Task F2: Code quality review (unspecified-high)
├── Task F3: Real visual/manual QA (unspecified-high)
└── Task F4: Scope fidelity check (deep)
-> Present results -> Get explicit user okay

Critical Path: Task 1 → Task 6 → Task 9 → Task 10 → Task 11 → F1-F4 → user okay
Parallel Speedup: ~55% faster than sequential
Max Concurrent: 4
```

### Dependency Matrix

| Task | Blocked By | Blocks | Wave |
|---|---|---|---|
| 1 | None | 5, 6, 7, 8, 9 | 1 |
| 2 | None | 5, 6, 7, 8 | 1 |
| 3 | None | 6, 7 | 1 |
| 4 | None | 9 | 1 |
| 5 | 1, 2 | 9 | 2 |
| 6 | 1, 2, 3 | 9 | 2 |
| 7 | 1, 2, 3 | 9 | 2 |
| 8 | 1, 2 | 9 | 2 |
| 9 | 4, 5, 6, 7, 8 | 10, 11 | 3 |
| 10 | 9 | 11 | 3 |
| 11 | 9, 10 | F1-F4 | 3 |
| F1-F4 | 11 | User approval | FINAL |

### Agent Dispatch Summary

- **Wave 1**: 4 tasks — T1 `visual-engineering`, T2-T4 `quick`
- **Wave 2**: 4 tasks — T5-T8 `visual-engineering`
- **Wave 3**: 3 tasks — T9 `visual-engineering`, T10-T11 `quick`
- **FINAL**: 4 review tasks — F1 `oracle`, F2 `unspecified-high`, F3 `unspecified-high`, F4 `deep`

---

## TODOs

> Implementation + Test = ONE Task where practical. Never separate verification from the implementation it validates.
> EVERY task MUST have: Recommended Agent Profile + Parallelization info + QA Scenarios.

- [ ] 1. Dashboard contract and layout foundation

  **What to do**:
  - Inspect `lib/presentation/screens/dashboard_screen.dart` and preserve the public constructor contract expected by `home_screen.dart`.
  - Establish the dashboard’s main `Scaffold`/root layout, dark premium background, safe-area handling, vertical scroll behavior, and portrait iPhone spacing rhythm.
  - Keep the dashboard as the real Home tab content; do not create a detached demo-only route.

  **Must NOT do**:
  - Do not remove or rename the `isDarkMode` parameter expected by parent wiring.
  - Do not add service/model integration.
  - Do not replace bottom navigation architecture.

  **Recommended Agent Profile**:
  - **Category**: `visual-engineering`
    - Reason: This task establishes the screen layout foundation and high-fidelity visual constraints.
  - **Skills**: [`frontend-ui-ux`]
    - `frontend-ui-ux`: Needed for premium spacing, hierarchy, and mobile UI structure.
  - **Skills Evaluated but Omitted**:
    - `playwright`: Useful later for QA, not needed for source layout foundation.

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 2, 3, 4)
  - **Blocks**: Tasks 5, 6, 7, 8, 9
  - **Blocked By**: None

  **References**:
  - `lib/presentation/screens/dashboard_screen.dart` - Current dashboard class and constructor contract to preserve.
  - `lib/presentation/screens/home_screen.dart` - Parent tab wiring that instantiates the dashboard at Home index.
  - `lib/presentation/app.dart` - App-level `isDarkMode` flow into `HomeScreen`.
  - `lib/core/theme/colors.dart` - Existing dark background and emerald token references.
  - `lib/core/theme/app_theme.dart` - Radius, typography, and Material 3 conventions.

  **Acceptance Criteria**:
  - [ ] `DashboardScreen` remains constructible from existing Home tab wiring.
  - [ ] Root dashboard uses dark premium background and safe portrait spacing.
  - [ ] No new route or demo-only entrypoint is introduced.
  - [ ] `flutter analyze` reports no new dashboard contract errors.

  **QA Scenarios**:
  ```text
  Scenario: Home dashboard route still renders
    Tool: Flutter test or Flutter run with screenshot
    Preconditions: App starts from default main entrypoint.
    Steps:
      1. Launch the app in a mobile portrait target.
      2. Wait until the Home tab content is visible.
      3. Assert the dashboard root renders without exceptions and displays a dark background.
    Expected Result: App opens to Home dashboard without constructor/runtime errors.
    Failure Indicators: Red error screen, missing Home content, constructor mismatch, or white/default scaffold background.
    Evidence: .sisyphus/evidence/task-1-home-dashboard-renders.png

  Scenario: No detached demo route is required
    Tool: Bash
    Preconditions: Implementation completed.
    Steps:
      1. Inspect changed files with git diff.
      2. Confirm dashboard changes are wired through existing Home tab path.
      3. Confirm no new standalone demo-only route is added.
    Expected Result: Home tab path remains the route for the dashboard.
    Failure Indicators: A separate showcase route is required to see the design.
    Evidence: .sisyphus/evidence/task-1-route-scope.txt
  ```

  **Evidence to Capture**:
  - [ ] `task-1-home-dashboard-renders.png`
  - [ ] `task-1-route-scope.txt`

  **Commit**: YES
  - Message: `feat(dashboard): add premium wellness home screen foundation`
  - Files: `lib/presentation/screens/dashboard_screen.dart`
  - Pre-commit: `flutter analyze`

- [ ] 2. Premium visual tokens and static dashboard data

  **What to do**:
  - Define curated static dashboard display values near the dashboard implementation or in a small private helper structure: Maya greeting, date/weather/activity summary, score `84`, metrics, mini-card values, trend labels, AI insight, and suggestions.
  - Define local dashboard-only color/gradient/shadow constants when existing theme tokens are insufficient, anchored to codebase dark palette and emerald accent style.
  - Keep tokens minimal and local unless an existing shared theme file clearly expects additions.

  **Must NOT do**:
  - Do not connect to APIs, local storage, providers, or user models.
  - Do not globally restyle the whole app unless required by existing token usage.
  - Do not introduce bright colors or extra accent palettes.

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Small, focused static data/token task with limited file surface.
  - **Skills**: []
  - **Skills Evaluated but Omitted**:
    - `frontend-ui-ux`: Main design execution occurs in later visual tasks.

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 1, 3, 4)
  - **Blocks**: Tasks 5, 6, 7, 8
  - **Blocked By**: None

  **References**:
  - `lib/core/theme/colors.dart` - Existing dark palette and emerald token baseline.
  - `lib/core/theme/app_theme.dart` - Existing style-token conventions to avoid random global styling.
  - `lib/presentation/screens/dashboard_screen.dart` - Place or consume static UI values in the dashboard.

  **Acceptance Criteria**:
  - [ ] Static values include every required label/value from the user request.
  - [ ] Emerald accent visually aligns with `#22C58B style` while respecting existing app palette.
  - [ ] No live-data dependency is introduced.
  - [ ] Constants are named specifically, not generically (`wellnessScore`, not `value1`).

  **QA Scenarios**:
  ```text
  Scenario: Required static wellness values are present
    Tool: Bash or Flutter widget test
    Preconditions: Static dashboard values implemented.
    Steps:
      1. Search/render for “Hi Maya”, “84”, “Today’s Plan”, “Calories”, “Sleep”, “Steps”, “Water intake”.
      2. Assert each value appears exactly as dashboard content.
      3. Assert AI insight text equals “Your recovery is improving after better sleep consistency.”
    Expected Result: All required static values are present and readable.
    Failure Indicators: Missing labels, altered required AI insight, or placeholder text.
    Evidence: .sisyphus/evidence/task-2-static-values.txt

  Scenario: No live data wiring added
    Tool: Bash
    Preconditions: Implementation completed.
    Steps:
      1. Inspect dashboard diff for provider/service/API/model imports.
      2. Confirm values are static display data only.
    Expected Result: Dashboard has no new data-service dependency.
    Failure Indicators: New API/provider/repository/model imports solely for dashboard content.
    Evidence: .sisyphus/evidence/task-2-no-live-data.txt
  ```

  **Evidence to Capture**:
  - [ ] `task-2-static-values.txt`
  - [ ] `task-2-no-live-data.txt`

  **Commit**: YES
  - Message: `feat(dashboard): define premium wellness display data`
  - Files: `lib/presentation/screens/dashboard_screen.dart` or small dashboard-local helper
  - Pre-commit: `flutter analyze`

- [ ] 3. Progress and glow primitives audit/adaptation

  **What to do**:
  - Reuse `ProgressRing` where suitable for the score indicator and mini-card circular progress rings.
  - Add small dashboard-local wrappers or parameters only if needed for sizes, emerald gradients, center text, and premium glow effects.
  - Ensure glow/shadow effects remain subtle and performant in Flutter.

  **Must NOT do**:
  - Do not duplicate a full progress-ring implementation if existing widget can be reused cleanly.
  - Do not add animation complexity unless already straightforward and low risk.
  - Do not create bright neon effects that violate the calm premium style.

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Focused component audit/adaptation with small scope.
  - **Skills**: []
  - **Skills Evaluated but Omitted**:
    - `artistry`: Not needed; this should be restrained and convention-driven.

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 1, 2, 4)
  - **Blocks**: Tasks 6, 7
  - **Blocked By**: None

  **References**:
  - `lib/presentation/widgets/progress_ring.dart` - Existing circular progress implementation to reuse/adapt.
  - `lib/presentation/screens/dashboard_screen.dart` - Existing dashboard usage of ring tiles if present.
  - `lib/core/theme/colors.dart` - Accent and dark surface colors for ring/glow styling.

  **Acceptance Criteria**:
  - [ ] Existing progress-ring pattern is reused or explicitly justified if not suitable.
  - [ ] Score and metric rings can render at distinct sizes.
  - [ ] Ring colors remain emerald/subtle and dark-theme appropriate.
  - [ ] No unnecessary dependency is added.

  **QA Scenarios**:
  ```text
  Scenario: Progress rings render at dashboard sizes
    Tool: Flutter run screenshot or widget test
    Preconditions: Ring primitive adapted/available.
    Steps:
      1. Render dashboard in portrait viewport.
      2. Verify one large circular score indicator is visible around score “84”.
      3. Verify four smaller circular progress rings are visible in the metric cards.
    Expected Result: Five circular progress visuals render without clipping.
    Failure Indicators: Missing rings, clipped rings, wrong color dominance, or layout overflow.
    Evidence: .sisyphus/evidence/task-3-progress-rings.png

  Scenario: No duplicate heavy progress implementation
    Tool: Bash
    Preconditions: Implementation completed.
    Steps:
      1. Inspect changed files for new CustomPainter/progress implementations.
      2. Confirm reuse/adaptation rationale is clear.
    Expected Result: Existing progress component is reused or minimally extended.
    Failure Indicators: Large duplicated ring painter without need.
    Evidence: .sisyphus/evidence/task-3-progress-implementation.txt
  ```

  **Evidence to Capture**:
  - [ ] `task-3-progress-rings.png`
  - [ ] `task-3-progress-implementation.txt`

  **Commit**: YES
  - Message: `feat(dashboard): adapt progress visuals for wellness metrics`
  - Files: `lib/presentation/widgets/progress_ring.dart`, `lib/presentation/screens/dashboard_screen.dart`
  - Pre-commit: `flutter analyze`

- [ ] 4. Bottom navigation preservation check

  **What to do**:
  - Verify `home_screen.dart` already provides the five requested tabs: Home, Activity, Meals, Habits, Profile.
  - Preserve the custom bottom nav architecture and Home active emerald state.
  - Make only minimal changes if labels, active color, or dashboard placement do not match the requested screen.

  **Must NOT do**:
  - Do not replace custom navigation with Material `BottomNavigationBar`.
  - Do not alter non-Home tab content.
  - Do not introduce extra tabs.

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Small verification and potential minimal wiring fix.
  - **Skills**: []
  - **Skills Evaluated but Omitted**:
    - `frontend-ui-ux`: Visual nav polish is minor compared with main dashboard sections.

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 1, 2, 3)
  - **Blocks**: Task 9
  - **Blocked By**: None

  **References**:
  - `lib/presentation/screens/home_screen.dart` - Custom bottom nav, selected tab state, dashboard placement.
  - `lib/presentation/screens/dashboard_screen.dart` - Home tab screen component.
  - `lib/core/theme/colors.dart` - Emerald active-state color.

  **Acceptance Criteria**:
  - [ ] Bottom nav has exactly Home, Activity, Meals, Habits, Profile.
  - [ ] Home is active by default and visually emerald-highlighted.
  - [ ] Dashboard remains Home index content.
  - [ ] Non-Home tabs remain reachable.

  **QA Scenarios**:
  ```text
  Scenario: Five-tab navigation is visible
    Tool: Flutter run screenshot or widget test
    Preconditions: App launched to Home.
    Steps:
      1. Render the main app.
      2. Assert text labels Home, Activity, Meals, Habits, Profile are visible.
      3. Assert Home has active styling or selected state.
    Expected Result: Five bottom tabs render with Home active.
    Failure Indicators: Missing tab, extra tab, wrong active tab, or hidden nav.
    Evidence: .sisyphus/evidence/task-4-bottom-nav.png

  Scenario: Non-Home tabs remain navigable
    Tool: Flutter widget test or Flutter run interaction
    Preconditions: App launched to Home.
    Steps:
      1. Tap Activity tab.
      2. Confirm Activity content appears or selected state changes.
      3. Tap Home tab.
      4. Confirm premium dashboard content returns.
    Expected Result: Navigation behavior remains intact.
    Failure Indicators: Taps do nothing, app crashes, or Home dashboard cannot be restored.
    Evidence: .sisyphus/evidence/task-4-tab-navigation.txt
  ```

  **Evidence to Capture**:
  - [ ] `task-4-bottom-nav.png`
  - [ ] `task-4-tab-navigation.txt`

  **Commit**: YES
  - Message: `fix(home): preserve dashboard tab navigation`
  - Files: `lib/presentation/screens/home_screen.dart` if changed
  - Pre-commit: `flutter analyze`

- [ ] 5. Header, notification, and AI assistant button

  **What to do**:
  - Build the top dashboard section with greeting “Hi Maya”, a thin subtext date/weather/activity summary, a notification affordance, and an AI assistant floating button.
  - Use elegant typography, restrained icons/line shapes, dark glass surfaces, and soft emerald glow.
  - Ensure the AI assistant button reads as premium and AI-guided without becoming visually loud.

  **Must NOT do**:
  - Do not use generic cluttered fitness icon sets.
  - Do not make the notification or AI button dominate the hero card.
  - Do not add functional notification/chat flows beyond the visual affordance.

  **Recommended Agent Profile**:
  - **Category**: `visual-engineering`
    - Reason: High-fidelity mobile visual section with spacing, typography, and micro-hierarchy requirements.
  - **Skills**: [`frontend-ui-ux`]
    - `frontend-ui-ux`: Needed for polished header hierarchy and premium interaction affordances.
  - **Skills Evaluated but Omitted**:
    - `playwright`: QA-only, not needed during implementation.

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 2 (with Tasks 6, 7, 8)
  - **Blocks**: Task 9
  - **Blocked By**: Tasks 1, 2

  **References**:
  - `lib/presentation/screens/dashboard_screen.dart` - Place header within existing dashboard layout.
  - `lib/core/theme/app_theme.dart` - Typography and radius conventions.
  - `lib/core/theme/colors.dart` - Dark and emerald color references.

  **Acceptance Criteria**:
  - [ ] Greeting “Hi Maya” is visible near the top.
  - [ ] A small date/weather/activity summary appears below greeting.
  - [ ] Notification affordance appears in the top section.
  - [ ] AI assistant floating button/chip appears and uses restrained emerald glow.

  **QA Scenarios**:
  ```text
  Scenario: Header content is visible and readable
    Tool: Flutter run screenshot or widget test
    Preconditions: App launched to Home dashboard.
    Steps:
      1. Render dashboard in iPhone portrait viewport.
      2. Assert “Hi Maya” appears at the top.
      3. Assert the date/weather/activity summary text appears under it.
      4. Assert notification and AI assistant affordances are visible.
    Expected Result: Header communicates personalization and AI guidance without clutter.
    Failure Indicators: Missing greeting, unreadable subtext, absent AI button, or crowded top section.
    Evidence: .sisyphus/evidence/task-5-header.png

  Scenario: Header has no functional dead-end errors
    Tool: Flutter run interaction
    Preconditions: Dashboard visible.
    Steps:
      1. Tap notification affordance.
      2. Tap AI assistant affordance.
      3. Confirm app does not crash or navigate to broken route.
    Expected Result: Taps are either inert visual affordances or handled gracefully without errors.
    Failure Indicators: Exception overlay, broken navigation, or route-not-found error.
    Evidence: .sisyphus/evidence/task-5-header-taps.txt
  ```

  **Evidence to Capture**:
  - [ ] `task-5-header.png`
  - [ ] `task-5-header-taps.txt`

  **Commit**: YES
  - Message: `feat(dashboard): add premium personalized header`
  - Files: `lib/presentation/screens/dashboard_screen.dart`
  - Pre-commit: `flutter analyze`

- [ ] 6. Hero wellness card, score ring, and silhouette

  **What to do**:
  - Build the large main wellness overview card with rich depth, rounded glassmorphism feel, soft gradients, subtle shadows, and emerald light accents.
  - Include circular wellness score indicator displaying `84`.
  - Include a refined human body silhouette visualization, avoiding cartoonish proportions.
  - Place metrics around the silhouette: Weight, Body fat %, Sleep hours, Recovery.
  - Include the exact AI insight: “Your recovery is improving after better sleep consistency.”

  **Must NOT do**:
  - Do not create a cartoon avatar/body illustration.
  - Do not overload the hero with too many labels or icons.
  - Do not omit any required body metric.

  **Recommended Agent Profile**:
  - **Category**: `visual-engineering`
    - Reason: This is the core high-fidelity visual feature requiring premium composition.
  - **Skills**: [`frontend-ui-ux`]
    - `frontend-ui-ux`: Needed for body visualization, score hierarchy, and luxury card composition.
  - **Skills Evaluated but Omitted**:
    - `artistry`: Could overcomplicate; the design should remain restrained and production-oriented.

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 2 (with Tasks 5, 7, 8)
  - **Blocks**: Task 9
  - **Blocked By**: Tasks 1, 2, 3

  **References**:
  - `lib/presentation/screens/dashboard_screen.dart` - Existing dashboard card structure and target screen.
  - `lib/presentation/widgets/progress_ring.dart` - Score ring reference/reuse.
  - `lib/presentation/widgets/avatar_widget.dart` - Existing body/avatar visualization reference; use only if it can be made premium/non-cartoonish.
  - `lib/core/theme/colors.dart` - Dark card and emerald accent palette.
  - `lib/core/theme/app_theme.dart` - Radius and text hierarchy conventions.

  **Acceptance Criteria**:
  - [ ] Hero card is the dominant screen element below the header.
  - [ ] Score ring displays `84` clearly.
  - [ ] Body silhouette is visible and premium/minimal.
  - [ ] Weight, Body fat %, Sleep hours, and Recovery are all visible around the silhouette.
  - [ ] Exact AI insight text is visible.
  - [ ] No layout overflow in iPhone portrait dimensions.

  **QA Scenarios**:
  ```text
  Scenario: Hero wellness overview renders completely
    Tool: Flutter run screenshot or widget test
    Preconditions: Dashboard visible in iPhone portrait viewport.
    Steps:
      1. Capture the main dashboard viewport.
      2. Assert score “84” appears inside or near a circular score indicator.
      3. Assert Weight, Body fat %, Sleep hours, and Recovery labels appear around the silhouette.
      4. Assert exact AI insight text appears.
    Expected Result: Hero card communicates wellness score, body metrics, and AI insight in one premium card.
    Failure Indicators: Missing metric, clipped score ring, unreadable insight, or cartoonish body visual.
    Evidence: .sisyphus/evidence/task-6-hero-card.png

  Scenario: Hero card remains stable on compact portrait height
    Tool: Flutter run screenshot
    Preconditions: App can be launched with compact mobile viewport.
    Steps:
      1. Render dashboard at a compact portrait size similar to iPhone SE.
      2. Scroll if necessary.
      3. Confirm hero card does not overflow horizontally and body metrics remain readable.
    Expected Result: Compact portrait layout remains usable with no overflow warnings.
    Failure Indicators: Yellow/black overflow stripes, clipped body metrics, or unreadable score.
    Evidence: .sisyphus/evidence/task-6-compact-hero.png
  ```

  **Evidence to Capture**:
  - [ ] `task-6-hero-card.png`
  - [ ] `task-6-compact-hero.png`

  **Commit**: YES
  - Message: `feat(dashboard): add wellness score hero card`
  - Files: `lib/presentation/screens/dashboard_screen.dart`, optionally `lib/presentation/widgets/progress_ring.dart`
  - Pre-commit: `flutter analyze`

- [ ] 7. Metric mini-card grid

  **What to do**:
  - Build the secondary metrics grid with four mini cards: Calories, Sleep, Steps, Water intake.
  - Each card must include a circular progress ring, numeric value, and small trend indicator.
  - Use rounded glass surfaces, subtle shadows, balanced spacing, and restrained emerald highlights.

  **Must NOT do**:
  - Do not add extra metric cards.
  - Do not use bright multicolor chart styling.
  - Do not make cards too dense or text too small to read.

  **Recommended Agent Profile**:
  - **Category**: `visual-engineering`
    - Reason: Requires polished grid composition and visual consistency.
  - **Skills**: [`frontend-ui-ux`]
    - `frontend-ui-ux`: Needed for premium card hierarchy and responsive spacing.
  - **Skills Evaluated but Omitted**:
    - `playwright`: Verification only.

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 2 (with Tasks 5, 6, 8)
  - **Blocks**: Task 9
  - **Blocked By**: Tasks 1, 2, 3

  **References**:
  - `lib/presentation/screens/dashboard_screen.dart` - Existing metric card/ring tile patterns if present.
  - `lib/presentation/widgets/progress_ring.dart` - Circular progress ring primitive.
  - `lib/core/theme/app_theme.dart` - Radius and text style conventions.
  - `lib/core/theme/colors.dart` - Dark card and accent colors.

  **Acceptance Criteria**:
  - [ ] Exactly four metric mini cards render.
  - [ ] Cards are labeled Calories, Sleep, Steps, Water intake.
  - [ ] Each card has a circular progress ring.
  - [ ] Each card has a numeric value and trend indicator.
  - [ ] Grid spacing is clean in portrait width.

  **QA Scenarios**:
  ```text
  Scenario: Four metric cards render with required content
    Tool: Flutter widget test or screenshot
    Preconditions: Dashboard visible.
    Steps:
      1. Render dashboard and scroll to metrics grid if needed.
      2. Assert exactly the labels Calories, Sleep, Steps, Water intake are present.
      3. Assert each card includes a numeric value and trend text/symbol.
      4. Capture screenshot of the grid.
    Expected Result: Four polished mini cards appear in a balanced grid.
    Failure Indicators: Missing card, extra card, no numeric value, or unreadable layout.
    Evidence: .sisyphus/evidence/task-7-metric-grid.png

  Scenario: Metric grid does not overflow on narrow portrait width
    Tool: Flutter run screenshot
    Preconditions: Compact portrait viewport available.
    Steps:
      1. Render dashboard on narrow mobile width.
      2. Scroll to metric grid.
      3. Confirm no horizontal overflow and all card labels remain readable.
    Expected Result: Grid adapts cleanly to narrow portrait width.
    Failure Indicators: Overflow warning, clipped labels, or cards extending offscreen.
    Evidence: .sisyphus/evidence/task-7-metric-grid-compact.png
  ```

  **Evidence to Capture**:
  - [ ] `task-7-metric-grid.png`
  - [ ] `task-7-metric-grid-compact.png`

  **Commit**: YES
  - Message: `feat(dashboard): add wellness metric cards`
  - Files: `lib/presentation/screens/dashboard_screen.dart`
  - Pre-commit: `flutter analyze`

- [ ] 8. CTA and adaptive AI messaging polish

  **What to do**:
  - Add the emerald gradient primary CTA labeled “Today’s Plan”.
  - Add tiny AI insight chip and personalized wellness/adaptive suggestion messaging.
  - Ensure CTA and AI messaging integrate into the dashboard hierarchy without clutter.

  **Must NOT do**:
  - Do not create a new Today’s Plan destination screen.
  - Do not add chat/coaching functionality.
  - Do not use generic marketing copy that feels unrelated to the user’s wellness state.

  **Recommended Agent Profile**:
  - **Category**: `visual-engineering`
    - Reason: Visual polish and copy hierarchy task.
  - **Skills**: [`frontend-ui-ux`]
    - `frontend-ui-ux`: Needed for button hierarchy and polished AI microcopy placement.
  - **Skills Evaluated but Omitted**:
    - `writing`: Copy is minimal and already specified enough.

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 2 (with Tasks 5, 6, 7)
  - **Blocks**: Task 9
  - **Blocked By**: Tasks 1, 2

  **References**:
  - `lib/presentation/screens/dashboard_screen.dart` - CTA/messaging placement target.
  - `lib/core/theme/colors.dart` - Emerald accent/gradient baseline.
  - `lib/core/theme/app_theme.dart` - Button radius/typography conventions.

  **Acceptance Criteria**:
  - [ ] “Today’s Plan” CTA is visible and primary.
  - [ ] CTA uses emerald gradient styling.
  - [ ] Tiny AI insight chip is visible.
  - [ ] Personalized/adaptive suggestion copy is visible and calm.
  - [ ] Tapping CTA does not crash, even if no destination is implemented.

  **QA Scenarios**:
  ```text
  Scenario: Today’s Plan CTA and AI chip render
    Tool: Flutter run screenshot or widget test
    Preconditions: Dashboard visible.
    Steps:
      1. Render dashboard.
      2. Assert “Today’s Plan” appears as the primary CTA.
      3. Assert a small AI chip/label appears near the insight or suggestions.
      4. Capture screenshot showing CTA and AI messaging.
    Expected Result: CTA and AI elements feel premium, guided, and not cluttered.
    Failure Indicators: Missing CTA, flat/non-primary button, missing AI chip, or excessive copy.
    Evidence: .sisyphus/evidence/task-8-cta-ai-chip.png

  Scenario: CTA interaction is safe
    Tool: Flutter run interaction or widget test
    Preconditions: Dashboard visible.
    Steps:
      1. Tap “Today’s Plan”.
      2. Observe app state for errors.
      3. Confirm no exception overlay or broken route appears.
    Expected Result: CTA tap is handled gracefully or intentionally inert.
    Failure Indicators: Crash, route-not-found, or exception overlay.
    Evidence: .sisyphus/evidence/task-8-cta-tap.txt
  ```

  **Evidence to Capture**:
  - [ ] `task-8-cta-ai-chip.png`
  - [ ] `task-8-cta-tap.txt`

  **Commit**: YES
  - Message: `feat(dashboard): add today plan cta and ai guidance`
  - Files: `lib/presentation/screens/dashboard_screen.dart`
  - Pre-commit: `flutter analyze`

- [ ] 9. Full screen integration and responsive iPhone portrait polish

  **What to do**:
  - Integrate header, hero, CTA/AI messaging, metric grid, and bottom navigation into a cohesive premium dashboard.
  - Tune spacing, shadows, gradients, rounded cards, scroll behavior, and depth so the screen feels highly polished and production-ready.
  - Validate portrait iPhone-style sizing across normal and compact heights.
  - Preserve readable typography and avoid visual clutter.

  **Must NOT do**:
  - Do not let any one component visually crowd the screen.
  - Do not introduce horizontal scrolling.
  - Do not sacrifice readability for decorative glow effects.

  **Recommended Agent Profile**:
  - **Category**: `visual-engineering`
    - Reason: Final visual integration and polish require designer-level judgment.
  - **Skills**: [`frontend-ui-ux`]
    - `frontend-ui-ux`: Needed for final Dribbble-quality composition and mobile polish.
  - **Skills Evaluated but Omitted**:
    - `ai-slop-remover`: Single-file cleanup may be useful later only if code quality review flags issues.

  **Parallelization**:
  - **Can Run In Parallel**: NO
  - **Parallel Group**: Wave 3 integration
  - **Blocks**: Tasks 10, 11
  - **Blocked By**: Tasks 4, 5, 6, 7, 8

  **References**:
  - `lib/presentation/screens/dashboard_screen.dart` - Main integration target.
  - `lib/presentation/screens/home_screen.dart` - Bottom nav integration context.
  - `lib/core/theme/colors.dart` - App palette.
  - `lib/core/theme/app_theme.dart` - Typography/radius conventions.

  **Acceptance Criteria**:
  - [ ] One complete portrait mobile screen presents all requested dashboard sections.
  - [ ] Visual style matches dark premium iOS-inspired wellness aesthetic.
  - [ ] No overflow warnings in normal or compact portrait viewport.
  - [ ] Bottom nav remains visible and usable.
  - [ ] Content hierarchy reads top-to-bottom: greeting → hero → CTA/AI → metric grid → nav.

  **QA Scenarios**:
  ```text
  Scenario: Full premium dashboard screenshot
    Tool: Flutter run screenshot
    Preconditions: App launched to Home dashboard in iPhone-like portrait viewport.
    Steps:
      1. Render the screen from the top with Home tab active.
      2. Capture a screenshot of the full visible viewport.
      3. Assert screenshot includes greeting, hero card, score, CTA, metric cards, and bottom nav.
    Expected Result: A complete polished mobile dashboard is visible in one portrait composition.
    Failure Indicators: Missing major section, cluttered layout, off-brand colors, or overflow stripe.
    Evidence: .sisyphus/evidence/task-9-full-dashboard.png

  Scenario: Scroll and compact behavior remain clean
    Tool: Flutter run interaction and screenshot
    Preconditions: App launched in compact portrait viewport.
    Steps:
      1. Render dashboard at compact portrait height.
      2. Scroll from top to bottom.
      3. Confirm all content is reachable, bottom nav remains usable, and no horizontal overflow appears.
    Expected Result: Dashboard remains polished and usable on compact portrait devices.
    Failure Indicators: Content inaccessible, bottom nav overlap, horizontal overflow, or unreadable cards.
    Evidence: .sisyphus/evidence/task-9-compact-scroll.png
  ```

  **Evidence to Capture**:
  - [ ] `task-9-full-dashboard.png`
  - [ ] `task-9-compact-scroll.png`

  **Commit**: YES
  - Message: `feat(dashboard): polish premium home composition`
  - Files: `lib/presentation/screens/dashboard_screen.dart`, `lib/presentation/screens/home_screen.dart` if changed
  - Pre-commit: `flutter analyze`

- [ ] 10. Flutter widget tests after implementation

  **What to do**:
  - Add or update Flutter widget tests under `test/` for dashboard-visible content.
  - Test that the app/home dashboard renders the required labels and static values.
  - Test bottom navigation labels and Home dashboard presence.
  - Keep tests robust to visual implementation details; avoid brittle pixel/golden assertions unless existing patterns support them.

  **Must NOT do**:
  - Do not add golden-test infrastructure unless already easy and necessary.
  - Do not write tests that depend on live data.
  - Do not delete unrelated existing tests without replacing their intent.

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Focused Flutter widget test coverage for static UI content.
  - **Skills**: []
  - **Skills Evaluated but Omitted**:
    - `playwright`: The project uses Flutter widget tests; visual QA is covered separately.

  **Parallelization**:
  - **Can Run In Parallel**: NO
  - **Parallel Group**: Wave 3 after integration
  - **Blocks**: Task 11
  - **Blocked By**: Task 9

  **References**:
  - `test/widget_test.dart` - Existing Flutter test style and current baseline.
  - `pubspec.yaml` - Confirms `flutter_test` dependency.
  - `lib/presentation/screens/dashboard_screen.dart` - Text/content to assert.
  - `lib/presentation/screens/home_screen.dart` - Bottom nav labels to assert.

  **Acceptance Criteria**:
  - [ ] Widget tests assert key content: “Hi Maya”, `84`, “Today’s Plan”, “Calories”, “Sleep”, “Steps”, “Water intake”.
  - [ ] Widget tests assert bottom nav labels exist.
  - [ ] `flutter test` passes.
  - [ ] Tests do not rely on network or external services.

  **QA Scenarios**:
  ```text
  Scenario: Widget tests pass for dashboard content
    Tool: Bash
    Preconditions: Widget tests implemented.
    Steps:
      1. Run `flutter test`.
      2. Capture full terminal output.
      3. Confirm all tests pass and dashboard content assertions are included.
    Expected Result: `flutter test` passes with dashboard coverage.
    Failure Indicators: Any failing test, missing dashboard assertions, or network-dependent test behavior.
    Evidence: .sisyphus/evidence/task-10-flutter-test.txt

  Scenario: Tests fail meaningfully if required text disappears
    Tool: Bash/code inspection
    Preconditions: Tests implemented.
    Steps:
      1. Inspect test assertions for required labels and values.
      2. Confirm each critical static requirement has a corresponding finder/assertion.
    Expected Result: Removing required dashboard copy would fail tests.
    Failure Indicators: Tests only pump the widget without checking required content.
    Evidence: .sisyphus/evidence/task-10-test-coverage.txt
  ```

  **Evidence to Capture**:
  - [ ] `task-10-flutter-test.txt`
  - [ ] `task-10-test-coverage.txt`

  **Commit**: YES
  - Message: `test(dashboard): cover premium home content`
  - Files: `test/widget_test.dart` or new `test/dashboard_screen_test.dart`
  - Pre-commit: `flutter test`

- [ ] 11. Analyzer/test cleanup and evidence prep

  **What to do**:
  - Run `flutter analyze` and `flutter test` after all implementation/test work.
  - Fix any issues introduced by this dashboard work.
  - Ensure QA evidence paths from tasks are created/populated by the executing agent.
  - Review final diff for scope creep: no extra screens, no live data, no navigation rewrite, no unnecessary dependencies.

  **Must NOT do**:
  - Do not suppress warnings with broad ignores instead of fixing them.
  - Do not add `// ignore` or `as dynamic` hacks for avoidable analyzer issues.
  - Do not broaden scope while cleaning up.

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Verification/cleanup task with concrete commands and limited fixes.
  - **Skills**: []
  - **Skills Evaluated but Omitted**:
    - `git-master`: Commit creation is optional and orchestrator-controlled; not needed for cleanup itself.

  **Parallelization**:
  - **Can Run In Parallel**: NO
  - **Parallel Group**: Wave 3 final cleanup
  - **Blocks**: Final Verification Wave
  - **Blocked By**: Tasks 9, 10

  **References**:
  - `analysis_options.yaml` - Analyzer/lint rules to satisfy.
  - `pubspec.yaml` - Test/lint dependency context.
  - `lib/presentation/screens/dashboard_screen.dart` - Main changed file to inspect.
  - `test/` - Tests to run and verify.

  **Acceptance Criteria**:
  - [ ] `flutter analyze` passes or has no new issues caused by this work.
  - [ ] `flutter test` passes.
  - [ ] Evidence files for task QA scenarios exist.
  - [ ] Final diff contains no extra screens, live data wiring, or unnecessary dependencies.

  **QA Scenarios**:
  ```text
  Scenario: Analyzer and tests pass
    Tool: Bash
    Preconditions: All implementation and widget tests complete.
    Steps:
      1. Run `flutter analyze`.
      2. Run `flutter test`.
      3. Capture terminal output for both commands.
    Expected Result: Analysis and tests pass with no new dashboard-related failures.
    Failure Indicators: Analyzer errors, failing tests, or ignored warnings introduced by the dashboard.
    Evidence: .sisyphus/evidence/task-11-analyze-test.txt

  Scenario: Final scope guardrails hold
    Tool: Bash/git diff inspection
    Preconditions: All code changes complete.
    Steps:
      1. Inspect final changed files.
      2. Confirm no new dependency was added for glassmorphism/glow.
      3. Confirm no live data service/provider/model wiring was added.
      4. Confirm no extra onboarding/demo screens were added.
    Expected Result: Diff is scoped to dashboard/home UI and tests.
    Failure Indicators: Unrequested dependencies, live data integrations, extra routes/screens, or navigation rewrites.
    Evidence: .sisyphus/evidence/task-11-scope-check.txt
  ```

  **Evidence to Capture**:
  - [ ] `task-11-analyze-test.txt`
  - [ ] `task-11-scope-check.txt`

  **Commit**: YES
  - Message: `chore(dashboard): verify premium home screen`
  - Files: changed implementation/test files
  - Pre-commit: `flutter analyze && flutter test`

---

## Final Verification Wave (MANDATORY — after ALL implementation tasks)

> 4 review agents run in PARALLEL. ALL must APPROVE. Present consolidated results to user and get explicit "okay" before completing.
>
> **Do NOT auto-proceed after verification. Wait for user's explicit approval before marking work complete.**
> **Never mark F1-F4 as checked before getting user's okay.** Rejection or user feedback -> fix -> re-run -> present again -> wait for okay.

- [ ] F1. **Plan Compliance Audit** — `oracle`
  Read the plan end-to-end. For each "Must Have": verify implementation exists through source inspection and app/widget execution. For each "Must NOT Have": search codebase for forbidden scope creep and dependency additions. Check evidence files exist in `.sisyphus/evidence/`. Compare deliverables against plan.
  Output: `Must Have [N/N] | Must NOT Have [N/N] | Tasks [N/N] | VERDICT: APPROVE/REJECT`

- [ ] F2. **Code Quality Review** — `unspecified-high`
  Run `flutter analyze` and `flutter test`. Review changed Dart files for unused imports, overly generic helper names, excessive comments, layout hacks, hard-to-maintain magic numbers, and unnecessary dependencies. Confirm constructor contracts remain compatible.
  Output: `Analyze [PASS/FAIL] | Tests [N pass/N fail] | Files [N clean/N issues] | VERDICT`

- [ ] F3. **Real Visual Manual QA** — `unspecified-high`
  Start from clean state. Run the Flutter app in a mobile portrait viewport/emulator/web target where available. Execute EVERY QA scenario from EVERY task and capture screenshots under `.sisyphus/evidence/final-qa/`. Verify visual hierarchy, dark theme, emerald accents, no clutter, bottom nav, and static content.
  Output: `Scenarios [N/N pass] | Visual Checks [N/N] | Evidence [paths] | VERDICT`

- [ ] F4. **Scope Fidelity Check** — `deep`
  For each task: compare "What to do" against actual diff. Verify all requested UI elements exist and no extra screens, live data wiring, or navigation rewrites were added. Check "Must NOT do" compliance and flag unaccounted changes.
  Output: `Tasks [N/N compliant] | Scope Creep [CLEAN/N issues] | Unaccounted [CLEAN/N files] | VERDICT`

---

## Commit Strategy

- **Commit 1**: `feat(dashboard): add premium wellness home screen` — dashboard screen, supporting widgets/tokens, nav preservation.
- **Commit 2**: `test(dashboard): cover premium home content` — widget tests and QA evidence references if repository convention allows evidence tracking.

---

## Success Criteria

### Verification Commands
```bash
flutter analyze
# Expected: No issues found, or no new issues introduced by this work.

flutter test
# Expected: All tests pass.
```

### Final Checklist
- [ ] Actual Home tab displays the premium dashboard.
- [ ] All specified sections and copy are present.
- [ ] Visual style is dark, calm, premium, futuristic, and emerald-accented.
- [ ] Bottom nav has five tabs and Home active state.
- [ ] Static mock data only; no live data wiring.
- [ ] Widget tests pass.
- [ ] Visual QA evidence files exist.
- [ ] Final verification agents approve and user gives explicit okay.
