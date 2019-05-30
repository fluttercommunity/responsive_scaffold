import 'package:flutter/material.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';

class MultiColumnNavigationExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThreeColumnNavigation(
      showDetailsArrows: true,
      sections: [
        MainSection(
          label: Text('All Inboxes'),
          icon: Icon(Icons.mail),
          itemCount: 100,
          itemBuilder: (context, index, selected) {
            return ListTile(
              selected: selected,
              title: Text('Test A $index'),
            );
          },
          getDetails: (context, index) {
            return DetailsWidget(
              title: Text('Details'),
              child: Center(
                child: Text(
                  index.toString(),
                ),
              ),
            );
          },
        ),
        MainSection(
          label: Text('Sent Mail'),
          icon: Icon(Icons.send),
          itemCount: 100,
          itemBuilder: (context, index, selected) {
            return ListTile(
              selected: selected,
              title: Text('Test B $index'),
            );
          },
          getDetails: (context, index) {
            return DetailsWidget(
              title: Text('Details'),
              actions: [
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {},
                ),
              ],
              child: Center(
                child: Text(
                  index.toString(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
