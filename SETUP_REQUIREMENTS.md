# Setup Requirements & Critical Information

## Important: Gradle Wrapper Generation

When you clone this repository, the **Gradle wrapper files are NOT included** (they are gitignored as binary files). Flutter will automatically generate them when you run your first Flutter command.

### Required Steps After Clone:

```bash
# 1. Navigate to project
cd campaign_manager

# 2. This command generates ALL missing files:
flutter pub get

# Flutter will automatically create:
# - android/gradlew
# - android/gradlew.bat
# - android/gradle/wrapper/gradle-wrapper.jar
# - android/.gradle/ (build cache)
```

### If `flutter pub get` Fails:

Try regenerating the Android project:

```bash
# Option 1: Recreate Android folder
rm -rf android/
flutter create --platforms=android .

# Option 2: Use flutter to generate missing files
flutter doctor -v
flutter precache
flutter pub get
```

---

## local.properties Configuration

Create `/android/local.properties` with your SDK paths:

```properties
# Linux
sdk.dir=/home/YOUR_USERNAME/Android/Sdk
flutter.sdk=/home/YOUR_USERNAME/flutter

# macOS
sdk.dir=/Users/YOUR_USERNAME/Library/Android/sdk
flutter.sdk=/Users/YOUR_USERNAME/flutter

# Windows
sdk.dir=C:\\Users\\YOUR_USERNAME\\AppData\\Local\\Android\\Sdk
flutter.sdk=C:\\Users\\YOUR_USERNAME\\flutter
```

Or let Flutter create it automatically:
```bash
flutter config --android-sdk /path/to/Android/Sdk
flutter doctor
```

---

## Pre-Interview Checklist

### 1. Environment Setup
- [ ] Flutter SDK installed (3.16+)
- [ ] Android SDK installed (API 21+)
- [ ] `flutter doctor` shows all green checks
- [ ] Android emulator or physical device available

### 2. Project Setup
```bash
git clone <repo-url> campaign_manager
cd campaign_manager
flutter pub get          # Generates gradle wrapper
flutter analyze          # Should show no issues
```

### 3. First Run
```bash
flutter run              # First build takes 3-5 minutes
```

### 4. Release Build
```bash
flutter build apk --release
# APK at: build/app/outputs/flutter-apk/app-release.apk
```

---

## Common Issues & Solutions

### Issue: "Gradle wrapper not found"
```bash
# Flutter generates this automatically
flutter pub get
```

### Issue: "local.properties not found"
```bash
# Create the file with your SDK paths
cp android/local.properties.template android/local.properties
# Edit with your actual paths
```

### Issue: "Android SDK not found"
```bash
flutter config --android-sdk /path/to/Android/Sdk
flutter doctor
```

### Issue: "CMake/NDK errors"
```bash
# Install missing Android SDK components
sdkmanager "cmake;3.22.1" "ndk;25.1.8937393"
```

### Issue: "Dependency resolution failed"
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

---

## What Gets Generated

When you run `flutter pub get` for the first time, Flutter generates:

**Android files:**
- `android/gradlew` - Gradle wrapper script (Unix)
- `android/gradlew.bat` - Gradle wrapper script (Windows)
- `android/gradle/wrapper/gradle-wrapper.jar` - Gradle wrapper JAR
- `android/.gradle/` - Gradle build cache
- `android/local.properties` - SDK paths (if flutter config is set)

**Flutter files:**
- `.dart_tool/` - Dart tool configuration
- `.flutter-plugins` - Plugin configuration
- `.flutter-plugins-dependencies` - Plugin dependencies
- `pubspec.lock` - Locked dependency versions

---

## Files Intentionally Not in Git

These files are correctly gitignored:

```
# Binary/generated files
android/gradlew
android/gradlew.bat
android/gradle/wrapper/gradle-wrapper.jar
android/.gradle/
android/app/build/
android/local.properties
.dart_tool/
build/
pubspec.lock
*.g.dart
```

This is **correct practice** - these files should be generated locally.

---

## Verification Commands

```bash
# Check Flutter setup
flutter doctor -v

# Verify project structure
ls -la android/
# After flutter pub get, should see:
# gradlew, gradlew.bat, gradle/, app/, build.gradle, etc.

# Verify dependencies
flutter pub deps

# Check for issues
flutter analyze

# Test app runs
flutter run --debug
```

---

## Emergency: Minimal Setup Script

```bash
#!/bin/bash
# Save as setup.sh and run: bash setup.sh

echo "Setting up Campaign Manager..."

# Check Flutter installed
if ! command -v flutter &> /dev/null; then
    echo "ERROR: Flutter not installed"
    exit 1
fi

# Clean start
flutter clean

# Get dependencies (generates gradle wrapper)
flutter pub get

# Verify
echo ""
echo "=== Verification ==="
ls -la android/gradlew 2>/dev/null && echo "✓ gradlew exists" || echo "✗ gradlew missing"
ls -la android/gradle/wrapper/gradle-wrapper.jar 2>/dev/null && echo "✓ gradle-wrapper.jar exists" || echo "✗ gradle-wrapper.jar missing"

# Check local.properties
if [ ! -f android/local.properties ]; then
    echo "⚠ android/local.properties missing - will be created on first build"
fi

echo ""
echo "Setup complete! Run: flutter run"
```

---

## Quick Start Summary

1. **Clone** the repository
2. **Run** `flutter pub get` (generates missing files)
3. **Create** `android/local.properties` if needed
4. **Run** `flutter run`

The app will compile and run with pre-seeded demo data.
