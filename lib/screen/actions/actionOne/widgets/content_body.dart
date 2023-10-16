import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:foraneo/db/models/task_data.dart';
import 'package:foraneo/db/tables_conection.dart';
import 'package:foraneo/local/my_preferences.dart';
import 'package:foraneo/provider/shooping_notifier.dart';
import 'package:foraneo/screen/actions/actionOne/widgets/card_category.dart';
import 'package:provider/provider.dart';

import '../../../../utils/colors.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    expand = false;
    shooping = context.read<ShoopingNotifier>();
    // post = shooping.postContent.listTaskCategory;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // print('"idPost":"0","category":"","title":""');
    return Consumer<ShoopingNotifier>(builder: (context, notifier, __) {
      return Column(
        children: [
          Container(
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
                          color: Colors.black54),
                      child: Icon(
                        expand ? Icons.arrow_downward : Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Container(
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 35, 224, 107),
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
                    child: Container(
                        alignment: Alignment.center,
                        height: size.width * 0.08,
                        width: size.width * 0.3,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(colors: [
                              AppColors.lightPurple,
                              Color.fromARGB(255, 150, 238, 250),
                              AppColors.lightPurple,
                            ])),
                        child: const Text(
                          "Total a pagar",
                          style: TextStyle(),
                        )),
                  )
                ],
              ),
            ),
          ),
          ...List.generate(shooping.postContent.listTaskCategory.length,
              (index) {
            return Container(
              margin: EdgeInsets.only(top: index == 0 ? 20 : 0, bottom: 20),
              child: Column(
                children: [
                  CardCategory(
                    category: notifier.postContent.listTaskCategory[index],
                  ),
                  !notifier.postContent.listTaskCategory[index].expand
                      ? AddProduct(onTap: () async {
                          final newTask = await TaskData().insertTaskDB(
                              shooping.postContent.listTaskCategory[index]);
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
