import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';

// ══════════════════════════════════════════════════════════════
// PROFILE SCREEN
// ══════════════════════════════════════════════════════════════

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topInset = MediaQuery.of(context).padding.top;
    final user = Supabase.instance.client.auth.currentUser;
    final isLoggedIn = user != null;
    final name =
        user?.userMetadata?['full_name'] as String? ?? 'Traveler';
    final phone = user?.phone ?? '';

    return Scaffold(
      backgroundColor: TourPakColors.obsidian,
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, topInset + 16, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile',
                    style: TourPakTextStyles.displayLarge,
                  ),
                  const SizedBox(height: 24),

                  // ── Avatar + info ──
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: TourPakColors.forestGreen,
                          border: Border.all(
                            color: TourPakColors.goldMuted.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: TourPakColors.goldMuted,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isLoggedIn ? name : 'Guest',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: TourPakColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isLoggedIn
                                  ? phone
                                  : 'Sign in to sync your data',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: TourPakColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Menu items ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: Column(
                children: [
                  // Sign in button (only shown for guests)
                  if (!isLoggedIn)
                    _ActionButton(
                      icon: Icons.login_rounded,
                      label: 'Sign In',
                      subtitle: 'Login with your phone number',
                      accentColor: TourPakColors.goldAction,
                      onTap: () => context.push('/auth/phone'),
                    ),

                  _ActionButton(
                    icon: Icons.settings_rounded,
                    label: 'Settings',
                    subtitle: 'App preferences',
                    onTap: () => context.push('/settings'),
                  ),

                  _ActionButton(
                    icon: Icons.info_outline_rounded,
                    label: 'About TourPak',
                    subtitle: 'Version 1.0.0',
                    onTap: () {},
                  ),

                  if (isLoggedIn) ...[
                    const SizedBox(height: 16),
                    _ActionButton(
                      icon: Icons.logout_rounded,
                      label: 'Sign Out',
                      subtitle: phone,
                      accentColor: TourPakColors.errorRed,
                      onTap: () async {
                        await Supabase.instance.client.auth.signOut();
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom spacing for nav bar
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

// ── Reusable menu button ────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.accentColor = TourPakColors.textPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: TourPakColors.forestGreen.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: TourPakColors.forestLight.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: accentColor, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: accentColor,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: TourPakColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: TourPakColors.textSecondary.withValues(alpha: 0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
