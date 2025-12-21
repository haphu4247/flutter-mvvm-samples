# GitHub Actions CI/CD Setup Guide

This project includes GitHub Actions workflows for continuous integration and continuous deployment.

## Workflows

### 1. `ci.yml` - Full CI/CD Pipeline
A comprehensive workflow that includes:
- **Test & Analyze**: Runs code formatting checks, static analysis, and tests
- **Build Android**: Builds APKs for all environments (dev, staging, prod)
- **Build iOS**: Builds iOS apps for all environments (requires macOS runner)
- **Build Web**: Builds web versions for all environments

**When it runs:**
- On push to `main` or `develop` branches
- On pull requests to `main` or `develop` branches

### 2. `ci-simple.yml` - Simple CI
A lightweight workflow that only runs:
- Code formatting verification
- Static analysis
- Tests

**When it runs:**
- On push to `main` branch
- On pull requests to `main` branch

## Getting Started

### Option 1: Use the Simple CI (Recommended for Start)
1. The `ci-simple.yml` workflow is ready to use
2. Just push your code to GitHub and it will run automatically
3. Check the "Actions" tab in your GitHub repository to see the results

### Option 2: Use the Full CI/CD Pipeline
1. The `ci.yml` workflow includes builds for all platforms
2. Note: iOS builds require a macOS runner (free tier has limited minutes)
3. You may want to disable iOS builds if you don't need them

## Customization

### Disable Specific Build Jobs
If you don't need certain builds, you can comment out or remove entire job blocks in `ci.yml`:

```yaml
# Comment out or remove this entire job block
# build-ios:
#   name: Build iOS
#   ...
```

### Add Flavor Support (Android)
If you want to use flavors for Android builds, you need to configure them in `android/app/build.gradle.kts`:

```kotlin
android {
    // ... existing config ...
    
    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
        }
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
        }
        create("prod") {
            dimension = "environment"
        }
    }
}
```

Then update the workflow to use `--flavor` flags:
```yaml
- name: Build Android APK (Dev)
  run: flutter build apk --release --flavor dev -t lib/main_dev.dart
```

### Add Flavor Support (iOS)
For iOS, you'll need to configure schemes in Xcode. Then update the workflow accordingly.

### Change Flutter Version
Update the `flutter-version` in the workflow files:
```yaml
- name: Set up Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.24.0'  # Change this
```

### Add Deployment Steps
You can add deployment steps after builds succeed. For example, to deploy to Firebase App Distribution:

```yaml
- name: Deploy to Firebase App Distribution
  uses: wzieba/Firebase-Distribution-Github-Action@v1
  with:
    appId: ${{ secrets.FIREBASE_APP_ID }}
    token: ${{ secrets.FIREBASE_TOKEN }}
    groups: testers
    file: build/app/outputs/flutter-apk/app-release.apk
```

## Secrets and Environment Variables

If you need to use secrets (API keys, signing certificates, etc.), add them in:
1. Go to your GitHub repository
2. Settings → Secrets and variables → Actions
3. Add your secrets there
4. Reference them in workflows using `${{ secrets.SECRET_NAME }}`

## Artifacts

The full CI workflow uploads build artifacts:
- Android APKs are available for 7 days after build
- Web builds are available for 7 days after build
- Download them from the Actions tab after a workflow run completes

## Troubleshooting

### Workflow fails on "Get dependencies"
- Make sure `pubspec.yaml` is valid
- Check if all dependencies are available on pub.dev

### Build fails
- Ensure your code compiles locally first
- Check if you need to configure signing for Android/iOS
- Verify flavor configurations if using flavors

### Tests fail
- Run `flutter test` locally to debug
- Make sure all test files follow the `*_test.dart` naming convention

## Next Steps

1. **Push to GitHub**: Commit and push these workflow files
2. **Monitor Runs**: Check the Actions tab to see workflows running
3. **Add Tests**: Create test files in a `test/` directory
4. **Customize**: Adjust workflows based on your project needs
5. **Add Deployment**: Configure deployment steps for your target platforms

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter CI/CD Guide](https://docs.flutter.dev/deployment/cd)
- [Flutter Action on GitHub](https://github.com/subosito/flutter-action)

