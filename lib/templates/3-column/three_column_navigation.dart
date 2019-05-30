import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ThreeColumnNavigation extends StatefulWidget {
  ThreeColumnNavigation({
    @required this.sections,
    this.showDetailsArrows = true,
    this.expandedIconData = Icons.fullscreen_exit,
    this.collapsedIconData = Icons.fullscreen,
  }) : _adaptive = false;
  List<MainSection> sections;
  final bool _adaptive;
  final bool showDetailsArrows;
  final IconData expandedIconData, collapsedIconData;
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
        // if (widget._adaptive) {
        //   return CupertinoPageScaffold(
        //     navigationBar: CupertinoNavigationBar(),
        //     child: Container(),
        //   );
        // }
        if (constraints.maxWidth > 720) {
          return Material(
            child: Row(
              children: <Widget>[
                if (_expanded && constraints.maxWidth > 900)
                  Container(
                    width: 300,
                    child: Scaffold(
                      appBar: AppBar(
                        leading: IconButton(
                          icon: Icon(widget.expandedIconData),
                          onPressed: () {
                            if (mounted)
                              setState(() {
                                _expanded = false;
                              });
                          },
                        ),
                        title: Text('Mailboxes'),
                      ),
                      body: ListView.builder(
                        itemBuilder: (context, index) {
                          final _item = widget.sections[index];
                          return ListTile(
                            leading: _item.icon,
                            title: _item.label,
                            selected: index == _sectionIndex,
                            onTap: () {
                              if (_sectionIndex != index) {
                                if (mounted)
                                  setState(() {
                                    _sectionIndex = index;
                                  });
                                _setUpController(false);
                              }
                            },
                          );
                        },
                        itemCount: widget.sections.length,
                      ),
                    ),
                  ),
                Container(
                  width: 400,
                  child: Builder(
                    builder: (_) {
                      final _section = widget.sections[_sectionIndex];
                      return Scaffold(
                        appBar: AppBar(
                          leading: !_expanded && constraints.maxWidth >= 720
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
                        body: ListView.builder(
                          controller: controller,
                          itemBuilder: (context, index) {
                            final _item = _section.itemBuilder(
                                context, index, _listIndex == index);
                            return AutoScrollTag(
                              controller: controller,
                              key: ValueKey(index),
                              index: index,
                              child: GestureDetector(
                                child: _item,
                                onTap: () {
                                  if (_listIndex != index) {
                                    if (mounted)
                                      setState(() {
                                        _listIndex = index;
                                      });
                                  }
                                },
                              ),
                            );
                          },
                          itemCount: _section.itemCount,
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (_) {
                      final _details = widget.sections[_sectionIndex]
                          .getDetails(context, _listIndex);
                      return Scaffold(
                        appBar: AppBar(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              if (widget.showDetailsArrows)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.arrow_upward),
                                      onPressed: _listIndex == 0
                                          ? null
                                          : () {
                                              if (mounted)
                                                setState(() {
                                                  _listIndex--;
                                                });
                                              _scrollToIndex(_listIndex);
                                            },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.arrow_downward),
                                      onPressed: widget.sections.isNotEmpty &&
                                              _listIndex ==
                                                  widget.sections.length - 1
                                          ? null
                                          : () {
                                              if (mounted)
                                                setState(() {
                                                  _listIndex++;
                                                });
                                              _scrollToIndex(_listIndex);
                                            },
                                    ),
                                  ],
                                ),
                              if (_details?.title != null)
                                Expanded(
                                  child: Center(child: _details.title),
                                ),
                            ],
                          ),
                          actions: _details.actions,
                        ),
                        body: _details.child,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('Inbox'),
          ),
        );
      },
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
  });
  final Text label;
  final Icon icon;
  final int itemCount;
  final Widget Function(BuildContext context, int index, bool selected)
      itemBuilder;
  final DetailsWidget Function(BuildContext context, int index) getDetails;
}

class DetailsWidget {
  const DetailsWidget({
    @required this.child,
    this.actions,
    this.title,
  });
  final Text title;
  final Widget child;
  final List<Widget> actions;
}
