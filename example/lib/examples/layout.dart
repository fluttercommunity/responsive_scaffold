import 'package:flutter/material.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';

class LayoutExample extends StatelessWidget {
  const LayoutExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: const Text('Responsive Layout Example'),
      drawer: ListView(
        children: const <Widget>[
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings Page'),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Info Page'),
          ),
          ListTile(
            leading: Icon(Icons.library_books),
            title: Text('Library Page'),
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help Page'),
          ),
        ],
      ),
      endIcon: Icons.filter_list,
      endDrawer: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.filter_list),
            title: const Text('Filter List'),
            subtitle: const Text('Hide and show items'),
            trailing: Switch(
              value: true,
              onChanged: (val) {},
            ),
          ),
          const ListTile(
            leading: Icon(Icons.image_aspect_ratio),
            title: Text('Size Settings'),
            subtitle: Text('Change size of images'),
          ),
          ListTile(
            title: Slider(
              value: 0.5,
              onChanged: (val) {},
            ),
          ),
          ListTile(
            leading: const Icon(Icons.sort_by_alpha),
            title: const Text('Sort List'),
            subtitle: const Text('Change layout behavior'),
            trailing: Switch(
              value: false,
              onChanged: (val) {},
            ),
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {},
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
