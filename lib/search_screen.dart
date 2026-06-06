import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<dynamic> _allProducts = [];
  List<dynamic> _filtered = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await ApiService.getProducts();
      setState(() {
        _allProducts = products;
        _filtered = products;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  void _filterResults(String query) {
    setState(() {
      if (query.isEmpty) {
        _filtered = _allProducts;
      } else {
        _filtered = _allProducts.where((item) {
          final name = (item['name'] ?? '').toString().toLowerCase();
          final category = (item['category'] ?? '').toString().toLowerCase();
          return name.contains(query.toLowerCase()) || category.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  IconData _getCategoryIcon(String? category) {
    if (category == null) return Icons.shopping_bag_outlined;
    switch (category.toLowerCase()) {
      case 'dairy': return Icons.water_drop_outlined;
      case 'meat': return Icons.kebab_dining_rounded;
      case 'produce': return Icons.eco_outlined;
      case 'bakery': return Icons.bakery_dining_rounded;
      default: return Icons.shopping_bag_outlined;
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
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
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: _filterResults,
          style: const TextStyle(fontSize: 15, color: Color(0xFF0D1F14)),
          decoration: InputDecoration(
            hintText: "Search grocery items...",
            hintStyle: const TextStyle(color: Color(0xFFADBDB6), fontSize: 15),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            fillColor: Colors.transparent,
            filled: true,
            prefixIcon: Icon(Icons.search_rounded, color: cs.primary, size: 18),
            prefixIconConstraints: const BoxConstraints(minWidth: 40),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F5F2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.close_rounded, size: 14, color: Color(0xFF6B7C72)),
              ),
              onPressed: () {
                _searchController.clear();
                _filterResults('');
              },
            ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE2EAE5)),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: cs.primary, strokeWidth: 2.5))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_searchController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Text(
                      "${_filtered.length} result${_filtered.length == 1 ? '' : 's'} for \"${_searchController.text}\"",
                      style: const TextStyle(fontSize: 12, color: Color(0xFF9AB0A5)),
                    ),
                  ),
                Expanded(
                  child: _filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F5F2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.search_off_rounded,
                                  size: 40,
                                  color: Color(0xFFBDCFC6),
                                ),
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                "No items found",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0D1F14),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Try a different search term",
                                style: TextStyle(fontSize: 13, color: Color(0xFF6B7C72)),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                          itemCount: _filtered.length,
                          itemBuilder: (context, index) {
                            final item = _filtered[index];
                            final String itemName = item['name'] ?? 'Unnamed';
                            final String itemCategory = item['category'] ?? 'General';
                            final String itemQuantity = item['quantity'] ?? '1 unit';
                            final Color catColor = _getCategoryColor(itemCategory);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailScreen(name: itemName),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: catColor.withOpacity(0.15)),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: catColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          _getCategoryIcon(itemCategory),
                                          color: catColor,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              itemName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                color: Color(0xFF0D1F14),
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: catColor.withOpacity(0.08),
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: Text(
                                                    itemCategory,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w600,
                                                      color: catColor,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  itemQuantity,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Color(0xFF9AB0A5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(Icons.chevron_right_rounded, color: catColor.withOpacity(0.5), size: 18),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}