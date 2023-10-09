import 'package:flutter/material.dart';
import 'package:foraneo/screen/home_page_view.dart';
import 'package:provider/provider.dart';

import '../provider/home_notifier.dart';
import '../utils/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late HomeNotifier _homeNotifier;

  @override
  void initState() {
    super.initState();
    _homeNotifier = context.read<HomeNotifier>();
    _homeNotifier.homePage = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _homeNotifier.homePage.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: const Scaffold(
        body: HomePageView(),
      ),
      onWillPop: () async => await Future.value(false),
    );
  }
}
