import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organize_college/bloc/drawer/drawer_cubit.dart';
import 'package:organize_college/bloc/drawer/drawer_state.dart' as drawerState;
import 'package:organize_college/pages/schedule_page.dart';
import 'package:organize_college/utils/colors.dart';

import 'calculator_page.dart';
import 'home_page.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final ZoomDrawerController _zoomDrawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_zoomDrawerController.isOpen != null) {
          bool isOpen = _zoomDrawerController.isOpen!();
          if (isOpen && _zoomDrawerController.close != null) {
            _zoomDrawerController.close!();
            return false;
          }
        }
        return true;
      },
      child: Scaffold(
        body: BlocBuilder<DrawerCubit,drawerState.DrawerState>(
          builder: (context, snapshot) {
            return ZoomDrawer(
                controller: _zoomDrawerController,
                menuScreen: Builder(builder: (context) => createMenuScreen(context),),
                mainScreen: createMainScreen(context,snapshot),
                borderRadius: 24.0,
                showShadow: true,
                disableGesture: false,
                mainScreenTapClose: true,
                angle: -13.0,
                backgroundColor: Colors.white,
                slideWidth: MediaQuery.of(context).size.width * 0.5);
          }
        ),
      ),
    );
  }


  createMenuScreen(BuildContext context) {
    DrawerCubit drawerCubit = context.read<DrawerCubit>();
    return Container(
      color: AppColors.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.only(left: 20),
              width: MediaQuery.of(context).size.width * 0.5,
              child: Image.asset("assets/images/menu_image.png")),
          SizedBox(
            width: double.infinity,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Menu",
                      style: GoogleFonts.balsamiqSans(
                          fontSize: 30, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.home,
                          size: 20,
                          color: Colors.black87,
                        ),
                        onPressed: () {
                          drawerCubit.changePage(0);
                          ZoomDrawer.of(context)?.close();
                        },
                        label: const SizedBox(
                            width: double.infinity,
                            child: Text("Home",
                                style: TextStyle(color: Colors.black87))),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.schedule,
                          size: 20,
                          color: Colors.black87,
                        ),
                        onPressed: () {
                          drawerCubit.changePage(1);
                          ZoomDrawer.of(context)?.close();
                        },
                        label: const SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Horario",
                              style: TextStyle(color: Colors.black87),
                            )),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.dialpad_rounded,
                          color: Colors.black87,
                          size: 20,
                        ),
                        onPressed: () {
                          drawerCubit.changePage(2);
                          ZoomDrawer.of(context)?.close();
                        },
                        label: const SizedBox(
                            width: double.infinity,
                            child: Text("Calculadora",
                                style: TextStyle(color: Colors.black87))),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  createMainScreen(context, drawerState.DrawerState snapshot) {
    switch(snapshot.getPageNumber()){
      case 0:
        return const HomePage();
      case 1:
        return const SchedulePage();
      case 2:
        return const CalculatorPage();
      default:
        return const HomePage();
    }
  }
}
