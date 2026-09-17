import 'dart:convert';

import 'package:http/http.dart' as https;
import 'package:shared_preferences/shared_preferences.dart';

class ProductsService {
  static const baseUrl = 'https://dadishaapi.kodhatch.com/api/admin/courses';

  Future<List<dynamic>> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('tokenKey');
    final response = await https.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load courses');
    }
  }
}
