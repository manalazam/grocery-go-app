import 'package:flutter/material.dart';
import 'services/api_service.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late Future<List<dynamic>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ApiService.getProducts();
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
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 13,
              color: cs.primary,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Insights",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF0D1F14),
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final products = snapshot.data!;

          int totalItems = products.length;

          int boughtItems = products.where((item) {
            final price =
                double.tryParse(item['price']?.toString() ?? '0') ?? 0;
            return price == 1.0;
          }).length;

          int pendingItems = totalItems - boughtItems;

          double progress =
              totalItems == 0 ? 0 : boughtItems / totalItems;

          int dairy = 0;
          int bakery = 0;
          int produce = 0;
          int meat = 0;
          int other = 0;

          for (var item in products) {
            final category =
                (item['category'] ?? '').toString().toLowerCase();

            switch (category) {
              case 'dairy':
                dairy++;
                break;
              case 'bakery':
                bakery++;
                break;
              case 'produce':
                produce++;
                break;
              case 'meat':
                meat++;
                break;
              default:
                other++;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                /// Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF166534),
                        Color(0xFF16A34A),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.analytics_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Shopping Overview",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "$boughtItems of $totalItems items completed",
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                /// Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        Icons.shopping_bag_outlined,
                        "Total",
                        "$totalItems",
                        const Color(0xFF3B82F6),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _statCard(
                        Icons.check_circle_outline,
                        "Bought",
                        "$boughtItems",
                        const Color(0xFF16A34A),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        Icons.pending_actions_rounded,
                        "Pending",
                        "$pendingItems",
                        const Color(0xFFF59E0B),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _statCard(
                        Icons.percent_rounded,
                        "Progress",
                        "${(progress * 100).toStringAsFixed(0)}%",
                        const Color(0xFF8B5CF6),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// Progress Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFFE2EAE5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Completion Progress",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 14),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                        borderRadius: BorderRadius.circular(20),
                        backgroundColor: const Color(0xFFE5E7EB),
                        color: const Color(0xFF16A34A),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${(progress * 100).toStringAsFixed(0)}% completed",
                        style: const TextStyle(
                          color: Color(0xFF6B7C72),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// Category Breakdown
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFFE2EAE5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Category Breakdown",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 15),

                      _categoryRow("🥛 Dairy", dairy),
                      _categoryRow("🥬 Produce", produce),
                      _categoryRow("🍞 Bakery", bakery),
                      _categoryRow("🥩 Meat", meat),
                      _categoryRow("📦 Other", other),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// Summary
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFFBBF7D0),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Color(0xFF16A34A),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Keep checking off items as you shop to track your progress efficiently.",
                          style: TextStyle(
                            color: Color(0xFF166534),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statCard(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2EAE5)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(title),
        ],
      ),
    );
  }

  Widget _categoryRow(String label, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label),
          const Spacer(),
          Text(
            count.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}