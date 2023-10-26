import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foraneo/db/models/task_data.dart';
import 'package:foraneo/provider/shooping_notifier.dart';
import 'package:foraneo/screen/actions/actionOne/widgets/content_body.dart';
import 'package:foraneo/screen/widgets/dialog_calculated_grame.dart';
import 'package:foraneo/screen/widgets/input_label.dart';
import 'package:provider/provider.dart';

import '../../../../utils/form_formats.dart';
import '../../../widgets/text_title.dart';

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
    shooping = context.read<ShoopingNotifier>();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    task = widget.task;
    shooping.controllerTask = TextEditingController(text: task.product);
    shooping.controllerPrice = TextEditingController(text: task.price);

    return Flex(
      direction: Axis.horizontal,
      children: [
        // AnimatedContainer(
        //   width: shooping.totality ? size.width * 0.03 : size.width * 0.04,
        //   duration: const Duration(milliseconds: 200),
        // ),
        Expanded(
            child: DropdownButton<int>(
          padding: const EdgeInsets.only(left: 10),
          icon: const Icon(Icons.arrow_drop_down, size: 20),
          hint: Text(
            task.itemProduct.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          items: itemsInt()
              .map<DropdownMenuItem<int>>((int value) => DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  )))
              .toList(),
          onChanged: (int? value) async {
            // TaskCategory response = taskCategory;
            if (value != null) {
              setState(() {
                shooping.updateTaskItemDB(task.copyTask(itemProduct: value));
                shooping.updateContainPost(
                    task: task.copyTask(itemProduct: value), listener: true);
              });
            }
          },
        )),
        Expanded(
          flex: 6,
          child: Dismissible(
            key: ValueKey<int>(task.idTask),
            background: Container(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(blurRadius: 6, offset: Offset(1, 1))
                ],
                color: Colors.blueAccent,
              ),
              child: const Icon(
                Icons.balance,
                color: Colors.white,
              ),
            ),
            secondaryBackground: Container(
              padding: const EdgeInsets.only(right: 10),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(blurRadius: 6, offset: Offset(1, 1))
                ],
                color: Colors.redAccent,
              ),
              child: const Icon(
                Icons.delete_sweep_outlined,
                color: Colors.white,
              ),
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                await Future.delayed(const Duration(milliseconds: 500));
                await TaskData().deleteIdTaskDB(task);
                shooping.deleteContaintPost(task: task);
                return true;
              }

              if (direction == DismissDirection.startToEnd) {
                final price = await showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return DialogCalculateGrame(
                        task: task,
                      );
                    });
                if (price != null) {
                  task = price;
                  setState(() {
                    shooping.updateContainPost(task: task, listener: true);
                  });
                  await shooping.updateTaskPriceDB(task);
                }
              }
              return null;
            },
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                    flex: shooping.totality ? 4 : 6,
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(border: Border.all(width: 0.3)),
                      child: InputLabel(
                        fontWeight: shooping.totality,
                        // colorText: shooping.totality ? Colors.blueGrey : null,
                        read: shooping.totality,
                        controller: shooping.controllerTask,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        onChanged: (value) async {
                          task = task.copyTask(product: value);
                          await shooping.updateTaskTitleDB(task);
                          shooping.updateContainPost(task: task);
                        },
                        // onTapOutside: (value) {
                        //   shooping.updateContainPost(
                        //       task: task, listener: true);
                        // },
                      ),
                    )),
                shooping.totality
                    ? Expanded(
                        flex: 2,
                        child: Container(
                          decoration:
                              BoxDecoration(border: Border.all(width: 0.3)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Text("\$"),
                              Expanded(
                                  child: Container(
                                      padding: const EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                                  255, 84, 245, 146)
                                              .withOpacity(0.1),
                                          border:
                                              const Border(left: BorderSide())),
                                      width: size.width * 0.17,
                                      // color: Colors.white,
                                      child: Flex(
                                        direction: Axis.horizontal,
                                        children: [
                                          const Text("\$"),
                                          Expanded(
                                            flex: 3,
                                            child: InputLabel(
                                                textInputFormatter: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r"[0-9.]")),
                                                  CurrencyFormat(),
                                                ],
                                                textInputType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                  signed: false,
                                                  decimal: false,
                                                ),
                                                controller:
                                                    shooping.controllerPrice,
                                                hintText: "0.00",
                                                onChanged: (value) async {
                                                  task = task.copyTask(
                                                      price: value);
                                                  // print(task.price);
                                                  await shooping
                                                      .updateTaskPriceDB(task);
                                                  // setState(() {
                                                  shooping.updateContainPost(
                                                      task: task);
                                                  print(shooping
                                                      .controllerPrice.text);
                                                  // });
                                                },
                                                onEditingComplete: () {
                                                  shooping.updateContainPost(
                                                      task: task,
                                                      listener: true);
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                }),
                                          ),
                                          // Expanded(
                                          //     child: DropdownButton<int>(
                                          //   isExpanded: true,
                                          //   icon: const Icon(Icons.arrow_drop_down,
                                          //       size: 20),
                                          //   hint: Text(
                                          //     task.itemProduct.toString(),
                                          //     style: const TextStyle(
                                          //         fontSize: 12,
                                          //         fontWeight: FontWeight.bold),
                                          //   ),
                                          //   items: itemsInt()
                                          //       .map<DropdownMenuItem<int>>(
                                          //           (int value) =>
                                          //               DropdownMenuItem<int>(
                                          //                   value: value,
                                          //                   child: Text(
                                          //                     value.toString(),
                                          //                     style: const TextStyle(
                                          //                         fontSize: 12,
                                          //                         fontWeight:
                                          //                             FontWeight
                                          //                                 .bold),
                                          //                   )))
                                          //       .toList(),
                                          //   onChanged: (int? value) async {
                                          //     // TaskCategory response = taskCategory;
                                          //     if (value != null) {
                                          //       setState(() {
                                          //         shooping.updateTaskItemDB(task
                                          //             .copyTask(itemProduct: value));
                                          //         shooping.updateContainPost(
                                          //             task: task.copyTask(
                                          //                 itemProduct: value),
                                          //             listener: true);
                                          //       });
                                          //     }
                                          //   },
                                          // ))
                                        ],
                                      ))),
                            ],
                          ),
                        ))
                    : const Center()
              ],
            ),
          ),
        ),
      ],
    );
  }
}

List<int> itemsInt() {
  List<int> list = [];
  for (var i = 1; i <= 30; i++) {
    list.add(i);
  }
  return list;
}
