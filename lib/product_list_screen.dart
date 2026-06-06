import 'package:flutter/material.dart';
import 'product_detail_screen.dart';
import 'add_item_screen.dart';
import 'search_screen.dart';
import 'services/api_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<dynamic>> _productsFuture;
  final Map<int, bool> _localCheckstates = {};

  @override
  void initState() {
    super.initState();
    _refreshProducts();
  }

  void _refreshProducts() {
    setState(() {
      _productsFuture = ApiService.getProducts();
    });
  }

  String _getCategoryEmoji(String? category) {
    if (category == null) return "🛍️";
    switch (category.toLowerCase()) {
      case 'dairy': return "🥛";
      case 'meat': return "🥩";
      case 'produce': return "🥬";
      case 'bakery': return "🍞";
      default: return "🛍️";
    }
  }

  Color _getCategoryColor(String? category) {
    if (category == null) return const Color(0xFF8B5CF6);
    switch (category.toLowerCase()) {
      case 'dairy': return const Color(0xFF3B82F6);
      case 'meat': return const Color(0xFFEF4444);
      case 'produce': return const Color(0xFF16A34A);
      case 'bakery': return const Color(0xFFF59E0B);
      default: return const Color(0xFF8B5CF6);
    }
  }

  void _showEditDeleteDialog(
    int id,
    String currentName,
    String currentCategory,
    String currentQuantity,
    double currentPrice,
  ) {
    final nameController = TextEditingController(text: currentName);
    final quantityController = TextEditingController(text: currentQuantity);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF16A34A)),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Edit Item",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF0D1F14)),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF9AB0A5)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text("Item name", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF374840))),
              const SizedBox(height: 6),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "e.g. Milk, Eggs...",
                  prefixIcon: Icon(Icons.shopping_basket_outlined, size: 18),
                ),
              ),
              const SizedBox(height: 14),
              const Text("Quantity", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF374840))),
              const SizedBox(height: 6),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  hintText: "e.g. 2 kg, 1 pack",
                  prefixIcon: Icon(Icons.numbers_rounded, size: 18),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await ApiService.deleteProduct(id);
                        _refreshProducts();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFEF4444),
                        side: const BorderSide(color: Color(0xFFFECACA)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Delete", style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await ApiService.updateProductStatus(
                          id,
                          nameController.text,
                          currentPrice,
                          currentCategory,
                          quantityController.text,
                        );
                        _refreshProducts();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 46),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Save changes"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
          "My Grocery List",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: Color(0xFF0D1F14),
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.refresh_rounded, color: cs.primary, size: 18),
            ),
            onPressed: _refreshProducts,
            tooltip: "Refresh",
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Good Evening 👋",
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),

      const SizedBox(height: 4),

      const Text(
        "Let's shop smart today",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0D1F14),
        ),
      ),

      const SizedBox(height: 16),

      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SearchScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFE2EAE5),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: cs.primary,
                size: 18,
              ),
              const SizedBox(width: 10),
              const Text(
                "Search items...",
                style: TextStyle(
                  color: Color(0xFFADBDB6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
),

          // Product list
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: cs.primary, strokeWidth: 2.5),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.wifi_off_rounded, size: 36, color: Color(0xFFEF4444)),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            "Connection failed",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0D1F14)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Make sure your server is running",
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: 160,
                            child: ElevatedButton.icon(
                              onPressed: _refreshProducts,
                              icon: const Icon(Icons.refresh_rounded, size: 16),
                              label: const Text("Try again"),
                              style: ElevatedButton.styleFrom(minimumSize: const Size(0, 44)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text("🧺", style: TextStyle(fontSize: 44)),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          "Your list is empty",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0D1F14)),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Tap + to add your first item",
                          style: TextStyle(fontSize: 13, color: Color(0xFF6B7C72)),
                        ),
                      ],
                    ),
                  );
                }

                final groceries = snapshot.data!;
                final boughtCount =
                    groceries.where((item) {
                      final id = item['id'] ?? 0;
                      final price = double.tryParse(item['price']?.toString() ?? '0') ?? 0.0;
                      return _localCheckstates.containsKey(id)
                          ? _localCheckstates[id]!
                          : price == 1.0;
                    }).length;

                return Column(
                  children: [
                    // Progress banner
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBBF7D0)),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "$boughtCount / ${groceries.length} items checked",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF16A34A),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              boughtCount == groceries.length && groceries.isNotEmpty
                                  ? "All done! 🎉"
                                  : "${groceries.length - boughtCount} remaining",
                              style: TextStyle(
                                fontSize: 12,
                                color: boughtCount == groceries.length
                                    ? const Color(0xFF16A34A)
                                    : const Color(0xFF6B7C72),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 80),
                        itemCount: groceries.length,
                        itemBuilder: (context, index) {
                          final item = groceries[index];
                          final int itemId = item['id'] ?? 0;
                          final String itemName = item['name'] ?? 'Unnamed';
                          final String itemCategory = item['category'] ?? 'General';
                          final String itemQuantity = item['quantity'] ?? '1 unit';

                          double itemPrice = 0.0;
                          if (item['price'] != null) {
                            itemPrice = double.tryParse(item['price'].toString()) ?? 0.0;
                          }

                          bool isBought = _localCheckstates.containsKey(itemId)
                              ? _localCheckstates[itemId]!
                              : (itemPrice == 1.0);

                          Color catColor = _getCategoryColor(itemCategory);
                          String catEmoji = _getCategoryEmoji(itemCategory);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              decoration: BoxDecoration(
  color: isBought ? const Color(0xFFF9FBF9) : Colors.white,

  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ],
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isBought
                                      ? const Color(0xFFE2EAE5)
                                      : catColor.withOpacity(0.2),
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.only(left: 4, right: 12, top: 4, bottom: 4),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                     builder: (_) => ProductDetailScreen(
  name: itemName,
  category: itemCategory,
  quantity: itemQuantity,
  isBought: isBought,
),
                                   ) );
                                },
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: isBought,
                                        onChanged: (bool? value) async {
                                          if (value != null) {
                                            setState(() {
                                              _localCheckstates[itemId] = value;
                                            });
                                            await ApiService.updateProductStatus(
                                              itemId, itemName, value ? 1.0 : 0.0, itemCategory, itemQuantity,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: catColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(catEmoji, style: const TextStyle(fontSize: 18)),
                                    ),
                                  ],
                                ),
                                title: Text(
                                  itemName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: isBought
                                        ? const Color(0xFFADBDB6)
                                        : const Color(0xFF0D1F14),
                                    decoration: isBought ? TextDecoration.lineThrough : null,
                                    decorationColor: const Color(0xFFADBDB6),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: catColor.withOpacity(0.08),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          itemCategory,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: catColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        itemQuantity,
                                        style: const TextStyle(fontSize: 11, color: Color(0xFF9AB0A5)),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.more_vert_rounded, size: 18, color: Color(0xFF9AB0A5)),
                                  onPressed: () => _showEditDeleteDialog(
                                    itemId, itemName, itemCategory, itemQuantity, itemPrice,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddItemScreen(
                onItemAdded: (name, category, quantity) async {
                  await ApiService.addProduct(name, category, quantity);
                  _refreshProducts();
                },
              ),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 11, 90, 40),
        foregroundColor: Colors.white,
        elevation: 8,
        icon: const Icon(Icons.add_rounded),
        label: const Text("Add Item", style: TextStyle(fontWeight: FontWeight.w700)),
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
}