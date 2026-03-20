import 'package:flutter/material.dart';
import 'package:test_flutter_app/features/tasks/create_task_dialog.dart';
import 'package:test_flutter_app/features/tasks/task_tile.dart';
import 'package:test_flutter_app/models/task.dart';
import 'package:test_flutter_app/services/repositories/task_repository.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({
    super.key,
    required this.householdId,
    required this.currentUserId,
  });

  final String householdId;
  final String currentUserId;

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final _repo = TaskRepository();
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    _tasksFuture = _repo.getTasksByHousehold(widget.householdId);
  }

  Future<void> _openCreateDialog() async {
    final task = await showDialog<Task>(
      context: context,
      builder: (_) => CreateTaskDialog(
        householdId: widget.householdId,
        createdBy: widget.currentUserId,
      ),
    );
    if (task != null) {
      setState(() => _loadTasks());
    }
  }

  Future<void> _toggleTask(Task task) async {
    await _repo.toggleStatus(task.id, task.status);
    setState(() => _loadTasks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Task List'),
      ),
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final tasks = snapshot.data ?? [];
          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks yet. Tap + to add one.'));
          }
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return TaskTile(
                task: tasks[index],
                onToggle: () => _toggleTask(tasks[index]),
              );
            },
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
