<div align="center">
  <img src="build/Assets/SleepMac-icon-256.png" alt="SleepMac Logo" width="128" height="128">
  <h1>SleepMac</h1>
  <p><strong>Put your Mac to sleep. On your terms.</strong></p>
  <p>
    <img src="https://img.shields.io/badge/macOS-13.0%2B-brightgreen" alt="macOS 13.0+">
    <img src="https://img.shields.io/badge/Swift-6.3-orange" alt="Swift 6.3">
    <img src="https://img.shields.io/badge/license-MIT-blue" alt="MIT License">
    <img src="https://img.shields.io/badge/version-2.3.0-black" alt="Version 2.3.0">
    <img src="https://img.shields.io/badge/apple%20silicon-intel-brightgreen" alt="Apple Silicon + Intel">
    <img src="https://img.shields.io/badge/dependencies-0-success" alt="Zero Dependencies">
  </p>
  <br>
  <p>
    <strong>SleepMac</strong> is a lightweight macOS menu bar utility with three timer modes — <strong>Chronometer</strong>, <strong>Countdown</strong>, and <strong>Sleep Timer</strong> — all wrapped in a gorgeous orange <em>Fluo</em> neon interface.
    No bloat. No subscriptions. No dependencies. Pure SwiftUI.
  </p>
  <br>
  <p>
    <code>brew install sleepmac</code>
    &nbsp;&nbsp;·&nbsp;&nbsp;
    <a href="https://github.com/YOUR_USERNAME/SleepBabySleep/releases">Download DMG</a>
    &nbsp;&nbsp;·&nbsp;&nbsp;
    <a href="#building-from-source">Build from Source</a>
  </p>
</div>

<br>

---

## ✨ Features

| | |
|---|---|
| <img src="build/Assets/SleepMac-icon-64.png" width="20"> **Chronometer** | Track how long your Mac has been awake with high-precision 50Hz timing. Start, pause, resume, reset, lap. |
| <img src="build/Assets/SleepMac-icon-64.png" width="20"> **Countdown Timer** | Set a countdown from 1–30 minutes (or custom). When it hits zero, your Mac sleeps. Pause and resume anytime. |
| <img src="build/Assets/SleepMac-icon-64.png" width="20"> **Sleep Timer** | Pick a specific date and time for automatic sleep. Perfect for "sleep at 11 PM." |
| 🔔 **30-Second Warning** | Before sleep, a macOS notification appears with a **Cancel** button. Changed your mind? One click aborts. |
| 🎨 **Orange Fluo Neon UI** | 3D gradient icons, high-visibility orange neon buttons, and a sleek dark popup. Your menu bar has never looked this good. |
| 🔋 **Zero Overhead** | ~2 MB on disk. No background processes. No network access. No tracking. Nothing runs unless you click. |

<br>

## 📸 In Action

```
┌──────────────────────────────────────┐
│  🌙  SleepMac                        │
│  ┌────┬──────┬──────┐               │
│  │ ⏱  │  ⏲  │  🌙  │               │
│  │Chro│Count │ Sleep│               │
│  ├────┴──────┴──────┤               │
│  │                  │               │
│  │  00:00:00.00     │               │
│  │                  │               │
│  │ [Start] [Reset]  │               │
│  │                  │               │
│  └──────────────────┘               │
│  Sound On  ·  Launch at Login  ·  ⏻ │
└──────────────────────────────────────┘
```

<sub>*Screenshot of the SleepMac menu bar popup with Chronometer tab active.*</sub>

<br>

## 🚀 Installation

### Option 1: Homebrew (Recommended)
```bash
brew tap YOUR_USERNAME/tap
brew install --cask sleepmac
```

