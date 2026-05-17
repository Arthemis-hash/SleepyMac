#!/bin/bash
set -euo pipefail

# Build SleepBabySleep and create a proper .app bundle
# Usage: ./Scripts/build.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

# Run the app build script
bash "${SCRIPT_DIR}/build-app.sh"
