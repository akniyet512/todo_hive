import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_hive/domain/data_provider/box_manager.dart';
import 'package:todo_hive/domain/entity/task.dart';

class TaskFormWidgetModel extends ChangeNotifier {
  int groupKey;

  TaskFormWidgetModel({required this.groupKey});

  String _taskText = "";

  bool get isValid => _taskText.trim().isNotEmpty;

  set taskText(String value) {
    final bool isTaskTextEmpty = _taskText.trim().isNotEmpty;
    _taskText = value;
    if (value.trim().isEmpty != isTaskTextEmpty) {
      notifyListeners();
    }
  }

  Future<void> saveTask(BuildContext context) async {
    if (_taskText.trim().isEmpty) return;

    final Box<Task> taskBox = await BoxManager.instance.openTaskBox(groupKey);
    final Task task = Task(
      text: _taskText,
      isDone: false,
    );
    await taskBox.add(task).whenComplete(() {
      Navigator.of(context).pop();
    });
  }
}

class TaskFormWidgetModelProvider extends InheritedNotifier {
  final TaskFormWidgetModel model;

  const TaskFormWidgetModelProvider({
    super.key,
    required Widget child,
    required this.model,
  }) : super(
          child: child,
          notifier: model,
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
