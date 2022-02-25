import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/subjects/insert_subject_dialog_cubit.dart';
import '../bloc/subjects/insert_subject_dialog_state.dart';
import '../bloc/subjects/subjects_cubit.dart';
import '../bloc/subjects/subjects_state.dart';
import '../models/color_model.dart';
import '../models/icon_model.dart';
import '../models/subject_model.dart';
import '../utils/colors.dart';
import '../utils/colors_info.dart';
import '../utils/icons_info.dart';
import 'detail_subject_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      context.read<SubjectsCubit>().getSubjects();
    });
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text("Materias"),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              ZoomDrawer.of(context)?.toggle();
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: AppColors.secondaryColor,
        onPressed: () async {
          _insertSubjectDialog(context);
        },
      ),
      body: BlocBuilder<SubjectsCubit, SubjectsState>(
          builder: (context, snapshot) {
            switch (snapshot.runtimeType) {
              case SubjectsFilled:
                return _createWidgetSubjectsFilled(snapshot as SubjectsFilled);
              case SubjectsLoading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                return Container();
            }
          }),
    );
  }

  void _insertSubjectDialog(BuildContext context) async {
    SubjectModel? subjectModel = await showDialog<SubjectModel>(
        context: context,
        builder: (context) {
          TextEditingController nameController = TextEditingController();
          TextEditingController roomController = TextEditingController();
          TextEditingController teacherController = TextEditingController();
          InsertSubjectDialogCubit cubit = InsertSubjectDialogCubit();
          return BlocBuilder<InsertSubjectDialogCubit,
              InsertSubjectDialogState>(
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
                        TextField(
                          controller: nameController,
                          onChanged: (value) {
                            cubit.selectName(value);
                          },
                          decoration: const InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                              hintText: "Nombre"),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: roomController,
                          onChanged: (value) {
                            cubit.selectRoom(value);
                          },
                          decoration: const InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                              hintText: "Salon"),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          onChanged: (value) {
                            cubit.selectTeacher(value);
                          },
                          controller: teacherController,
                          decoration: const InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                              hintText: "Teacher"),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        _createDropDownIcons(snapshot, cubit),
                        const SizedBox(
                          height: 15,
                        ),
                        _createDropDownColors(snapshot, cubit),
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
                                    SubjectModel(
                                        name: snapshot.getName(),
                                        teacher: snapshot.getTeacher(),
                                        room: snapshot.getRoom(),
                                        color: snapshot.getColorSelected().id,
                                        icon: snapshot.getIconSelected().id));
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
    if (subjectModel != null) {
      context.read<SubjectsCubit>().insertSubject(subjectModel);
    }
  }

  Widget _createDropDownIcons(
      InsertSubjectDialogState state, InsertSubjectDialogCubit cubit) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: Colors.grey)),
        child: DropdownButton<IconModel>(
          isExpanded: true,
          underline: Container(),
          borderRadius: BorderRadius.circular(10),
          items: IconsInfo.allIcons
              .map((e) => DropdownMenuItem<IconModel>(
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
                    Icon(e.icon),
                  ],
                ),
              ],
            ),
          ))
              .toList(),
          onChanged: (IconModel? value) {
            cubit.selectIcon(value);
          },
          value: state.getIconSelected(),
        ),
      ),
    );
  }

  Widget _createDropDownColors(
      InsertSubjectDialogState state, InsertSubjectDialogCubit cubit) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: Colors.grey)),
        child: DropdownButton<ColorModel>(
          underline: Container(),
          isExpanded: true,
          borderRadius: BorderRadius.circular(10),
          items: ColorsInfo.allColors
              .map((e) => DropdownMenuItem<ColorModel>(
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
                    Container(
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      decoration: BoxDecoration(
                          color: e.color,
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ],
                ),
              ],
            ),
          ))
              .toList(),
          onChanged: (ColorModel? value) {
            cubit.selectColor(value);
          },
          value: state.getColorSelected(),
        ),
      ),
    );
  }


  Widget _createWidgetSubjectsFilled(SubjectsFilled snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: InkWell(
              onTap: () async {
               await  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailSubjectPage(snapshot.getSubjects()[index].id??1)));
                context.read<SubjectsCubit>().getSubjects();
              },
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    IconsInfo.getIconById(
                                        (snapshot.subjects[index].icon) ??
                                            0)
                                        .icon,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  snapshot.subjects[index].name,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: ColorsInfo.getColorById(
                                      snapshot.subjects[index].color ?? 0)
                                      .color),
                              child: const Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
          );
        },
        itemCount: snapshot.subjects.length,
      ),
    );
  }
}
