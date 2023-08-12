import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_hive/domain/entity/group.dart';
import 'package:todo_hive/domain/entity/task.dart';

class TaskFormWidgetModel {
  int groupKey;

  TaskFormWidgetModel({required this.groupKey});

  String taskText = "";

  Future<void> saveTask(BuildContext context) async {
    if (taskText.isEmpty) return;

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(GroupAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskAdapter());
    }
    final Box<Task> taskBox = await Hive.openBox<Task>("task_box");
    final Task task = Task(
      text: taskText,
      isDone: false,
    );
    await taskBox.add(task);

    await Hive.openBox<Group>("group_box").then((Box<Group> groupBox) {
      final Group group = groupBox.get(groupKey)!;
      group.addTask(taskBox, task);
      Navigator.of(context).pop();
    });
  }
}

class TaskFormWidgetModelProvider extends InheritedWidget {
  final TaskFormWidgetModel model;

  const TaskFormWidgetModelProvider({
    super.key,
    required Widget child,
    required this.model,
  }) : super(
          child: child,
        );

  static TaskFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TaskFormWidgetModelProvider>();
  }

  static TaskFormWidgetModelProvider? read(BuildContext context) {
    final Widget? widget = context
        .getElementForInheritedWidgetOfExactType<TaskFormWidgetModelProvider>()
        ?.widget;
    return widget is TaskFormWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(covariant TaskFormWidgetModelProvider oldWidget) {
    return false;
  }
}
