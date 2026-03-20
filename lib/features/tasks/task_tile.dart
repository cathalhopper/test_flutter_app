import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback? onToggle;

  const TaskTile({super.key, required this.task, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        task.status ? Icons.check_box : Icons.check_box_outline_blank,
      ),
      title: Text(task.title),
      onTap: onToggle,
    );
  }
}
