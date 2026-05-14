# FitnessPal Design Implementation Notes

## Design System

### Color Palette

#### Dark Theme (Primary)
- Background: `#020617` (darkest slate)
- Card Surface: `rgba(30, 41, 59, 0.55)` (glass effect)
- Foreground 1 (Text): `#F1F5F9` (light gray)
- Foreground 2 (Secondary): `#94A3B8` (medium gray)
- Foreground 3 (Tertiary): `#64748B` (dim gray)

#### Light Theme
- Background: `#F6F7F9` (soft off-white)
- Card Surface: `#FFFFFF` (white)
- Foreground 1 (Text): `#0F172A` (dark blue-gray)
- Foreground 2 (Secondary): `#475569` (medium blue-gray)
- Foreground 3 (Tertiary): `#64748B` (dim blue-gray)

#### Accent Colors
- Primary Accent: `#10B981` (Emerald Green)
- Status Easy: `#10B981` (Emerald)
- Status Medium: `#F59E0B` (Amber)
- Status Hard/Danger: `#EF4444` (Red)

### Visual Elements

#### Spacing Scale
- XS: 4px
- SM: 6px
- MD: 8px
- LG: 10px
- XL: 12px
- 2XL: 16px
- 3XL: 20px

#### Border Radius
- XS: 4px
- SM: 6px
- MD: 8px
- LG: 10px
- XL: 12px
- 2XL: 16px
- 3XL: 20px
- PILL: 9999px

#### Typography
- Font Family: Inter (with fallback to system fonts)
- Display Large: 32px, 900 weight
- Display Medium: 28px, 800 weight
- Headline Small: 24px, 700 weight
- Title Large: 20px, 700 weight
- Title Medium: 18px, 700 weight
- Title Small: 14px, 600 weight
- Body Large: 16px, 400 weight
- Body Medium: 14px, 400 weight
- Body Small: 12px, 400 weight
- Label Large: 14px, 600 weight
- Label Medium: 12px, 600 weight
- Label Small: 11px, 700 weight (all caps, 0.1em letter-spacing)

### Components

#### Progress Rings (SVG)
- Stroke Width: 6px (dashboard), 5px (tiles), 4px (wellness)
- Stroke Cap: Round
- Background Track: Border color with opacity
- Fill: Accent color with shadow filter

#### Glass Cards
- Backdrop Filter: `blur(20px) saturate(180%)`
- Border: 1px solid rgba(border-color)
- Border Radius: 16px or 20px

#### Timeline
- Spine: 2px solid border
- Dot: 12px circle with 3px border
- Dot Colors: Accent (default), Amber (warning), Muted (disabled)
- Card Icon: 28px square with rounded corners

#### Heat Map Calendar
- Cell Size: Aspect ratio 1:1
- Grid: 7 columns, 4px gap
- 5-level intensity: 0%, 20%, 45%, 70%, 100%

#### FAB (Floating Action Button)
- Size: 60px circle
- Position: Bottom right, 18px from edge, above nav bar
- Shadow: 0 12px 28px accent-glow, outer ring 6px accent-soft

### Interactions

#### Time Slider (Avatar)
- 3 States: Today, +4 weeks, +12 weeks
- Active State: Accent background, white text
- Animation: 0.35s cubic-bezier(0.4, 0, 0.2, 1)

#### Tab Navigation
- Active Tab: Accent color text + icon
- Inactive Tab: Tertiary color text + icon
- Animation: Icon translateY -1px

#### Density Modes
- Compact: 12px padding, 8px gaps, 10px row padding
- Default: 16px padding, 12px gaps, 14px row padding
- Comfortable: 18px padding, 14px gaps, 16px row padding

## Implementation Details

### Avatar Component

The stylized body visualization uses:
- Layered gradient for 3D appearance
- Glowing effect with radial gradient
- Separate zones for head, torso, and legs
- Color intensity changes based on time projection

### Screen Layouts

Each screen follows this structure:
1. Header (eyebrow, title, subtitle)
2. Main content area (scrollable)
3. Bottom spacing (clear tab bar)

### Navigation

- Bottom tab bar with 5 tabs: Dashboard, Activity, Meals, Habits, Profile
- Tab icons use Material Design icons
- Active tab highlighted in accent color
- FAB only visible on Meals screen

## Accessibility Considerations

- Color contrast ratios meet WCAG AA standards
- Text sizes minimum 11px for body text, 14px for primary content
- Touch targets minimum 44x44 dp (iOS) / 48x48 dp (Android)
- Clear visual feedback for interactive elements
- Letter-spacing and line-height for readability

## Performance Notes

- Use CustomPaint for progress rings instead of image assets
- Gradient calculations are applied in theme, not per-widget
- SVG-like shapes built with Flutter's drawing APIs
- Smooth animations use cubic-bezier easing
