import 'package:flutter/material.dart';
import 'package:test_flutter_app/features/floor_plan/floor_plan_canvas.dart';

class FloorPlanPage extends StatelessWidget {
  const FloorPlanPage({
    super.key,
    required this.householdId,
    required this.currentUserId,
  });

  final String householdId;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Floor Plan'),
      ),
      body: const Center(
        child: FloorPlanCanvas(),
      ),
    );
  }
}
