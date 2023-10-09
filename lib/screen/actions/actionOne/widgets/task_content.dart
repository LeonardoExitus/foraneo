import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foraneo/db/models/task_data.dart';
import 'package:foraneo/provider/shooping_notifier.dart';
import 'package:foraneo/screen/widgets/input_label.dart';
import 'package:provider/provider.dart';

import '../../../../utils/form_formats.dart';

class TaskContent extends StatefulWidget {
  const TaskContent({
    super.key,
    required this.task,
  });
  final Task task;
  @override
  State<TaskContent> createState() => _TaskContentState();
}

class _TaskContentState extends State<TaskContent> {
  late ShoopingNotifier shooping;
  late Task task;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    task = widget.task;
    shooping = context.read<ShoopingNotifier>();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    shooping.controllerTask = TextEditingController(text: task.product);
    shooping.controllerPrice = TextEditingController(text: task.price);

    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: Checkbox(
            value: task.active,
            onChanged: (value) async {
              print("vemos");
              setState(() {
                task = task.copyTask(active: value);
              });
              await shooping.updateTaskActiveDB(task);
            },
          ),
        ),
        Expanded(
            flex: 6,
            child: InputLabel(
              controller: shooping.controllerTask,
              onChanged: (value) async {
                task = task.copyTask(product: value);
                await shooping.updateTaskTitleDB(task);
              },
              // controller: si,
            )),
        Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text("\$"),
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                            border: Border(left: BorderSide())),
                        width: size.width * 0.17,
                        // color: Colors.white,
                        child: InputLabel(
                          // textInputFormatter: [
                          //   FilteringTextInputFormatter.allow(
                          //       RegExp(r"[0-9.,]")),
                          //   CurrencyFormat(),
                          // ],
                          textInputType: const TextInputType.numberWithOptions(
                            signed: false,
                            decimal: false,
                          ),
                          controller: shooping.controllerPrice,
                          labelText: "Costo",
                          onChanged: (value) async {
                            task = task.copyTask(price: value);
                            print(task.price);
                            await shooping.updateTaskPriceDB(task);
                            // setState(() {
                            shooping.updateContainPost(task: task);
                            // });
                          },
                        ))),
              ],
            ))
      ],
    );
  }
}
