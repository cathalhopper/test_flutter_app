import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter_app/app/router.dart';
import 'package:test_flutter_app/app/theme.dart';
import 'package:test_flutter_app/features/household/household_list_page.dart';
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
    final currentUserId = dotenv.env['TEST_USER_ID'] ?? '';

    return MaterialApp(
      title: 'Floor Plan App',
      theme: appTheme,
      home: HouseholdListPage(currentUserId: currentUserId),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
