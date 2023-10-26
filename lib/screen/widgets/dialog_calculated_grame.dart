import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foraneo/provider/shooping_notifier.dart';
import 'package:foraneo/screen/actions/actionOne/widgets/content_body.dart';
import 'package:foraneo/screen/widgets/input_label.dart';
import 'package:foraneo/screen/widgets/text_title.dart';
import 'package:foraneo/utils/colors.dart';
import 'package:foraneo/utils/form_formats.dart';

class DialogCalculateGrame extends StatefulWidget {
  const DialogCalculateGrame({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<DialogCalculateGrame> createState() => _DialogCalculateGrameState();
}

class _DialogCalculateGrameState extends State<DialogCalculateGrame> {
  late TextEditingController priceCtrl;
  late TextEditingController grameCtrl;
  late Task task;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    task = widget.task;
    priceCtrl = TextEditingController(text: "");
    grameCtrl = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AlertDialog(
      title: Center(child: TextTitle(title: task.product)),
      content: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        height: size.height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("\$"),
                const SizedBox(width: 10),
                InputLabel(
                  controller: priceCtrl,
                  textAlign: true,
                  border: true,
                  width: size.width * 0.3,
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                    CurrencyFormat(),
                  ],
                  textInputType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  onChanged: (value) {
                    setState(() {
                      task = task.copyTask(
                          price:
                              calculatedGrame(priceCtrl.text, grameCtrl.text));
                    });
                  },
                ),
                const SizedBox(width: 10),
                const Text("/ Kilo"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Peso"),
                const SizedBox(width: 10),
                InputLabel(
                  onChanged: (value) {
                    setState(() {
                      task = task.copyTask(
                          price:
                              calculatedGrame(priceCtrl.text, grameCtrl.text));
                    });
                  },
                  controller: grameCtrl,
                  textAlign: true,
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                  ],
                  textInputType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  border: true,
                  width: size.width * 0.3,
                ),
                const SizedBox(width: 10),
                const Text("/ Gramo"),
              ],
            ),
            // Text("PRECIO: \$${task.price.isEmpty ? "0.00" : task.price}", style: TextStyle(color: Colors.),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ForaneoButton(
                    title: "Guardar",
                    colorButton: AppColors.primary,
                    colorText: Colors.white,
                    onPressed: () {
                      Navigator.pop(context, task);
                    }),
                const SizedBox(width: 10),
                ForaneoButton(
                  title: "Cancelar",
                  onPressed: () => Navigator.pop(context, task),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

String calculatedGrame(String price, String grame) {
  String result = "";
  if (price.isNotEmpty && grame.isNotEmpty) {
    double dPrice = double.parse(price.replaceAll(",", ""));
    double dGrame = double.parse(grame.replaceAll(",", ""));
    result = (dGrame * (dPrice / 1000)).toStringAsFixed(2);
    List<String> totalList = result.split(".");
    print(totalList);
    if (totalList[0].length > 3) {
      String tempEnter = "";
      List<String> enter = totalList[0].split("");
      enter = enter.reversed.toList();
      for (var i = 0; i < enter.length; i++) {
        tempEnter = enter[i] + tempEnter;
        if (i == 2) {
          enter.removeRange(0, 3);
          if (enter.isNotEmpty) {
            tempEnter = ",$tempEnter";
          }
          i = -1;
        }
      }
      result = "$tempEnter.${totalList[1]}";
    }
    return result;
  }
  return "0.00";
}
