import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_hive/domain/entity/group.dart';

class GroupFormWidgetModel {
  String groupName = "";
  Future<void> saveGroup(BuildContext context) async {
    if (groupName.isEmpty) return;

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(GroupAdapter());
    }

    final Box groupBox = await Hive.openBox<Group>("group_box");
    final Group group = Group(name: groupName);
    await groupBox.add(group).whenComplete(() {
      Navigator.of(context).pop();
    });
  }
}

class GroupFormWidgetModelProvider extends InheritedWidget {
  final GroupFormWidgetModel model;

  const GroupFormWidgetModelProvider({
    super.key,
    required Widget child,
    required this.model,
  }) : super(
          child: child,
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
