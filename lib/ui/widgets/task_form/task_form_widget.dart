import 'package:flutter/material.dart';
import 'package:todo_hive/ui/widgets/task_form/task_form_widget_model.dart';

class TaskFormWidget extends StatefulWidget {
  final int groupKey;

  const TaskFormWidget({
    super.key,
    required this.groupKey,
  });

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  TaskFormWidgetModel? _model;

  @override
  void initState() {
    super.initState();
    _model = TaskFormWidgetModel(groupKey: widget.groupKey);
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
      return TaskFormWidgetModelProvider(
        model: _model!,
        child: const _TaskFormWidgetBody(),
      );
    }
  }
}

class _TaskFormWidgetBody extends StatelessWidget {
  const _TaskFormWidgetBody();

  @override
  Widget build(BuildContext context) {
    TaskFormWidgetModel? model =
        TaskFormWidgetModelProvider.watch(context)?.model;
    return Scaffold(
      appBar: AppBar(
        title: const Text("New task"),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _TaskTextWidget(),
        ),
      ),
      floatingActionButton: model?.isValid == true
          ? FloatingActionButton(
              onPressed: () async => await model?.saveTask(context),
              child: const Icon(Icons.done),
            )
          : null,
    );
  }
}

class _TaskTextWidget extends StatelessWidget {
  const _TaskTextWidget();

  @override
  Widget build(BuildContext context) {
    final TaskFormWidgetModel? model =
        TaskFormWidgetModelProvider.read(context)?.model;

    return TextField(
      autofocus: true,
      minLines: null,
      maxLines: null,
      expands: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "Task text",
      ),
      onChanged: (value) => model?.taskText = value,
      onEditingComplete: () async => await model?.saveTask(context),
    );
  }
}
