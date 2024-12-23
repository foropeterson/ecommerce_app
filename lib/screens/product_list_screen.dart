import 'package:ecommerce_app/widgets/search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/services/api_service.dart';
import 'package:ecommerce_app/widgets/product_card.dart';
import 'package:ecommerce_app/utils/error_handler.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> futureProducts;
  TextEditingController searchController = TextEditingController();
  List<Product> allProducts = [];
  List<Product> displayedProducts = [];

  @override
  void initState() {
    super.initState();
    futureProducts = ApiService().fetchProducts();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      List<Product> products = await ApiService().fetchProducts();
      setState(() {
        allProducts = products;
        displayedProducts = allProducts;
      });
    } catch (e) {
      setState(() {
        displayedProducts = [];
      });
      showErrorDialog(context, "Error: $e", fetchProducts);
    }
  }

  void filterProducts(String query) {
    List<Product> filteredProducts = allProducts
        .where((product) =>
            product.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      displayedProducts = filteredProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ProductSearchDelegate());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No products available"));
          } else {
            return RefreshIndicator(
              onRefresh: fetchProducts,
              child: GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: displayedProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: displayedProducts[index]);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
