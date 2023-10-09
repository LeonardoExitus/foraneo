import 'package:flutter/material.dart';
import 'package:foraneo/db/models/post_data.dart';
import 'package:foraneo/local/my_preferences.dart';
import 'package:foraneo/provider/shooping_notifier.dart';
import 'package:foraneo/screen/actions/actionOne/widgets/content_body.dart';
import 'package:foraneo/screen/actions/actionOne/widgets/head_action.dart';
import 'package:foraneo/utils/colors.dart';
import 'package:provider/provider.dart';

class ShoopingScreen extends StatelessWidget {
  const ShoopingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final shooping = context.read<ShoopingNotifier>();

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              shooping.insertNewPostDB();
              shooping.shoopingPage.jumpToPage(1);
            },
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.post_add)),
        body: const SingleChildScrollView(
          child: Column(
            children: [HeadAction(title: "Lista de compras"), ContentBody()],
          ),
        ),
      ),
    );
  }
}
