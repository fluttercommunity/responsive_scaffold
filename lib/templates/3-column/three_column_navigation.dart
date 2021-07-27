import 'dart:developer' as developer show log;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'common/index.dart';

class ThreeColumnNavigation extends StatefulWidget {
  const ThreeColumnNavigation({
    Key? key,
    required this.sections,
    this.showDetailsArrows = true,
    this.expandedIconData = Icons.fullscreen_exit,
    this.collapsedIconData = Icons.fullscreen,
    this.initiallyExpanded = true,
    this.bottomAppBar,
    this.backgroundColor,
    this.title,
  }) : super(key: key);

  final Color? backgroundColor;
  final Widget? bottomAppBar;
  final IconData expandedIconData, collapsedIconData;
  final bool initiallyExpanded;
  final List<MainSection> sections;
  final bool showDetailsArrows;
  final Text? title;

  @override
  _ThreeColumnNavigationState createState() => _ThreeColumnNavigationState();
}

class _ThreeColumnNavigationState extends State<ThreeColumnNavigation> {
  AutoScrollController? controller;

  bool _expanded = true;
  int _listIndex = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _sectionIndex = 0;

  @override
  void initState() {
    if (!widget.initiallyExpanded) {
      if (mounted) {
        setState(() {
          _expanded = false;
        });
      }
    }

    _setUpController(true);
    super.initState();
  }

