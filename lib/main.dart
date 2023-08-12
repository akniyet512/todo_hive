import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/widgets/group_form/group_form_widget.dart';
import 'package:todo_hive/widgets/groups/groups_widget.dart';
import 'package:todo_hive/widgets/task_form/task_form_widget.dart';
import 'package:todo_hive/widgets/tasks/tasks_widget.dart';

//flutter packages pub run build_runner watch
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/groups": (context) => const GroupsWidget(),
        "/groups/form": (context) => const GroupFormWidget(),
        "/groups/tasks": (context) => const TasksWidget(),
        "/groups/tasks/form": (context) => const TaskFormWidget(),
      },
      initialRoute: "/groups",
    );
  }
}
