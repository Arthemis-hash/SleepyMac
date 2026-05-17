# SleepMac

A lightweight macOS menu bar app that puts your Mac to sleep on a timer. No more manually running `sleep 3800 && pmset sleepnow`.

## Features

- **Quick Timer**: Preset durations (10, 15, 30, 45 minutes)
- **Schedule**: Pick a specific date/time for sleep
- **Menu Bar**: Lives in your menu bar, stays out of your way
- **Warning**: 30-second notification before sleep with cancel option
- **Keyboard Shortcut**: `Cmd+Shift+Esc` to cancel an active timer
- **Launch at Login**: Optional auto-start on login
- **Zero Dependencies**: Pure SwiftUI, no external libraries
- **Open Source**: MIT License

## Installation

### Option 1: Download DMG

1. Go to [Releases](https://github.com/YOUR_USERNAME/SleepBabySleep/releases)
2. Download the latest `SleepMac.dmg`
3. Open the DMG and drag **SleepMac** to your Applications folder
4. **First launch**: Right-click the app and select **Open** (Gatekeeper bypass for unsigned apps)

### Option 2: Homebrew

```bash
brew tap YOUR_USERNAME/tap
brew install --cask sleepmac
```

### Option 3: Build from Source

```bash
git clone https://github.com/YOUR_USERNAME/SleepBabySleep.git
cd SleepBabySleep
./Scripts/build-app.sh
```

The `.app` will be in `build/Release/SleepBabySleep.app`.

## Usage

1. Click the moon icon in your menu bar
2. Choose a quick timer preset (10/15/30/45 min) or pick a specific time
3. The icon shows a countdown while the timer is active
4. 30 seconds before sleep, you'll get a notification with a **Cancel** button
5. Click **Cancel** on the notification, open the menu and click Cancel, or press `Cmd+Shift+Esc`

## Requirements

- macOS 13.0 (Ventura) or later
- Apple Silicon (arm64) or Intel (x86_64)

## Technical Details

### How it works

SleepMac uses the native IOKit `IOPMSleepSystem()` API to put your Mac to sleep. This is the same underlying mechanism macOS uses internally. If IOKit fails for any reason, it falls back to `pmset sleepnow`.

### Security

- **No sandbox**: Required to access IOKit power management APIs
- **Hardened Runtime**: Enabled to prevent code injection
- **No network access**: The app never connects to the internet
- **No file access**: Only reads/writes local UserDefaults for preferences
- **Minimal surface area**: The app does exactly one thing

### Why not the Mac App Store?

The Mac App Store requires sandboxing, which blocks access to `IOPMSleepSystem()` and `pmset`. This app must be distributed outside the App Store.

## Project Structure

```
SleepBabySleep/
├── SleepBabySleep/
│   ├── App/                    # App entry point
│   ├── Views/                  # SwiftUI views
│   ├── ViewModels/             # Business logic
│   ├── Services/               # Sleep, notifications, shortcuts
│   ├── Models/                 # Data models
│   ├── Utilities/              # Formatters, constants
│   └── Resources/              # Info.plist, assets
├── SleepBabySleepTests/        # Unit tests
├── Scripts/                    # Build and DMG creation
└── .github/workflows/          # CI/CD
```

## Building

```bash
# Build (requires Swift 5.9+ and macOS SDK)
swift build -c release

# Create .app bundle
./Scripts/build-app.sh

# Create DMG
./Scripts/create-dmg.sh

# Run tests (requires full Xcode installation)
swift test
```

## Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](LICENSE)