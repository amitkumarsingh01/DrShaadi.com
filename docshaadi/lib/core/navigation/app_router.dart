import 'package:go_router/go_router.dart';
import '../../views/screens/welcome_screen.dart';
import '../../views/screens/family_management_screen.dart';
import '../../views/screens/mobile_verification_screen.dart';
import '../../views/screens/otp_verification_screen.dart';
import '../../views/screens/profile_setup_screen.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/family-management',
        name: 'family-management',
        builder: (context, state) => const FamilyManagementScreen(),
      ),
      GoRoute(
        path: '/mobile-verification',
        name: 'mobile-verification',
        builder: (context, state) => const MobileVerificationScreen(),
      ),
      GoRoute(
        path: '/otp-verification',
        name: 'otp-verification',
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: '/profile-setup',
        name: 'profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
    ],
  );

  static GoRouter get router => _router;
}
