import 'package:organize_college/models/class_model.dart';

class SubjectModel{

  int? id;
  String name;
  int? icon;
  String? room;
  int? color;
  String? teacher;


  SubjectModel({this.id,required this.name, this.icon, this.room,
    this.color,this.teacher});

  Map<String,Object?> toJson() {
    return {
      'id':id,
      'name':name,
      'icon':icon,
      'room':room,
      'color':color,
      'teacher':teacher
    };
  }


}