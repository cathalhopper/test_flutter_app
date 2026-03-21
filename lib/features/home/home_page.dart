import 'package:flutter/material.dart';
import 'package:test_flutter_app/app/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.householdId,
    required this.householdName,
    required this.currentUserId,
  });

  final String householdId;
  final String householdName;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(householdName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.floorPlan);
              },
              child: const Text('Create Floor Plan'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.tasks,
                  arguments: {
                    'householdId': householdId,
                    'currentUserId': currentUserId,
                  },
                );
              },
              child: const Text('Show Task List'),
            ),
          ],
        ),
      ),
    );
  }
}
