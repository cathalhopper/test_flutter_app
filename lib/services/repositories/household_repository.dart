import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_client.dart';
import '../../models/household.dart';
import '../../models/household_member.dart';

class HouseholdRepository {
  final SupabaseClient _client = SupabaseClientProvider.client;

  /// Fetch all households that a user is a member of.
  /// Joins household data via the household_member table.
  Future<List<Household>> getHouseholdsForUser(String userId) async {
    final data = await _client
        .from('household_member')
        .select('*, household(*)')
        .eq('user_id', userId);

    return data.map((json) {
      final householdJson = json['household'] as Map<String, dynamic>;
      return Household.fromJson(householdJson);
    }).toList();
  }

  /// Fetch the membership record for a user in a specific household.
  Future<HouseholdMember> getMembership(
    String householdId,
    String userId,
  ) async {
    final data = await _client
        .from('household_member')
        .select()
        .eq('household_id', householdId)
        .eq('user_id', userId)
        .single();

    return HouseholdMember.fromJson(data);
  }

  /// Fetch all members of a household.
  Future<List<HouseholdMember>> getMembers(String householdId) async {
    final data = await _client
        .from('household_member')
        .select()
        .eq('household_id', householdId)
        .order('joined_at', ascending: true);

    return data.map((json) => HouseholdMember.fromJson(json)).toList();
  }
}
