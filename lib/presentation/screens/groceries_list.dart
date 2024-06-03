import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/presentation/widgets/grocery_list_item.dart';

class GroceriesList extends StatelessWidget {
  const GroceriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          return GroceryListItem(item: groceryItems[index]);
        },
        itemCount: groceryItems.length,
      ),
    );
  }
}
