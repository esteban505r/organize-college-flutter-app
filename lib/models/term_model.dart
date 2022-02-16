class TermModel{

  int? id;
  double percentage;
  double mark;

  TermModel({this.id, required this.percentage, required this.mark});

  TermModel copyWith({int? id, double? percentage, double? mark}){
    return TermModel(id:id??this.id,percentage: percentage??this.percentage, mark: mark??this.mark);
  }
}