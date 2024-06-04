import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/presentation/widgets/grocery_list_item.dart';
import 'package:shopping_list/presentation/widgets/new_item.dart';

class GroceriesList extends StatefulWidget {
  const GroceriesList({super.key});

  @override
  State<GroceriesList> createState() => _GroceriesListState();
}

class _GroceriesListState extends State<GroceriesList> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (ctx) => const NewItem()),
    );

    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _onRemove(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: _groceryItems.isNotEmpty
          ? ListView.builder(
              itemBuilder: (ctx, index) {
                return GroceryListItem(
                  item: _groceryItems[index],
                  onRemove: _onRemove,
                );
              },
              itemCount: _groceryItems.length,
            )
          : const Center(
              child: Text(
                'You have no items ((',
                style: TextStyle(fontSize: 24),
              ),
            ),
    );
  }
}
