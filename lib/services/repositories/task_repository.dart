import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_client.dart';
import '../../models/task.dart';

class TaskRepository {
  final SupabaseClient _client = SupabaseClientProvider.client;

  /// Fetch all tasks for a household.
  Future<List<Task>> getTasksByHousehold(String householdId) async {
    final data = await _client
        .from('task')
        .select('*, room(*)')
        .eq('household_id', householdId)
        .order('due_date', ascending: true);

    return data.map((json) => Task.fromJson(json)).toList();
  }

  /// Fetch a single task by ID.
  Future<Task> getTaskById(String taskId) async {
    final data = await _client
        .from('task')
        .select('*, room(*)')
        .eq('id', taskId)
        .single();

    return Task.fromJson(data);
  }

  /// Fetch tasks filtered by room.
  Future<List<Task>> getTasksByRoom(
    String householdId,
    String roomId, {
    int limit = 20,
  }) async {
    final data = await _client
        .from('task')
        .select()
        .eq('household_id', householdId)
        .eq('room_id', roomId)
        .order('due_date')
        .limit(limit);

    return data.map((json) => Task.fromJson(json)).toList();
  }

  /// Fetch tasks assigned to a specific user.
  Future<List<Task>> getTasksByAssignee(
    String householdId,
    String userId,
  ) async {
    final data = await _client
        .from('task')
        .select('*, room(*)')
        .eq('household_id', householdId)
        .eq('assigned_to', userId)
        .order('due_date');

    return data.map((json) => Task.fromJson(json)).toList();
  }

  /// Create a new task. Returns the created task with its
  /// server-generated ID and timestamp.
  Future<Task> createTask({
    required String householdId,
    required String roomId,
    required String createdBy,
    required String title,
    required String description,
    required DateTime dueDate,
    String? assignedTo,
  }) async {
    final data = await _client
        .from('task')
        .insert({
          'household_id': householdId,
          'room_id': roomId,
          'created_by': createdBy,
          'assigned_to': assignedTo ?? createdBy,
          'title': title,
          'description': description,
          'status': false,
          'due_date': dueDate.toIso8601String().split('T').first,
        })
        .select()
        .single();

    return Task.fromJson(data);
  }

  /// Update an existing task.
  Future<Task> updateTask(String taskId, Map<String, dynamic> updates) async {
    final data = await _client
        .from('task')
        .update(updates)
        .eq('id', taskId)
        .select()
        .single();

    return Task.fromJson(data);
  }

  /// Toggle task completion status.
  Future<Task> toggleStatus(String taskId, bool currentStatus) async {
    return updateTask(taskId, {'status': !currentStatus});
  }

  /// Delete a task.
  Future<void> deleteTask(String taskId) async {
    await _client
        .from('task')
        .delete()
        .eq('id', taskId);
  }
}