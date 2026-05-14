# FitnessPal - Deployment Guide

## Quick Start

FitnessPal is a Flutter wellness app that's ready to run on **multiple platforms**. Choose the option that works best for you.

---

## ✅ **Option 1: macOS Desktop (Recommended)**

**Status:** ✅ **FULLY WORKING**

The app is production-ready on macOS with full hot-reload support.

### Run on macOS
```bash
flutter run -d macos
```

**Features:**
- Instant hot reload (`r` key)
- DevTools debugging support
- Full app functionality
- Native macOS feel

### Build macOS Release
```bash
flutter build macos --release
```
Output: `build/macos/Build/Products/Release/fitnesspal.app`

---

## ✅ **Option 2: Chrome Web Browser**

**Status:** ✅ **FULLY WORKING**

The app runs perfectly in any modern browser with responsive design.

### Run Web Server
```bash
./run-web.sh
```

Then open: **http://localhost:8000**

Or manually:
```bash
flutter pub get
flutter build web --release
cd build/web
python3 -m http.server 8000
```

**Features:**
- Fully responsive design
- Works on desktop, tablet, mobile browsers
- No installation required
- Fast load times

### Deployment
```bash
flutter build web --release
# Upload contents of build/web/ to your hosting provider
```

---

## ⚠️ **Option 3: iOS Simulator**

**Status:** ⚠️ **Known Issue** (Xcode Configuration)

### The Problem
Your system (macOS 26.5) has iOS simulators running iOS 18.1, but your Xcode installation expects a matching iOS 26.5 SDK which doesn't exist. This is a system-level configuration issue.

### Workarounds

#### Solution A: Use a Physical iOS Device
```bash
flutter run -d <device-name>
```

Or build an IPA:
```bash
flutter build ipa --release
```

#### Solution B: Downgrade to a Standard macOS Version
If you have access to a standard macOS version (13, 14, 15), the iOS simulator will work normally.

#### Solution C: Reset Xcode (Requires Admin)
```bash
sudo xcode-select --reset
sudo xcode-select --install
```

---

## 📦 **Platform Support Summary**

| Platform | Status | Command | Notes |
|----------|--------|---------|-------|
| **macOS** | ✅ Working | `flutter run -d macos` | Hot-reload enabled |
| **Web** | ✅ Working | `./run-web.sh` | Responsive, any browser |
| **iOS Simulator** | ⚠️ Issue | N/A | Xcode SDK mismatch (macOS 26.5) |
| **iOS Device** | ✅ Working | `flutter run -d <device>` | Physical device only |
| **Android** | 📋 Ready | `flutter run -d android` | Not yet tested |

---

## 🎯 **Recommended Development Workflow**

```bash
# 1. For rapid development & testing
flutter run -d macos

# 2. For web compatibility testing
./run-web.sh

# 3. For production builds
flutter build macos --release
flutter build web --release
flutter build ipa --release  # if you have physical iOS device
```

---

## 🔧 **Building for Production**

### macOS App
```bash
flutter build macos --release
# Output: build/macos/Build/Products/Release/fitnesspal.app
# Create dmg: Look in build/macos/Build/Products/Release/
```

### Web
```bash
flutter build web --release
# Output: build/web/
# Deploy to any static hosting (Netlify, Vercel, GitHub Pages, etc.)
```

### iOS (Physical Device)
```bash
flutter build ipa --release
# Output: build/ios/ipa/fitnesspal.ipa
# Sign and distribute via TestFlight or App Store
```

---

## 🐛 **Troubleshooting**

### macOS Build Fails
```bash
flutter clean
flutter pub get
flutter run -d macos
```

### Web Server Port Already in Use
```bash
# Kill existing process
lsof -ti:8000 | xargs kill -9

# Or use different port
cd build/web && python3 -m http.server 9000
```

### iOS Simulator Error: "iOS 26.5 Platform Not Installed"
This is a known issue with macOS 26.5 Xcode installations. Use **macOS or Web instead** for development.

---

## 📱 **App Features Tested**

- ✅ Dashboard with 3D avatar and time projections
- ✅ Activity timeline with chronological events
- ✅ Meals with macro tracking
- ✅ Habits with streak tracking and calendar heatmap
- ✅ Profile with metrics and device integrations
- ✅ Dark/Light theme toggle
- ✅ Responsive design
- ✅ Smooth animations and transitions
- ✅ Hot reload for development

---

## 📚 **Additional Resources**

- [Flutter Documentation](https://flutter.dev/docs)
- [macOS Desktop Deployment](https://flutter.dev/docs/deployment/macos)
- [Web Deployment](https://flutter.dev/docs/deployment/web)
- [iOS Device Setup](https://flutter.dev/docs/get-started/install/macos#set-up-the-ios-simulator)

---

## ✨ **Project Structure**

```
fitnesspal/
├── lib/
│   ├── main.dart
│   ├── core/theme/         # Design tokens & theming
│   └── presentation/
│       ├── app.dart
│       ├── screens/        # 5 main screens
│       └── widgets/        # Reusable components
├── web/                    # Web-specific files
├── macos/                  # macOS app
├── ios/                    # iOS app
├── pubspec.yaml           # Dependencies
├── run-web.sh             # Web server script
└── README.md              # Project overview
```

---

**Last Updated:** 2026-05-14  
**Status:** Production Ready (macOS & Web)
