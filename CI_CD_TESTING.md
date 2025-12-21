# CI/CD Testing Guide

This guide explains how to test the CI/CD pipeline locally on macOS.

## Quick Start

### Option 1: Using the Local Test Script (Recommended)

The easiest way to test CI/CD locally is using the provided script:

```bash
# Run all CI/CD checks (analysis, tests, and builds)
./scripts/test-ci-local.sh

# Run only tests and analysis (skip builds)
./scripts/test-ci-local.sh --skip-build

# Build for specific platform
./scripts/test-ci-local.sh --platform ios
./scripts/test-ci-local.sh --platform macos
./scripts/test-ci-local.sh --platform web

# Build for all platforms
./scripts/test-ci-local.sh --platform all
```

### Option 2: Using GitHub Actions Locally with `act`

`act` is a tool that allows you to run GitHub Actions workflows locally using Docker.

#### Installation

```bash
# Install act using Homebrew
brew install act

# Or using the install script
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
```

#### Usage

```bash
# List available workflows
act -l

# Run a specific workflow
act

# Run a specific job
act -j analyze
act -j test
act -j build-ios

# Run with specific event
act push
act pull_request

# Run with environment variables
act --env-file .env
```

**Note:** `act` requires Docker to be running. Some jobs (like iOS builds) may not work perfectly with `act` since they require macOS runners.

### Option 3: Manual Step-by-Step Testing

You can also run each CI step manually:

```bash
# 1. Clean and install dependencies
flutter clean
flutter pub get
flutter gen-l10n

# 2. Analyze code
flutter analyze

# 3. Check formatting
dart format --set-exit-if-changed .

# 4. Run tests
flutter test --coverage

# 5. Build for iOS
flutter build ios --release --no-codesign

# 6. Build for macOS
flutter build macos --release

# 7. Build for Web
flutter build web --release
```

## macOS Version Support

- **GitHub Actions**: Currently uses `macos-15` (macOS Sequoia) - the latest available runner
- **Local Testing**: The test script works on any macOS version, including macOS 26.1 (Tahoe)
- **Note**: If you're running macOS 26.1 locally, you can test all CI/CD steps using the local script, which will run on your actual macOS version

## CI/CD Pipeline Overview

The CI/CD pipeline includes the following jobs:

### 1. **Analyze** (Ubuntu)
- Checks out code
- Sets up Flutter
- Installs dependencies
- Generates localization files
- Runs code analysis
- Checks code formatting

### 2. **Test** (Ubuntu)
- Checks out code
- Sets up Flutter
- Installs dependencies
- Generates localization files
- Runs all tests with coverage
- Uploads coverage to Codecov (optional)

### 3. **Build Android** (Ubuntu)
- Builds Android APK
- Builds Android App Bundle
- Uploads artifacts

### 4. **Build iOS** (macOS 15)
- Builds iOS app (no codesign)
- Uploads build artifacts
- **Note**: Runs on `macos-15` runner (latest available on GitHub Actions)

### 5. **Build Web** (Ubuntu)
- Builds web app
- Uploads build artifacts

### 6. **Build macOS** (macOS 15)
- Builds macOS app
- Uploads build artifacts
- **Note**: Runs on `macos-15` runner (latest available on GitHub Actions)

## Testing Specific Scenarios

### Test Before Committing

```bash
# Quick check before committing
./scripts/test-ci-local.sh --skip-build
```

### Test Full Build Pipeline

```bash
# Test all builds (may take longer)
./scripts/test-ci-local.sh --platform all
```

### Test Individual Platforms

```bash
# Test iOS build only
./scripts/test-ci-local.sh --platform ios

# Test macOS build only
./scripts/test-ci-local.sh --platform macos

# Test Web build only
./scripts/test-ci-local.sh --platform web
```

## Troubleshooting

### Flutter Not Found
If you get "Flutter is not installed", make sure Flutter is in your PATH:
```bash
export PATH="$PATH:/path/to/flutter/bin"
```

### CocoaPods Issues (iOS)
If you encounter CocoaPods issues:
```bash
cd ios
pod install
cd ..
```

### Build Failures
- Ensure all dependencies are installed: `flutter pub get`
- Clean the project: `flutter clean`
- Check Flutter doctor: `flutter doctor`

### Permission Denied
If the script is not executable:
```bash
chmod +x scripts/test-ci-local.sh
```

## GitHub Actions Workflow

The workflow file is located at `.github/workflows/ci.yml`. It automatically runs on:
- Push to `main`, `develop`, or `master` branches
- Pull requests to these branches
- Manual trigger via GitHub Actions UI

## Continuous Integration Best Practices

1. **Run tests locally before pushing**: Use `./scripts/test-ci-local.sh --skip-build`
2. **Fix formatting issues**: Run `dart format .` before committing
3. **Check analysis**: Run `flutter analyze` to catch issues early
4. **Test builds**: Run full builds before creating a release

## Next Steps

- Set up code coverage reporting (Codecov, Coveralls)
- Configure automated releases
- Add deployment steps for different environments
- Set up notifications (Slack, email, etc.)

