import 'package:flutter/material.dart';
import 'package:jwt_learning/services/products_service.dart';
import 'package:jwt_learning/services/search_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductsService _productsService = ProductsService();
  final SearchService _searchService = SearchService();
  final TextEditingController searchController = TextEditingController();
  List<dynamic> products = [];
  bool isLoading = true;
  bool _productLoaded=false;

  Future<void>loadedProducts()async{
    if(_productLoaded)return;
    _productLoaded=true;
    await loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading = true;
    notifyListeners();
    try {
      products = await _productsService.getProducts();
    } catch (e) {
      products = [];
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> searchProducts() async {
    final query = searchController.text;
    final result = await _searchService.searchProducts(query);
    products = result;
    searchController.clear();
    notifyListeners();
  }

  void addProduct(dynamic newProduct) {
    products.insert(0, newProduct);
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
