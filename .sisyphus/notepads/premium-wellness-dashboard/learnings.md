# Premium Wellness Dashboard - Learnings

## Task 4: Bottom Navigation Preservation

- `home_screen.dart` uses a custom `Row` of `_navTab` widgets (not Material `BottomNavigationBar`)
- 5 tabs confirmed: Home, Activity, Meals, Habits, Profile
- Home tab is at index 0 with `_selectedTab = 0` (active by default)
- Active color uses `AppColors.accent` (emerald `#10B981`) — already correct
- DashboardScreen is at index 0 — already correct
- **Change made**: Renamed first tab label from `'Dashboard'` to `'Home'` (line 68)
- No other changes needed — navigation architecture preserved
- LSP diagnostics: clean after change
