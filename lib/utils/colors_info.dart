import 'package:flutter/material.dart';
import '../models/color_model.dart';

class ColorsInfo{

  static final allColors = [
    ColorModel(id: 0, color: Colors.blue,name: "Azul"),
    ColorModel(id: 1, color: Colors.orange,name: "Orange"),
    ColorModel(id: 2, color: Colors.purple,name: "Violeta"),
    ColorModel(id: 3, color:Colors.black,name: "Negro"),
    ColorModel(id: 4, color: Colors.yellow,name: "Amarillo"),
    ColorModel(id: 5, color: Colors.red,name: "Rojo"),
  ];

  static ColorModel getColorById(int id){
    ColorModel? colorModel;
    try{
      colorModel = allColors.firstWhere((element) => element.id==id);
      return colorModel;
    }
    catch(e){
      return allColors[0];
    }
  }
}