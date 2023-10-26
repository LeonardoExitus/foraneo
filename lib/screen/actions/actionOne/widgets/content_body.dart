import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:foraneo/db/models/task_data.dart';
import 'package:foraneo/db/tables_conection.dart';
import 'package:foraneo/local/my_preferences.dart';
import 'package:foraneo/provider/shooping_notifier.dart';
import 'package:foraneo/screen/actions/actionOne/widgets/card_category.dart';
import 'package:foraneo/utils/colors.dart';
import 'package:provider/provider.dart';

import 'card_shooping.dart';

class ContentBody extends StatefulWidget {
  const ContentBody({
    super.key,
  });

  @override
  State<ContentBody> createState() => _ContentBodyState();
}

class _ContentBodyState extends State<ContentBody> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final shooping = context.read<ShoopingNotifier>();

    ConectionDB conectionDB = ConectionDB();
    MyAppPreferences.getCreateTableShooping().then((value) async {
      await MyAppPreferences.setCreateTableShooping(true);
      if (!value) {
        await conectionDB.createTables();
      }
      // ignore: use_build_context_synchronously
      final notifier = context.read<ShoopingNotifier>();
      conectionDB.getContentAllShoopingDB().then((value) async {
        notifier.listCard = value;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      child: Consumer<ShoopingNotifier>(builder: (context, notifier, __) {
        return Column(
            children: notifier.getListCard.isNotEmpty
                ? List.generate(
                    notifier.getListCard.length,
                    (index) => FadeInLeft(
                        duration: const Duration(milliseconds: 400),
                        child: Dismissible(
                          key: UniqueKey(),
                          background: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(blurRadius: 6, offset: Offset(1, 1))
                              ],
                              color: Colors.redAccent,
                            ),
                            margin: const EdgeInsets.only(top: 20),
                          ),
                          child: CardShooping(
                              postContent: notifier.getListCard[index]),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              await Future.delayed(
                                  const Duration(milliseconds: 500));
                              await ConectionDB()
                                  .deletePostDB(notifier.getListCard[index]);
                              notifier.deleteContaintPost(
                                  post: notifier.getListCard[index]);

                              return true;
                            }
                            return null;
                          },
                        )))
                : [
                    SizedBox(
                      height: size.height * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.post_add,
                            color: Colors.black12,
                            size: size.width * 0.2,
                          ),
                          const Text(
                            "Agrega una nueva lista",
                            style: TextStyle(
                              color: Colors.black38,
                            ),
                          )
                        ],
                      ),
                    )
                  ]);
      }),
    );
  }
}

class ContentBodyPost extends StatefulWidget {
  const ContentBodyPost({
    super.key,
  });

  @override
  State<ContentBodyPost> createState() => _ContentBodyPostState();
}

class _ContentBodyPostState extends State<ContentBodyPost> {
  // late List<TaskCategory> post;
  late bool expand;
  late ShoopingNotifier shooping;
  late bool initial;
  // late ExpansionTileController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    expand = false;
    shooping = context.read<ShoopingNotifier>();
    shooping.expandedCtr = ExpansionTileController();
    initial = false;
    // controller = ExpansionTileController();
    // post = shooping.postContent.listTaskCategory;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // print('"idPost":"0","category":"","title":""');
    return Consumer<ShoopingNotifier>(builder: (context, notifier, __) {
      return Column(
        children: [
          SizedBox(
            height: size.height * 0.06,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        for (TaskCategory element
                            in shooping.postContent.listTaskCategory) {
                          shooping.updateContainPost(
                              category:
                                  element.copyTaskCategory(expand: !expand));
                          if (expand) {
                            element.expansionCtr.expand();
                          } else {
                            element.expansionCtr.collapse();
                          }
                        }
                        expand = !expand;
                      });
                    },
                    child: Container(
                      height: size.width * 0.08,
                      width: size.width * 0.08,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                        color: AppColors.primary,
                      ),
                      child: Icon(
                        expand ? Icons.arrow_downward : Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        child: Container(
                            alignment: Alignment.center,
                            height: size.width * 0.08,
                            width: size.width * 0.3,
                            decoration: BoxDecoration(
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              shooping.totality
                                  ? "Detener compras"
                                  : "Iniciar compras",
                              style: const TextStyle(
                                color: Color(0xFF1d4371),
                              ),
                            )),
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          shooping.setTotality = !shooping.totality;
                        },
                      ),
                      shooping.totality
                          ? SizedBox(width: size.width * 0.03)
                          : const Center(),
                      shooping.totality
                          ? ForaneoButton(
                              colorBorder: Colors.black,
                              colorsGradient: AppColors.gradientGreen,
                              title: "Total",
                              colorText: Colors.black,
                              onPressed: () {
                                showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 35, 224, 107),
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20))),
                                        height: size.height * 0.2,
                                        child: Text(
                                          "Total: \$${shooping.totalPrice().toString()}",
                                          style: const TextStyle(
                                              fontSize: 26,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    });
                              },
                            )
                          : const Center()
                    ],
                  )
                ],
              ),
            ),
          ),
          ...List.generate(shooping.postContent.listTaskCategory.length,
              (index) {
            TaskCategory categoy = notifier.postContent.listTaskCategory[index];
            // if (!categoy.expand) {
            //   if (initial) {
            //     categoy.controller.expand();
            //   }
            // } else {
            //   if (initial) {
            //     categoy.controller.collapse();
            //   }
            // }
            if (shooping.postContent.listTaskCategory.length == index + 1) {
              initial = true;
            }
            print(expand);
            // if(shooping.postContent.listTaskCategory.length == index)
            return Container(
              margin: EdgeInsets.only(top: index == 0 ? 20 : 0, bottom: 20),
              child: Column(
                children: [
                  CardCategory(
                      category: categoy, expansionCtr: notifier.expandedCtr),
                  !categoy.expand
                      ? AddProduct(onTap: () async {
                          final newTask =
                              await TaskData().insertTaskDB(categoy);
                          shooping.addTaskInCategory(newTask);
                        })
                      : const Center()
                ],
              ),
            );
          }),
          Container(
            // color: Colors.amber,
            color: Colors.transparent,
            height: size.height * 0.1,
          )
        ],
      );
    });
  }
}

class ForaneoButton extends StatelessWidget {
  const ForaneoButton({
    super.key,
    this.width,
    this.height,
    required this.title,
    this.colorText,
    this.colorButton,
    this.colorsGradient,
    this.colorBorder,
    this.onPressed,
  });

  final double? width;
  final double? height;
  final String title;
  final Color? colorText;
  final Color? colorButton;
  final List<Color>? colorsGradient;
  final Color? colorBorder;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        alignment: Alignment.center,
        height: height ?? size.width * 0.08,
        width: width ?? size.width * 0.2,
        // height: size.width * 0.08,
        // width: size.width * 0.2,
        decoration: BoxDecoration(
            border: Border.all(color: colorBorder ?? Colors.black),
            borderRadius: BorderRadius.circular(10),
            color: colorButton,
            gradient: colorsGradient != null
                ? LinearGradient(colors: colorsGradient!)
                : null),
        child: MaterialButton(
          elevation: 0,
          padding: const EdgeInsets.all(0),
          onPressed: onPressed,
          child: Text(
            title,
            style: TextStyle(color: colorText ?? Colors.black),
          ),
        ));
  }
}

class AddProduct extends StatelessWidget {
  const AddProduct({super.key, required this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.add), Text("Agregar producto")],
        ));
  }
}
