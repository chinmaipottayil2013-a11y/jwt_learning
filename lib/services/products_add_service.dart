import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductsAddService {
  final String baseUri = 'https://dadishaapi.kodhatch.com/api/admin/courses/';

  Future<dynamic> addProduct({
    required String name,
    required String types,
    required String description,
    required String hours,
    required String salePrice,
    required String category,
    required String language,
    required String level,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('tokenKey');

    final parsedCategory = int.tryParse(category) ?? 1;
    final parsedLanguage = int.tryParse(language) ?? 1;
    final parsedLevel = int.tryParse(level) ?? 1;
    final parsedHours = int.tryParse(hours) ?? 10;

    final response = await http.post(
      Uri.parse(baseUri),
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "name": name,
        "slug": name.
        toLowerCase().
        replaceAll(RegExp(r'[^a-z0-9]+'), '-'),
        "small_description": description,
        "large_description":
            "<p>${description.isNotEmpty ? description : 'Course description'}</p>",
        "sale_price": salePrice.isNotEmpty ? salePrice : "2999.00",
        "mrp": "2999.00",
        "total_hour": parsedHours,
        "intended_for": "Safety Engineers, HSE Officers, and Site Supervisors",
        "certification_issued": "Advanced HSE Professional Certification",
        "certification_validity": 525600,
        "requirements": "Basic understanding of industrial safety guidelines",
        "types": types.isNotEmpty ? types : "Dadisha Courses",
        "level": parsedLevel,
        "category": [parsedCategory],
        "industry": [1],
        "language": parsedLanguage,
        "downloadable_files": 5,
        "free_course": false,
        "is_active": true,
        "is_featured": false,
        "badge": "Bestseller",
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      try {
        final errorData = jsonDecode(response.body);
        final msg = errorData['message'] ?? errorData['detail'] ?? response.body;
        throw Exception(msg);
      } catch (e) {
        if (e is Exception && !e.toString().contains('FormatException')) {
          rethrow;
        }
        throw Exception(
          'Failed to add product (Status: ${response.statusCode})',
        );
      }
    }
  }
}
