import 'package:flutter/material.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';

class MultiColumnNavigationExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThreeColumnNavigation(
      title: Text('Mailboxes'),
      showDetailsArrows: true,
      backgroundColor: Colors.grey[100],
      bottomAppBar: BottomAppBar(
        elevation: 1,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.filter_list,
                color: Colors.transparent,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      sections: [
        MainSection(
          label: Text('All Inboxes'),
          icon: Icon(Icons.mail),
          itemCount: 100,
          itemBuilder: (context, index, selected) {
            return ListTile(
              leading: CircleAvatar(
                child: Text(index.toString()),
              ),
              selected: selected,
              title: Text('Primary Information'),
              subtitle: Text('Here are some details about the item'),
            );
          },
          bottomAppBar: BottomAppBar(
            elevation: 1,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {},
                ),
              ],
            ),
          ),
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
              leading: CircleAvatar(
                child: Text(index.toString()),
              ),
              selected: selected,
              title: Text('Secondary Information'),
              subtitle: Text('Here are some details about the item'),
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