  void _setUpController(bool init) {
    controller = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical,
    );
  }

  Future _scrollToIndex(int value,
      {AutoScrollPosition position = AutoScrollPosition.middle}) async {
    try {
      controller!.scrollToIndex(
        value,
        preferPosition: position,
      );
      // controller.highlight(value);
    } on Exception catch (e) {
      developer.log(
        'Could not scroll to index: $value',
        name: 'responsive_scaffold',
        error: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 720) {
          final _showMenu = constraints.maxWidth < 1100;
          if (_showMenu) {
            _expanded = false;
          }
          return Material(
            child: Row(
              children: <Widget>[
                if (_expanded)
                  SizedBox(
                    width: 300,
                    child: Scaffold(
                      backgroundColor: widget.backgroundColor,
                      appBar: AppBar(
                        title: widget.title,
                        leading: IconButton(
                          icon: Icon(widget.expandedIconData),
                          onPressed: () {
                            if (mounted) {
                              setState(() {
                                _expanded = false;
                              });
                            }
                          },
                        ),
                      ),
                      body: SectionsList(
                        sections: widget.sections,
                        sectionIndex: _sectionIndex,
                        sectionTap: (index) {
                          if (_sectionIndex != index) {
                            if (mounted) {
                              setState(() {
                                _sectionIndex = index;
                              });
                            }
                            _setUpController(false);
                          }
                        },
                      ),
                      bottomNavigationBar: widget.bottomAppBar,
                    ),
                  ),
                SizedBox(
                  width: 400,
                  child: Scaffold(
                    drawerScrimColor: Colors.transparent,
                    drawer: _showMenu
                        ? SectionsDrawer(
                            sections: widget.sections,
                            sectionIndex: _sectionIndex,
                            sectionChanged: (context, index) {
                              if (_sectionIndex != index) {
                                if (mounted) {
                                  setState(() {
                                    _sectionIndex = index;
                                  });
                                }
                                _setUpController(false);
                                Navigator.pop(context);
                              }
                            },
                          )
                        : null,
                    appBar: AppBar(
                      leading: _showMenu
                          ? MenuButton(scaffoldKey: _scaffoldKey)
                          : !_expanded
                              ? IconButton(
                                  icon: Icon(widget.collapsedIconData),
                                  onPressed: () {
                                    if (mounted) {
                                      setState(() {
                                        _expanded = true;
                                      });
                                    }
                                  },
                                )
                              : null,
                      title: widget.sections[_sectionIndex].label,
                    ),
                    body: SectionList(
                      controller: controller,
                      section: widget.sections[_sectionIndex],
                      listIndex: _listIndex,
                      listTap: (index) {
                        if (_listIndex != index) {
                          if (mounted) {
                            setState(() {
                              _listIndex = index;
                            });
                          }
                        }
                      },
                    ),
                    bottomNavigationBar:
                        widget.sections[_sectionIndex].bottomAppBar,
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      DetailsView(
                        scaffoldKey: _scaffoldKey,
                        automaticallyImplyLeading: false,
                        isFirst: _listIndex == 0,
                        isLast: widget.sections[_sectionIndex].itemCount ==
                            _listIndex + 1,
                        details: widget.sections[_sectionIndex]
                            .getDetails(context, _listIndex),
                        showDetailsArrows: widget.showDetailsArrows,
                        previous: () {
                          if (mounted) {
                            setState(() {
                              _listIndex--;
                            });
                          }
                          _scrollToIndex(_listIndex);
                        },
                        next: () {
                          if (mounted) {
                            setState(() {
                              _listIndex++;
                            });
                          }
                          _scrollToIndex(_listIndex);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Scaffold(
          drawer: SectionsDrawer(
            sections: widget.sections,
            sectionIndex: _sectionIndex,
            sectionChanged: (context, index) {
              if (_sectionIndex != index) {
                if (mounted) {
                  setState(() {
                    _sectionIndex = index;
                  });
                }

                _setUpController(false);
                Navigator.pop(context);
              }
            },
          ),
          appBar: AppBar(
            title: widget.sections[_sectionIndex].label,
          ),
          body: SectionList(
            controller: controller,
            section: widget.sections[_sectionIndex],
            listIndex: _listIndex,
            listTap: (index) {
              if (_listIndex != index) {
                if (mounted) {
                  setState(() {
                    _listIndex = index;
                  });
                }
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) {
                    final _details = widget.sections[_sectionIndex]
                        .getDetails(context, _listIndex);
                    return DetailsView(
                      isFirst: _listIndex == 0,
                      isLast: widget.sections.isNotEmpty &&
                          _listIndex == widget.sections.length - 1,
                      details: _details,
                      // showDetailsArrows: false,
                    );
                  },
                ));
              }
            },
          ),
          bottomNavigationBar: widget.sections[_sectionIndex].bottomAppBar,
        );
      },
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key? key,
    required GlobalKey<ScaffoldState> scaffoldKey,
  })   : _scaffoldKey = scaffoldKey,
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        Scaffold.of(context).openDrawer();
        _scaffoldKey.currentState?.showBodyScrim(true, 0.5);
      },
    );
  }
}

class SectionsDrawer extends StatelessWidget {
  const SectionsDrawer({
    Key? key,
    required int sectionIndex,
    required this.sectionChanged,
    required this.sections,
  })   : _sectionIndex = sectionIndex,
        super(key: key);

  final List<MainSection> sections;

  final int _sectionIndex;

  final Function(BuildContext, int) sectionChanged;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SectionsList(
        sections: sections,
        sectionIndex: _sectionIndex,
        sectionTap: (index) => sectionChanged(context, index),
      ),
    );
  }
}

class MainSection {
  const MainSection({
    required this.itemBuilder,
    required this.itemCount,
    required this.getDetails,
    required this.icon,
    required this.label,
    this.bottomAppBar,
  });

  final Widget? bottomAppBar;
  final Icon icon;
  final int itemCount;
  final Text label;

  final Widget Function(BuildContext context, int index, bool selected)
      itemBuilder;

  final DetailsWidget Function(BuildContext context, int index) getDetails;
}

class DetailsWidget {
  const DetailsWidget({
    required this.child,
    this.actions,
    this.title,
    this.bottomAppBar,
  });

  final List<Widget>? actions;
  final Widget? bottomAppBar;
  final Widget child;
  final Text? title;
}
