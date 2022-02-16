import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organize_college/bloc/classes/class_cubit.dart';
import 'package:organize_college/bloc/subjects/subjects_state.dart';
import 'package:organize_college/database/subject_helper.dart';
import 'package:organize_college/models/class_model.dart';
import 'package:organize_college/models/subject_model.dart';

import '../bloc/classes/class_state.dart';
import '../bloc/classes/insert_class_dialog_cubit.dart';
import '../bloc/classes/insert_class_dialog_state.dart';
import '../bloc/subjects/subjects_cubit.dart';
import '../utils/colors.dart';
import '../utils/colors_info.dart';
import '../utils/icons_info.dart';
import '../utils/utils.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 7, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      context.read<ClassCubit>().getClasses();
      context.read<SubjectsCubit>().getSubjects();
    });

    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: const Text("Horario"),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              ZoomDrawer.of(context)?.toggle();
            },
          ),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(
                text: "Lunes",
              ),
              Tab(
                text: "Martes",
              ),
              Tab(
                text: "Miercoles",
              ),
              Tab(
                text: "Jueves",
              ),
              Tab(
                text: "Viernes",
              ),
              Tab(
                text: "Sabado",
              ),
              Tab(
                text: "Domingo",
              ),
            ],
            onTap: (value) {
              context.read<ClassCubit>().getClasses();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: AppColors.secondaryColor,
          onPressed: () async {
            //_insertClassDialog(context);
            /*context.read<ClassCubit>().insertClass(
                ClassModel(time: "TIME", day: 1, subjectId: 1));*/
            _insertClassDialog(context);
            //DefaultTabController.of(context)?.animateTo(1);
          },
        ),
        body: BlocBuilder<SubjectsCubit, SubjectsState>(
            builder: (context, snapshot) {
          switch (snapshot.runtimeType) {
            case SubjectsFilled:
              return _createTabView(snapshot as SubjectsFilled);
            case SubjectsLoading:
            case SubjectsInitial:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case SubjectsError:
              return const Center(
                child: Text("Error"),
              );
            default:
              return Container();
          }
        }),
      );
    });
  }

  void _insertClassDialog(BuildContext context) async {
    int dayToAnimate = _tabController.index + 1;
    SubjectHelper subjectHelper = SubjectHelper();
    List<SubjectModel> subjects = await subjectHelper.getSubjects();
    ClassModel? classModel = await showDialog<ClassModel>(
        context: context,
        builder: (context) {
          TextEditingController dayController = TextEditingController();
          TextEditingController timeController = TextEditingController();
          TextEditingController teacherController = TextEditingController();
          InsertClassDialogCubit cubit = InsertClassDialogCubit(
              day: 1,
              time: "8:00",
              subjectSelected: subjects[0],
              subjects: subjects);
          return BlocBuilder<InsertClassDialogCubit, InsertClassDialogState>(
              bloc: cubit,
              builder: (context, snapshot) {
                return AlertDialog(
                  contentPadding: const EdgeInsets.only(
                      left: 25, right: 25, top: 15, bottom: 10),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Añadir materia",
                          style: GoogleFonts.balsamiqSans(
                              textStyle: const TextStyle(
                                  color: AppColors.primaryColor, fontSize: 23)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _createDropDownDays(snapshot, cubit),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () async {
                            TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime:
                                    const TimeOfDay(hour: 8, minute: 00));
                            cubit.selectTime(
                                "${Utils.formatTime(time?.hour ?? 8)}:${Utils.formatTime(time?.minute ?? 00)}");
                          },
                          child: TextField(
                            controller: timeController
                              ..text = cubit.state.getTime(),
                            onChanged: (value) {
                              cubit.selectTime(value);
                            },
                            decoration: const InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(),
                                disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                hintText: "Hora",
                                suffixIcon: Icon(
                                  Icons.schedule,
                                  color: Colors.black,
                                  size: 26,
                                ),
                                hintStyle: TextStyle(color: Colors.black),
                                enabled: false),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        _createDropDownSubjects(snapshot, cubit),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancelar",
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(
                                    context,
                                    ClassModel(
                                        time: snapshot.getTime(),
                                        day: snapshot.getDay(),
                                        subjectId:
                                            snapshot.getSubjectSelected().id ??
                                                1));
                                dayToAnimate = snapshot.getDay() - 1;
                              },
                              child: const Text(
                                "Aceptar",
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });
        });
    if (classModel != null) {
      context.read<ClassCubit>().insertClass(classModel);
      _tabController.animateTo(dayToAnimate);
    }
  }

  Widget _createWidgetClassFilled(
      ClassFilled snapshot, SubjectsFilled subjectsSnapshot) {
    return TabBarView(
      controller: _tabController,
      children: List.generate(7, (tabIndex) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: InkWell(
                    onTap: () {},
                    child: _createClassCard(
                        snapshot, tabIndex, index, subjectsSnapshot)),
              );
            },
            itemCount: snapshot.classes
                .where((element) => element.day == tabIndex + 1)
                .toList()
                .length,
          ),
        );
      }),
    );
  }

  Widget _createDropDownSubjects(
      InsertClassDialogState state, InsertClassDialogCubit cubit) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: Colors.grey)),
        child: DropdownButton<SubjectModel>(
          isExpanded: true,
          underline: Container(),
          borderRadius: BorderRadius.circular(10),
          items: state
              .getSubjects()
              .map((e) => DropdownMenuItem<SubjectModel>(
                    value: e,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.name),
                        Row(
                          children: [
                            const VerticalDivider(
                              width: 20,
                              thickness: 2,
                            ),
                            Icon(IconsInfo.getIconById(e.icon ?? 0).icon),
                          ],
                        ),
                      ],
                    ),
                  ))
              .toList(),
          onChanged: (SubjectModel? value) {
            if (value != null) {
              cubit.selectSubject(value);
            }
          },
          value: state.getSubjectSelected(),
        ),
      ),
    );
  }

  Widget _createDropDownDays(
      InsertClassDialogState state, InsertClassDialogCubit cubit) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: Colors.grey)),
        child: DropdownButton<int>(
          isExpanded: true,
          underline: Container(),
          borderRadius: BorderRadius.circular(10),
          items: [1, 2, 3, 4, 5, 6, 7]
              .map((e) => DropdownMenuItem<int>(
                    value: e,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Utils.getDayById(e)),
                        Row(
                          children: [
                            const VerticalDivider(
                              width: 20,
                              thickness: 2,
                            ),
                            Text(
                              e.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))
              .toList(),
          onChanged: (int? value) {
            if (value != null) {
              cubit.selectDay(value);
            }
          },
          value: state.getDay(),
        ),
      ),
    );
  }

  _createClassCard(ClassFilled snapshot, int tabIndex, int index,
      SubjectsFilled subjectSnapshot) {
    ClassModel classModel = _getClassesByDay(snapshot, tabIndex, index);
    SubjectModel subjectModel = subjectSnapshot.subjects
        .firstWhere((element) => classModel.subjectId == element.id);
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              IconsInfo.getIconById(
                                  //(snapshot.subjects[index].icon) ?? 0).icon,
                                  subjectModel.icon??0).icon,
                              size: 30,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            subjectModel.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          classModel.time + " - Salon " + (subjectModel.room??"Sin salon"),
                          style: GoogleFonts.roboto(textStyle: const TextStyle(fontSize: 14,color: AppColors.primaryColor)),
                        ),
                      ),
                    ],
                  ),
                  /*Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: ColorsInfo.getColorById(
                            //snapshot.classes[index].color ?? 0).color),
                            0).color),
                    child: const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  )*/
                ],
              ),
            ],
          ),
        ));
  }

  Widget _createTabView(SubjectsFilled subjectsSnapshot) {
    return BlocBuilder<ClassCubit, ClassState>(
      builder: (context, snapshot) {
        switch (snapshot.runtimeType) {
          case ClassFilled:
            return _createWidgetClassFilled(
                snapshot as ClassFilled, subjectsSnapshot);
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }

  ClassModel _getClassesByDay(ClassFilled snapshot, int tabIndex, int index) {
    return snapshot.classes
        .where(
          (element) => element.day == tabIndex + 1,
        )
        .toList()[index];
  }
}
