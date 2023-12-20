import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/Screen/addcatalogscreen.dart';

import '../DB/dbhelper.dart';
import '../Model/catalog.dart';
import '../Model/product.dart';
import '../main.dart';
import 'addproductscreen.dart';
import 'homescreen.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Map<String, List<Product>> groupedProducts = {};

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    List<Product> products = await DBHelper.getProducts();
    groupedProducts = {};
    for (var product in products) {
      Catalog? catalog = await DBHelper.getCatalogById(product.catalogId);
      if (catalog != null) {
        groupedProducts.putIfAbsent(catalog.name, () => []).add(product);
      }
    }
    setState(() {});
  }

    void _navigateToEditCatalogScreen(BuildContext context, String catalogName) async {
      final catalog = await DBHelper.getCatalogByName(catalogName);
      if (catalog != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddCatalogScreen(catalog: catalog)),
        );
      }
    }

    void _deleteProduct(String id) async {
      await DBHelper.deleteProduct(id);
      _loadProducts();
    }

    void _navigateToEditProductScreen(BuildContext context, String productId) async {
      final product = await DBHelper.getProductById(productId);
      if (product != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddProductScreen(product: product)),
        );
      }
    }

    @override
    Widget build(BuildContext context) {
      final themeProvider = ChangeThemeProvider.of(context);
      return Scaffold(
        appBar: AppBar(
          title: Text('Product List'),
          automaticallyImplyLeading: false,
        ),
        body: groupedProducts == null
            ? CircularProgressIndicator()
            : ListView.builder(
          itemCount: groupedProducts.length,
          itemBuilder: (context, index) {
            String catalogId = groupedProducts.keys.elementAt(index);
            List<Product> products = groupedProducts[catalogId]!;
            return ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Catalog $catalogId'),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _navigateToEditCatalogScreen(context, catalogId);
                    },
                  ),
                ],
              ),
              children: products.map((product) => Card(
                child: ListTile(
                  title: Text(product.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _navigateToEditProductScreen(context, product.id);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteProduct(product.id);
                        },
                      ),
                    ],
                  ),
                ),
              )).toList(),
            );
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                          (Route<dynamic> route) => false,
                    );
                  },
                  child: Icon(Icons.home), // Иконка домика
                  tooltip: 'Home', // Всплывающая подсказка при долгом нажатии
                ),
                FloatingActionButton(
                  onPressed: () {
                    themeProvider.toggleTheme();
                  },
                  child: Icon(Icons.sunny) ,
                  tooltip: 'Theme', // Всплывающая подсказка при долгом нажатии
                ),
              ]
          )
        )
      );
  }
}
