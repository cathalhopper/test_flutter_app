import 'package:flutter/material.dart';
import 'package:test_flutter_app/features/household/household_list_page.dart';
import 'package:test_flutter_app/features/home/home_page.dart';
import 'package:test_flutter_app/features/floor_plan/floor_plan_page.dart';
import 'package:test_flutter_app/features/login/login_page.dart';
import 'package:test_flutter_app/features/tasks/task_list_page.dart';
import 'package:test_flutter_app/services/auth/auth_service.dart';

class AppRouter {
  static const String login = '/login';
  static const String households = '/';
  static const String home = '/home';
  static const String floorPlan = '/floor-plan';
  static const String tasks = '/tasks';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case households:
        final args = settings.arguments as Map<String, String>?;
        final userId = args?['currentUserId']
            ?? AuthService().currentUser?.id
            ?? '';
        return MaterialPageRoute(
          builder: (_) => HouseholdListPage(
            currentUserId: userId,
          ),
        );
      case home:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => HomePage(
            householdId: args['householdId']!,
            householdName: args['householdName']!,
            currentUserId: args['currentUserId']!,
          ),
        );
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
        return MaterialPageRoute(
          builder: (_) => const HouseholdListPage(currentUserId: ''),
        );
    }
  }
}
