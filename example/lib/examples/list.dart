import 'package:flutter/material.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';

class ListExample extends StatefulWidget {
  const ListExample({Key? key}) : super(key: key);

  @override
  _ListExampleState createState() => _ListExampleState();
}

class _ListExampleState extends State<ListExample> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late List<String> _items;

  @override
  void initState() {
    _items = List.generate(20, (int index) => "test_$index");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveListScaffold.builder(
      scaffoldKey: _scaffoldKey,
      detailBuilder: (BuildContext context, int index, bool tablet) {
        final i = _items[index];
        return DetailsScreen(
          body: ExampleDetailsScreen(
            row: i,
            tablet: tablet,
            onDelete: () {
              setState(() {
                _items.removeAt(index);
              });
              if (!tablet) Navigator.of(context).pop();
            },
            onChanged: (String value) {
              setState(() {
                _items[index] = value;
              });
            },
          ),
        );
      },
      nullItems: const Center(child: CircularProgressIndicator()),
      emptyItems: const Center(child: Text("No Items Found")),
      slivers: const <Widget>[
        SliverAppBar(
          title: Text("App Bar"),
        ),
      ],
      itemCount: _items.length,
      itemBuilder: (BuildContext context, int index) {
        final i = _items[index];
        return ListTile(
          leading: Text(i),
        );
      },
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        child: IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Snackbar!"),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ExampleDetailsScreen extends StatelessWidget {
  const ExampleDetailsScreen({
    Key? key,
    required this.row,
    required this.tablet,
    required this.onDelete,
    required this.onChanged,
  })   : 
        super(key: key);

  final String row;
  final bool tablet;
  final VoidCallback onDelete;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: !tablet,
        title: const Text("Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              onChanged("$row ${DateTime.now().toString()}");
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        child: IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {},
        ),
      ),
      body: Center(
        child: Text("Item: $row"),
      ),
    );
  }
}
