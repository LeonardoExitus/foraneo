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
    // bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    // print(showFab);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final category =
                  await CategoryData().insertCategoryDB(shooping.postContent);
              final task = await TaskData().insertTaskDB(category);
              shooping.newCategory(category);
              shooping.addTaskInCategory(task);
            },
            backgroundColor: Colors.amber,
            child: const Icon(Icons.post_add)),
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
