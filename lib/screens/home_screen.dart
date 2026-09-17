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
  void dispose() {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search products',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  onPressed: searchProducts,
                  icon: const Icon(Icons.search),
                ),
              ),
              onSubmitted: (_) => searchProducts(),
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? const Center(child: Text('No products found'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final thumbnail = product['image'] as String?;
                      return Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Card(
                            elevation: 2,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 180,
                                  width: double.infinity,
                                  child: thumbnail != null
                                      ? Image.network(
                                          thumbnail,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) => Container(
                                            color: Colors.grey.shade100,
                                            child: const Icon(
                                              Icons.image_not_supported,
                                              size: 48,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          color: Colors.grey.shade100,
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            size: 48,
                                          ),
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              product['name'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          if (product['mrp'] != null)
                                            Text(
                                              '\$${product['mrp']}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                color: Colors.green,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        product['types'],
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      if (product['large_description'] !=
                                          null) ...[
                                        const SizedBox(height: 10),
                                        Text(
                                          product['large_description'],
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                      const SizedBox(height: 12),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          if (product['total_hour'] != null)
                                            _infoChip(
                                              Icons.timer_outlined,
                                              product['total_hour'].toString(),
                                            ),
                                          if (product['certification_issued'] !=
                                              null)
                                            _infoChip(
                                              Icons.workspace_premium_outlined,
                                              product['certification_issued']
                                                  .toString(),
                                            ),
                                          if (product['requirements'] != null)
                                            _infoChip(
                                              Icons.checklist_outlined,
                                              product['requirements']
                                                  .toString(),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
