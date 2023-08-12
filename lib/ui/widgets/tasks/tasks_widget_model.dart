import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/domain/entity/group.dart';
import 'package:todo_hive/domain/entity/task.dart';
import 'package:todo_hive/ui/navigation/main_navigation.dart';

class TasksWidgetModel extends ChangeNotifier {
  int groupKey;
  late final Box<Group> _groupBox;
  Group? _group;
  List<Task> _tasks = [];

  Group? get group => _group;
  List<Task> get tasks => _tasks.toList();

  TasksWidgetModel({required this.groupKey}) {
    _setup();
  }

  Future<void> _setup() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(GroupAdapter());
    }

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskAdapter());
    }

    _groupBox = await Hive.openBox<Group>("group_box");
    _group = _groupBox.get(groupKey);
    await _readTasksFromHive();
    _groupBox.listenable(
        keys: [groupKey]).addListener(() async => await _readTasksFromHive());
  }

  Future<void> deleteTask(int index) async {
    await Hive.openBox<Task>("task_box");
    _group?.tasks?.deleteFromHive(index);
    _group?.save();
  }

  Future<void> doneToggle(int index) async {
    _group?.tasks?[index].isDone = !(_group?.tasks?[index].isDone ?? false);
    group?.tasks?[index].save();
    notifyListeners();
  }

  Future<void> showForm(BuildContext context) async {
    await Navigator.of(context).pushNamed(
      MainNavigationRouteNames.taskForm,
      arguments: {
        "groupKey": groupKey,
      },
    );
  }

  Future<void> _readTasksFromHive() async {
    await Hive.openBox<Task>("task_box");
    _tasks = _group?.tasks ?? [];
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
