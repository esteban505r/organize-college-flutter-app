import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organize_college/models/color_model.dart';
import 'package:organize_college/models/icon_model.dart';
import 'insert_subject_dialog_state.dart';

class InsertSubjectDialogCubit extends Cubit<InsertSubjectDialogState> {
  InsertSubjectDialogCubit() : super(InsertSubjectDialogInitial());

  void selectIcon(IconModel? icon) {
    emit(state.copyWith(iconSelected: icon));
  }

  void selectColor(ColorModel? color) {
    emit(state.copyWith(colorSelected: color));
  }

  void selectName(String? name){
    emit(state.copyWith(name: name));
  }

  void selectRoom(String? room){
    emit(state.copyWith(room: room));
  }

  void selectTeacher(String? teacher){
    emit(state.copyWith(teacher: teacher));
  }
}
