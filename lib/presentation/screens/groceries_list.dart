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

  bool _isLoading = true;
  String? _error;

  void _loadItems() async {
    final url = Uri.https(
        'flutter-pet-7d5d7-default-rtdb.europe-west1.firebasedatabase.app',
        'shopping-list.json');

    final response = await http.get(url);
    if (response.statusCode >= 400) {
      setState(() {
        _error = 'Failed to fetch data. Please try again later.';
      });
    }

    if (response.body == 'null') {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
              (element) => element.value.title == item.value['category'])
          .value;
      loadedItems.add(GroceryItem(
          category: category,
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity']));
    }

    setState(() {
      _groceryItems = loadedItems;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

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

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);

    setState(() {
      _groceryItems.remove(item);
    });
    final url = Uri.https(
        'flutter-pet-7d5d7-default-rtdb.europe-west1.firebasedatabase.app',
        'shopping-list/${item.id}.json');
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text(
        'You have no items ((',
        style: TextStyle(fontSize: 24),
      ),
    );

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemBuilder: (ctx, index) {
          return GroceryListItem(
            item: _groceryItems[index],
            onRemove: _removeItem,
          );
        },
        itemCount: _groceryItems.length,
      );
    }

    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Groceries'),
          actions: [
            IconButton(onPressed: _addItem, icon: const Icon(Icons.add))
          ],
        ),
        body: content);
  }
}
