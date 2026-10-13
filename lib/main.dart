import 'package:flutter/material.dart';

void main() {
  runApp(const ShoppingApp());
}

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> items = ['Milk', 'Bread', 'Rice'];
  final Set<String> boughtItems = {};
  final TextEditingController controller = TextEditingController();

  void addItem() {
    String text = controller.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Type an item first'),
        ),
      );
      return;
    }

    setState(() {
      items.add(text);
    });

    controller.clear();
  }

  void deleteItem(String item) {
    setState(() {
      items.remove(item);
      boughtItems.remove(item);
    });
  }

  void clearBoughtItems() {
    setState(() {
      items.removeWhere((item) => boughtItems.contains(item));
      boughtItems.clear();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter an item',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => addItem(),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: addItem,
                    child: const Text('Add'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  String item = items[index];

                  return ListTile(
                    title: Text(
                      item,
                      style: TextStyle(
                        decoration: boughtItems.contains(item)
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: Colors.black,
                        decorationThickness: 3,
                        color: boughtItems.contains(item)
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                    leading: Checkbox(
                      value: boughtItems.contains(item),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            boughtItems.add(item);
                          } else {
                            boughtItems.remove(item);
                          }
                        });
                      },
                    ),
                    trailing: TextButton(
                      onPressed: () => deleteItem(item),
                      child: const Text('Delete'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: clearBoughtItems,
                child: const Text('Clear Bought Items'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}