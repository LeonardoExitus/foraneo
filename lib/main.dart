import 'package:flutter/material.dart';
import 'package:foraneo/local/my_preferences.dart';
import 'package:foraneo/provider/home_notifier.dart';
import 'package:foraneo/screen/home.dart';
import 'package:foraneo/screen/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

// ...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MyAppPreferences();
  SqflitePlugin.registerWith();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => HomeNotifier())],
      child: MaterialApp(
        title: 'Foraneo',
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.initial,
        routes: Routes.routes,
      ),
    );
  }
}

class Routes {
  static const initial = "home";
  static Map<String, Widget Function(BuildContext)> routes = {
    "home": (context) => const Home(),
    "home-screen": (context) => const HomeScreen()
  };
}
