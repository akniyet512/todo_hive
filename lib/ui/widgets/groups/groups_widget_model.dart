import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/domain/entity/group.dart';
import 'package:todo_hive/ui/navigation/main_navigation.dart';

class GroupsWidgetModel extends ChangeNotifier {
  GroupsWidgetModel() {
    _setup();
  }
  List<Group> _groups = [];

  List<Group> get groups => _groups.toList();

  Future<void> showForm(BuildContext context) async {
    await Navigator.of(context).pushNamed(MainNavigationRouteNames.groupForm);
  }

  Future<void> showTasks(BuildContext context, int index) async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(GroupAdapter());
    }

    await Hive.openBox<Group>("group_box").then((Box<Group> box) async {
      final int groupKey = box.keyAt(index) as int;
      await Navigator.of(context).pushNamed(
        MainNavigationRouteNames.tasks,
        arguments: {
          "groupKey": groupKey,
        },
      );
    });
  }

  Future<void> _setup() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(GroupAdapter());
    }

    final Box<Group> box = await Hive.openBox<Group>("group_box");
    _readGroupsFromHive(box);
    box.listenable().addListener(() => _readGroupsFromHive(box));
  }

  Future<void> deleteGroup(int index) async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(GroupAdapter());
    }

    final Box<Group> box = await Hive.openBox<Group>("group_box");
    await box.getAt(index)?.tasks?.deleteAllFromHive();
    await box.deleteAt(index);
  }

  void _readGroupsFromHive(Box<Group> box) {
    _groups = box.values.toList();
    notifyListeners();
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;

  const GroupsWidgetModelProvider({
    super.key,
    required Widget child,
    required this.model,
  }) : super(
          child: child,
          notifier: model,
        );

  static GroupsWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }

  static GroupsWidgetModelProvider? read(BuildContext context) {
    final Widget? widget = context
        .getElementForInheritedWidgetOfExactType<GroupsWidgetModelProvider>()
        ?.widget;
    return widget is GroupsWidgetModelProvider ? widget : null;
  }
}
