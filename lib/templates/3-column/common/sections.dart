import 'package:flutter/material.dart';

import '../three_column_navigation.dart';

class SectionsList extends StatelessWidget {
  const SectionsList({
    Key key,
    @required this.sectionTap,
    @required int sectionIndex,
    @required this.sections,
  })  : _sectionIndex = sectionIndex,
        super(key: key);

  final int _sectionIndex;
  final ValueChanged<int> sectionTap;
  final List<MainSection> sections;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final _item = sections[index];
        return ListTile(
          leading: _item.icon,
          title: _item.label,
          selected: index == _sectionIndex,
          onTap: () => sectionTap(index),
        );
      },
      itemCount: sections.length,
    );
  }
}
