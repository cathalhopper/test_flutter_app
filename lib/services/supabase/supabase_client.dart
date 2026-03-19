import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

/// Initialises the Supabase client once at app startup.
///
/// Call [SupabaseClientProvider.initialize] in main() before runApp(),
/// then access the client anywhere via [SupabaseClientProvider.client].
class SupabaseClientProvider {
  SupabaseClientProvider._();

  /// Call this once in main() before runApp().
  ///
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await SupabaseClientProvider.initialize();
  ///   runApp(const MyApp());
  /// }
  /// ```
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  }

  /// The Supabase client instance — available after [initialize] completes.
  ///
  /// Use this throughout the app:
  /// ```dart
  /// final data = await SupabaseClientProvider.client
  ///     .from('rooms')
  ///     .select()
  ///     .eq('household_id', householdId);
  /// ```
  static SupabaseClient get client => Supabase.instance.client;
}