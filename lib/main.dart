import 'dart:io';

import 'package:flutter/material.dart';

// import 'package:flutter_acrylic/flutter_acrylic.dart';  // Disabled for Linux compatibility
import 'package:hid_listener/hid_listener.dart';
// import 'package:macos_window_utils/macos_window_utils.dart';  // macOS-only dependency
import 'package:window_manager/window_manager.dart';

import 'app.dart';

void main() async {
  // ensure flutter plugins are intialized and ready to use
  WidgetsFlutterBinding.ensureInitialized();
  // await Window.initialize(); // flutter_acrylic - disabled for Linux compatibility
  await windowManager.ensureInitialized(); // window_manager

  if (getListenerBackend() != null) {
    if (!getListenerBackend()!.initialize()) {
      debugPrint("Failed to initialize listener backend");
    }
  } else {
    debugPrint("No listener backend for this platform");
  }

  runApp(const KeyvizApp());

  _initWindow();
}

_initWindow() async {
  await windowManager.waitUntilReadyToShow(
    WindowOptions(
      skipTaskbar: true,
      alwaysOnTop: true,
      fullScreen: !Platform.isMacOS,
      titleBarStyle: TitleBarStyle.hidden,
    ),
    () async {
      windowManager.setIgnoreMouseEvents(true);
      windowManager.setHasShadow(false);
      windowManager.setAsFrameless();
    },
  );

  // Platform-specific window effects - temporarily disabled for Linux compatibility
  if (Platform.isMacOS) {
    // WindowManipulator.makeWindowFullyTransparent();
    // WindowManipulator.enableFullSizeContentView();
    // await WindowManipulator.zoomWindow();
    debugPrint("macOS window effects not available in Linux build");
  } else {
    // Window.setEffect(
    //   effect: WindowEffect.transparent,
    //   color: Colors.transparent,
    // );
    debugPrint("Window transparency effects not available in Linux build");
  }
  windowManager.blur();
}
