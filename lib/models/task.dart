class Task {
  final String id;
  final String householdId;
  final String? roomId;
  final String assignedTo;
  final String createdBy;
  final DateTime createdAt;
  final String title;
  final String description;
  final DateTime? dueDate;
  final bool status;

  Task({
    required this.id,
    required this.householdId,
    this.roomId,
    required this.assignedTo,
    required this.createdBy,
    required this.title,
    this.description = '',
    this.dueDate,
    this.status = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as String,
        householdId: json['household_id'] as String,
        roomId: json['room_id'] as String?,
        assignedTo: json['assigned_to'] as String,
        createdBy: json['created_by'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        dueDate: json['due_date'] != null
            ? DateTime.parse(json['due_date'] as String)
            : null,
        status: json['status'] as bool? ?? false,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Task copyWith({
    String? id,
    String? householdId,
    String? roomId,
    String? assignedTo,
    String? createdBy,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? status,
    DateTime? createdAt,
  }) =>
      Task(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        roomId: roomId ?? this.roomId,
        assignedTo: assignedTo ?? this.assignedTo,
        createdBy: createdBy ?? this.createdBy,
        title: title ?? this.title,
        description: description ?? this.description,
        dueDate: dueDate ?? this.dueDate,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );

  Map<String, dynamic> toJson() => {
        'household_id': householdId,
        'room_id': roomId,
        'assigned_to': assignedTo,
        'created_by': createdBy,
        'title': title,
        'description': description,
        'status': status,
        'due_date': dueDate?.toIso8601String().split('T').first,
      };
}