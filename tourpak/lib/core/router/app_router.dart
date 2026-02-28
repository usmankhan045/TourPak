import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_state_provider.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/otp_verification_screen.dart';
import '../../features/auth/presentation/screens/phone_auth_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/destinations/presentation/screens/destination_screen.dart';
import '../../features/guides/presentation/screens/guide_detail_screen.dart';
import '../../features/home/presentation/screens/explore_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/profile_screen.dart';
import '../../features/home/presentation/screens/saved_screen.dart';
import '../../features/home/presentation/screens/settings_screen.dart';
import '../../features/home/presentation/widgets/scaffold_with_nav_bar.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/spots/presentation/screens/spot_detail_screen.dart';
import '../../features/spots/presentation/screens/spots_list_screen.dart';
import '../../features/weather/presentation/screens/weather_detail_screen.dart';

// ── Navigator keys ──────────────────────────────────────────
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _homeTabKey = GlobalKey<NavigatorState>(debugLabel: 'homeTab');
final _exploreTabKey = GlobalKey<NavigatorState>(debugLabel: 'exploreTab');
final _savedTabKey = GlobalKey<NavigatorState>(debugLabel: 'savedTab');
final _profileTabKey = GlobalKey<NavigatorState>(debugLabel: 'profileTab');

// ── Route name constants ────────────────────────────────────
class AppRoutes {
  AppRoutes._();

  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String phoneAuth = 'phone-auth';
  static const String otpVerification = 'otp-verification';
  static const String home = 'home';
  static const String explore = 'explore';
  static const String saved = 'saved';
  static const String profile = 'profile';
  static const String search = 'search';
  static const String destination = 'destination';
  static const String spotDetail = 'spot-detail';
  static const String guideDetail = 'guide-detail';
  static const String spotsList = 'spots-list';
  static const String weatherDetail = 'weather-detail';
  static const String settings = 'settings';
}

// ── Transition builders ─────────────────────────────────────

/// Slide-right + fade for destination pages
CustomTransitionPage<void> _slideFadePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetTween = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));

      final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: Curves.easeIn));

      return SlideTransition(
        position: animation.drive(offsetTween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );
}

/// Bottom-sheet style slide-up for detail pages (spot, guide)
CustomTransitionPage<void> _slideUpPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetTween = Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));

      final fadeTween = Tween<double>(begin: 0.6, end: 1.0)
          .chain(CurveTween(curve: Curves.easeIn));

      return SlideTransition(
        position: animation.drive(offsetTween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );
}

// ── Router provider (Riverpod) ──────────────────────────────

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,

    // ── Redirect logic ──────────────────────────────────────
    redirect: (context, state) {
      final currentPath = state.matchedLocation;

      // Splash screen handles its own navigation
      if (currentPath == '/splash') return null;

      final loggedIn = authState.whenOrNull(data: (val) => val) ?? false;

      // Auth flow paths
      const authPaths = ['/onboarding', '/auth/phone', '/auth/otp'];
      final isOnAuthPath = authPaths.contains(currentPath);

      // Authenticated user on auth pages → send to home
      if (loggedIn && isOnAuthPath) return '/home';

      // Auth is optional — unauthenticated users can browse freely
      return null;
    },

    // ── Routes ──────────────────────────────────────────────
    routes: [
      // Splash
      GoRoute(
        path: '/splash',
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: '/onboarding',
        name: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth
      GoRoute(
        path: '/auth/phone',
        name: AppRoutes.phoneAuth,
        builder: (context, state) => const PhoneAuthScreen(),
      ),
      GoRoute(
        path: '/auth/otp',
        name: AppRoutes.otpVerification,
        builder: (context, state) => const OtpVerificationScreen(),
      ),

      // ── Main shell (bottom nav) ──────────────────────────
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Tab 0: Home
          StatefulShellBranch(
            navigatorKey: _homeTabKey,
            routes: [
              GoRoute(
                path: '/home',
                name: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'search',
                    name: AppRoutes.search,
                    builder: (context, state) => const SearchScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Tab 1: Explore
          StatefulShellBranch(
            navigatorKey: _exploreTabKey,
            routes: [
              GoRoute(
                path: '/explore',
                name: AppRoutes.explore,
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),

          // Tab 2: Saved
          StatefulShellBranch(
            navigatorKey: _savedTabKey,
            routes: [
              GoRoute(
                path: '/saved',
                name: AppRoutes.saved,
                builder: (context, state) => const SavedScreen(),
              ),
            ],
          ),

          // Tab 3: Profile
          StatefulShellBranch(
            navigatorKey: _profileTabKey,
            routes: [
              GoRoute(
                path: '/profile',
                name: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // ── Destination (slide + fade) ───────────────────────
      GoRoute(
        path: '/destination/:id',
        name: AppRoutes.destination,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _slideFadePage(
            key: state.pageKey,
            child: DestinationScreen(destinationId: id),
          );
        },
        routes: [
          // Spots list (slide-up)
          GoRoute(
            path: 'spots',
            name: AppRoutes.spotsList,
            parentNavigatorKey: _rootNavigatorKey,
            pageBuilder: (context, state) {
              final destId = state.pathParameters['id']!;
              return _slideUpPage(
                key: state.pageKey,
                child: SpotsListScreen(destinationId: destId),
              );
            },
          ),

          // Weather detail (slide-up)
          GoRoute(
            path: 'weather',
            name: AppRoutes.weatherDetail,
            parentNavigatorKey: _rootNavigatorKey,
            pageBuilder: (context, state) {
              final destId = state.pathParameters['id']!;
              return _slideUpPage(
                key: state.pageKey,
                child: WeatherDetailScreen(destinationId: destId),
              );
            },
          ),

          // Spot detail (slide-up)
          GoRoute(
            path: 'spot/:spotId',
            name: AppRoutes.spotDetail,
            parentNavigatorKey: _rootNavigatorKey,
            pageBuilder: (context, state) {
              final destId = state.pathParameters['id']!;
              final spotId = state.pathParameters['spotId']!;
              return _slideUpPage(
                key: state.pageKey,
                child: SpotDetailScreen(
                  destinationId: destId,
                  spotId: spotId,
                ),
              );
            },
          ),

          // Guide detail (slide-up)
          GoRoute(
            path: 'guide/:guideId',
            name: AppRoutes.guideDetail,
            parentNavigatorKey: _rootNavigatorKey,
            pageBuilder: (context, state) {
              final destId = state.pathParameters['id']!;
              final guideId = state.pathParameters['guideId']!;
              return _slideUpPage(
                key: state.pageKey,
                child: GuideDetailScreen(
                  destinationId: destId,
                  guideId: guideId,
                ),
              );
            },
          ),
        ],
      ),

      // ── Settings (full-screen, above nav) ────────────────
      GoRoute(
        path: '/settings',
        name: AppRoutes.settings,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
