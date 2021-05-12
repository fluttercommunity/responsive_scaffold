import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'examples/index.dart';

/// main is entry point of Flutter application
void main() {
  // Desktop platforms aren't a valid platform.
  if (!kIsWeb) _setTargetPlatformForDesktop();
  return runApp(const MyApp());
}

/// If the current platform is desktop, override the default platform to
/// a supported platform (iOS for macOS, Android for Linux and Windows).
/// Otherwise, do nothing.
void _setTargetPlatformForDesktop() {
  TargetPlatform? targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(accentColor: Colors.red),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Examples'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Responsive List'),
            onTap: () => _goToScreen(context, const ListExample()),
          ),
          ListTile(
            title: const Text('Responsive Layout'),
            onTap: () => _goToScreen(context, const LayoutExample()),
          ),
          ListTile(
            title: const Text('Multi Column Layout'),
            onTap: () =>
                _goToScreen(context, const MultiColumnNavigationExample()),
          ),
        ],
      ),
    );
  }

  void _goToScreen(BuildContext context, Widget child) =>
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => child),
      );
}
