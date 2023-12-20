import 'package:flutter/material.dart';
import 'package:untitled3/Screen/productlistscreen.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'addcatalogscreen.dart';
import 'addproductscreen.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ChangeThemeProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddCatalogScreen()),
                );
              },
              child: Text('Add Catalog'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductScreen()),
                );
              },
              child: Text('Add Product'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductListScreen()),
                );
              },
              child: Text('View Products'),
            ),
          ],
        ),
      ),
      floatingActionButton:
      FloatingActionButton(
        onPressed: () {
          themeProvider.toggleTheme();
        },
        child: Icon(Icons.sunny) ,
        tooltip: 'Theme', // Всплывающая подсказка при долгом нажатии
      ),
    );
  }
}