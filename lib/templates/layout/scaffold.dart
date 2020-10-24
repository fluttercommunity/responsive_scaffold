import 'package:flutter/material.dart';

class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    this.scaffoldKey,
    this.drawer,
    this.endDrawer,
    this.title,
    this.body,
    this.trailing,
    this.floatingActionButton,
    this.menuIcon,
    this.endIcon,
    this.kTabletBreakpoint = 720.0,
    this.kDesktopBreakpoint = 1440.0,
    this.appBarElevation,
    this.floatingActionButtonLocation = FloatingActionButtonLocation.endFloat,
    this.responsiveFloatingActionButtonLocation =
        ResponsiveFloatingActionButtonLocation.topStartDocked,
  });

  final Widget drawer, endDrawer;

  final Widget title;

  final Widget body;

  final Widget trailing;

  final Widget floatingActionButton;

  /// The [FloatingActionButtonLocation] used on small screens
  final FloatingActionButtonLocation floatingActionButtonLocation;

  /// The [ResponsiveFloatingActionButtonLocation] used on tablet and desktop screens
  final ResponsiveFloatingActionButtonLocation
      responsiveFloatingActionButtonLocation;

  final kTabletBreakpoint;
  final kDesktopBreakpoint;
  final _drawerWidth = 304.0;

  final IconData menuIcon, endIcon;

  final double appBarElevation;

  final Key scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth >= kDesktopBreakpoint) {
          return Material(
            child: Stack(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    if (drawer != null) ...[
                      SizedBox(
                        width: _drawerWidth,
                        child: Drawer(
                          child: SafeArea(
                            child: drawer,
                          ),
                        ),
                      ),
                    ],
                    Expanded(
                      child: Scaffold(
                        key: scaffoldKey,
                        appBar: AppBar(
                          elevation: appBarElevation,
                          automaticallyImplyLeading: false,
                          title: title,
                          actions: <Widget>[
                            if (trailing != null) ...[
                              trailing,
                            ],
                          ],
                        ),
                        body: Row(
                          children: <Widget>[
                            Expanded(
                              child: body ?? Container(),
                            ),
                            if (endDrawer != null) ...[
                              Container(
                                width: _drawerWidth,
                                child: Drawer(
                                  elevation: 3.0,
                                  child: SafeArea(
                                    child: endDrawer,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (floatingActionButton != null) ...[
                  Positioned(
                    top: responsiveFloatingActionButtonLocation.top != null
                        ? 84 + responsiveFloatingActionButtonLocation.top
                        : null,
                    left: responsiveFloatingActionButtonLocation.left != null
                        ? responsiveFloatingActionButtonLocation.overDrawer
                            ? _drawerWidth - 28
                            : _drawerWidth +
                                responsiveFloatingActionButtonLocation.left
                        : null,
                    bottom: responsiveFloatingActionButtonLocation.bottom,
                    right: responsiveFloatingActionButtonLocation.right != null
                        ? responsiveFloatingActionButtonLocation.overDrawer
                            ? _drawerWidth - 28
                            : _drawerWidth +
                                responsiveFloatingActionButtonLocation.right
                        : null,
                    child: floatingActionButton,
                  )
                ],
              ],
            ),
          );
        }
        if (constraints.maxWidth >= kTabletBreakpoint) {
          return Scaffold(
            key: scaffoldKey,
            drawer: drawer == null
                ? null
                : Drawer(
                    child: SafeArea(
                      child: drawer,
                    ),
                  ),
            appBar: AppBar(
              elevation: appBarElevation,
              automaticallyImplyLeading: false,
              title: title,
              leading: _MenuButton(iconData: menuIcon),
              actions: <Widget>[
                if (trailing != null) ...[
                  trailing,
                ],
              ],
            ),
            body: SafeArea(
              right: false,
              bottom: false,
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: body ?? Container(),
                      ),
                      if (endDrawer != null) ...[
                        Container(
                          width: _drawerWidth,
                          child: Drawer(
                            elevation: 3.0,
                            child: SafeArea(
                              child: endDrawer,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (floatingActionButton != null) ...[
                    Positioned(
                      top: responsiveFloatingActionButtonLocation.top,
                      left: responsiveFloatingActionButtonLocation.left,
                      bottom: responsiveFloatingActionButtonLocation.bottom,
                      right: responsiveFloatingActionButtonLocation.right !=
                              null
                          ? responsiveFloatingActionButtonLocation.overDrawer
                              ? _drawerWidth - 28
                              : _drawerWidth +
                                  responsiveFloatingActionButtonLocation.right
                          : null,
                      child: floatingActionButton,
                    )
                  ],
                ],
              ),
            ),
          );
        }
        return Scaffold(
          key: scaffoldKey,
          drawer: drawer == null
              ? null
              : Drawer(
                  child: SafeArea(
                    child: drawer,
                  ),
                ),
          endDrawer: endDrawer == null
              ? null
              : Drawer(
                  child: SafeArea(
                    child: endDrawer,
                  ),
                ),
          appBar: AppBar(
            elevation: appBarElevation,
            automaticallyImplyLeading: false,
            leading: _MenuButton(iconData: menuIcon),
            title: title,
            actions: <Widget>[
              if (trailing != null) ...[
                trailing,
              ],
              if (endDrawer != null) ...[
                _OptionsButton(iconData: endIcon),
              ]
            ],
          ),
          body: body,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
        );
      },
    );
  }
}

class _OptionsButton extends StatelessWidget {
  const _OptionsButton({
    Key key,
    @required this.iconData,
  }) : super(key: key);

  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(iconData ?? Icons.more_vert),
      onPressed: () {
        Scaffold.of(context).openEndDrawer();
      },
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    Key key,
    @required this.iconData,
  }) : super(key: key);

  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(iconData ?? Icons.menu),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }
}

class ResponsiveFloatingActionButtonLocation {
  final bool overDrawer;
  final double top;
  final double bottom;
  final double left;
  final double right;
  static const topStartDocked = ResponsiveFloatingActionButtonLocation(
      overDrawer: true, top: 16, left: 16);
  static const bottomStartDocked = ResponsiveFloatingActionButtonLocation(
      overDrawer: true, bottom: 16, left: 16);
  static const topStartFloating = ResponsiveFloatingActionButtonLocation(
      overDrawer: false, top: 16, left: 8);
  static const bottomStartFloating = ResponsiveFloatingActionButtonLocation(
      overDrawer: false, bottom: 16, left: 16);
  static const topEndFloating = ResponsiveFloatingActionButtonLocation(
      overDrawer: false, top: 16, right: 8);
  static const bottomEndFloating = ResponsiveFloatingActionButtonLocation(
      overDrawer: false, bottom: 16, right: 16);
  static const topEndDocked = ResponsiveFloatingActionButtonLocation(
      overDrawer: true, top: 16, right: 16);
  static const bottomEndDocked = ResponsiveFloatingActionButtonLocation(
      overDrawer: true, bottom: 16, right: 16);

  const ResponsiveFloatingActionButtonLocation(
      {this.overDrawer = false, this.top, this.bottom, this.left, this.right})
      : assert((top == null && bottom == null) ||
            (left == null && right == null) ||
            (top != null || bottom != null) ||
            (left != null && right != null));
}
