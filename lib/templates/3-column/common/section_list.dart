import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../three_column_navigation.dart';

class SectionList extends StatelessWidget {
  const SectionList({
    Key? key,
    required this.controller,
    required MainSection section,
    required int listIndex,
    required this.listTap,
  })   : _section = section,
        _listIndex = listIndex,
        super(key: key);

  final AutoScrollController? controller;
  final MainSection _section;
  final int _listIndex;
  final ValueChanged<int> listTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      itemBuilder: (context, index) {
        final _item = _section.itemBuilder(context, index, _listIndex == index);
        return AutoScrollTag(
          controller: controller!,
          key: ValueKey(index),
          index: index,
          child: GestureDetector(
            onTap: () => listTap(index),
            child: _item,
          ),
        );
      },
      itemCount: _section.itemCount,
    );
  }
}
