import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tesandroid/src/models/product.dart';
import 'package:tesandroid/src/models/product_price.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'tesandroid.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE products(product_id TEXT PRIMARY KEY NOT NULL, product_name TEXT NOT NULL,product_type TEXT, product_group TEXT, product_weight REAL, uom TEXT, dnr_code TEXT, sap_code TEXT,price INTEGER NOT NULL, is_ppn_include TEXT NOT NULL, product_weight_uom TEXT NOT NULL)",
        );
        await database.execute(
          "CREATE TABLE products_price(product_id TEXT PRIMARY KEY NOT NULL, price INTEGER NOT NULL,branch_id TEXT NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertProduct(List<Product> products) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var product in products) {
      result = await db.insert('products', product.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    return result;
  }

  Future<int> insertProductPrice(List<ProductPrice> products) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var product in products) {
      result = await db.insert('products_price', product.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    return result;
  }

  Future<List<Product>> retrieveProductWithSearch(String variable) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        'SELECT p.product_name, p.price, r.branch_id FROM products p LEFT JOIN products_price r ON p.product_id = r.product_id WHERE product_name LIKE ? OR p.price LIKE ?',
        ['%$variable%', '%$variable%']);
    return queryResult.map((e) => Product.fromMap(e)).toList();
  }

  Future<List<Product>> retrieveProducts(String table, String order) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        'SELECT p.product_name, p.price, r.branch_id FROM products p LEFT JOIN products_price r ON p.product_id = r.product_id ORDER BY p.' +
            table +
            ' ' +
            order);
    ;
    return queryResult.map((e) => Product.fromMap(e)).toList();
  }

  Future<void> deleteProducts(String productId) async {
    final db = await initializeDB();
    await db.delete(
      'products',
      where: "product_id = ?",
      whereArgs: [productId],
    );
  }
}
