import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseUtils {
  static Future<Database> getDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'college_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE subject(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, "
              "icon INTEGER, room TEXT,color INTEGER, time TEXT, teacher TEXT);",
        );
        await db.execute(
            "CREATE TABLE class(id INTEGER PRIMARY KEY AUTOINCREMENT, time TEXT NOT NULL, "
            "day INTEGER, subjectId INTEGER, FOREIGN KEY(subjectId) references subject(id));");
        return;
      },
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      version: 1,
    );
  }
}
