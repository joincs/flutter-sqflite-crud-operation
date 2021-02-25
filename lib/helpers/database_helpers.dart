import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_battery/models/BatteryModels.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;

  DatabaseHelper._instance();

  String batteryTable = 'batteryTable';
  String colId = 'id';
  String colName = 'name';
  String colDate = 'date';
  String colStorageLoction = 'storageLocation';
  String colPurchaseData = 'purchaseData';
  String colBatteryType = 'batteryType';
  String colNumberOfCharges = 'numberOfCharge';
  String colChargeStatus = 'chargeStatus';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'battery_list.db';
    final batteryListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return batteryListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $batteryTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colDate TEXT, $colPurchaseData TEXT, $colStorageLoction TEXT, $colBatteryType TEXT, $colNumberOfCharges TEXT, $colChargeStatus TEXT)');
  }

  Future<List<Map<String, dynamic>>> getBatteryMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(batteryTable);
    return result;
  }

  //get Battery Data

  Future<List<Battery>> getBatteryList() async {
    final List<Map<String, dynamic>> batteryMapList = await getBatteryMapList();
    final List<Battery> batteryList = [];
    batteryMapList.forEach((batteryMap) {
      batteryList.add(Battery.fromMap(batteryMap));
    });
    batteryList
        .sort((batteryA, batteryB) => batteryA.date.compareTo(batteryB.date));
    return batteryList;
  }

  //Insert Battery data

  Future<int> insertBattery(Battery battery) async {
    Database db = await this.db;
    final int result = await db.insert(batteryTable, battery.toMap());
    return result;
  }

  // Update Battery data

  Future<int> updateBattery(Battery battery) async {
    Database db = await this.db;
    final int result = await db.update(
      batteryTable,
      battery.toMap(),
      where: '$colId = ?',
      whereArgs: [battery.id],
    );
    return result;
  }

  // Delete Battery data
  Future<int> deleteBattery(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      batteryTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }
}
