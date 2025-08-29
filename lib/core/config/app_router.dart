import 'package:go_router/go_router.dart';
import 'package:invennico_fbp/features/auth/presentation/login_screen.dart';
import 'package:invennico_fbp/features/auth/presentation/splash_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true, // helpful during development
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}
