import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:soapp/model/item_count_model.dart';

import 'model/sesi_model.dart';

class Db {
  static Database? _db;
  static const String table2 = 'item_counts';
  static const String table1 = 'sesi';
  static const String dbName = 'soapp.db';
  static const itemCountstable = "CREATE TABLE $table2("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "id_sesi INTEGER, "
      "kode_item TEXT, "
      "nama_item TEXT, "
      "kode_sesi TEXT, "
      "carton INTEGER, "
      "box INTEGER, "
      "unit INTEGER, "
      "saldo_item INTEGER, "
      "hitung INTEGER, "
      "selisih INTEGER, "
      "FOREIGN KEY (id_sesi) "
      "REFERENCES sesi(id) "
      "ON DELETE CASCADE)";

  static const sesiTable = "CREATE TABLE $table1("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "kode_sesi TEXT, "
      "tanggal TEXT, "
      "pic TEXT)";
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    var db = await openDatabase(path,
        version: 1, onCreate: _onCreate, onConfigure: _onConfigure);
    return db;
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  _onCreate(Database db, int version) async {
    await db.execute(sesiTable);
    await db.execute(itemCountstable);
  }

  saveSesi(Sesi sesi) async {
    var dbClient = await db;
    sesi.id = await dbClient.insert(table1, sesi.toJson());
    return sesi.id;
  }

  Future<List<Sesi>> getSesi() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(table1, columns: [
      'id',
      'kode_sesi',
      'tanggal',
      'pic',
    ]);

    List<Sesi> sesi = [];
    if (maps.isNotEmpty) {
      for (var i = 0; i < maps.length; i++) {
        sesi.add(Sesi.fromJson(maps[i]));
      }
    }

    return sesi;
  }

  Future<int> deleteSesi(int id) async {
    var dbClient = await db;
    return await dbClient.delete(table1, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateSesi(Sesi sesi) async {
    var dbClient = await db;
    return await dbClient
        .update(table1, sesi.toJson(), where: 'id = ?', whereArgs: [sesi.id]);
  }

  saveItemCounts(List<ItemCount> itemCount) async {
    var dbClient = await db;
    Batch batch = dbClient.batch();
    for (var element in itemCount) {
      batch.insert(table2, element.toJson());
    }
    batch.commit();
  }

  Future<List<ItemCount>> getItemCounts(int id) async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(
      table2,
      columns: [
        'id',
        'id_sesi',
        'kode_item',
        'nama_item',
        'kode_sesi',
        'carton',
        'box',
        'unit',
        'saldo_item',
        'hitung',
        'selisih'
      ],
      where: 'id_sesi = ?',
      whereArgs: [id],
    );

    List<ItemCount> itemCounts = [];
    if (maps.isNotEmpty) {
      for (var i = 0; i < maps.length; i++) {
        itemCounts.add(ItemCount.fromJson(maps[i]));
      }
    }

    return itemCounts;
  }

  Future<int> deleteItemCounts(int id) async {
    var dbClient = await db;
    return await dbClient.delete(table2, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateItemCounts(ItemCount itemCount) async {
    var dbClient = await db;
    return await dbClient.update(table2, itemCount.toJson(),
        where: 'id = ?', whereArgs: [itemCount.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
