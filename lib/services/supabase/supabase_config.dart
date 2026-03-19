import 'package:flutter_dotenv/flutter_dotenv.dart';
/// Supabase project configuration.
///
/// These values come from your Supabase project dashboard under
/// Settings → API. In production, consider loading these from
/// environment variables or a .env file via the `flutter_dotenv`
/// package rather than hardcoding them.
class SupabaseConfig {
  SupabaseConfig._();
 
  static String get url =>
      dotenv.env['SUPABASE_URL'] ?? _missing('SUPABASE_URL');
 
  static String get anonKey =>
      dotenv.env['SUPABASE_ANON_KEY'] ?? _missing('SUPABASE_ANON_KEY');
 
  static Never _missing(String key) =>
      throw StateError('Missing $key in .env file');
}