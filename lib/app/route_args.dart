/// Base args for any route scoped to a household.
class HouseholdRouteArgs {
  final String householdId;
  final String currentUserId;

  const HouseholdRouteArgs({
    required this.householdId,
    required this.currentUserId,
  });
}

/// Args for the home page (adds household name for display).
class HomeRouteArgs extends HouseholdRouteArgs {
  final String householdName;

  const HomeRouteArgs({
    required super.householdId,
    required super.currentUserId,
    required this.householdName,
  });
}

/// Args for the floor plan page.
class FloorPlanRouteArgs extends HouseholdRouteArgs {
  const FloorPlanRouteArgs({
    required super.householdId,
    required super.currentUserId,
  });
}
