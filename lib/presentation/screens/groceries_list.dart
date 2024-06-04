import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/presentation/widgets/grocery_list_item.dart';
import 'package:shopping_list/presentation/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceriesList extends StatefulWidget {
  const GroceriesList({super.key});

  @override
  State<GroceriesList> createState() => _GroceriesListState();
}

class _GroceriesListState extends State<GroceriesList> {
  List<GroceryItem> _groceryItems = [];

  void _loadItems() async {
    final url = Uri.https(
        'flutter-pet-7d5d7-default-rtdb.europe-west1.firebasedatabase.app',
        'shopping-list.json');
    final response = await http.get(url);
    final Map<String, dynamic> listData =
        json.decode(response.body);
    final List<GroceryItem> _loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
              (element) => element.value.title == item.value['category'])
          .value;
      _loadedItems.add(GroceryItem(
          category: category,
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity']));
    }

    setState(() {
      _groceryItems = _loadedItems;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _addItem() async {
    await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (ctx) => const NewItem()),
    );
    _loadItems();
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
