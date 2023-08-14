import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_hive/domain/data_provider/box_manager.dart';
import 'package:todo_hive/domain/entity/group.dart';

class GroupFormWidgetModel extends ChangeNotifier {
  String _groupName = "";
  String? errorText;

  set groupName(String value) {
    if (errorText != null && _groupName.trim().isNotEmpty) {
      errorText = null;
      notifyListeners();
    }
    _groupName = value;
  }

  Future<void> saveGroup(BuildContext context) async {
    if (_groupName.trim().isEmpty) {
      errorText = "Enter group name";
      notifyListeners();
      return;
    }

    final Box<Group> groupBox = await BoxManager.instance.openGroupBox();
    final Group group = Group(name: _groupName);
    await groupBox.add(group).whenComplete(() {
      Navigator.of(context).pop();
    });
  }
}

class GroupFormWidgetModelProvider extends InheritedNotifier {
  final GroupFormWidgetModel model;

  const GroupFormWidgetModelProvider({
    super.key,
    required Widget child,
    required this.model,
  }) : super(
          child: child,
          notifier: model,
        );

  static GroupFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>();
  }

  static GroupFormWidgetModelProvider? read(BuildContext context) {
    final Widget? widget = context
        .getElementForInheritedWidgetOfExactType<GroupFormWidgetModelProvider>()
        ?.widget;
    return widget is GroupFormWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(covariant GroupFormWidgetModelProvider oldWidget) {
    return true;
  }
}
