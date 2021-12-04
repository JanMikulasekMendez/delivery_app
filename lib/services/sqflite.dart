import 'package:deliveryapp/models/package.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLHelper {
  Future<Database> loadDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'my_db.db');
    var db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
// When creating the db, create the table
      await db.execute(
          'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
    });
    return db;
  }

  Future insertPackage({required Package package}) async {
    // Insert some records in a transaction
    var db = await loadDatabase();
    await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO Test(name, value, num) VALUES(${package.name}, 1234, 456.789)');
      print('inserted1: $id1');
    });
  }
}
