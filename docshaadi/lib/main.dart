import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_router.dart';
import 'controllers/auth_controller.dart';
import 'controllers/family_controller.dart';
import 'controllers/profile_controller.dart';

void main() {
  runApp(const DrShaadiApp());
}

class DrShaadiApp extends StatelessWidget {
  const DrShaadiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => FamilyController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
      ],
      child: MaterialApp.router(
        title: 'DrShaadi.com',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
