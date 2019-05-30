import 'package:flutter/material.dart';

import '../three_column_navigation.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({
    Key key,
    @required int listIndex,
    @required DetailsWidget details,
    this.previous,
    this.next,
    this.isLast = false,
    this.isFirst = false,
    this.automaticallyImplyLeading = true,
    this.showDetailsArrows = false,
  })  : _listIndex = listIndex,
        _details = details,
        super(key: key);

  final int _listIndex;
  final DetailsWidget _details;
  final VoidCallback previous, next;
  final bool showDetailsArrows;
  final bool isLast, isFirst;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: automaticallyImplyLeading,
        title: !showDetailsArrows
            ? _details.title
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_upward),
                        onPressed: isFirst ? null : previous,
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_downward),
                        onPressed: isLast ? null : next,
                      ),
                    ],
                  ),
                  if (_details?.title != null)
                    Expanded(
                      child: Center(child: _details.title),
                    ),
                ],
              ),
        actions: _details?.actions,
      ),
      body: _details.child,
      bottomNavigationBar: _details?.bottomAppBar,
    );
  }
}
