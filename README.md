# FitnessPal

A holistic wellness tracking app combining habit tracking, nutrition analysis, activity logging, BMI and calorie goals, AI meal insights, and smart coaching recommendations.

## Features

- **Dashboard**: Interactive 3D avatar visualization with time-based projections (Today, +4 weeks, +12 weeks)
- **Activity**: Chronological timeline of daily activities, sleep, heart rate, meals with photos, runs, supplements
- **Meals**: Macro tracking with ring visualization, AI-analyzed meal hero card, meal list
- **Habits**: Streak tracking, monthly heatmap calendar, habit list with category tags
- **Profile**: User metrics, wellness score ring, device integrations (Apple Health, WHOOP, Garmin, Fitbit)

## Design System

Built on the **NeetPractice** design system with:
- **Accent Color**: Emerald green (#10B981)
- **Status Colors**: Easy (green), Medium (amber), Hard (red)
- **Themes**: Both dark and light modes with toggle
- **Density**: Compact, comfortable, and default options
- **Typography**: Inter font family with 11 font weights
- **Components**: Glass cards, progress rings, timeline, heat map, macro bars

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd fitnesspal
```

2. Get dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Project Structure

```
lib/
├── main.dart                 # Entry point
├── core/
│   └── theme/
│       ├── app_theme.dart    # Material theme configuration
│       └── colors.dart       # Color palette tokens
├── presentation/
│   ├── app.dart              # Root app widget with theme toggle
│   ├── screens/
│   │   ├── home_screen.dart  # Bottom nav controller
│   │   ├── dashboard_screen.dart
│   │   ├── activity_screen.dart
│   │   ├── meals_screen.dart
│   │   ├── habits_screen.dart
│   │   └── profile_screen.dart
│   └── widgets/
│       ├── avatar.dart       # 3D body visualization
│       └── progress_ring.dart # SVG-based progress rings
```

## Architecture

The app follows a screen-based architecture with:
- **Colors**: Centralized color tokens for both themes
- **Theme**: Material 3 theming with custom text styles
- **Widgets**: Reusable components (progress rings, avatar, timeline items)
- **Screens**: Tab-based navigation with independent state management

## Customization

### Change Theme Colors

Edit `lib/core/theme/colors.dart` to modify the color palette. The design uses a strict emerald accent with soft gradients.

### Add New Screens

1. Create a new screen file in `lib/presentation/screens/`
2. Add a new tab in `home_screen.dart`
3. Update the navigation logic

### Adjust Density

Modify `lib/core/theme/app_theme.dart` to change font sizes, spacing, and border radius values.

## Dependencies

- **fl_chart**: 0.68.0 - Charts and visualizations
- **intl**: 0.19.0 - Internationalization
- **smooth_page_indicator**: 1.1.0 - Page indicators

## License

Proprietary - FitnessPal Inc.

## Support

For issues or feature requests, please contact the development team.
