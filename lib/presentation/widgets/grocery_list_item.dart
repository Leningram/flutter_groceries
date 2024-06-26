import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';

class GroceryListItem extends StatelessWidget {
  const GroceryListItem(
      {super.key, required this.item, required this.onRemove});

  final GroceryItem item;
  final Function(GroceryItem item) onRemove;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        onRemove(item);
      },
      key: ValueKey(item.id),
      child: ListTile(
        title: Text(item.name),
        leading: Container(
          width: 24,
          height: 24,
          color: item.category.color,
        ),
        trailing: Text(
          item.quantity.toString(),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
