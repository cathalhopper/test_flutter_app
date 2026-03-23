import 'package:flutter/material.dart';
import 'package:test_flutter_app/services/repositories/cached_task_repository.dart';

class CreateTaskDialog extends StatefulWidget {
  const CreateTaskDialog({
    super.key,
    required this.householdId,
    required this.createdBy,
  });

  final String householdId;
  final String createdBy;

  @override
  State<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  final _repo = CachedTaskRepository();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _roomIdController = TextEditingController();
  final _assignedToController = TextEditingController();
  DateTime? _dueDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _roomIdController.dispose();
    _assignedToController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    final roomId = _roomIdController.text.trim();
    final assignedTo = _assignedToController.text.trim();

    final errors = <String>[];
    if (title.isEmpty) errors.add('Task name is required.');
    if (_dueDate == null) errors.add('Due date is required.');

    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errors.join(' '))),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final task = await _repo.createTask(
        householdId: widget.householdId,
        roomId: roomId.isEmpty ? null : roomId,
        createdBy: widget.createdBy,
        title: title,
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        dueDate: _dueDate!,
        assignedTo: assignedTo.isEmpty ? null : assignedTo,
      );
      if (mounted) Navigator.pop(context, task);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create task: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('New Task', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 24),
              TextField(
                controller: _titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Task name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _roomIdController,
                decoration: const InputDecoration(
                  labelText: 'Room ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _assignedToController,
                decoration: const InputDecoration(
                  labelText: 'Assign to (user ID)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _pickDueDate,
                icon: const Icon(Icons.calendar_today, size: 18),
                label: Text(
                  _dueDate == null
                      ? 'Set due date (required)'
                      : 'Due: ${_dueDate!.year}-${_dueDate!.month.toString().padLeft(2, '0')}-${_dueDate!.day.toString().padLeft(2, '0')}',
                ),
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
