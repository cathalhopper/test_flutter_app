import 'package:flutter/material.dart';
import 'package:test_flutter_app/app/route_args.dart';
import 'package:test_flutter_app/app/router.dart';
import 'package:test_flutter_app/models/household.dart';
import 'package:test_flutter_app/services/auth/auth_service.dart';
import 'package:test_flutter_app/services/repositories/household_repository.dart';

class HouseholdListPage extends StatefulWidget {
  const HouseholdListPage({
    super.key,
    required this.currentUserId,
  });

  final String currentUserId;

  @override
  State<HouseholdListPage> createState() => _HouseholdListPageState();
}

class _HouseholdListPageState extends State<HouseholdListPage> {
  final _repo = HouseholdRepository();
  late Future<List<Household>> _householdsFuture;

  @override
  void initState() {
    super.initState();
    _householdsFuture = _repo.getHouseholdsForUser(widget.currentUserId);
  }

  void _enterHousehold(Household household) {
    Navigator.pushNamed(
      context,
      AppRouter.home,
      arguments: HomeRouteArgs(
        householdId: household.id,
        householdName: household.name,
        currentUserId: widget.currentUserId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My Households'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthService().signOut(),
          ),
        ],
      ),
      body: FutureBuilder<List<Household>>(
        future: _householdsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final households = snapshot.data ?? [];
          if (households.isEmpty) {
            return const Center(
              child: Text('You are not a member of any household yet.'),
            );
          }
          return ListView.builder(
            itemCount: households.length,
            itemBuilder: (context, index) {
              final household = households[index];
              return ListTile(
                leading: const Icon(Icons.home),
                title: Text(household.name),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _enterHousehold(household),
              );
            },
          );
        },
      ),
    );
  }
}
