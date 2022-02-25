
import 'package:flutter/material.dart';
import 'package:organize_college/models/subject_model.dart';

import '../../models/class_model.dart';

@immutable
abstract class ClassState{
  List<ClassModel> getClasses();
}

class ClassInitial extends ClassState{
  final List<ClassModel> classes = [];

  @override
  List<ClassModel> getClasses() {
    return classes;
  }

}

class ClassFilled extends ClassState{
  final List<ClassModel> classes;
  ClassFilled(this.classes);

  @override
  List<ClassModel> getClasses() {
    return classes;
  }
}

class ClassLoading extends ClassState{
  @override
  List<ClassModel> getClasses() {
    return [];
  }
}

class ClassError extends ClassState{
  final String message;
  final Object? error;
  ClassError(this.message, {this.error});

  @override
  List<ClassModel> getClasses() {
    return [];
  }
}

class ClassSuccessful extends ClassState{
  final String message;
  ClassSuccessful(this.message);

  @override
  List<ClassModel> getClasses() {
    return [];
  }
}