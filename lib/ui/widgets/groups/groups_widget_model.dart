import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/domain/data_provider/box_manager.dart';
import 'package:todo_hive/domain/entity/group.dart';
import 'package:todo_hive/ui/navigation/main_navigation.dart';

class GroupsWidgetModel extends ChangeNotifier {
  late final Box<Group> _groupBox;
  GroupsWidgetModel() {
    _setup();
  }
  List<Group> _groups = [];

  List<Group> get groups => _groups.toList();

  Future<void> showForm(BuildContext context) async {
    await Navigator.of(context).pushNamed(MainNavigationRouteNames.groupForm);
  }

  Future<void> showTasks(BuildContext context, int index) async {
    final Group? group = _groupBox.getAt(index);
    if (group != null) {
      await Navigator.of(context).pushNamed(
        MainNavigationRouteNames.tasks,
        arguments: {
          "groupKey": group.key as int,
          "title": group.name,
        },
      );
    }
  }

  Future<void> _setup() async {
    _groupBox = await BoxManager.instance.openGroupBox();
    _readGroupsFromHive();
    _groupBox.listenable().addListener(() => _readGroupsFromHive());
  }

  Future<void> deleteGroup(int index) async {
    final int groupKey = _groupBox.keyAt(index) as int;
    await Hive.deleteBoxFromDisk("task_box_$groupKey");
    await _groupBox.deleteAt(index);
  }

  void _readGroupsFromHive() {
    _groups = _groupBox.values.toList();
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
