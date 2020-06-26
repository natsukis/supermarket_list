import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:supermarket_list/model/list.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();

  String tblMarketList = "marketlist";
  String colId = "id";
  String colQuantity = "quantity";
  String colArticle = "article";
  String colStatus = "status";
  String colDate = "date";

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "supermarket.db";
    var dbExpenses = await openDatabase(path, version: 1, onCreate: _create, onUpgrade: _upgrade);
    return dbExpenses;
  }

  void _create(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tblMarketList($colId INTEGER PRIMARY KEY, $colQuantity INTEGER , $colArticle TEXT, " +
            "$colStatus INTEGER, $colDate TEXT)");
      }

  void _upgrade(Database db, int version, int update) async {  
  }

  Future<int> insertProduct(SuperMarketList product) async {
    Database db = await this.db;
    var result = await db.insert(tblMarketList, product.toMap());
    return result;
  }

  Future<List> getProduct() async {
    Database db = await this.db;
    var result =
        await db.rawQuery("SELECT * FROM $tblMarketList order by $colArticle ASC");
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("Select count (*) from $tblMarketList"));
    return result;
  }

  Future<int> updateProduct(SuperMarketList product) async {
    Database db = await this.db;
    var result = await db.update(tblMarketList, product.toMap(),
        where: "$colId = ?", whereArgs: [product.id]);
    return result;
  }

  Future<int> deleteProduct(int id) async {
    int result;
    Database db = await this.db;
    result = await db.rawDelete('DELETE FROM $tblMarketList WHERE $colId = $id');
    return result;
  }
}