import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:foraneo/provider/home_notifier.dart';
import 'package:foraneo/provider/shooping_notifier.dart';
import 'package:foraneo/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../../widgets/back_button.dart';
import '../../../widgets/input_label.dart';

class HeadAction extends StatelessWidget {
  const HeadAction({super.key, required this.title, this.color});

  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final notifier = context.read<HomeNotifier>();

    return Stack(
      children: [
        Container(
          height: size.height * 0.1,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/lista-compras.png"),
                  fit: BoxFit.cover)),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: color ?? AppColors.primary,
                borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.only(top: size.height * 0.075),
            // padding: ,
            width: size.width * 0.6,
            height: size.height * 0.05,
            child: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        BackPage(
          onTap: () async {
            // await shooping.closeDB();
            notifier.homePage.jumpToPage(0);
          },
        )
      ],
    );
  }
}

class HeadActionPost extends StatelessWidget {
  const HeadActionPost({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shooping = context.read<ShoopingNotifier>();

    return Stack(
      children: [
        Container(
          height: size.height * 0.1,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/lista-compras.png"),
                fit: BoxFit.cover),
            boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black)],
          ),
        ),
        FadeIn(
          child: Container(
            height: size.height * 0.1,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
              const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
            ])),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  // color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.only(top: size.height * 0.025),
              // padding: ,
              width: size.width * 0.7,
              height: size.height * 0.08,
              child: InputLabel(
                colorText: Colors.white,
                colorHint: Colors.white,
                fontWeight: true,
                controller: shooping.controllerTitle,
                labelText: "Escribe un titulo",
                onChanged: (value) async {
                  shooping.updateContainPost(
                      post: shooping.postContent.copyPostContent(title: value));
                  await shooping.updatePostContentDB();
                },
              )),
        ),
        BackPage(
          onTap: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            shooping.cleanPost();
            shooping.shoopingPage.jumpToPage(0);
          },
        ),
      ],
    );
  }
}
