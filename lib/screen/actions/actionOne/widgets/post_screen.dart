import 'package:flutter/material.dart';
import 'package:foraneo/db/models/category_data.dart';
import 'package:foraneo/db/models/task_data.dart';
import 'package:foraneo/screen/actions/actionOne/widgets/content_body.dart';
import 'package:foraneo/screen/actions/actionOne/widgets/head_action.dart';
import 'package:provider/provider.dart';

import '../../../../utils/colors.dart';
import '../../../../provider/shooping_notifier.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late ShoopingNotifier shooping;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shooping = context.read<ShoopingNotifier>();
    shooping.initListCategory();
    shooping.initSelectionCategory(shooping.postContent.listTaskCategory);
    shooping.controllerTitle =
        TextEditingController(text: shooping.getPost.title);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    shooping.controllerTitle.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shooping = context.read<ShoopingNotifier>();
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final category = await CategoryData()
                  .insertCategoryDB(shooping.postContent);
              final task =
                  await TaskData().insertTaskDB(category);
              shooping.newCategory(category);
              shooping.addTaskInCategory(task);
            },
            backgroundColor: const Color.fromARGB(255, 35, 224, 107),
            child: const Icon(Icons.post_add)),

        // bottomSheet: SizedBox(
        //   height: size.height * 0.1,
        //   // width: size.width,
        //   // color: Colors.transparent.withOpacity(opacity),
        //   child: Flex(
        //     direction: Axis.horizontal,
        //     children: [
        //       Expanded(
        //           flex: 3,
        //           child: Padding(
        //             padding: EdgeInsets.only(
        //               right: size.width * 0.1,
        //               top: size.width * 0.08,
        //             ),
        //             child: InkWell(
        //               child: Container(
        //                 decoration: const BoxDecoration(
        //                     color: Color.fromARGB(255, 35, 224, 107),
        //                     borderRadius: BorderRadius.only(
        //                         topRight: Radius.circular(50))),
        //                 child: const SizedBox.expand(
        //                     child: Center(
        //                         child: Text(
        //                   "Ver detalles",
        //                   style: TextStyle(
        //                       color: Colors.white,
        //                       fontSize: 20,
        //                       fontWeight: FontWeight.bold),
        //                 ))),
        //               ),
        //               onTap: () {
        //                 setState(() {});
        //                 final totalPrice = shooping.totalPrice();
        //                 print(shooping
        //                     .postContent.listTaskCategory[4].listTask[0].price);
        //                 showModalBottomSheet(
        //                     backgroundColor: Colors.transparent,
        //                     context: context,
        //                     builder: (context) {
        //                       return Container(
        //                         alignment: Alignment.center,
        //                         decoration: const BoxDecoration(
        //                             color: Color.fromARGB(255, 35, 224, 107),
        //                             borderRadius: BorderRadius.vertical(
        //                                 top: Radius.circular(20))),
        //                         height: size.height * 0.2,
        //                         child: Text(
        //                           "Total: \$${totalPrice.toString()}",
        //                           style: const TextStyle(
        //                               fontSize: 26,
        //                               color: Colors.white,
        //                               fontWeight: FontWeight.bold),
        //                         ),
        //                       );
        //                     });
        //               },
        //             ),
        //           )),
        //       Expanded(
        //         child: FloatingActionButton(
        //             onPressed: () async {
        //               final category = await CategoryData().insertCategoryDB(
        //                   shooping.postContent, shooping.database);
        //               final task = await TaskData()
        //                   .insertTaskDB(category, shooping.database);
        //               shooping.newCategory(category);
        //               shooping.addTaskInCategory(task);
        //             },
        //             backgroundColor: const Color.fromARGB(255, 35, 224, 107),
        //             child: const Icon(Icons.post_add)),
        //       ),
        //     ],
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: Container(
        //   alignment: Alignment.bottomCenter,
        //   color: Colors.red,
        //   height: size.height * 0.1,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [

        //     ],
        //   ),
        // ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Transform.scale(
              scale: 1.05,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image.asset("assets/images/post_fond.jpg", fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.white,
                        Colors.white,
                      ]),
                    ),
                  )
                ],
              ),
            ),
            const SingleChildScrollView(
              child: Column(
                children: [HeadActionPost(), ContentBodyPost()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
