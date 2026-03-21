class HouseholdMember {
  final String householdId;
  final String userId;
  final DateTime joinedAt;
  final String role;

  HouseholdMember({
    required this.householdId,
    required this.userId,
    required this.joinedAt,
    required this.role,
  });

  factory HouseholdMember.fromJson(Map<String, dynamic> json) =>
      HouseholdMember(
        householdId: json['household_id'] as String,
        userId: json['user_id'] as String,
        joinedAt: DateTime.parse(json['joined_at'] as String),
        role: json['role'] as String,
      );

  Map<String, dynamic> toJson() => {
        'household_id': householdId,
        'user_id': userId,
        'role': role,
      };
}
