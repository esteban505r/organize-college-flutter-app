import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organize_college/bloc/subjects/subjects_cubit.dart';
import 'package:organize_college/pages/main_page.dart';
import 'package:organize_college/utils/database_utils.dart';
import 'package:organize_college/utils/strings.dart';
import 'bloc/calculator/calculator_cubit.dart';
import 'bloc/classes/class_cubit.dart';
import 'bloc/drawer/drawer_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseUtils.getDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SubjectsCubit()),
        BlocProvider(create: (_) => ClassCubit()),
        BlocProvider(create: (_) => DrawerCubit()),
        BlocProvider(create: (_) => CalculatorCubit())
      ],
      child: MaterialApp(
        title: Strings.appName,
        theme: ThemeData(
        ),
        home: MainPage(),
      ),
    );
  }


}

