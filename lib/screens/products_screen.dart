import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_learning/services/products_add_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final durationController = TextEditingController();
  final totalHoursController = TextEditingController();
  final priceController = TextEditingController();
  final categoryController = TextEditingController();
  final languageController = TextEditingController();
  final levelController = TextEditingController();
  final ProductsAddService _addService = ProductsAddService();

  final types = ['Dadisha Courses', 'Partner Courses'];
  String? selectedType;
  bool isLoading = false;

  Future<void> addProducts() async {
    setState(() {
      isLoading = true;
    });
    try {
      final newProduct = await _addService.addProduct(
        name: nameController.text,
        types: selectedType ?? '',
        description: descriptionController.text,
        hours: totalHoursController.text,
        salePrice: priceController.text,
        category: categoryController.text,
        language: languageController.text,
        level: levelController.text,
      );
      nameController.clear();
      descriptionController.clear();
      durationController.clear();
      totalHoursController.clear();
      priceController.clear();
      if (!mounted) return;
      Navigator.pop(context, newProduct);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product : $e')));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    durationController.dispose();
    totalHoursController.dispose();
    priceController.dispose();
    categoryController.dispose();
    levelController.dispose();
    languageController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontSize: 15),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Add Product',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: _decoration('Product name'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
              initialValue: selectedType,
              decoration: _decoration('Type'),
              items: types
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (value) => setState(() => selectedType = value),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: _decoration('Small description'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: totalHoursController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: _decoration('Total hours'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),

              decoration: _decoration('Price').copyWith(prefixText: '\$ '),
            ),
            SizedBox(height: 16),
            TextField(
              controller: categoryController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: _decoration('Category'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: languageController,
              keyboardType: TextInputType.number,
              decoration: _decoration('Language'),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            SizedBox(height: 16),
            TextField(
              controller: levelController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: _decoration('Level'),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: addProducts,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
