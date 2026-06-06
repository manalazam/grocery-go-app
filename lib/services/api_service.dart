import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3006/api';
    return 'http://10.0.2.2:3006/api';
  }

 static Future<List<dynamic>> getProducts() async {
  try {
    print("========== API DEBUG ==========");
    print("Calling: $baseUrl/products");

    final response = await http.get(
      Uri.parse('$baseUrl/products'),
    );

    print("Status Code: ${response.statusCode}");
    print("Response Body:");
    print(response.body);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      print("Decoded Type: ${decoded.runtimeType}");

      if (decoded is List) {
        print("Products Count: ${decoded.length}");
        return decoded;
      }

      throw Exception("Backend returned non-list JSON");
    }

    throw Exception(
      "HTTP ${response.statusCode}: ${response.body}",
    );
  } catch (e) {
    print("API ERROR: $e");
    throw Exception("Error connecting to backend: $e");
  }
}

  static Future<bool> addProduct(String name, String category, String quantity) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "category": category,
          "quantity": quantity,
          "price": 0.0,
        }),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> updateProductStatus(
    int id,
    String name,
    double price,
    String category,
    String quantity,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/products/$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "price": price,
          "category": category,
          "quantity": quantity,
        }),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> deleteProduct(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/products/$id'));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}