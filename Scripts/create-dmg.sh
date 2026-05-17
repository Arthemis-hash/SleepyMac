#!/bin/bash
set -euo pipefail

# Create a DMG for SleepBabySleep distribution
# Usage: ./Scripts/create-dmg.sh
# Requires: ./Scripts/build.sh to have been run first

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
APP_NAME="SleepBabySleep"
DMG_NAME="${APP_NAME}.dmg"
VOL_NAME="Sleep Baby Sleep"
BUILD_DIR="${PROJECT_DIR}/build/Release"
TMP_DMG="/tmp/${APP_NAME}-temp.dmg"
OUTPUT_DMG="${PROJECT_DIR}/${DMG_NAME}"

echo "=== Creating DMG ==="

# Check that the .app exists
if [ ! -d "${BUILD_DIR}/${APP_NAME}.app" ]; then
    echo "ERROR: ${BUILD_DIR}/${APP_NAME}.app not found."
    echo "Run ./Scripts/build.sh first."
    exit 1
fi

# Clean previous DMG
rm -f "${OUTPUT_DMG}" "${TMP_DMG}"

# Get app size and add padding
APP_SIZE_KB=$(du -sk "${BUILD_DIR}/${APP_NAME}.app" | awk '{print $1}')
DMG_SIZE_KB=$((APP_SIZE_KB + 10240))

echo "App size: ${APP_SIZE_KB}KB, DMG size: ${DMG_SIZE_KB}KB"

# Create temporary writable DMG
hdiutil create \
    -size "${DMG_SIZE_KB}k" \
    -fs HFS+ \
    -volname "${VOL_NAME}" \
    -ov \
    "${TMP_DMG}"

# Mount the DMG
MOUNT_OUTPUT=$(hdiutil attach "${TMP_DMG}" -readwrite -noverify)
MOUNT_DIR=$(echo "$MOUNT_OUTPUT" | grep "/Volumes/" | sed 's/.*\/Volumes/\/Volumes/')

echo "Mounted at: ${MOUNT_DIR}"

# Copy the .app
cp -R "${BUILD_DIR}/${APP_NAME}.app" "${MOUNT_DIR}/"

# Create symbolic link to /Applications
ln -s /Applications "${MOUNT_DIR}/Applications"

# Unmount
sync
hdiutil detach "${MOUNT_DIR}"

# Convert to compressed read-only DMG
hdiutil convert \
    "${TMP_DMG}" \
    -format UDZO \
    -imagekey zlib-level=9 \
    -o "${OUTPUT_DMG}"

# Clean up temp file
rm -f "${TMP_DMG}"

# Show result
DMG_SIZE=$(du -sh "${OUTPUT_DMG}" | awk '{print $1}')
echo "=== DMG created ==="
echo "File: ${OUTPUT_DMG}"
echo "Size: ${DMG_SIZE}"

# Compute SHA256 for Homebrew Cask
echo ""
echo "SHA256 (for Homebrew Cask):"
shasum -a 256 "${OUTPUT_DMG}"
