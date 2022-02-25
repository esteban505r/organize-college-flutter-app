import 'package:organize_college/models/subject_model.dart';
import 'package:organize_college/utils/database_utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

import '../models/class_model.dart';

class ClassHelper{

  static final ClassHelper _instance = ClassHelper._internal();

  ClassHelper._internal();

  factory ClassHelper(){
    return _instance;
  }

  insertClass(ClassModel classModel) async{
    final Database db = await DatabaseUtils.getDatabase();

    return await db.insert(
      'class',
      classModel.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ClassModel>> getClasses() async {
    final Database db = await DatabaseUtils.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('class');

    return List.generate(maps.length, (i) {
      return ClassModel(
        id: maps[i]['id'],
        time: maps[i]['time'],
        day: maps[i]['day'],
        subjectId: maps[i]['subjectId'],
      );
    });
  }

  getClassesByDay(int day) async {
    final Database db = await DatabaseUtils.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('class',where: "day = $day");

    return List.generate(maps.length, (i) {
      return ClassModel(
        id: maps[i]['id'],
        time: maps[i]['time'],
        day: maps[i]['day'],
        subjectId: maps[i]['subjectId'],
      );
    });
  }

  getClassesBySubject(int id) async {
    final Database db = await DatabaseUtils.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('class',where: "subjectId = $id");

    return List.generate(maps.length, (i) {
      return ClassModel(
        id: maps[i]['id'],
        time: maps[i]['time'],
        day: maps[i]['day'],
        subjectId: maps[i]['subjectId'],
      );
    });
  }

}