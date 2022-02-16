class ClassModel{

  int? id;
  String time;
  int day;
  int subjectId;

  ClassModel({this.id,required this.time,required this.day, required this.subjectId});

  Map<String,Object?> toJson() {
    return {
      'id':id,
      'time':time,
      'day':day,
      'subjectId':subjectId
    };
  }
}