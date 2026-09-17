import 'package:flutter/material.dart';

import 'package:jwt_learning/services/products_add_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final ProductsAddService _addService = ProductsAddService();

  Future<void> addProducts() async {
    final title = nameController.text;
    final price = double.parse(priceController.text);
    final newProduct = await _addService.addProduct(title, price);
    nameController.clear();
    priceController.clear();
    if (!mounted) return;
    Navigator.pop(context, newProduct);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Products Adding Page'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Product name'),
          ),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Price'),
          ),
          SizedBox(height: 10),
          ElevatedButton(onPressed: addProducts, child: Icon(Icons.add)),
        ],
      ),
    );
  }
}
