import 'package:flutter/material.dart';
import 'package:foraneo/screen/actions/actionOne/widgets/post_screen.dart';
import 'package:foraneo/provider/shooping_notifier.dart';
import 'package:foraneo/screen/actions/actionOne/shooping_screen.dart';
import 'package:provider/provider.dart';

class ShoopingPageView extends StatefulWidget {
  const ShoopingPageView({super.key});

  static Widget init() => ChangeNotifierProvider(
        create: (context) => ShoopingNotifier(),
        child: const ShoopingPageView(),
      );

  @override
  State<ShoopingPageView> createState() => _ShoopingPageViewState();
}

class _ShoopingPageViewState extends State<ShoopingPageView> {
  late ShoopingNotifier shoopingNotifier;

  @override
  void initState() {
    super.initState();

    shoopingNotifier = context.read<ShoopingNotifier>();
    shoopingNotifier.shoopingPage = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ShoopingNotifier().dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: shoopingNotifier.shoopingPage,
      physics: const NeverScrollableScrollPhysics(),
      children: const [ShoopingScreen(), PostScreen()],
    );
  }
}
