#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
APP_NAME="SleepBabySleep"
ENTITLEMENTS="${PROJECT_DIR}/${APP_NAME}/${APP_NAME}.entitlements"
CONFIGURATION="Release"

echo "=== Building ${APP_NAME} ==="
cd "$PROJECT_DIR"

BINARY_SRC=".build/release/${APP_NAME}"
if [ ! -f "$BINARY_SRC" ]; then
    swift build -c "release"
fi

BUILD_DIR="${PROJECT_DIR}/build/${CONFIGURATION}"
APP_BUNDLE="${BUILD_DIR}/${APP_NAME}.app"
CONTENTS="${APP_BUNDLE}/Contents"
MACOS="${CONTENTS}/MacOS"
RESOURCES="${CONTENTS}/Resources"

rm -rf "$APP_BUNDLE"
mkdir -p "$MACOS" "$RESOURCES"

cp "$BINARY_SRC" "${MACOS}/${APP_NAME}"
chmod +x "${MACOS}/${APP_NAME}"

cp "${PROJECT_DIR}/${APP_NAME}/Resources/Info.plist" "${CONTENTS}/Info.plist"

ASSETS_SRC="${PROJECT_DIR}/${APP_NAME}/Resources/Assets.xcassets"
if [ -d "$ASSETS_SRC" ]; then
    cp -R "$ASSETS_SRC" "${RESOURCES}/Assets.xcassets"
fi

# Apply entitlements with ad-hoc codesign for hardened runtime
if [ -f "$ENTITLEMENTS" ]; then
    cp "$ENTITLEMENTS" "${CONTENTS}/${APP_NAME}.entitlements"
    codesign --force --sign - --entitlements "$ENTITLEMENTS" --timestamp --options runtime "${APP_BUNDLE}" 2>/dev/null || true
fi

chmod -R a+rX "$APP_BUNDLE"

echo "=== Build complete ==="
echo "App: ${APP_BUNDLE}"
echo "Size: $(du -sh "$APP_BUNDLE" | awk '{print $1}')"

if [ -f "${CONTENTS}/Info.plist" ] && [ -f "${MACOS}/${APP_NAME}" ]; then
    echo "Bundle structure: OK"
    plutil -lint "${CONTENTS}/Info.plist" > /dev/null
else
    echo "ERROR: Bundle structure incomplete"
    exit 1
fi
