import 'package:flutter/material.dart';
import 'package:foraneo/provider/week_notifier.dart';
import 'package:provider/provider.dart';

class WeekPageView extends StatefulWidget {
  const WeekPageView({super.key});

  static Widget init() => ChangeNotifierProvider(
        create: (context) => WeekNotifier(),
        child: const WeekPageView(),
      );


  @override
  State<WeekPageView> createState() => _WeekPageViewState();
}

class _WeekPageViewState extends State<WeekPageView> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      
    );
  }
}