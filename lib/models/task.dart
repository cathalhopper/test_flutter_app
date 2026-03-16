class Task {
  final String id;
  final String title;
  final String room;
  final DateTime? dueDate;
  final DateTime createdAt;
  bool isComplete;

  Task({
    required this.id,
    required this.title,
    this.room = '',
    this.dueDate,
    this.isComplete = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as String,
        title: json['title'] as String,
        room: json['room'] as String? ?? '',
        dueDate: json['due_date'] != null
            ? DateTime.parse(json['due_date'] as String)
            : null,
        isComplete: json['is_complete'] as bool? ?? false,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}
