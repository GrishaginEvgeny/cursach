import 'package:flutter/material.dart';
import 'package:untitled3/Screen/productlistscreen.dart';
import 'package:uuid/uuid.dart';

import '../DB/dbhelper.dart';
import '../Model/catalog.dart';
import '../main.dart';
import 'homescreen.dart';

class AddCatalogScreen extends StatefulWidget {
  final Catalog? catalog;

  AddCatalogScreen({this.catalog});

  @override
  _AddCatalogScreenState createState() => _AddCatalogScreenState();
}

class _AddCatalogScreenState extends State<AddCatalogScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  static const uuid = Uuid();
  String _catalogName = '';
  String _id = uuid.v1().toString();

  @override
  void initState() {
    super.initState();
    _catalogName = widget.catalog?.name ?? '';
    _nameController = TextEditingController(text: widget.catalog?.name ?? '');
  }

  void _saveCatalog() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.catalog == null) {
        await DBHelper.addCatalog(Catalog(name: _catalogName, id: _id));
      } else {
        await DBHelper.addCatalog(Catalog(name: _catalogName, id: widget.catalog!.id));
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
          title: Text('Add Catalog'),
          automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Catalog Name'),
                onSaved: (value) {
                  _catalogName = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a catalog name';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _saveCatalog,
                child: Text('Save Catalog'),
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
