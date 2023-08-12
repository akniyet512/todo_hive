import 'package:flutter/material.dart';
import 'package:todo_hive/ui/widgets/group_form/group_form_widget.dart';
import 'package:todo_hive/ui/widgets/groups/groups_widget.dart';
import 'package:todo_hive/ui/widgets/task_form/task_form_widget.dart';
import 'package:todo_hive/ui/widgets/tasks/tasks_widget.dart';

abstract class MainNavigationRouteNames {
  static const String groups = "/";
  static const String groupForm = "/addForm";
  static const String tasks = "/groups";
  static const String taskForm = "/addTask";
}

class MainNavigation {
  final String initialRoute = MainNavigationRouteNames.groups;

  final Map<String, Widget Function(BuildContext)> routes = {
    MainNavigationRouteNames.groups: (context) => const GroupsWidget(),
    MainNavigationRouteNames.groupForm: (context) => const GroupFormWidget(),
  };

  Route<Object>? onGenerateRoute(RouteSettings settings) {
    final Map<String, dynamic> args =
        settings.arguments as Map<String, dynamic>;
    switch (settings.name) {
      case MainNavigationRouteNames.tasks:
        final int groupKey = args["groupKey"];
        return MaterialPageRoute(
          builder: (context) {
            return TasksWidget(groupKey: groupKey);
          },
          settings: RouteSettings(name: "${settings.name}/$groupKey"),
        );
      case MainNavigationRouteNames.taskForm:
        final int groupKey = args["groupKey"];
        return MaterialPageRoute(
          builder: (context) {
            return TaskFormWidget(groupKey: groupKey);
          },
          settings: RouteSettings(name: "${MainNavigationRouteNames.tasks}/$groupKey/addTask"),
        );
      default:
        return MaterialPageRoute(
          builder: (context) {
            return const Scaffold(
              body: Center(
                child: Text("Navigation error!"),
              ),
            );
          },
        );
    }
  }
}
