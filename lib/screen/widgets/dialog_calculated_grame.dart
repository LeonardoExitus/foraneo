import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foraneo/provider/shooping_notifier.dart';
import 'package:foraneo/screen/actions/actionOne/widgets/content_body.dart';
import 'package:foraneo/screen/widgets/input_label.dart';
import 'package:foraneo/screen/widgets/text_title.dart';
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
                    // setState(() {
                    //   task = task.copyTask(product: value);
                    // });
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
            const Text("PRECIO: \$"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ForaneoButton(title: "Guardar", onPressed: () {}),
                const SizedBox(width: 10),
                ForaneoButton(
                  title: "Cancelar",
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// String calculatedGrame(String price, String grame){
//   if(price.isNotEmpty && grame.isNotEmpty){
    
//   }

// }
