import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/room.dart';

class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(room.name),
      ),
    );
  }
}
