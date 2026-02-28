import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tourpak/core/widgets/tourpak_bottom_nav.dart';

/// Shell widget that provides the persistent bottom navigation bar
/// for the main app tabs: Home, Explore, Saved, Profile.
class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      extendBody: true,
      bottomNavigationBar: TourPakBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
