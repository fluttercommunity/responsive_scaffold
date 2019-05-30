import 'package:flutter/material.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'examples/index.dart';

/// main is entry point of Flutter application
void main() {
  // Desktop platforms aren't a valid platform.
  _setTargetPlatformForDesktop();

  return runApp(MyApp());
}

/// If the current platform is desktop, override the default platform to
/// a supported platform (iOS for macOS, Android for Linux and Windows).
/// Otherwise, do nothing.
void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(accentColor: Colors.red),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Responsive Examples'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Responsive List'),
            onTap: () => _goToScreen(context, ListExample()),
          ),
          ListTile(
            title: Text('Responsive Layout'),
            onTap: () => _goToScreen(context, LayoutExample()),
          ),
          ListTile(
            title: Text('Multi Column Layout'),
            onTap: () => _goToScreen(context, MultiColumnNavigationExample()),
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
