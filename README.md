[![Flutter Community: responsive_scaffold](https://fluttercommunity.dev/_github/header/responsive_scaffold)](https://github.com/fluttercommunity/community)

[![Buy Me A Coffee](https://img.shields.io/badge/Donate-Buy%20Me%20A%20Coffee-yellow.svg)](https://www.buymeacoffee.com/rodydavis)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=WSH3GVC49GNNJ)
[![pub package](https://img.shields.io/pub/v/responsive_scaffold.svg)](https://pub.dartlang.org/packages/responsive_scaffold)
![github pages](https://github.com/fluttercommunity/responsive_scaffold/workflows/github%20pages/badge.svg)

# responsive_scaffold

View the online demo [here](https://fluttercommunity.github.io/responsive_scaffold/)!

On mobile it shows a list and pushes to details and on tablet it shows the List and the selected item.

Online Demo: https://fluttercommunity.github.io/responsive_scaffold/

## Getting Started

### 3 Column Layout

[example](https://github.com/fluttercommunity/responsive_scaffold/tree/dev/lib/templates/3-column)

### Responsive Layout

Follows Material Design Layout [Docs](https://material.io/design/layout/responsive-layout-grid.html#grid-behavior). 

![md-layout](https://github.com/fluttercommunity/responsive_scaffold/blob/master/doc/screenshots/layout/md-layout.gif)

Here is a demo on various sizes.


<img src="https://github.com/fluttercommunity/responsive_scaffold/blob/master/doc/screenshots/layout/1.png" width="800">
<img src="https://github.com/fluttercommunity/responsive_scaffold/blob/master/doc/screenshots/layout/2.png" width="800">
<img src="https://github.com/fluttercommunity/responsive_scaffold/blob/master/doc/screenshots/layout/6.png" width="800">
<img src="https://github.com/fluttercommunity/responsive_scaffold/blob/master/doc/screenshots/layout/3.png" width="300">
<img src="https://github.com/fluttercommunity/responsive_scaffold/blob/master/doc/screenshots/layout/4.png" width="300">
<img src="https://github.com/fluttercommunity/responsive_scaffold/blob/master/doc/screenshots/layout/5.png" width="300">



#### Example

``` dart 
import 'package:flutter/material.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';

class LayoutExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: Text('Responsive Layout Example'),
      drawer: ListView(
        children: <Widget>[
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
            leading: Icon(Icons.filter_list),
            title: Text('Filter List'),
            subtitle: Text('Hide and show items'),
            trailing: Switch(
              value: true,
              onChanged: (val) {},
            ),
          ),
          ListTile(
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
            leading: Icon(Icons.sort_by_alpha),
            title: Text('Sort List'),
            subtitle: Text('Change layout behavior'),
            trailing: Switch(
              value: false,
              onChanged: (val) {},
            ),
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.search),
        onPressed: () {},
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () {},
      ),
    );
  }
}


```

### Responsive List

* You can use this in two modes `ResponsiveListScaffold` and `ResponsiveListScaffold.builder`.
* On Mobile the ListView will push to the details screen

![tablet](https://github.com/fluttercommunity/responsive_scaffold/blob/master/doc/screenshots/tablet.png)
![push](https://github.com/fluttercommunity/responsive_scaffold/blob/master/doc/screenshots/push.png)
![mobile](https://github.com/fluttercommunity/responsive_scaffold/blob/master/doc/screenshots/mobile.png)

* On Tablet it will show a Master Detail View.
* You can add additional Slivers to the Scrollview and the AppBar is optional.


##### Example

``` dart 
import 'package:flutter/material.dart';

import 'package:responsive_scaffold/responsive_scaffold.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ResponsiveListScaffold.builder(
        scaffoldKey: _scaffoldKey,
        detailBuilder: (BuildContext context, int index, bool tablet) {
          return DetailsScreen(
            // appBar: AppBar(
            //   elevation: 0.0,
            //   title: Text("Details"),
            //   actions: [
            //     IconButton(
            //       icon: Icon(Icons.share),
            //       onPressed: () {},
            //     ),
            //     IconButton(
            //       icon: Icon(Icons.delete),
            //       onPressed: () {
            //         if (!tablet) Navigator.of(context).pop();
            //       },
            //     ),
            //   ],
            // ),
            body: Scaffold(
              appBar: AppBar(
                elevation: 0.0,
                title: Text("Details"),
                automaticallyImplyLeading: !tablet,
                actions: [
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      if (!tablet) Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                elevation: 0.0,
                child: Container(
                  child: IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {},
                  ),
                ),
              ),
              body: Container(
                child: Center(
                  child: Text("Item: $index"),
                ),
              ),
            ),
          );
        },
        nullItems: Center(child: CircularProgressIndicator()),
        emptyItems: Center(child: Text("No Items Found")),
        slivers: <Widget>[
          SliverAppBar(
            title: Text("App Bar"),
          ),
        ],
        itemCount: 100,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Text(index.toString()),
          );
        },
        bottomNavigationBar: BottomAppBar(
          elevation: 0.0,
          child: Container(
            child: IconButton(
              icon: Icon(Icons.share),
              onPressed: () {},
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Snackbar!"),
            ));
          },
        ),
      ),
    );
  }
}

```
