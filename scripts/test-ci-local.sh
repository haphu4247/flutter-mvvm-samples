#!/bin/bash

# Local CI/CD Test Script for macOS
# This script runs the same checks as the CI/CD pipeline locally

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Check macOS version
check_macos_version() {
    print_step "Checking macOS version..."
    MACOS_VERSION=$(sw_vers -productVersion)
    print_success "Running on macOS $MACOS_VERSION"
}

# Check if Flutter is installed
check_flutter() {
    print_step "Checking Flutter installation..."
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed or not in PATH"
        exit 1
    fi
    FLUTTER_VERSION=$(flutter --version | head -n 1)
    print_success "Flutter found: $FLUTTER_VERSION"
}

# Clean previous builds
clean_project() {
    print_step "Cleaning project..."
    flutter clean
    print_success "Project cleaned"
}

# Install dependencies
install_dependencies() {
    print_step "Installing dependencies..."
    flutter pub get
    print_success "Dependencies installed"
}

# Generate localization files
generate_localizations() {
    print_step "Generating localization files..."
    flutter gen-l10n
    print_success "Localization files generated"
}

# Analyze code
analyze_code() {
    print_step "Analyzing code..."
    if flutter analyze; then
        print_success "Code analysis passed"
    else
        print_error "Code analysis failed"
        exit 1
    fi
}

# Check code formatting
check_formatting() {
    print_step "Checking code formatting..."
    if dart format --set-exit-if-changed .; then
        print_success "Code formatting is correct"
    else
        print_error "Code formatting issues found. Run 'dart format .' to fix."
        exit 1
    fi
}

# Run tests
run_tests() {
    print_step "Running tests..."
    if flutter test --coverage; then
        print_success "All tests passed"
    else
        print_error "Tests failed"
        exit 1
    fi
}


# Build for iOS (macOS only)
build_android() {
    print_step "Building iOS app..."
    if flutter build apk -t lib/main_dev.dart --release --no-codesign; then
        print_success "Android build completed"
    else
        print_error "Android build failed"
        exit 1
    fi
}

# Build for iOS (macOS only)
# build_ios() {
#     print_step "Building iOS app..."
#     if flutter build ios -t lib/main_dev.dart --release --no-codesign; then
#         print_success "iOS build completed"
#     else
#         print_error "iOS build failed"
#         exit 1
#     fi
# }


# Main execution
main() {
    echo ""
    echo "=========================================="
    echo "  Flutter CI/CD Local Test Script"
    echo "=========================================="
    echo ""

    # Parse command line arguments
    SKIP_BUILD=false
    BUILD_PLATFORM="all"
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --skip-build)
                SKIP_BUILD=true
                shift
                ;;
            --platform)
                BUILD_PLATFORM="$2"
                shift 2
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --skip-build    Skip build steps (only run tests and analysis)"
                echo "  --platform      Build for specific platform (ios, macos, web, all)"
                echo "  --help          Show this help message"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done

    # Run CI steps
    check_macos_version
    check_flutter
    clean_project
    install_dependencies
    generate_localizations
    analyze_code
    check_formatting
    run_tests

    # Build steps (optional)
    if [ "$SKIP_BUILD" = false ]; then
        case $BUILD_PLATFORM in
            ios)
                build_ios
                ;;
            macos)
                build_macos
                ;;
            web)
                build_web
                ;;
            all)
                build_ios
                build_macos
                build_web
                ;;
            *)
                print_warning "Unknown platform: $BUILD_PLATFORM. Skipping build."
                ;;
        esac
    else
        print_warning "Build steps skipped (--skip-build flag)"
    fi

    echo ""
    echo "=========================================="
    print_success "All CI/CD checks passed!"
    echo "=========================================="
    echo ""
}

# Run main function
main "$@"

