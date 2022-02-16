import 'package:flutter/material.dart';
import 'package:organize_college/models/icon_model.dart';

class IconsInfo{

  static const allIcons = [
    IconModel(id: 0, icon: Icons.add_a_photo,name: "Camara"),
    IconModel(id: 1, icon: Icons.sports_basketball,name: "Deportes"),
    IconModel(id: 2, icon: Icons.addchart,name: "Graficas"),
    IconModel(id: 3, icon: Icons.adb,name: "Movil"),
    IconModel(id: 4, icon: Icons.animation,name: "Animacion"),
    IconModel(id: 5, icon: Icons.whatshot,name: "Fuego"),
  ];

  static IconModel getIconById(int id){
    IconModel? iconModel;
    try{
      iconModel = allIcons.firstWhere((element) => element.id==id);
      return iconModel;
    }
    catch(e){
      return allIcons[0];
    }
  }
}