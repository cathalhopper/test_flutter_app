import 'package:flutter/material.dart';
import 'package:test_flutter_app/features/home/home_page.dart';
import 'package:test_flutter_app/features/floor_plan/floor_plan_page.dart';
import 'package:test_flutter_app/features/tasks/task_list_page.dart';

class AppRouter {
  static const String home = '/';
  static const String floorPlan = '/floor-plan';
  static const String tasks = '/tasks';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case floorPlan:
        return MaterialPageRoute(builder: (_) => const FloorPlanPage());
      case tasks:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => TaskListPage(
            householdId: args['householdId']!,
            currentUserId: args['currentUserId']!,
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
