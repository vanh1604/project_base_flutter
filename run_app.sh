#!/bin/bash

# Stephen King Books App - Run Script
# This script helps you run the app on different devices

echo "🚀 Stephen King Books App"
echo "========================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -1)"
echo ""

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ Failed to get dependencies"
    exit 1
fi

echo "✅ Dependencies installed"
echo ""

# Show available devices
echo "📱 Available devices:"
flutter devices
echo ""

# Ask user which device to run on
echo "Select a device:"
echo "1) macOS Desktop"
echo "2) iOS Simulator"
echo "3) Chrome Browser"
echo "4) Auto-select"
echo ""

read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo "🖥️  Running on macOS..."
        flutter run -d macos
        ;;
    2)
        echo "📱 Running on iOS Simulator..."
        flutter run -d iphone
        ;;
    3)
        echo "🌐 Running on Chrome..."
        flutter run -d chrome
        ;;
    4)
        echo "🎯 Auto-selecting device..."
        flutter run
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac
