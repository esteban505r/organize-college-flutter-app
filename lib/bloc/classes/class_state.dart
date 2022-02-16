
import 'package:flutter/material.dart';
import 'package:organize_college/models/subject_model.dart';

import '../../models/class_model.dart';

@immutable
abstract class ClassState{}

class ClassInitial extends ClassState{
  final List<SubjectModel> classes = [];
}

class ClassFilled extends ClassState{
  final List<ClassModel> classes;
  ClassFilled(this.classes);
}

class ClassLoading extends ClassState{}

class ClassError extends ClassState{
  final String message;
  final Object? error;
  ClassError(this.message, {this.error});
}

class ClassSuccessful extends ClassState{
  final String message;
  ClassSuccessful(this.message);
}