# Linux Port Status for Keyviz

## Current Status: ⚠️ PARTIALLY FUNCTIONAL

This Linux port has **significant limitations** and is currently **not recommended for production use**.

## What Works ✅
- ✅ Input detection (keyboard and mouse events are captured)
- ✅ Basic Flutter application launches
- ✅ Builds successfully on Ubuntu 24.04.3 LTS
- ✅ Proper .deb package generation

## Critical Issues ❌

### 1. Window Manager Plugin Failures
The `window_manager` Flutter plugin is missing Linux implementations for essential methods:
```
MissingPluginException: No implementation found for method setIgnoreMouseEvents
MissingPluginException: No implementation found for method setHasShadow
```

**Impact**: Application crashes when trying to configure window behavior, making it unusable for its intended purpose.

### 2. Missing Configuration Files
The application expects configuration files that don't exist:
```
File: '/home/stephan/Documents/config.json' not found!
File: '/home/stephan/Documents/style.json' not found!
```

**Impact**: Application may not save/load user preferences properly.

### 3. Disabled Features
- Window transparency effects (intentionally disabled for Linux compatibility)
- Platform-specific window manipulations

## Technical Implementation Details

### Dependencies Modified
In `pubspec.yaml`:
```yaml
# flutter_acrylic: ^1.1.4  # Temporarily disabled for Linux compatibility
# macos_window_utils: ^1.8.4  # macOS-only dependency
```

### Code Changes Made
In `lib/main.dart`:
- Commented out `flutter_acrylic` and `macos_window_utils` imports
- Disabled `Window.initialize()` call
- Added debug messages for disabled transparency effects

### Build Requirements
**Critical**: C++ compilation requires specific include paths:
```bash
export CPLUS_INCLUDE_PATH=/usr/include/c++/13:/usr/include/x86_64-linux-gnu/c++/13:$CPLUS_INCLUDE_PATH
```

### System Dependencies
```bash
sudo apt install libayatana-appindicator3-dev mpv libgtk-3-dev libstdc++-12-dev
```

## Root Cause Analysis

### The Real Problem
The original `keyviz-2.0.0a3-linux.deb` failure was **NOT** due to missing system libraries, but rather:

1. **Incorrect dependency names** in the .deb control file
2. **Missing Linux plugin implementations** in Flutter dependencies
3. **Premature alpha release** without proper Linux testing

### Why This Port Has Limited Value
- The `window_manager` plugin lacks essential Linux support
- Core functionality (window positioning, transparency, mouse event handling) is broken
- This is fundamentally a **Flutter ecosystem limitation**, not a packaging issue

## Recommendations

### For Users
- **DO NOT USE** this port for production/presentation purposes
- Wait for official Linux support from the keyviz maintainers
- Consider alternative keystroke visualization tools (see below)

### For Developers
1. **Contribute to upstream Flutter plugins**:
   - `window_manager` needs Linux implementations for `setIgnoreMouseEvents`, `setHasShadow`
   - `flutter_acrylic` needs Linux transparency support

2. **Alternative approaches**:
   - Use native Linux libraries (e.g., X11/Wayland directly)
   - Implement as a native GTK/Qt application
   - Use Electron with native Node.js modules

## Building This Port

### Prerequisites
```bash
# Install Flutter
sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev libstdc++-12-dev
sudo apt install libayatana-appindicator3-dev mpv

# Set C++ include paths (critical!)
export CPLUS_INCLUDE_PATH=/usr/include/c++/13:/usr/include/x86_64-linux-gnu/c++/13:$CPLUS_INCLUDE_PATH
```

### Build Commands
```bash
flutter pub get
flutter build linux --release
```

### Package Creation
```bash
# Create .deb structure and build
dpkg-deb --build keyviz-linux-deb keyviz-2.0.0-alpha2-linux1_amd64.deb
```

## Conclusion

This port demonstrates that keyviz **CAN** be compiled for Linux, but the Flutter plugin ecosystem is **not ready** for a functional Linux desktop keystroke visualizer. The effort would be better spent on:

1. **Finding mature alternatives** (see recommendations below)
2. **Contributing to Flutter plugin Linux support**
3. **Waiting for official Linux support** from keyviz developers

## ✅ Recommended Alternative: screenkey

Since keyviz is currently non-functional on Linux, we recommend using **[screenkey](https://gitlab.com/screenkey/screenkey)** - a mature, stable Linux keystroke visualization tool.

### Installation
```bash
sudo apt install screenkey
```

### Features
- ✅ **Real-time keystroke display** with customizable position (top, center, bottom, fixed)
- ✅ **Mouse button visualization** with `--mouse` flag
- ✅ **Modifier key highlighting** (Ctrl, Alt, Shift, etc.)
- ✅ **Customizable appearance**: font, colors, opacity, size
- ✅ **Multiple display modes**: composed, translated, keysyms, raw
- ✅ **System tray integration**
- ✅ **Multi-monitor support**
- ✅ **Screencasting-friendly** - designed for presentations and tutorials

### Basic Usage
```bash
# Simple keystroke display
screenkey

# With mouse buttons and custom position
screenkey --mouse --position top --font-size large

# Show only modifier combinations (like Ctrl+C, Alt+Tab)
screenkey --mods-only --position bottom

# Custom styling
screenkey --font-color '#00FF00' --bg-color '#000000' --opacity 0.8
```

### Why screenkey is better for Linux:
1. **Native Linux tool** - no Flutter/plugin dependencies
2. **Actively maintained** with regular updates
3. **Lightweight** - minimal resource usage
4. **Reliable** - no crashes or missing features
5. **Mature** - used by Linux content creators for years

### Output Comparison
While not identical to keyviz's styled bars, screenkey provides clean, readable keystroke visualization that serves the same purpose for screencasts, presentations, and teaching.

---

*This document serves as a technical record of the Linux porting attempt and its limitations. Last updated: August 28, 2025.*
