import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'utils/storage_service.dart';
import 'providers/auth_provider.dart';
import 'utils/constants.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/public/public_dashboard_screen.dart';
import 'screens/citizen/citizen_dashboard_screen.dart';
import 'screens/citizen/submit_complaint_screen.dart';
import 'screens/citizen/track_complaint_screen.dart';
import 'screens/citizen/feedback_screen.dart';
import 'screens/officer/officer_dashboard_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1E88E5),
            brightness: Brightness.light,
          ),
          fontFamily: 'Segoe UI',
          scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1E88E5),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        ),
        routerConfig: _buildRouter(context),
      ),
    );
  }

  GoRouter _buildRouter(BuildContext context) {
    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: false,
      redirect: (context, state) {
        final authProvider = context.read<AuthProvider>();
        final isLoggedIn = authProvider.isAuthenticated;
        final role = authProvider.user?.role;

        // Allow navigation to login/register/home without auth
        if (state.matchedLocation == '/login' ||
            state.matchedLocation == '/register' ||
            state.matchedLocation == '/') {
          return null; // Allow
        }

        // For authenticated users, allow all other routes
        if (isLoggedIn) {
          return null; // Allow
        }

        // Not authenticated and trying to access protected route
        if (!isLoggedIn) {
          return '/'; // Redirect to home
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/public',
          name: 'public_dashboard',
          builder: (context, state) => const PublicDashboardScreen(),
        ),
        GoRoute(
          path: '/citizen/dashboard',
          name: 'citizen_dashboard',
          builder: (context, state) => const CitizenDashboardScreen(),
        ),
        GoRoute(
          path: '/citizen/submit',
          name: 'citizen_submit',
          builder: (context, state) => const SubmitComplaintScreen(),
        ),
        GoRoute(
          path: '/citizen/track',
          name: 'citizen_track',
          builder: (context, state) => const TrackComplaintScreen(),
        ),
        GoRoute(
          path: '/citizen/feedback',
          name: 'citizen_feedback',
          builder: (context, state) => const FeedbackScreen(),
        ),
        GoRoute(
          path: '/officer/dashboard',
          name: 'officer_dashboard',
          builder: (context, state) => const OfficerDashboardScreen(),
        ),
        GoRoute(
          path: '/admin/dashboard',
          name: 'admin_dashboard',
          builder: (context, state) => const AdminDashboardScreen(),
        ),
      ],
    );
  }
}
