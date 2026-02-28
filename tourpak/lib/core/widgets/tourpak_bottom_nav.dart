import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourpak/core/theme/colors.dart';

/// Tab definition used by [TourPakBottomNav].
class _NavTab {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

const _tabs = [
  _NavTab(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
  _NavTab(icon: Icons.explore_outlined, activeIcon: Icons.explore_rounded, label: 'Explore'),
  _NavTab(icon: Icons.favorite_outline_rounded, activeIcon: Icons.favorite_rounded, label: 'Saved'),
  _NavTab(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile'),
];

/// Floating glassmorphism bottom navigation bar for TourPak.
///
/// 4 tabs with icon + tiny uppercase label. Active tab uses the
/// gold/primary colour. The bar floats with rounded corners and side margins.
class TourPakBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const TourPakBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding > 0 ? bottomPadding : 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: 68,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: TourPakColors.forestGreen.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final isActive = i == currentIndex;
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTap(i),
                    child: _TabItem(
                      tab: _tabs[i],
                      isActive: isActive,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

/// Single tab item — icon + tiny uppercase label.
class _TabItem extends StatelessWidget {
  final _NavTab tab;
  final bool isActive;

  const _TabItem({required this.tab, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? TourPakColors.goldAction
        : Colors.white.withValues(alpha: 0.5);

    return SizedBox(
      height: 68,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? tab.activeIcon : tab.icon,
            size: 24,
            color: color,
          ),
          const SizedBox(height: 4),
          Text(
            tab.label.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: color,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
