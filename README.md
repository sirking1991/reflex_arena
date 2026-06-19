# Reflex Arena ⚡

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Flutter](https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter)](https://flutter.dev)

A sleek, high-performance, synthwave-themed local multiplayer reflex game built with **Flutter**. Test your reaction times, avoid decoy traps, and push your limits in a neon-drenched cyberpunk arena.

---

## 🎮 Game Modes

Reflex Arena features three intense modes designed for 1-vs-1 local action on a single screen:

1. **Classic Mode**
   - The ultimate test of raw reaction speed.
   - Wait for the central target to activate (turns Neon Green).
   - Tapping it first wins the point. Tapping too early results in a freeze penalty!

2. **Fake Out Mode**
   - A battle of discipline and visual focus.
   - The target will flash decoy colors (Red, Blue, Yellow).
   - Only tap when it flashes the true activation color (Neon Green). Don't fall for the fake-outs!

3. **Tug of War**
   - A fast-paced, high-intensity tap battle.
   - Rapidly tap the active targets to push the neon dividing line into your opponent's territory.
   - Push it all the way to their edge to claim victory.

---

## ✨ Features

- **Local 1v1 Multiplayer:** Designed for two players sharing a single mobile screen (split-screen layout).
- **Synthwave Aesthetics:** Animated vector grids, pulsing ambient neon glows, and custom particle explosion effects.
- **Dynamic Physics/Feedback:** Sound effects, screen shake, and haptic rumble support for immersive gameplay.
- **Staggered Animations:** Premium entry animations, title drifts, and responsive card hovers.

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.12.0 or newer recommended)
- Android Studio or Xcode for mobile deployment
- A physical mobile device (recommended for the best multi-touch and local multiplayer experience)

### Installation & Running

1. **Clone the repository:**
   ```bash
   git clone https://github.com/sirking1991/reflex_arena.git
   cd reflex_arena
   ```

2. **Get dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   - Connect your Android/iOS device or start an emulator.
   - Execute:
     ```bash
     flutter run
     ```

---

## 📦 Building for Release

### Android
To build a release Android App Bundle (AAB):
```bash
flutter build appbundle
```
*Note: Ensure your `key.properties` and upload keystore files are placed in the `android/` directory (these are git-ignored for security).*

### iOS
To build the iOS archive:
```bash
flutter build ipa
```

---

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](file:///Users/sirking/Projects/Others/reflex_arena/CONTRIBUTING.md) for guidelines on how to set up, build, and submit changes to Reflex Arena.

---

## 📄 License

This project is licensed under the **GNU General Public License v3.0** (GPLv3). See the [LICENSE](file:///Users/sirking/Projects/Others/reflex_arena/LICENSE) file for the full text.