### Option 2: Download DMG
1. Go to [Releases](https://github.com/YOUR_USERNAME/SleepBabySleep/releases)
2. Download the latest `SleepMac.dmg`
3. Open the DMG and drag **SleepMac** to Applications
4. **First launch:** Right-click → **Open** (Gatekeeper bypass for unsigned apps)

### Option 3: Build from Source
```bash
git clone https://github.com/YOUR_USERNAME/SleepBabySleep.git
cd SleepBabySleep
./Scripts/build-app.sh
```
The `.app` will be in `build/Release/SleepBabySleep.app`.

<br>

## 🎯 Usage

| Step | Action |
|------|--------|
| **1** | Click the 🌙 moon icon in your menu bar |
| **2** | Choose your mode: Chronometer, Countdown, or Sleep Timer |
| **3** | Set your time and click **Sleep** (or **Start** for Chronometer) |
| **4** | A 30-second warning notification appears before sleep. **Cancel** anytime |
| **5** | Your Mac sleeps automatically. Or click **Cancel** to abort |

You can also cancel an active timer from the menu bar popup at any time.

<br>

## 🛠 Building from Source

SleepMac is built with **Swift Package Manager** — no Xcode required.

```bash
# Clone and build
git clone https://github.com/YOUR_USERNAME/SleepBabySleep.git
cd SleepBabySleep
./Scripts/build-app.sh

# Create distributable DMG
./Scripts/create-dmg.sh

# Run tests (requires Xcode)
swift test
```

### Requirements
- **macOS 13.0** (Ventura) or later
- **Command Line Tools** (no Xcode required)
- **Apple Silicon** or **Intel**

<br>

## 🔧 Technical Details

### Architecture
```
SleepBabySleep/
├── Sources/
│   ├── App/              # SwiftUI entry point, MenuBarExtra
│   ├── Views/            # SwiftUI views (3 tabs, footer)
│   ├── ViewModels/       # Business logic per tab
│   ├── Services/         # Sleep, notifications, sound
│   ├── Models/           # Data structures
│   └── Utilities/        # Formatters, constants, styles
├── Tests/                # Unit tests
├── Scripts/              # Build + DMG scripts
└── .github/workflows/    # CI/CD pipeline
```

### Sleep Mechanism
- **Primary:** `IOPMSleepSystem()` from IOKit — the same API macOS uses internally
- **Fallback:** `pmset sleepnow` if IOKit is unavailable
- **Safety:** 30-second notification with user notification actions before sleep executes

### Security
| Feature | Status |
|---------|--------|
| Network access | ❌ **None** — zero network calls |
| File system access | ❌ **None** — only UserDefaults for prefs |
| Sandbox | ❌ Not possible (IOKit requires entitlement) |
| Hardened Runtime | ✅ Enabled with ad-hoc codesign |
| Code injection protection | ✅ Hardened Runtime |
| Open source audit | ✅ MIT License — inspect every line |

### Why not the Mac App Store?
The Mac App Store requires sandboxing, which blocks `IOPMSleepSystem()` and `pmset`. SleepMac must be distributed outside the App Store.

<br>

## 📋 Changelog

### v2.3.0 — Pause/Resume + Memory Optimizations
- **Pause/Resume** on Chronometer and Countdown Timer — switch tabs without losing your timer
- **Persistent ViewModels** — timers survive tab switches (architectural fix)
- **Memory leak fixes:**
  - Laps array capped at 50 entries (was unbounded)
  - `AVAudioPlayer` properly released before creating new instances
  - Dead `KeyboardShortcutService` removed (60 lines)
  - `print()` replaced with `os_log` throughout
- **RAM stability:** 32→38MB growth over 3 days eliminated

### v2.2.0 — New UI
- 3D gradient icons with shadows per tab
- Orange fluo (`#FF8C00`) and green fluo (`#00E64D`) button styles
- Icons enlarged 12%, Sleep Start button enlarged 15%

### v2.1.0 — Performance
- Chronometer timer optimized 100Hz → 50Hz
- `formattedTime` cached, no longer recomputed on every tick
- `DateFormatter` cached as static property
- `print()` → `os_log` throughout

### v2.0.0 — Initial Release
- 3-tab menu bar app: Chronometer, Countdown, Sleep Timer
- IOKit `IOPMSleepSystem()` with `pmset` fallback
- 30-second warning notification with Cancel action
- Launch at login, sound toggle

<br>

## 📊 Project Stats

| Metric | Value |
|--------|-------|
| **Version** | 2.3.0 |
| **Size** | ~2 MB (compiled) |
| **Dependencies** | 0 |
| **Language** | Swift 6.3 |
| **Platform** | macOS 13.0+ (Ventura) |
| **Architecture** | arm64 + x86_64 |
| **License** | MIT |
| **Build system** | Swift Package Manager |

<br>

## 🤝 Contributing

Contributions are welcome! Please open an issue first for major changes.

1. Fork the repo
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<br>

## 📄 License

SleepMac is released under the **MIT License**. See [LICENSE](LICENSE) for details.

---

<div align="center">
  <p>
    <a href="https://github.com/YOUR_USERNAME/SleepBabySleep">GitHub</a>
    &nbsp;·&nbsp;
    <a href="https://github.com/YOUR_USERNAME/SleepBabySleep/releases">Releases</a>
    &nbsp;·&nbsp;
    <a href="https://github.com/YOUR_USERNAME/SleepBabySleep/issues">Report Issue</a>
  </p>
  <p>
    <sub>Built with ❤️ in pure SwiftUI · No subscriptions · No tracking · Just sleep</sub>
  </p>
</div>
