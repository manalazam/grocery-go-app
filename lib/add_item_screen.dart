import 'package:flutter/material.dart';

class AddItemScreen extends StatefulWidget {
  final Function(String name, String category, String quantity) onItemAdded;

  const AddItemScreen({super.key, required this.onItemAdded});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  String _selectedCategory = 'General';

  final List<Map<String, dynamic>> _categories = [
    {'name': 'General', 'emoji': '🛍️', 'color': const Color(0xFF8B5CF6)},
    {'name': 'Dairy', 'emoji': '🥛', 'color': const Color(0xFF3B82F6)},
    {'name': 'Meat', 'emoji': '🥩', 'color': const Color(0xFFEF4444)},
    {'name': 'Produce', 'emoji': '🥬', 'color': const Color.fromARGB(255, 14, 102, 46)},
    {'name': 'Bakery', 'emoji': '🍞', 'color': const Color(0xFFF59E0B)},
  ];

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 700;

    Widget body = Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2EAE5)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded, size: 13, color: cs.primary),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add Item",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF0D1F14)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cs.primary.withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text("➕", style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "New grocery item",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF0D1F14),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Fill in the details to add to your list",
                        style: TextStyle(fontSize: 12, color: Color(0xFF6B7C72)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            _fieldLabel("Item name"),
            const SizedBox(height: 6),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "e.g. Milk, Eggs, Bread",
                prefixIcon: Icon(Icons.fastfood_outlined, size: 18),
              ),
            ),

            const SizedBox(height: 16),

            _fieldLabel("Quantity"),
            const SizedBox(height: 6),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                hintText: "e.g. 2 liters, 1 kg, 6 pack",
                prefixIcon: Icon(Icons.straighten_rounded, size: 18),
              ),
            ),

            const SizedBox(height: 22),

            _fieldLabel("Category"),
            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((cat) {
                final bool isSelected = _selectedCategory == cat['name'];
                final Color catColor = cat['color'] as Color;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat['name']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? catColor.withOpacity(0.12) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? catColor : const Color(0xFFE2EAE5),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(cat['emoji'], style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 7),
                        Text(
                          cat['name'],
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 13,
                            color: isSelected ? catColor : const Color(0xFF374840),
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 5),
                          Icon(Icons.check_circle_rounded, size: 14, color: catColor),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 36),

            ElevatedButton.icon(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  widget.onItemAdded(
                    nameController.text,
                    _selectedCategory,
                    quantityController.text.isEmpty ? '1 unit' : quantityController.text,
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Please enter an item name"),
                      backgroundColor: const Color(0xFF16A34A),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.check_rounded, size: 18),
              label: const Text("Save to list"),
            ),
          ],
        ),
      ),
    );

    if (isDesktop) {
      return Scaffold(
        backgroundColor: const Color(0xFFECF5EE),
        body: Center(
          child: Container(
            width: 440,
            margin: const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 32,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: body,
            ),
          ),
        ),
      );
    }
    return body;
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374840),
      ),
    );
  }
}