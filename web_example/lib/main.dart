import 'package:flutter_web/material.dart';
import 'package:flutter_web/foundation.dart';
import 'examples/index.dart';

/// main is entry point of Flutter application
void main() {
  return runApp(MyApp());
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
        ],
      ),
    );
  }

  void _goToScreen(BuildContext context, Widget child) =>
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => child, fullscreenDialog: true),
      );
}
