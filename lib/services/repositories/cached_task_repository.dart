import '../../models/task.dart';
import '../cache/task_cache.dart';
import 'task_repository.dart';

/// Wraps [TaskRepository] with a write-through in-memory cache.
///
/// Reads return from cache when valid (TTL: 5 min) and fall through to the
/// API on a miss. Writes always hit the API and update the cache in-place so
/// subsequent reads remain consistent without an extra round trip.
class CachedTaskRepository {
  CachedTaskRepository._({TaskRepository? repo, TaskCache? cache})
      : _repo = repo ?? TaskRepository(),
        _cache = cache ?? TaskCache();

  static final CachedTaskRepository _instance = CachedTaskRepository._();
  factory CachedTaskRepository() => _instance;

  final TaskRepository _repo;
  final TaskCache _cache;

  Future<List<Task>> getTasksByHousehold(String householdId) async {
    final cached = _cache.get(householdId);
    if (cached != null) return cached;

    final tasks = await _repo.getTasksByHousehold(householdId);
    _cache.set(householdId, tasks);
    return tasks;
  }

  Future<Task> getTaskById(String taskId) async =>
      _cache.getTask(taskId) ?? await _repo.getTaskById(taskId);

  Future<List<Task>> getTasksByRoom(
    String householdId,
    String roomId, {
    int limit = 20,
  }) async {
    final cached = _cache.get(householdId);
    if (cached != null) {
      return cached.where((t) => t.roomId == roomId).take(limit).toList();
    }
    return _repo.getTasksByRoom(householdId, roomId, limit: limit);
  }

  Future<List<Task>> getTasksByAssignee(
    String householdId,
    String userId,
  ) async {
    final cached = _cache.get(householdId);
    if (cached != null) {
      return cached.where((t) => t.assignedTo == userId).toList();
    }
    return _repo.getTasksByAssignee(householdId, userId);
  }

  Future<Task> createTask({
    required String householdId,
    required String roomId,
    required String createdBy,
    required String title,
    required String description,
    required DateTime dueDate,
    String? assignedTo,
  }) async {
    final task = await _repo.createTask(
      householdId: householdId,
      roomId: roomId,
      createdBy: createdBy,
      title: title,
      description: description,
      dueDate: dueDate,
      assignedTo: assignedTo,
    );
    _cache.addTask(task);
    return task;
  }

  Future<Task> updateTask(String taskId, Map<String, dynamic> updates) async {
    final task = await _repo.updateTask(taskId, updates);
    _cache.upsertTask(task);
    return task;
  }

  Future<Task> toggleStatus(String taskId, bool currentStatus) =>
      updateTask(taskId, {'status': !currentStatus});

  Future<void> deleteTask(String taskId) async {
    await _repo.deleteTask(taskId);
    _cache.removeTask(taskId);
  }
}
