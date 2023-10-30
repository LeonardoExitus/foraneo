import 'package:flutter/material.dart';
import 'package:foraneo/db/tables_conection.dart';
import 'package:foraneo/local/my_preferences.dart';
import 'package:foraneo/provider/home_notifier.dart';
import 'package:foraneo/screen/actions/actionOne/shooping_page_view.dart';
import 'package:foraneo/screen/actions/actionTwo/maps_screen.dart';
import 'package:foraneo/screen/actions/actionTwo/week_page_view.dart';
import 'package:foraneo/screen/home_screen.dart';
import 'package:provider/provider.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeNotifier = context.read<HomeNotifier>();
    final page = homeNotifier.homePage;
    return PageView(
      controller: page,
      physics: const NeverScrollableScrollPhysics(),
      children: [HomeScreen(), ShoopingPageView.init(), WeekPageView.init()],
    );
  }
}
