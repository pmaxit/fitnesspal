#!/bin/bash

# FitnessPal Web Server Script
# Builds and serves the Flutter web app

set -e

echo "🏗️  Building FitnessPal for web..."
flutter build web --release

echo ""
echo "✅ Build complete!"
echo ""
echo "🌐 Starting web server on http://localhost:8000"
echo "   Press Ctrl+C to stop the server"
echo ""

cd build/web
python3 -m http.server 8000
