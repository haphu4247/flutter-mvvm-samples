#!/bin/bash

# Test Coverage Script for Flutter
# Generates test coverage report and opens it in a browser

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

# Run tests with coverage
print_step "Running tests with coverage..."
if flutter test --coverage; then
    print_success "Tests completed successfully"
else
    print_error "Tests failed"
    exit 1
fi

# Check if lcov is installed
if ! command -v lcov &> /dev/null; then
    print_warning "lcov is not installed. Installing HTML coverage viewer..."
    
    # Try to install lcov based on OS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            print_step "Installing lcov via Homebrew..."
            brew install lcov
        else
            print_error "Homebrew not found. Please install lcov manually:"
            print_error "  brew install lcov"
            exit 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        print_step "Installing lcov via apt-get..."
        sudo apt-get update && sudo apt-get install -y lcov
    else
        print_error "Unsupported OS. Please install lcov manually."
        exit 1
    fi
fi

# Generate HTML coverage report
print_step "Generating HTML coverage report..."

# Function to try generating HTML report
generate_html_report() {
    genhtml coverage/lcov.info -o coverage/html --no-function-coverage --no-branch-coverage 2>&1
}

# Try to generate the report
if generate_html_report > /dev/null 2>&1; then
    print_success "Coverage report generated"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - check for perl path issues with lcov
    print_warning "genhtml may have perl path issues on macOS"
    print_step "Attempting to fix perl path issue..."
    
    # Try to find the actual genhtml script and fix perl path
    GENHTML_PATH=$(which genhtml)
    if [ -f "$GENHTML_PATH" ]; then
        # Try to use the system perl instead
        PERL=$(which perl)
        if [ -n "$PERL" ]; then
            # Create a temporary wrapper or use perl directly
            print_step "Using system perl: $PERL"
            # Try generating without the problematic flags first
            if $PERL -e 'exit 0' 2>/dev/null; then
                # Simple approach: just generate with minimal options
                if genhtml coverage/lcov.info -o coverage/html 2>/dev/null; then
                    print_success "Coverage report generated (with workaround)"
                else
                    print_error "Failed to generate coverage report"
                    print_error ""
                    print_error "To fix this issue, try:"
                    print_error "  1. Reinstall lcov: brew reinstall lcov"
                    print_error "  2. Or view coverage summary: lcov --summary coverage/lcov.info"
                    print_error "  3. Or use online tools to view lcov.info file"
                    exit 1
                fi
            else
                print_error "Perl is not working correctly"
                exit 1
            fi
        fi
    fi
else
    # For other OS, just try the normal way
    if generate_html_report; then
        print_success "Coverage report generated"
    else
        print_error "Failed to generate coverage report"
        exit 1
    fi
fi

# Verify report was created
if [ -d "coverage/html" ] && [ -f "coverage/html/index.html" ]; then
    print_success "Coverage report generated successfully"
else
    print_error "Coverage report directory was not created"
    exit 1
fi

# Display coverage summary
print_step "Coverage Summary:"
if command -v lcov &> /dev/null; then
    lcov --summary coverage/lcov.info 2>&1 | grep -E "lines|functions|branches"
fi

# Open coverage report in browser
print_step "Opening coverage report in browser..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    open coverage/html/index.html
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    xdg-open coverage/html/index.html 2>/dev/null || sensible-browser coverage/html/index.html 2>/dev/null || echo "Please open coverage/html/index.html manually"
else
    # Windows or other
    print_step "Please open coverage/html/index.html in your browser"
fi

print_success "Coverage report location: coverage/html/index.html"
