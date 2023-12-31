import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_hive/domain/entity/task.dart';
import 'package:todo_hive/ui/widgets/tasks/tasks_widget_model.dart';

class TasksWidget extends StatefulWidget {
  final int groupKey;
  final String title;

  const TasksWidget({
    super.key,
    required this.groupKey,
    required this.title,
  });

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  TasksWidgetModel? _model;

  @override
  void initState() {
    super.initState();
    _model = TasksWidgetModel(
      groupKey: widget.groupKey,
      title: widget.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_model == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return TasksWidgetModelProvider(
        model: _model!,
        child: const _TasksWidgetBody(),
      );
    }
  }
}

class _TasksWidgetBody extends StatelessWidget {
  const _TasksWidgetBody();

  @override
  Widget build(BuildContext context) {
    final TasksWidgetModel? model =
        TasksWidgetModelProvider.watch(context)?.model;
    return Scaffold(
      appBar: AppBar(
        title: Text(model?.title ?? "Tasks"),
      ),
      body: const _TasksList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async =>
            TasksWidgetModelProvider.read(context)?.model.showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TasksList extends StatelessWidget {
  const _TasksList();

  @override
  Widget build(BuildContext context) {
    final int tasksCount =
        TasksWidgetModelProvider.watch(context)?.model.tasks.length ?? 0;
    return ListView.separated(
      itemBuilder: (context, index) {
        return _TasksListRowWidget(index: index);
      },
      separatorBuilder: (context, index) {
        return const Divider(
          thickness: 2,
          height: 3,
        );
      },
      itemCount: tasksCount,
    );
  }
}

class _TasksListRowWidget extends StatelessWidget {
  final int index;
  const _TasksListRowWidget({required this.index});

  @override
  Widget build(BuildContext context) {
    final Task task =
        TasksWidgetModelProvider.read(context)!.model.tasks[index];
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async =>
                await TasksWidgetModelProvider.read(context)!
                    .model
                    .deleteTask(index),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          task.text,
          style: task.isDone
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        trailing:
            task.isDone ? const Icon(Icons.done) : const Icon(Icons.portrait),
        onTap: () async =>
            await TasksWidgetModelProvider.read(context)!.model.doneToggle(index),
      ),
    );
  }
}
