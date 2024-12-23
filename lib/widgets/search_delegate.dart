import 'package:flutter/material.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/services/api_service.dart';
import 'package:ecommerce_app/widgets/product_card.dart';

class ProductSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Search products...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: ApiService().fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No results found"));
        } else {
          List<Product> filteredProducts = snapshot.data!
              .where((product) =>
                  product.title.toLowerCase().contains(query.toLowerCase()))
              .toList();
          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              return ProductCard(product: filteredProducts[index]);
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: ApiService().fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No products available"));
        } else {
          List<Product> filteredProducts = snapshot.data!
              .where((product) =>
                  product.title.toLowerCase().contains(query.toLowerCase()))
              .toList();
          return ListView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filteredProducts[index].title),
                onTap: () {
                  query = filteredProducts[index].title;
                  showResults(context);
                },
              );
            },
          );
        }
      },
    );
  }
}
