import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Talkies/database/User.dart';

class DbProvider {
  static Database _database;

  static String createTable =
      "CREATE TABLE USER( id INTEGER PRIMARY KEY, email TEXT ,password TEXT)";

  Future<Database> get database async {
    print("called Databse Init");

    if (_database != null) {
      return _database;
    } else {
      _database = await initDb();
      return _database;
    }
  }

  initDb() async {
    Directory userDirectory = await getApplicationDocumentsDirectory();
    String path = join(userDirectory.path, "user.db");
    _database = await openDatabase(path,
        version: 1, onOpen: (db) {}, onCreate: _onCreate);
    return _database;
  }

  // Creating a table name Employee with fields
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(createTable);
    print("Created tables");
  }

  void saveUser(User user) async {
    var dbUser = await _database;
    await dbUser.transaction((txn) async {
      return await txn.rawInsert('INSERT INTO USER(email,password) VALUES(' +
          '\'' +
          user.email +
          '\'' +
          ',' +
          '\'' +
          user.password +
          '\'' +
          ')');
    });
  }

  Future<User> getUser() async {
    var dbuser = await _database;
    User user = new User();

    List<Map> maplist = await dbuser.rawQuery("SELECT * FROM USER");
    if (maplist.length != 0) {
      user.email = maplist[0]["email"];
      user.password = maplist[0]["password"];
      return user;
    }
    return null;
  }
}
