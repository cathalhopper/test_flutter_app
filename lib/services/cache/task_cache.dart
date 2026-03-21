import 'package:collection/collection.dart';

import '../../models/task.dart';

class _CacheEntry {
  final List<Task> tasks;
  final DateTime fetchedAt;
  _CacheEntry(this.tasks, this.fetchedAt);
}

class TaskCache {
  static final TaskCache _instance = TaskCache._();
  TaskCache._();
  factory TaskCache() => _instance;

  static const _ttl = Duration(minutes: 5);

  final Map<String, _CacheEntry> _store = {};

  // Reverse map so mutations can locate the right household bucket by task id.
  final Map<String, String> _taskToHousehold = {};

  /// Returns the cached task list for [householdId] if it exists and is within
  /// the TTL, otherwise returns null.
  List<Task>? get(String householdId) {
    final entry = _store[householdId];
    if (entry == null) return null;
    if (DateTime.now().difference(entry.fetchedAt) > _ttl) {
      _evict(householdId);
      return null;
    }
    return entry.tasks;
  }

  /// Stores a fresh task list fetched from the API.
  void set(String householdId, List<Task> tasks) {
    _store[householdId] = _CacheEntry(List.unmodifiable(tasks), DateTime.now());
    for (final task in tasks) {
      _taskToHousehold[task.id] = householdId;
    }
  }

  /// Appends a newly created task to the household bucket.
  void addTask(Task task) {
    _taskToHousehold[task.id] = task.householdId;
    final entry = _store[task.householdId];
    if (entry == null) return;
    _store[task.householdId] = _CacheEntry(
      List.unmodifiable([...entry.tasks, task]),
      entry.fetchedAt,
    );
  }

  /// Replaces an existing task in the household bucket (used after updates).
  void upsertTask(Task task) {
    _taskToHousehold[task.id] = task.householdId;
    final entry = _store[task.householdId];
    if (entry == null) return;
    final updated = [
      for (final t in entry.tasks) t.id == task.id ? task : t,
    ];
    _store[task.householdId] = _CacheEntry(
      List.unmodifiable(updated),
      entry.fetchedAt,
    );
  }

  /// Returns a single cached task by ID, or null if not cached.
  Task? getTask(String taskId) {
    final householdId = _taskToHousehold[taskId];
    if (householdId == null) return null;
    final entry = _store[householdId];
    if (entry == null) return null;
    if (DateTime.now().difference(entry.fetchedAt) > _ttl) {
      _evict(householdId);
      return null;
    }
    return entry.tasks.firstWhereOrNull((t) => t.id == taskId);
  }

  /// Removes a deleted task from whichever household bucket it belongs to.
  void removeTask(String taskId) {
    final householdId = _taskToHousehold.remove(taskId);
    if (householdId == null) return;
    final entry = _store[householdId];
    if (entry == null) return;
    final updated = entry.tasks.where((t) => t.id != taskId).toList();
    _store[householdId] = _CacheEntry(
      List.unmodifiable(updated),
      entry.fetchedAt,
    );
  }

  void _evict(String householdId) {
    final entry = _store.remove(householdId);
    if (entry == null) return;
    for (final task in entry.tasks) {
      _taskToHousehold.remove(task.id);
    }
  }
}
