import 'package:flutter/material.dart';
import 'package:test_flutter_app/features/tasks/create_task_dialog.dart';
import 'package:test_flutter_app/features/tasks/task_tile.dart';
import 'package:test_flutter_app/models/task.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final List<Task> _tasks = [];

  Future<void> _openCreateDialog() async {
    final task = await showDialog<Task>(
      context: context,
      builder: (_) => const CreateTaskDialog(),
    );
    if (task != null) {
      setState(() => _tasks.add(task));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Task List'),
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text('No tasks yet. Tap + to add one.'))
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return TaskTile(
                  task: _tasks[index],
                  onToggle: () => setState(
                    () => _tasks[index].isComplete = !_tasks[index].isComplete,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateDialog,
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
