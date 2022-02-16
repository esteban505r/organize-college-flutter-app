import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organize_college/bloc/calculator/calculator_cubit.dart';
import 'package:organize_college/bloc/calculator/calculator_state.dart';

import '../models/term_model.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text("Calculadora"),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              ZoomDrawer.of(context)?.toggle();
            },
          );
        }),
      ),
      body: BlocBuilder<CalculatorCubit, CalculatorState>(
          builder: (context, snapshot) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                itemBuilder: (context, index) {
                  return _createTermCard(context, snapshot, index);
                },
                itemCount: snapshot.getTerms().length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  TermModel missingMarkTerm = snapshot.getTerms().firstWhere(
                      (element) =>
                          element.mark == 0.0 ||
                          element.id ==
                              snapshot
                                  .getTerms()[snapshot.getTerms().length - 1]
                                  .id);

                  double missingMark =
                      Utils.getMissingMark(terms: snapshot.getTerms());

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Para aprobar tu materia necesitas en el corte o periodo numero ${missingMarkTerm.id} una nota de: $missingMark")));
                },
                child: Text(
                  "CALCULATE",
                  style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(AppColors.secondaryColor)),
              )
            ],
          ),
        );
      }),
    );
  }

  Future<double?> showPercentageDialog(BuildContext context) async {
    return await showDialog<double>(
        context: context,
        builder: (context) {
          TextEditingController textController = TextEditingController();
          return AlertDialog(
            contentPadding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "% Porcentaje %",
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
                    if (double.parse(value) > 100) {
                      textController.text = 100.toString();
                    }
                  },
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  controller: textController,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, double.parse(textController.text));
                    },
                    child: const Text(
                      "Aceptar",
                      style: TextStyle(color: AppColors.primaryColor),
                    ))
              ],
            ),
          );
        });
  }

  Widget _createTermCard(
      BuildContext context, CalculatorState snapshot, int index) {
    TextEditingController textEditingController = TextEditingController(
        text: snapshot.getTerms()[index].percentage.toString());
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            children: [
              Container(
                height: 10,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: AppColors.secondaryColor,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        "Term ${index + 1}",
                        style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryColor)),
                      ),
                      GestureDetector(
                        onTap: () async {
                          double? result = await showPercentageDialog(context);
                          context.read<CalculatorCubit>().changeTerm(snapshot
                              .getTerms()[index]
                              .copyWith(percentage: result));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                "Percentage: ",
                                style: GoogleFonts.nunito(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.secondaryColor)),
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.only(top: 10),
                                width: 25,
                                child: TextField(
                                  style: const TextStyle(fontSize: 13),
                                  enabled: false,
                                  controller: textEditingController,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Nota"),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: 60,
                        child: TextField(
                          onChanged: (value) {
                            context.read<CalculatorCubit>().changeTerm(snapshot
                                .getTerms()[index]
                                .copyWith(mark: double.parse(value)));
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
