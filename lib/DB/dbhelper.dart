import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Model/catalog.dart';
import '../Model/product.dart';

class DBHelper {
  static Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'catalog_product.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE catalogs(id TEXT PRIMARY KEY, name TEXT NOT NULL)",
        );
        await database.execute(
          "CREATE TABLE products(id TEXT PRIMARY KEY, name TEXT NOT NULL, catalogId TEXT)",
        );
      },
      version: 1,
    );
  }

  static Future<void> addProduct(Product product) async {
    final db = await initializeDB();
    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> addCatalog(Catalog catalog) async {
    final db = await initializeDB();
    await db.insert(
      'catalogs',
      catalog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Product>> getProducts() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        catalogId: maps[i]['catalogId'],
      );
    });
  }

  static Future<List<Catalog>> getCatalogs() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query('catalogs');
    return List.generate(maps.length, (i) {
      return Catalog(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

  static Future<void> updateProduct(Product product) async {
    final db = await initializeDB();
    await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  static Future<void> updateCatalog(Catalog catalog) async {
    final db = await initializeDB();
    await db.update(
      'catalogs',
      catalog.toMap(),
      where: 'id = ?',
      whereArgs: [catalog.id],
    );
  }

  static Future<void> deleteProduct(String id) async {
    final db = await initializeDB();
    await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteCatalog(String id) async {
    final db = await initializeDB();
    await db.delete(
      'catalogs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<Catalog?> getCatalogById(String id) async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'catalogs',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Catalog(
        id: maps[0]['id'],
        name: maps[0]['name'],
      );
    }

    return null;
  }

  static Future<Catalog?> getCatalogByName(String name) async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'catalogs',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return Catalog(
        id: maps[0]['id'],
        name: maps[0]['name'],
      );
    }

    return null;
  }

  static Future<Product?> getProductById(String id) async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Product(
        id: maps[0]['id'],
        name: maps[0]['name'],
        catalogId: maps[0]['catalogId'],
      );
    }

    return null;
  }
}


