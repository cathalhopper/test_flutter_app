import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test_flutter_app/services/supabase/supabase_client.dart';

class AuthService {
  AuthService._();
  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;

  final GoTrueClient _auth = SupabaseClientProvider.client.auth;

  // ── Helpers ──────────────────────────────────────────────

  User? get currentUser => _auth.currentUser;
  Session? get currentSession => _auth.currentSession;
  bool get isSignedIn => _auth.currentSession != null;
  Stream<AuthState> get onAuthStateChange => _auth.onAuthStateChange;

  // ── Auth operations ──────────────────────────────────────

  Future<AuthResponse> signUp(String email, String password) async {
    try {
      return await _auth.signUp(email: email, password: password);
    } on AuthException catch (e) {
      throw AuthException(e.message, statusCode: e.statusCode);
    }
  }

  Future<AuthResponse> signInWithPassword(String email, String password) async {
    try {
      return await _auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw AuthException(e.message, statusCode: e.statusCode);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on AuthException catch (e) {
      throw AuthException(e.message, statusCode: e.statusCode);
    }
  }
}
