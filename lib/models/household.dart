class Household {
  final String id;
  final String name;
  final DateTime createdAt;

  Household({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory Household.fromJson(Map<String, dynamic> json) =>
      Household(
        id: json['id'] as String,
        name: json['name'] as String,
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}