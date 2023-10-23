import 'package:flutter/material.dart';
import 'package:foraneo/db/models/category_data.dart';
import 'package:foraneo/screen/actions/actionOne/widgets/task_content.dart';
import 'package:foraneo/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../../widgets/input_label.dart';
import '../../../../provider/shooping_notifier.dart';

class CardCategory extends StatefulWidget {
  const CardCategory({required this.category, super.key});

  final TaskCategory category;

  @override
  State<CardCategory> createState() => _CardCategoryState();
}

class _CardCategoryState extends State<CardCategory> {
  Category? drop;
  late TaskCategory taskCategory;
  late ShoopingNotifier shooping;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shooping = context.read<ShoopingNotifier>();
    // drop = shooping.listCategory.first;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    taskCategory = widget.category;
    // taskCategory = shooping.postContent.listTaskCategory[widget.position];
    // final listItems = shooping.listUpdate();

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        !taskCategory.expand
            ? Container(
                // margin: const EdgeInsets.only(top: 20),
                padding: EdgeInsets.only(
                  top: size.height * 0.05,
                ),
                width: size.width * 0.95,
                // height: size.height * 0.08,
                decoration: BoxDecoration(
                  border: Border.all(),
                  image: const DecorationImage(
                      image: AssetImage("assets/images/vector_eat.jpg"),
                      fit: BoxFit.cover,
                      opacity: 0.1),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.white,
                        blurRadius: 1,
                        offset: Offset(0, 1))
                  ],
                ),
                child: Flex(
                    direction: Axis.vertical,
                    children:
                        List.generate(taskCategory.listTask.length, (index) {
                      // print(taskCategory.listTask[index].idTask);
                      return TaskContent(task: taskCategory.listTask[index]);
                    })),
              )
            : const Center(),
        Container(
          // margin: const EdgeInsets.only(top: 20),

          height: size.height * 0.04,
          width: size.width * 0.95,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [BoxShadow(blurRadius: 6, offset: Offset(1, 1))],
              gradient: const LinearGradient(colors: [
                Color.fromARGB(255, 150, 250, 188),
                Color.fromARGB(255, 84, 245, 146),
                Color.fromARGB(255, 244, 240, 253),
              ])),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          shooping.updateContainPost(
                              category: taskCategory.copyTaskCategory(
                                  expand: !taskCategory.expand));
                        });
                      },
                      child: Icon(!taskCategory.expand
                          ? Icons.arrow_upward
                          : Icons.arrow_downward))),
              // Expanded(
              //     flex: 2,
              //     child: Container(
              //       alignment: Alignment.center,
              //       decoration: const BoxDecoration(
              //           border: Border(right: BorderSide())),
              //       child: const Text(
              //         "Categoría:",
              //         style: TextStyle(fontWeight: FontWeight.bold),
              //       ),
              //     )),
              Expanded(
                  flex: 6,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                          child: DropdownButton<Category>(
                        hint: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            taskCategory.category.isEmpty
                                ? "Selecciona una categoría"
                                : taskCategory.category,
                            style: TextStyle(
                                // color: Colors.white,
                                fontWeight: taskCategory.category.isNotEmpty
                                    ? FontWeight.bold
                                    : null),
                          ),
                        ),
                        items: shooping
                            .listUpdate()
                            .map<DropdownMenuItem<Category>>(
                                (Category value) => DropdownMenuItem<Category>(
                                      value: value,
                                      child: Row(
                                        children: [
                                          Icon(
                                            value.icon,
                                            size: size.width * 0.05,
                                          ),
                                          SizedBox(
                                            width: size.width * 0.02,
                                          ),
                                          Text(value.name)
                                        ],
                                      ),
                                    ))
                            .toList(),
                        onChanged: (Category? value) async {
                          // TaskCategory response = taskCategory;
                          if (value != null) {
                            setState(() {
                              drop = value;
                              // print(value.name);
                              shooping.selectionCategory(value.name, true);
                              taskCategory = shooping.categoryUpdate(
                                  taskCategory, value.name);
                            });
                            await CategoryData().updateCategoryDB(taskCategory);
                          }
                        },
                        // value: null,
                      ))
                    ],
                  ))
            ],
          ),
        )
      ],
    );
  }
}
