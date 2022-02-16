import 'package:flutter/material.dart';
import 'package:organize_college/models/icon_model.dart';
import 'package:organize_college/utils/icons_info.dart';

import '../../models/color_model.dart';
import '../../utils/colors_info.dart';

@immutable
abstract class InsertSubjectDialogState {
  IconModel getIconSelected();
  ColorModel getColorSelected();
  String getName();
  String getRoom();
  String getTeacher();

  InsertSubjectDialogSelected copyWith(
      {IconModel? iconSelected,
        ColorModel? colorSelected,
        String? teacher,
        String? name,
        String? room}) {
    return InsertSubjectDialogSelected(
        iconSelected: iconSelected ?? getIconSelected(),
        colorSelected: colorSelected ?? getColorSelected(),
        room: room ?? getRoom(),
        teacher: teacher ?? getTeacher(),
        name: name ?? getName());
  }
}

class InsertSubjectDialogInitial extends InsertSubjectDialogState {
  final IconModel _iconSelected = IconsInfo.allIcons[0];
  final ColorModel _colorSelected = ColorsInfo.allColors[0];
  final String? name = "";
  final String? room = "";
  final String? teacher = "";

  @override
  ColorModel getColorSelected() {
    return _colorSelected;
  }

  @override
  IconModel getIconSelected() {
    return _iconSelected;
  }

  @override
  String getName() {
    return name ?? "";
  }

  @override
  String getRoom() {
    return room ?? "";
  }

  @override
  String getTeacher() {
    return teacher ?? "";
  }


}

class InsertSubjectDialogSelected extends InsertSubjectDialogState {
  late final IconModel? iconSelected;
  late final ColorModel? colorSelected;
  final String? name;
  final String? room;
  final String? teacher;

  InsertSubjectDialogSelected(
      {this.iconSelected,
      this.colorSelected,
      this.teacher,
      this.name,
      this.room});

  @override
  ColorModel getColorSelected() {
    return colorSelected ?? ColorsInfo.allColors[0];
  }

  @override
  IconModel getIconSelected() {
    return iconSelected ?? IconsInfo.allIcons[0];
  }

  @override
  String getName() {
    return name ?? "";
  }

  @override
  String getRoom() {
    return room ?? "";
  }

  @override
  String getTeacher() {
    return teacher ?? "";
  }
}
