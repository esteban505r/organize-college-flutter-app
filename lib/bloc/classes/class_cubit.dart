import 'package:flutter_bloc/flutter_bloc.dart';


import '../../database/class_helper.dart';
import '../../models/class_model.dart';
import '../../utils/strings.dart';
import 'class_state.dart';

class ClassCubit extends Cubit<ClassState>{
  ClassCubit() : super(ClassInitial());

  final ClassHelper _classHelper = ClassHelper();

  void getClasses() async{
    emit(ClassLoading());
    List<ClassModel> classes = await _classHelper.getClasses();
    emit(ClassFilled(classes));
  }

  void getClassesByDay(int day) async{
    emit(ClassLoading());
    List<ClassModel> classes = await _classHelper.getClassesByDay(day);
    emit(ClassFilled(classes));
  }

  Future<void> insertClass(ClassModel subjectModel) async {
    emit(ClassLoading());
    int result = await _classHelper.insertClass(subjectModel);
    if(result>0){
      emit(ClassSuccessful(Strings.successfulInsertSubject));
      getClasses();
    }
    else{
      emit(ClassError(Strings.errorInsertSubject));
    }
  }
}