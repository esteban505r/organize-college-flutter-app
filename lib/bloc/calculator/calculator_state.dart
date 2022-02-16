
import 'package:flutter/material.dart';
import 'package:organize_college/models/subject_model.dart';
import 'package:organize_college/models/term_model.dart';

import '../../models/class_model.dart';

@immutable
abstract class CalculatorState{
  List<TermModel> getTerms();
}

class CalculatorInitial extends CalculatorState{
  final List<TermModel> terms = List.generate(4, (index) => TermModel(id: index+1,percentage: 25,mark: 0));

  @override
  getTerms() {
    return terms;
  }
}

class CalculatorFilled extends CalculatorState{
  final List<TermModel> terms;
  CalculatorFilled(this.terms);

  @override
  getTerms() {
    return terms;
  }
}
