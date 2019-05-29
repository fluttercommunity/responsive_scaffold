import 'package:flutter_web/material.dart';

class DetailsScreen {
  const DetailsScreen({
    this.appBar,
    @required this.body,
  });

  final Widget body;
  final PreferredSizeWidget appBar;
}
