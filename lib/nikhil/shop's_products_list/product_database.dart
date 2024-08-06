import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class ProductDatabase{


  //variables
  static const dbName = "myDatabase.db";
  static const dbVersion = 1;
  static const dbTable = "myTable";
   //table column name
  static const columnId = "id";
  static const columnName = "name";
  static const columnPrice = "price";
  static const columnIsAvailability = "is_availability";
  static const columnCategory = "category";
  static const columnSizeQuantity = "size_quantity";
  static const columnItemImageUrl = "item_image_url";


  //constructor
  static final ProductDatabase instance = ProductDatabase();

  //database intialization
  static Database? _database;

  Future<Database?> get database async{
    _database ??= await initDB();
    return _database;

  }

  initDB() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(path, version: dbVersion, onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async{
    db.execute('''
      CREATE TABLE $dbTable(
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL,
      $columnPrice INTEGER NOT NULL,
      $columnIsAvailability INTEGER NOT NULL,
      $columnCategory TEXT NOT NULL,
      $columnSizeQuantity INTEGER NOT NULL,
      $columnItemImageUrl TEXT NOT NULL)
    ''');
  }

  //INSERT METHOD
  insertRecord(Map<String, dynamic> row) async{
    Database? db = await instance.database;
    return await db!.insert(dbTable, row);
  }

  //read database
  Future<List<Map<String, dynamic>>> readDatabase() async{
    Database? db = await instance.database;
    return await db!.query(dbTable);
  }
}