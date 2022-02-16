import 'package:flutter/material.dart';
import 'package:organize_college/models/subject_model.dart';

@immutable
abstract class SubjectsState {
  List<SubjectModel> getSubjects();
}

class SubjectsInitial extends SubjectsState {
  final List<SubjectModel> subjects = [];

  @override
  List<SubjectModel> getSubjects() {
    return subjects;
  }
}

class SubjectsFilled extends SubjectsState {
  final List<SubjectModel> subjects;
  SubjectsFilled(this.subjects);

  @override
  List<SubjectModel> getSubjects() {
    return subjects;
  }
}

class SubjectsLoading extends SubjectsState {
  @override
  List<SubjectModel> getSubjects() {
    return [];
  }
}

class SubjectsError extends SubjectsState {
  final String message;
  final Object? error;
  SubjectsError(this.message, {this.error});
  @override
  List<SubjectModel> getSubjects() {
    return [];
  }
}

class SubjectsSuccessful extends SubjectsState {
  final String message;
  SubjectsSuccessful(this.message);
  @override
  List<SubjectModel> getSubjects() {
    return [];
  }
}
