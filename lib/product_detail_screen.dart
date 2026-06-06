import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final String name;
  final String category;
  final String quantity;
  final bool isBought;

  const ProductDetailScreen({
    super.key,
    required this.name,
    this.category = 'General',
    this.quantity = '1 unit',
    this.isBought = false,
  });

  String _getCategoryEmoji(String cat) {
    switch (cat.toLowerCase()) {
      case 'dairy':    return "🥛";
      case 'meat':     return "🥩";
      case 'produce':  return "🥬";
      case 'bakery':   return "🍞";
      default:         return "🛍️";
    }
  }

  Color _getCategoryColor(String cat) {
    switch (cat.toLowerCase()) {
      case 'dairy':   return const Color(0xFF3B82F6);
      case 'meat':    return const Color(0xFFEF4444);
      case 'produce': return const Color.fromARGB(255, 9, 66, 30);
      case 'bakery':  return const Color(0xFFF59E0B);
      default:        return const Color(0xFF8B5CF6);
    }
  }

  String _getCategoryTip(String cat) {
    switch (cat.toLowerCase()) {
      case 'dairy':   return "Keep refrigerated below 4°C";
      case 'meat':    return "Store in fridge, use within 2 days";
      case 'produce': return "Keep cool & dry for freshness";
      case 'bakery':  return "Best consumed within 2–3 days";
      default:        return "Store in a cool, dry place";
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 700;
    final Color catColor = _getCategoryColor(category);
    final String catEmoji = _getCategoryEmoji(category);

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
          "Item Details",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF0D1F14)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero card — colour & emoji match the category
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [catColor.withOpacity(0.08), catColor.withOpacity(0.02)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: catColor.withOpacity(0.15)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: catColor.withOpacity(0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(catEmoji, style: const TextStyle(fontSize: 38)),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0D1F14),
                      letterSpacing: -0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: isBought
                          ? const Color(0xFF16A34A).withOpacity(0.1)
                          : const Color(0xFFF59E0B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isBought ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                          size: 13,
                          color: isBought ? const Color(0xFF16A34A) : const Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isBought ? "Checked off" : "Pending purchase",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isBought ? const Color(0xFF16A34A) : const Color(0xFFF59E0B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            const Text("Specifications",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF0D1F14))),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2EAE5)),
              ),
              child: Column(
                children: [
                  _specRow("📂", "Category", category, catColor),
                  _divider(),
                  _specRow("📦", "Quantity", quantity, const Color(0xFF374840)),
                  _divider(),
                  _specRow("🏷️", "Status", isBought ? "Bought ✓" : "Pending",
                      isBought ? const Color.fromARGB(255, 9, 72, 32) : const Color(0xFFF59E0B)),
                  _divider(),
                  _specRow("💡", "Storage tip", _getCategoryTip(category), const Color(0xFF9AB0A5)),
                ],
              ),
            ),

            const SizedBox(height: 22),

            const Text("Notes",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF0D1F14))),
            const SizedBox(height: 10),

            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Add storage details, brand preference, or reminders...",
                hintStyle: TextStyle(color: Color(0xFFADBDB6), fontSize: 13),
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 22),

            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: const Text("Back to list"),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF16A34A),
                side: const BorderSide(color: Color(0xFFBBF7D0)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 48),
              ),
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

  Widget _divider() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Divider(height: 1, color: Color(0xFFF0F5F2)),
      );

  Widget _specRow(String emoji, String label, String value, Color valueColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Text("$label:",
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7C72), fontWeight: FontWeight.w500)),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: valueColor),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
