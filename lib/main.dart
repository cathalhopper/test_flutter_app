import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test_flutter_app/app/router.dart';
import 'package:test_flutter_app/app/theme.dart';
import 'package:test_flutter_app/features/household/household_list_page.dart';
import 'package:test_flutter_app/features/login/login_page.dart';
import 'package:test_flutter_app/services/auth/auth_service.dart';
import 'package:test_flutter_app/services/supabase/supabase_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await SupabaseClientProvider.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return MaterialApp(
      title: 'Floor Plan App',
      theme: appTheme,
      home: StreamBuilder<AuthState>(
        stream: authService.onAuthStateChange,
        builder: (context, snapshot) {
          final session = snapshot.data?.session;
          if (session != null) {
            return HouseholdListPage(currentUserId: session.user.id);
          }
          return const LoginPage();
        },
      ),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
