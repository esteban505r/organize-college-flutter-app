import '../models/term_model.dart';

class Utils {
  static String getDayById(int id) {
    switch (id) {
      case 1:
        return "Lunes";
      case 2:
        return "Martes";
      case 3:
        return "Miercoles";
      case 4:
        return "Jueves";
      case 5:
        return "Viernes";
      case 6:
        return "Sabado";
      case 7:
        return "Domingo";
      default:
        return "Dia invalido";
    }
  }

  static String formatTime(int time) {
    if (time > 9) {
      return time.toString();
    } else {
      return "0$time";
    }
  }

  static double getMissingMark({
    required List<TermModel> terms,
  }) {
    TermModel missingMarkTerm = terms.firstWhere((element) => element.mark==0.0 || element.id==terms[terms.length-1].id);
    double sum = 0;
    double percentageMissingTerm = 0;
    for(final item in terms){
      if(item.id!=missingMarkTerm.id){
          sum += item.mark*item.percentage;
      }
      else{
        percentageMissingTerm = item.percentage;
      }
    }
    double result =  (300 - sum)/percentageMissingTerm;
    return result<0?0:result;
  }
}
