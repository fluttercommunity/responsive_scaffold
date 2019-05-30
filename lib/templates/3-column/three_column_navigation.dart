import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'common/index.dart';

class ThreeColumnNavigation extends StatefulWidget {
  ThreeColumnNavigation({
    @required this.sections,
    this.showDetailsArrows = true,
    this.expandedIconData = Icons.fullscreen_exit,
    this.collapsedIconData = Icons.fullscreen,
    this.initiallyExpanded = true,
    this.bottomAppBar,
    this.backgroundColor,
    this.title,
  }) : _adaptive = false;
  List<MainSection> sections;
  final bool _adaptive;
  final bool showDetailsArrows;
  final bool initiallyExpanded;
  final IconData expandedIconData, collapsedIconData;
  final Widget bottomAppBar;
  final Color backgroundColor;
  final Text title;
  @override
  _ThreeColumnNavigationState createState() => _ThreeColumnNavigationState();
}

class _ThreeColumnNavigationState extends State<ThreeColumnNavigation> {
  bool _expanded = true;
  int _sectionIndex = 0;
  int _listIndex = 0;
  AutoScrollController controller;

  @override
  void initState() {
    if (widget.initiallyExpanded) {}
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
    await controller.scrollToIndex(
      value,
      preferPosition: position,
    );
    controller.highlight(value);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 720) {
          final _showMenu = constraints.maxWidth < 1100;
          return Material(
            child: Row(
              children: <Widget>[
                if (_expanded)
                  Container(
                    width: 300,
                    child: Scaffold(
                      backgroundColor: widget?.backgroundColor,
                      appBar: AppBar(
                        title: widget?.title,
                        leading: IconButton(
                          icon: Icon(widget.expandedIconData),
                          onPressed: () {
                            if (mounted)
                              setState(() {
                                _expanded = false;
                              });
                          },
                        ),
                      ),
                      body: SectionsList(
                        sections: widget.sections,
                        sectionIndex: _sectionIndex,
                        sectionTap: (index) {
                          if (_sectionIndex != index) {
                            if (mounted)
                              setState(() {
                                _sectionIndex = index;
                              });
                            _setUpController(false);
                          }
                        },
                      ),
                      bottomNavigationBar: widget?.bottomAppBar,
                    ),
                  ),
                Container(
                  width: 400,
                  child: Scaffold(
                    drawer: _showMenu
                        ? SectionsDrawer(
                            sections: widget.sections,
                            sectionIndex: _sectionIndex,
                            sectionChanged: (context, index) {
                              if (_sectionIndex != index) {
                                if (mounted)
                                  setState(() {
                                    _sectionIndex = index;
                                  });
                                _setUpController(false);
                                Navigator.pop(context);
                              }
                            },
                          )
                        : null,
                    appBar: AppBar(
                      leading: _showMenu
                          ? null
                          : !_expanded
                              ? IconButton(
                                  icon: Icon(widget.collapsedIconData),
                                  onPressed: () {
                                    if (mounted)
                                      setState(() {
                                        _expanded = true;
                                      });
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
                          if (mounted)
                            setState(() {
                              _listIndex = index;
                            });
                        }
                      },
                    ),
                    bottomNavigationBar:
                        widget.sections[_sectionIndex]?.bottomAppBar,
                  ),
                ),
                Expanded(
                  child: DetailsView(
                    automaticallyImplyLeading: false,
                    isFirst: _listIndex == 0,
                    isLast: widget.sections[_sectionIndex].itemCount ==
                        _listIndex + 1,
                    listIndex: _listIndex,
                    details: widget.sections[_sectionIndex]
                        .getDetails(context, _listIndex),
                    showDetailsArrows: widget.showDetailsArrows,
                    previous: () {
                      if (mounted)
                        setState(() {
                          _listIndex--;
                        });
                      _scrollToIndex(_listIndex);
                    },
                    next: () {
                      if (mounted)
                        setState(() {
                          _listIndex++;
                        });
                      _scrollToIndex(_listIndex);
                    },
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
                if (mounted)
                  setState(() {
                    _sectionIndex = index;
                  });

                _setUpController(false);
                Navigator.pop(context);
              }
            },
          ),
          appBar: AppBar(
            title: widget.sections[_sectionIndex]?.label,
          ),
          body: SectionList(
            controller: controller,
            section: widget.sections[_sectionIndex],
            listIndex: _listIndex,
            listTap: (index) {
              if (_listIndex != index) {
                if (mounted)
                  setState(() {
                    _listIndex = index;
                  });
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) {
                    final _details = widget.sections[_sectionIndex]
                        .getDetails(context, _listIndex);
                    return DetailsView(
                      isFirst: _listIndex == 0,
                      isLast: widget.sections.isNotEmpty &&
                          _listIndex == widget.sections.length - 1,
                      listIndex: _listIndex,
                      details: _details,
                      showDetailsArrows: false,
                    );
                  },
                ));
              }
            },
          ),
          bottomNavigationBar: widget.sections[_sectionIndex]?.bottomAppBar,
        );
      },
    );
  }
}

class SectionsDrawer extends StatelessWidget {
  const SectionsDrawer({
    Key key,
    @required int sectionIndex,
    @required this.sectionChanged,
    @required this.sections,
  })  : _sectionIndex = sectionIndex,
        super(key: key);

  final int _sectionIndex;
  final Function(BuildContext, int) sectionChanged;
  final List<MainSection> sections;

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
    @required this.itemBuilder,
    @required this.itemCount,
    @required this.getDetails,
    @required this.icon,
    @required this.label,
    this.bottomAppBar,
  });
  final Text label;
  final Icon icon;
  final int itemCount;
  final Widget Function(BuildContext context, int index, bool selected)
      itemBuilder;
  final DetailsWidget Function(BuildContext context, int index) getDetails;
  final Widget bottomAppBar;
}

class DetailsWidget {
  const DetailsWidget({
    @required this.child,
    this.actions,
    this.title,
    this.bottomAppBar,
  });
  final Text title;
  final Widget child;
  final List<Widget> actions;
  final Widget bottomAppBar;
}
