import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/theme/colors.dart';
import '../../../../services/auth_service.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../destinations/presentation/notifiers/destinations_notifier.dart';
import '../../../spots/domain/entities/spot.dart';
import '../../../spots/presentation/notifiers/spot_notifier.dart';

// ══════════════════════════════════════════════════════════════
// PROFILE SCREEN
// ══════════════════════════════════════════════════════════════

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  List<String> _savedSpotIds = [];
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _savedSpotIds = prefs.getStringList('saved_spots') ?? [];
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? false;
    });
  }

  Future<void> _toggleNotifications(bool val) async {
    setState(() => _notificationsEnabled = val);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', val);
  }

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const _LogoutDialog(),
    );
    if (confirmed == true && mounted) {
      ref.read(guestModeProvider.notifier).state = false;
      await AuthService.instance.signOut();
    }
  }

  void _showAbout() {
    showDialog(context: context, builder: (_) => const _AboutDialog());
  }

  void _showHelp() {
    showDialog(context: context, builder: (_) => const _HelpDialog());
  }

  @override
  Widget build(BuildContext context) {
    // Watch auth to rebuild on sign-in / sign-out
    ref.watch(authStateProvider);
    final user = Supabase.instance.client.auth.currentUser;
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: TourPakColors.obsidian,
      body: user == null
          ? _GuestView(topInset: topInset)
          : _buildLoggedInView(context, user, topInset),
    );
  }

  // ── Logged-in view ────────────────────────────────────────

  Widget _buildLoggedInView(
      BuildContext context, User user, double topInset) {
    final fullName =
        user.userMetadata?['full_name'] as String? ?? 'Traveler';
    final phone = user.phone ?? user.email ?? '';
    final avatarUrl = user.userMetadata?['avatar_url'] as String?;

    return RefreshIndicator(
      color: TourPakColors.goldAction,
      backgroundColor: TourPakColors.forestGreen,
      onRefresh: _loadPrefs,
      child: CustomScrollView(
        slivers: [
          // ── Profile Header ──────────────────────────────
          SliverToBoxAdapter(
            child: _ProfileHeader(
              fullName: fullName,
              subtitle: phone,
              avatarUrl: avatarUrl,
              topInset: topInset,
              onEditTap: () => context.push('/edit-profile'),
            ),
          ),

          // ── Stats Row ───────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  _StatCard(
                    value: _savedSpotIds.length.toString(),
                    label: 'Spots\nSaved',
                  ),
                  const SizedBox(width: 12),
                  const _StatCard(value: '0', label: 'Reviews'),
                  const SizedBox(width: 12),
                  const _StatCard(value: '0', label: 'Trips\nPlanned'),
                ],
              ),
            ),
          ),

          // ── Saved Spots ─────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              child: Text(
                'Saved Spots',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: TourPakColors.textPrimary,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _SavedSpotsSection(savedSpotIds: _savedSpotIds),
          ),

          // ── Settings ────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              child: Text(
                'Settings',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: TourPakColors.textPrimary,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: TourPakColors.forestGreen.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: TourPakColors.forestLight.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    _SettingsTile(
                      icon: Icons.person_outline_rounded,
                      title: 'Edit Profile',
                      onTap: () => context.push('/edit-profile'),
                    ),
                    _divider(),
                    _SettingsTile(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      trailing: Switch.adaptive(
                        value: _notificationsEnabled,
                        onChanged: _toggleNotifications,
                        activeTrackColor: TourPakColors.goldAction,
                      ),
                    ),
                    _divider(),
                    _SettingsTile(
                      icon: Icons.language_rounded,
                      title: 'Language',
                      subtitle: 'English',
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: TourPakColors.textSecondary
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Urdu soon',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: TourPakColors.textSecondary,
                          ),
                        ),
                      ),
                      enabled: false,
                    ),
                    _divider(),
                    _SettingsTile(
                      icon: Icons.help_outline_rounded,
                      title: 'Help & Support',
                      onTap: _showHelp,
                    ),
                    _divider(),
                    _SettingsTile(
                      icon: Icons.info_outline_rounded,
                      title: 'About TourPak',
                      subtitle: 'Version 1.0.0',
                      onTap: _showAbout,
                    ),
                    _divider(),
                    _SettingsTile(
                      icon: Icons.logout_rounded,
                      title: 'Log Out',
                      titleColor: TourPakColors.errorRed,
                      onTap: _signOut,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom spacing for nav bar
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  static Widget _divider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: TourPakColors.forestLight.withValues(alpha: 0.3),
      indent: 52,
    );
  }
}

