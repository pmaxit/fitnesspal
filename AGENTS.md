# PROJECT KNOWLEDGE BASE

**Generated:** 2026-05-14
**Stack:** Flutter 3.x / Dart 3.x
**App:** FitnessPal

## OVERVIEW

Wellness tracking platform combining fitness logging, nutrition analysis, habit tracking, and AI-powered insights. Single-module Flutter app using Material 3 design with custom dark/light theming.

## STRUCTURE

```
lib/
├── main.dart                          # Entry: runApp(FitnessPalApp)
├── core/
│   └── theme/
│       ├── app_theme.dart             # Dark/light ThemeData + radius tokens
│       └── colors.dart                # AppColors: accent, status, full dark/light palette
└── presentation/
    ├── app.dart                       # FitnessPalApp (theme/density state)
    ├── screens/                       # 5-tab bottom nav
    │   ├── dashboard_screen.dart      # Wellness score, metric cards, AI insight
    │   ├── activity_screen.dart       # Period-selector (Day/Week/Month)
    │   ├── meals_screen.dart          # Macro ring, meal cards
    │   ├── habits_screen.dart         # Streak tracker, habit list
    │   └── profile_screen.dart        # User avatar, settings list
    └── widgets/
        ├── progress_ring.dart         # CustomPaint ring with optional glow
        └── avatar.dart                # Stylized avatar with time-progression slider
test/
├── widget_test.dart                   # Smoke test (FitnessPalApp renders)
└── dashboard_screen_test.dart         # Dashboard + nav tab interaction tests
```

## WHERE TO LOOK

| Task | File(s) | Notes |
|------|---------|-------|
| App bootstrap | `lib/main.dart`, `lib/presentation/app.dart` | Entry point, theme/density toggles |
| Color system | `lib/core/theme/colors.dart` | Single source of truth for all colors |
| Theme tokens | `lib/core/theme/app_theme.dart` | Radius, dark/light ThemeData |
| Home/tab shell | `lib/presentation/screens/home_screen.dart` | Bottom nav bar, tab switching |
| Dashboard | `lib/presentation/screens/dashboard_screen.dart` | Largest file, wellness score + metrics |
| Reusable widgets | `lib/presentation/widgets/` | ProgressRing, AvatarWidget |
| Tests | `test/` | Flutter widget tests |

## CONVENTIONS

- **Theme propagation:** `isDarkMode` bool passed via constructor (no Provider/InheritedWidget)
- **Color usage:** Every screen derives local color vars from `AppColors` + `isDarkMode` at build top
- **State management:** `setState` only — no state management library
- **Navigation:** Tab index via `_selectedTab` int + widget array — no router
- **Linting:** `flutter_lints` with explicit error rules (`avoid_print`, `avoid_empty_else`, etc.)
- **Imports:** Package-relative (`package:fitnesspal/...`) — relative imports avoided
- **Key convention:** `Key? key` on all widget constructors

## ANTI-PATTERNS (THIS PROJECT)

- **Do NOT** add state management libraries without discussion — current `setState` is intentional
- **Do NOT** use `print()` — `avoid_print` lint is enabled
- **Do NOT** add routing dependencies — tab-based nav is sufficient for 5 screens
- **Do NOT** add new color constants outside `colors.dart` — AppColors is single source

## COMMANDS

```bash
flutter run                    # Run the app
flutter test                   # Run all tests
flutter analyze                # Static analysis
```

## NOTES

- DashboardScreen (539 lines) is the only file >500 lines — split if it grows further
- `graphify-out/` and `.claude/` contain pre-analyzed codebase graphs
- Material 3 (`useMaterial3: true`) with custom card shapes (radius2xl=16)
- Accent color: `#10B981` (emerald green) — used across all themes
