import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class ProductsAddService {
  final String baseUri = 'https://dadishaapi.kodhatch.com/api/admin/courses';

  Future<dynamic> addProduct(String title, double price) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('tokenKey');
    final response = await http.post(
      Uri.parse(baseUri),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'title': title, 'price': price}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add product');
    }
  }
}
