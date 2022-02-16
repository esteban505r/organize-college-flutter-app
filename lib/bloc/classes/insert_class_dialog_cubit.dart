import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organize_college/models/color_model.dart';
import 'package:organize_college/models/icon_model.dart';
import 'package:organize_college/models/subject_model.dart';
import 'insert_class_dialog_state.dart';

class InsertClassDialogCubit extends Cubit<InsertClassDialogState> {
  InsertClassDialogCubit(
      {required int day,
      required String time,
      required SubjectModel subjectSelected,required List<SubjectModel> subjects})
      : super(InsertClassDialogInitial(day: day,time: time,subjectSelected: subjectSelected, subjects: subjects));

  void selectDay(int day) {
    emit(state.copyWith(day: day));
  }

  void selectTime(String time) {
    emit(state.copyWith(time: time));
  }

  void selectSubject(SubjectModel subjectSelected) {
    emit(state.copyWith(subjectSelected: subjectSelected));
  }

}
