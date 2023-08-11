import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_hive/domain/entity/group.dart';
import 'package:todo_hive/widgets/groups/groups_widget_model.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({super.key});

  @override
  State<GroupsWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  final GroupsWidgetModel _model = GroupsWidgetModel();

  @override
  Widget build(BuildContext context) {
    return GroupsWidgetModelProvider(
      model: _model,
      child: const _GroupsWidgetBody(),
    );
  }
}

class _GroupsWidgetBody extends StatelessWidget {
  const _GroupsWidgetBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Groups"),
      ),
      body: const _GroupsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await GroupsWidgetModelProvider.read(context)
            ?.model
            .showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _GroupsList extends StatelessWidget {
  const _GroupsList();

  @override
  Widget build(BuildContext context) {
    final int groupsCount =
        GroupsWidgetModelProvider.watch(context)?.model.groups.length ?? 0;
    return ListView.separated(
      itemBuilder: (context, index) {
        return _GroupsListRowWidget(index: index);
      },
      separatorBuilder: (context, index) {
        return const Divider(
          thickness: 2,
          height: 3,
        );
      },
      itemCount: groupsCount,
    );
  }
}

class _GroupsListRowWidget extends StatelessWidget {
  final int index;
  const _GroupsListRowWidget({required this.index});

  @override
  Widget build(BuildContext context) {
    final Group group = GroupsWidgetModelProvider.read(context)!.model.groups[index];
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async => GroupsWidgetModelProvider.read(context)!.model.deleteGroup(index),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: Text(group.name),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
