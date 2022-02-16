import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organize_college/models/term_model.dart';


import '../../database/class_helper.dart';
import '../../models/class_model.dart';
import '../../utils/strings.dart';
import 'calculator_state.dart';

class CalculatorCubit extends Cubit<CalculatorState>{
  CalculatorCubit() : super(CalculatorInitial());

  changeTerms(List<TermModel> terms){
    emit(CalculatorFilled(terms));
  }

  changeTerm(TermModel term){
    List<TermModel> newList = state.getTerms().map((TermModel e) {
        if(term.id==e.id){
          return term;
        }
        return e;
    }).toList();
    emit(CalculatorFilled(newList));
  }

}