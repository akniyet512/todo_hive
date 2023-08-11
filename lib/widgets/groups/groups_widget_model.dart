import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/domain/entity/group.dart';

class GroupsWidgetModel extends ChangeNotifier {
  GroupsWidgetModel() {
    _setup();
  }
  List<Group> _groups = [];

  List<Group> get groups => _groups.toList();

  Future<void> showForm(BuildContext context) async {
    await Navigator.of(context).pushNamed("/groups/form");
  }

  Future<void> _setup() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(GroupAdapter());
    }

    final Box box = await Hive.openBox<Group>("group_box");
    _readGroupsFromHive(box);
    box.listenable().addListener(() => _readGroupsFromHive(box));
  }

  Future<void> deleteGroup(int index) async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(GroupAdapter());
    }

    final Box box = await Hive.openBox<Group>("group_box");
    await box.deleteAt(index);
  }

  void _readGroupsFromHive(Box box) {
    _groups = box.values.toList() as List<Group>;
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
