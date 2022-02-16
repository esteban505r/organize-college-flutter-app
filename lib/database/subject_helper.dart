import 'package:organize_college/models/subject_model.dart';
import 'package:organize_college/utils/database_utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

class SubjectHelper{

  static final SubjectHelper _instance = SubjectHelper._internal();

  SubjectHelper._internal();

  factory SubjectHelper(){
    return _instance;
  }

  insertSubject(SubjectModel subjectModel) async{
    final Database db = await DatabaseUtils.getDatabase();

    return await db.insert(
      'subject',
      subjectModel.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SubjectModel>> getSubjects() async {
    final Database db = await DatabaseUtils.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('subject');

    return List.generate(maps.length, (element) {
      return SubjectModel(
        id: maps[element]['id'],
        name: maps[element]['name'],
        icon: maps[element]['icon'],
        color: maps[element]['color'],
        room: maps[element]['room'],
      );
    });
  }

  getSubjectsById(int id) async {
    final Database db = await DatabaseUtils.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('subject',where: "id = $id");

    return List.generate(maps.length, (element) {
      return SubjectModel(
        id: maps[element]['id'],
        name: maps[element]['name'],
        icon: maps[element]['icon'],
        color: maps[element]['color'],
        room: maps[element]['room'],
      );
    });
  }

}