import 'package:flutter/material.dart';
import 'package:organize_college/models/icon_model.dart';
import 'package:organize_college/models/subject_model.dart';
import 'package:organize_college/utils/icons_info.dart';

import '../../models/color_model.dart';
import '../../utils/colors_info.dart';

@immutable
abstract class InsertClassDialogState {
  List<SubjectModel> getSubjects();
  SubjectModel getSubjectSelected();
  String getTime();
  int getDay();

  InsertClassDialogSelected copyWith(
      {List<SubjectModel>? subjects,SubjectModel? subjectSelected, String? time, int? day}) {
    return InsertClassDialogSelected(
        subjects: subjects?? getSubjects(),
        subjectSelected: subjectSelected ?? getSubjectSelected(),
        time: time ?? getTime(),
        day: day ?? getDay());
  }
}

class InsertClassDialogInitial extends InsertClassDialogState {
  final SubjectModel subjectSelected;
  final String time;
  final int day;
  final List<SubjectModel> subjects;

  InsertClassDialogInitial(
      {required this.subjectSelected, required this.time, required this.day, required this.subjects});

  @override
  int getDay() {
    return day;
  }

  @override
  SubjectModel getSubjectSelected() {
    return subjectSelected;
  }

  @override
  String getTime() {
    return time;
  }

  @override
  List<SubjectModel> getSubjects() {
    return subjects;
  }
}

class InsertClassDialogSelected extends InsertClassDialogState {
  final List<SubjectModel> subjects;
  final SubjectModel subjectSelected;
  final String time;
  final int day;

  InsertClassDialogSelected(
      {required this.subjectSelected, required this.time, required this.day,required this.subjects});

  @override
  int getDay() {
    return day;
  }

  @override
  SubjectModel getSubjectSelected() {
    return subjectSelected;
  }

  @override
  String getTime() {
    return time;
  }

  @override
  List<SubjectModel> getSubjects() {
    return subjects;
  }
}
