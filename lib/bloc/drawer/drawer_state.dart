import 'package:flutter/material.dart';

@immutable
abstract class DrawerState{
  getPageNumber();
}

class DrawerInitial extends DrawerState{

  final int? page;

  DrawerInitial({this.page});

  @override
  getPageNumber() {
    return page??0;
  }
}

class DrawerSelected extends DrawerState{

  final int page;

  DrawerSelected(this.page);

  @override
  getPageNumber() {
    return page;
  }
}