// ══════════════════════════════════════════════════════════════
// GUEST VIEW — Sign-in prompt card
// ══════════════════════════════════════════════════════════════

class _GuestView extends StatelessWidget {
  final double topInset;
  const _GuestView({required this.topInset});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(32, topInset + 40, 32, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TourPak icon
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF0A2D4A), Color(0xFF1565A7)],
                ),
              ),
              child: const Icon(Icons.explore_rounded,
                  color: Colors.white, size: 40),
            ),
            const SizedBox(height: 24),

            Text(
              'Welcome to TourPak',
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: TourPakColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              'Sign in to save your favourite spots\nand access your profile',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: TourPakColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // Sign In — navy primary
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => context.push('/auth/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A2D4A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Sign In',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Create Account — outlined
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () => context.push('/auth/signup'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: TourPakColors.textPrimary,
                  side: const BorderSide(color: TourPakColors.forestLight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Create Account',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Continue Browsing
            TextButton(
              onPressed: () => context.go('/home'),
              child: Text(
                'Continue Browsing',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: TourPakColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// PROFILE HEADER — Gradient card with avatar, name, edit icon
// ══════════════════════════════════════════════════════════════

class _ProfileHeader extends StatelessWidget {
  final String fullName;
  final String subtitle;
  final String? avatarUrl;
  final double topInset;
  final VoidCallback onEditTap;

  const _ProfileHeader({
    required this.fullName,
    required this.subtitle,
    required this.avatarUrl,
    required this.topInset,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(fullName);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, topInset + 20, 24, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A2D4A), Color(0xFF1565A7)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Top row — title + edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              GestureDetector(
                onTap: onEditTap,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Avatar 90px
          CircleAvatar(
            radius: 45,
            backgroundColor: const Color(0xFFE8A838),
            backgroundImage: avatarUrl != null
                ? CachedNetworkImageProvider(avatarUrl!)
                : null,
            child: avatarUrl == null
                ? Text(
                    initials,
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 14),

          // Name
          Text(
            fullName,
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),

          // Phone / email
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// STATS ROW — Stat card
// ══════════════════════════════════════════════════════════════

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: TourPakColors.forestGreen.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: TourPakColors.forestLight.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: TourPakColors.goldAction,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: TourPakColors.textSecondary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// SAVED SPOTS SECTION — Horizontal row of saved spot cards
// ══════════════════════════════════════════════════════════════

class _SavedSpotsSection extends ConsumerWidget {
  final List<String> savedSpotIds;
  const _SavedSpotsSection({required this.savedSpotIds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (savedSpotIds.isEmpty) return _emptyState();

    final destAsync = ref.watch(destinationsProvider);
    return destAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child:
              CircularProgressIndicator(color: TourPakColors.goldAction),
        ),
      ),
      error: (_, _) => _emptyState(),
      data: (destinations) {
        final swat = destinations
            .where((d) => d.name.toLowerCase().contains('swat'))
            .firstOrNull;
        if (swat == null) return _emptyState();

        final spotsAsync = ref.watch(spotsByDestinationProvider(swat.id));
        return spotsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: CircularProgressIndicator(
                  color: TourPakColors.goldAction),
            ),
          ),
          error: (_, _) => _emptyState(),
          data: (spots) {
            final saved = spots
                .where((s) => savedSpotIds.contains(s.id))
                .toList();
            if (saved.isEmpty) return _emptyState();

            return SizedBox(
              height: 170,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                scrollDirection: Axis.horizontal,
                itemCount: saved.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return _SpotMiniCard(
                    spot: saved[index],
                    onTap: () => context.push(
                      '/destination/${saved[index].destinationId}/spot/${saved[index].id}',
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  static Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: TourPakColors.forestGreen.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: TourPakColors.forestLight.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(Icons.bookmark_outline_rounded,
                color: TourPakColors.textSecondary.withValues(alpha: 0.5),
                size: 36),
            const SizedBox(height: 10),
            Text(
              'No saved spots yet',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: TourPakColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap the save icon on any spot to save it here',
              style: GoogleFonts.inter(
                fontSize: 12,
                color:
                    TourPakColors.textSecondary.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Spot mini card for saved spots row ───────────────────────

class _SpotMiniCard extends StatelessWidget {
  final Spot spot;
  final VoidCallback onTap;

  const _SpotMiniCard({required this.spot, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 130,
                height: 120,
                child: spot.heroImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: spot.heroImageUrl!,
                        fit: BoxFit.cover,
                        memCacheWidth: 260,
                        memCacheHeight: 240,
                        fadeInDuration: const Duration(milliseconds: 200),
                        placeholder: (_, _) =>
                            Container(color: TourPakColors.forestGreen),
                        errorWidget: (_, _, _) => Container(
                          color: TourPakColors.forestGreen,
                          child: const Icon(Icons.terrain_rounded,
                              color: TourPakColors.textSecondary),
                        ),
                      )
                    : Container(
                        color: TourPakColors.forestGreen,
                        child: const Icon(Icons.terrain_rounded,
                            color: TourPakColors.textSecondary),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              spot.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: TourPakColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// SETTINGS TILE
// ══════════════════════════════════════════════════════════════

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;
  final bool enabled;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon,
                color: titleColor ??
                    (enabled
                        ? TourPakColors.textSecondary
                        : TourPakColors.textSecondary
                            .withValues(alpha: 0.4)),
                size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: titleColor ??
                          (enabled
                              ? TourPakColors.textPrimary
                              : TourPakColors.textSecondary),
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: TourPakColors.textSecondary
                            .withValues(alpha: enabled ? 1.0 : 0.5),
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (onTap != null && enabled)
              Icon(
                Icons.chevron_right_rounded,
                color:
                    TourPakColors.textSecondary.withValues(alpha: 0.4),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// DIALOGS
// ══════════════════════════════════════════════════════════════

class _LogoutDialog extends StatelessWidget {
  const _LogoutDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: TourPakColors.forestGreen,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Sign Out?',
        style: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: TourPakColors.textPrimary,
        ),
      ),
      content: Text(
        'You can always sign back in to access your saved spots.',
        style: GoogleFonts.inter(
          fontSize: 14,
          color: TourPakColors.textSecondary,
          height: 1.4,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Cancel',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: TourPakColors.textSecondary,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            'Sign Out',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: TourPakColors.errorRed,
            ),
          ),
        ),
      ],
    );
  }
}

class _AboutDialog extends StatelessWidget {
  const _AboutDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: TourPakColors.forestGreen,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF0A2D4A), Color(0xFF1565A7)],
              ),
            ),
            child: const Icon(Icons.explore_rounded,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            'TourPak',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: TourPakColors.textPrimary,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Version 1.0.0',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: TourPakColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Discover the beauty of Pakistan.\nYour personal guide to domestic tourism.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: TourPakColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: TourPakColors.goldAction,
            ),
          ),
        ),
      ],
    );
  }
}

class _HelpDialog extends StatelessWidget {
  const _HelpDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: TourPakColors.forestGreen,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Help & Support',
        style: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: TourPakColors.textPrimary,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _faqItem(
            'How do I save spots?',
            'Tap the bookmark icon on any spot detail page to save it.',
          ),
          const SizedBox(height: 12),
          _faqItem(
            'How do I get directions?',
            'Open a spot and tap the Directions button to navigate.',
          ),
          const SizedBox(height: 12),
          _faqItem(
            'Need more help?',
            'Email us at support@tourpak.pk',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: TourPakColors.goldAction,
            ),
          ),
        ),
      ],
    );
  }

  static Widget _faqItem(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: TourPakColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          answer,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: TourPakColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// HELPER
// ══════════════════════════════════════════════════════════════

String _getInitials(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return 'T';
  final words = trimmed.split(RegExp(r'\s+'));
  if (words.length >= 2) {
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }
  return trimmed[0].toUpperCase();
}
