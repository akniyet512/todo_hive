import 'package:hive/hive.dart';
import 'package:todo_hive/domain/entity/task.dart';

part "group.g.dart";

@HiveType(typeId: 0)
class Group extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  HiveList<Task>? tasks;

  Group({
    required this.name,
  });

  void addTask(Box<Task> box, Task task) {
    tasks ??= HiveList(box);
    tasks?.add(task);
    save();
  }
}
