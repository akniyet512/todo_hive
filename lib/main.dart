import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/ui/navigation/main_navigation.dart';
import 'package:url_strategy/url_strategy.dart';

//flutter packages pub run build_runner watch
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final MainNavigation _mainNavigationRouteNames = MainNavigation();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: _mainNavigationRouteNames.routes,
      initialRoute: _mainNavigationRouteNames.initialRoute,
      onGenerateRoute: _mainNavigationRouteNames.onGenerateRoute,
    );
  }
}
