import 'package:flutter/material.dart';
import 'package:test_flutter_app/app/router.dart';
import 'package:test_flutter_app/app/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floor Plan App',
      theme: appTheme,
      initialRoute: AppRouter.home,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
