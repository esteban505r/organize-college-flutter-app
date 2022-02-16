import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organize_college/bloc/subjects/subjects_state.dart';
import 'package:organize_college/database/subject_helper.dart';
import 'package:organize_college/models/subject_model.dart';

import '../../utils/strings.dart';

class SubjectsCubit extends Cubit<SubjectsState>{
  SubjectsCubit() : super(SubjectsInitial());

  final SubjectHelper _subjectHelper = SubjectHelper();

  void getSubjects() async{
    emit(SubjectsLoading());
    List<SubjectModel> subjects = await _subjectHelper.getSubjects();
    emit(SubjectsFilled(subjects));
  }

  void getSubjectById(int id) async{
    emit(SubjectsLoading());
    List<SubjectModel> subjects = await _subjectHelper.getSubjectsById(id);
    emit(SubjectsFilled(subjects));
  }

  Future<void> insertSubject(SubjectModel subjectModel) async {
    emit(SubjectsLoading());
    int result = await _subjectHelper.insertSubject(subjectModel);
    if(result>0){
      emit(SubjectsSuccessful(Strings.successfulInsertSubject));
      getSubjects();
    }
    else{
      emit(SubjectsError(Strings.errorInsertSubject));
    }
  }
}