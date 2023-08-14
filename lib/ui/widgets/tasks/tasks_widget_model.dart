import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/domain/data_provider/box_manager.dart';
import 'package:todo_hive/domain/entity/task.dart';
import 'package:todo_hive/ui/navigation/main_navigation.dart';

class TasksWidgetModel extends ChangeNotifier {
  int groupKey;
  String title;
  late final Box<Task> _taskBox;

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks.toList();

  TasksWidgetModel({
    required this.groupKey,
    required this.title,
  }) {
    _setup();
  }

  Future<void> _setup() async {
    _taskBox = await BoxManager.instance.openTaskBox(groupKey);
    _readTasksFromHive();
    _taskBox.listenable().addListener(_readTasksFromHive);
  }

  Future<void> deleteTask(int index) async {
    await _taskBox.deleteAt(index);
  }

  Future<void> doneToggle(int index) async {
    final Task? task = _taskBox.getAt(index);
    task?.isDone = !task.isDone;
    await task?.save();
  }

  Future<void> showForm(BuildContext context) async {
    await Navigator.of(context).pushNamed(
      MainNavigationRouteNames.taskForm,
      arguments: {
        "groupKey": groupKey,
      },
    );
  }

  void _readTasksFromHive() {
    _tasks = _taskBox.values.toList();
    notifyListeners();
  }
}

class TasksWidgetModelProvider extends InheritedNotifier {
  final TasksWidgetModel model;

  const TasksWidgetModelProvider({
    super.key,
    required Widget child,
    required this.model,
  }) : super(
          child: child,
          notifier: model,
        );

  static TasksWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksWidgetModelProvider>();
  }

  static TasksWidgetModelProvider? read(BuildContext context) {
    final Widget? widget = context
        .getElementForInheritedWidgetOfExactType<TasksWidgetModelProvider>()
        ?.widget;
    return widget is TasksWidgetModelProvider ? widget : null;
  }
}
