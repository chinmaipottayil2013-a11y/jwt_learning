import 'package:flutter/material.dart';
import 'package:jwt_learning/screens/auth_screen.dart';
import 'package:jwt_learning/screens/products_screen.dart';
import 'package:jwt_learning/services/auth_service.dart';
import 'package:jwt_learning/services/products_service.dart';
import 'package:jwt_learning/services/search_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductsService _productsService = ProductsService();
  final SearchService _searchService = SearchService();
  final AuthService _authService = AuthService();
  final searchController = TextEditingController();
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final data = await _productsService.getProducts();
      setState(() {
        products = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> searchProducts() async {
    final query = searchController.text;
    final result = await _searchService.searchProducts(query);
    setState(() {
      products = result;
    });
    searchController.clear();
  }
  @override
  void dispose(){
    searchController.dispose();
    super.dispose();
  }

  Future<void> logout() async {
    await _authService.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (builder) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: () {
              logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search Products',
              suffixIcon: IconButton(
                onPressed: searchProducts,
                icon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final thumbnail = product['thumbnail'] as String?;
                return ListTile(
                  leading: thumbnail != null
                      ? Image.network(
                          product['thumbnail'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image_not_supported, size: 60),
                  title: Text(product['title']),
                  subtitle: Text('\$${product['price']}'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newProduct = await Navigator.push(
            context,
            MaterialPageRoute(builder: (builder) => const ProductsScreen()),
          );
          if (newProduct != null) {
            setState(() {
              products.insert(0, newProduct);
            });
          }
        },
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}
