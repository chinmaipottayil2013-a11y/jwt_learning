import 'dart:convert';

import 'package:http/http.dart' as http;
class SearchService {
  Future<List<dynamic>>searchProducts(String query)async{
    final String baseUri='https://dummyjson.com/products/search?q=${query.toLowerCase()}';
    final response=await http.get(Uri.parse(baseUri));
    if(response.statusCode==200){
      final data=jsonDecode(response.body);
      return data['products'];
    }
    throw Exception('Failed to search products');
  }
}