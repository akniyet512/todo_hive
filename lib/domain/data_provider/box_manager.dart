import 'package:hive/hive.dart';
import 'package:todo_hive/domain/entity/group.dart';
import 'package:todo_hive/domain/entity/task.dart';

class BoxManager {
  BoxManager._();

  static final BoxManager instance = BoxManager._();
  
  Future<Box<Group>> openGroupBox() async {
    return _openBox<Group>(
      typeId: 0,
      name: "group_box",
      adapter: GroupAdapter(),
    );
  }

  Future<Box<Task>> openTaskBox(int groupKey) async {
    return _openBox<Task>(
      typeId: 1,
      name: "task_box_$groupKey",
      adapter: TaskAdapter(),
    );
  }

  Future<void> closeBox<T>(Box<T> box) async {
    box.compact();
    box.close();
  }

  Future<Box<T>> _openBox<T>({
    required int typeId,
    required String name,
    required TypeAdapter<T> adapter,
  }) async {
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(adapter);
    }
    return Hive.openBox<T>(name);
  }
}
