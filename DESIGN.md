# SleepMac Design System — Orange Fluo

## 1. Visual Theme & Atmosphere

macOS menu bar utility with a premium dark interface and electric orange neon accents. Clean, minimal, functional — like a precision instrument. The UI glows without being garish.

- **Visual style:** dark, high-contrast, neon accent
- **Color stance:** dark surface, orange primary, green confirmation
- **Design intent:** Visible at a glance in the menu bar, beautiful when opened, fades into the background when not in use

## 2. Color Palette

### Primary
- **Orange Fluo** `#FF8C00` — Primary accent, CTAs, active states, timer text
- **Green Fluo** `#00E64D` — Start/confirmation buttons, active indicators

### Surfaces
- **Dark Surface** `#1C1C1E` — Main popup background
- **Card Surface** `#2C2C2E` — Tab content and card backgrounds
- **Darker Surface** `#141416` — Footer and divider areas

### Text
- **Primary Text** `#FFFFFF` — Headlines, active timer display
- **Secondary Text** `#A0A0A5` — Labels, descriptions, inactive states
- **Muted Text** `#636366` — Placeholder, disabled

### Semantic
- **Danger** `#FF3B30` — Stop/reset buttons, error states
- **Success** `#00E64D` — Start/confirm

### 3D Gradient Icons
- **Chronometer:** Blue gradient `#007AFF → #0055D4`
- **Countdown:** Orange gradient `#FF8C00 → #CC7000`
- **Sleep Timer:** Purple gradient `#AF52DE → #8B30B5`

### Glow Effects
- Button glow: `#FF8C00` at 30% opacity, 8px blur
- Green glow: `#00E64D` at 30% opacity, 8px blur

## 3. Typography

- **Primary:** SF Pro (system font on macOS)
- **Mono:** SF Mono for timer displays
- **Scale:** 11 / 12 / 13 / 14 / 15 / 17 / 20 / 24
- **Weights:** 400 (regular), 500 (medium), 600 (semibold), 700 (bold)
- Timer display: SF Mono, 20px, bold, monospace tracking

## 4. Spacing & Layout

- **Base unit:** 4px
- **Scale:** 4 / 8 / 12 / 16 / 20 / 24 / 32
- **Popups:** 300px width, 400px max height
- **Internal padding:** 16px on sides, 12px vertical
- **Tab content:** 12px padding

## 5. Components

### Buttons
- **Primary (Fluo):** `#FF8C00` background, white text, 6px radius, neon glow shadow
- **Green:** `#00E64D` background, dark text, 6px radius, green glow shadow
- **Danger:** `#FF3B30` background, white text, 6px radius
- **Secondary:** Card surface background, primary text, subtle border
- **Large variant:** 1.15x scale for primary actions

### Cards
- **Surface:** `#2C2C2E`, 8px radius, no shadow
- **Tab bar:** No background, active tab has bottom accent line in Orange Fluo

### Inputs & Controls
- **Date picker:** System native (NSTokenField style)
- **Preset buttons:** Capsule style, 6px radius, Orange Fluo when active
- **Progress ring:** Orange Fluo stroke, 3px width, circular

### Menu Bar Icon
- **SF Symbol:** `alarm.fill`
- **Color:** White with red dot indicator when timer active

## 6. Depth & Elevation

- **Level 0:** Flat dark surface
- **Level 1:** Card surface (slightly lighter)
- **Level 2:** Glow shadow on active elements
- No drop shadows — use surface contrast and glow instead

## 7. Motion & Interaction

- **Timer refresh:** 50Hz for chronometer, 1Hz for countdown/sleep
- **Button press:** Instant visual feedback (brightness shift)
- **Notification:** Standard macOS notification with action button
- **Transitions:** Instant (no animations in menu bar popup)

## 8. Voice & Brand

- **Tone:** Clean, precise, developer-friendly
- **Tagline:** "Put your Mac to sleep. On your terms."
- **Personality:** Utility-grade, no-nonsense, beautiful
- **Microcopy:** Action-oriented, minimal
  - "Sleep" instead of "Start Sleep Timer"
  - "Cancel" instead of "Abort Operation"
  - "Sound On" / "Sound Off"

## 9. Anti-patterns

- Do not use light backgrounds
- Do not add unnecessary animations
- Do not use gradients outside the 3 tab icons
- Do not increase popup width beyond 300px
- Do not add network-dependent features
- Do not use external fonts (SF Pro only)
- Do not add shadows — use glow or nothing
