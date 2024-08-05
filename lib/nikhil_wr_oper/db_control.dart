import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{

  //variables
  static const dbName = "myDatabase.db";
  static const dbVersion = 1;
  static const dbTable = "myBoooks";

  static const columnId = "id";
  static const columnTitle = "title";
  static const columnPrice = "price";

  //constructor
  static final DatabaseHelper instance = DatabaseHelper();

  //database initialization
  static Database? _database;

  Future<Database?> get database async{
    _database ??= await initDB();
    return _database;
  }

  initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(path, version: dbVersion, onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async{
    db.execute(''' 
      CREATE TABLE $dbTable(
      $columnId INTEGER PRIMARY KEY,
      $columnTitle TEXT NOT NULL,
      $columnPrice INTEGER NOT NULL)
    ''');
  }

  //insert method
  insert_record(Map<String, dynamic> row) async{
    Database? db = await instance.database;
    return await db!.insert(dbTable, row);
  }

  //read database
Future<List<Map<String, dynamic>>> readDatabase() async{
    Database? db = await instance.database;
    return await db!.query(dbTable);
}

}