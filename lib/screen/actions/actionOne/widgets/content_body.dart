import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:foraneo/db/models/task_data.dart';
import 'package:foraneo/db/tables_conection.dart';
import 'package:foraneo/local/my_preferences.dart';
import 'package:foraneo/provider/shooping_notifier.dart';
import 'package:foraneo/screen/actions/actionOne/widgets/card_category.dart';
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
                          key: ValueKey<int>(index),
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
                              await Future.delayed(const Duration(seconds: 2));
                              await ConectionDB()
                                  .deletePostDB(notifier.getListCard[index]);
                              return true;
                            }
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
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // print('"idPost":"0","category":"","title":""');
    return Consumer<ShoopingNotifier>(builder: (context, notifier, __) {
      final post = notifier.postContent.listTaskCategory;
      return Column(
        children: [
          ...List.generate(post.length, (index) {
            return Container(
              margin: EdgeInsets.only(top: index == 0 ? 20 : 0, bottom: 20),
              child: Column(
                children: [
                  CardCategory(
                    position: index,
                  ),
                  AddProduct(onTap: () async {
                    final newTask = await TaskData().insertTaskDB(post[index]);
                    notifier.addTaskInCategory(newTask);
                    FocusManager.instance.primaryFocus?.previousFocus();
                  }),
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
