import 'package:flutter/material.dart';
import 'package:untitled3/Screen/productlistscreen.dart';
import 'package:uuid/uuid.dart';

import '../DB/dbhelper.dart';
import '../Model/catalog.dart';
import '../Model/product.dart';
import '../main.dart';
import 'homescreen.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;

  AddProductScreen({this.product});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  static const uuid = Uuid();
  String _productName = '';
  String? _selectedCatalogId;
  List<Catalog> _catalogs = [];
  bool _isLoading = true;
  String _id = uuid.v1().toString();

  @override
  void initState() {
    super.initState();
    _productName = widget.product?.name ?? '';
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _selectedCatalogId = widget.product?.catalogId;
    _loadCatalogs();
  }

  void _loadCatalogs() async {
    _catalogs = await DBHelper.getCatalogs();
    setState(() => _isLoading = false);
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (widget.product == null && _selectedCatalogId != null) {
        await DBHelper.addProduct(Product(name: _productName, catalogId: _selectedCatalogId.toString(), id: _id));
      } else if (widget.product != null && _selectedCatalogId != null) {
        await DBHelper.updateProduct(Product(id: widget.product!.id, name: _productName, catalogId: _selectedCatalogId.toString()));
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ChangeThemeProvider.of(context);
    return Scaffold(
      appBar: AppBar(
          title: Text('Add Product'),
          automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                onSaved: (value) {
                  _productName = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField <String>(
                decoration: const InputDecoration(labelText: 'Catalog Name'),
                value: _selectedCatalogId,
                isExpanded: true,
                onChanged: (newValue) {
                  setState(() {
                    _selectedCatalogId = newValue!;
                  });
                },
                items: _catalogs.map<DropdownMenuItem<String>>((Catalog catalog) {
                  return DropdownMenuItem<String>(
                    value: catalog.id,
                    child: Text(catalog.name),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please choose catalog';
                  }
                  return null;
                },
                icon: Icon(
                  Icons.book_online_outlined, // Иконка выпадающего списка
                  color: Colors.deepPurple, // Цвет иконки
                ),
                style: TextStyle(
                  color: Colors.black, // Цвет текста выбранного элемента
                  fontSize: 18, // Размер шрифта выбранного элемента
                ),
                dropdownColor: Colors.white, // Цвет фона выпадающего меню
                elevation: 16, // Высота тени выпадающего меню
                borderRadius: BorderRadius.circular(10), // Радиус скругления выпадающего меню
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Отступы для элементов выпадающего меню
              ),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text('Save Product'),
              ),
            ],
          ),
        ),
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