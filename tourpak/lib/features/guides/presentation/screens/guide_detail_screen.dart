import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../domain/entities/guide.dart';
import '../notifiers/guide_notifier.dart';

// ══════════════════════════════════════════════════════════════
// GUIDE DETAIL SCREEN
// ══════════════════════════════════════════════════════════════

class GuideDetailScreen extends ConsumerWidget {
  final String destinationId;
  final String guideId;

  const GuideDetailScreen({
    super.key,
    required this.destinationId,
    required this.guideId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guideAsync = ref.watch(
      guideByIdProvider((destinationId: destinationId, guideId: guideId)),
    );

    return Scaffold(
      backgroundColor: TourPakColors.obsidian,
      body: guideAsync.when(
        loading: () => const _LoadingView(),
        error: (e, _) => ErrorDisplay(
          message: 'Failed to load guide details.',
          onRetry: () => ref.invalidate(
            guideByIdProvider(
                (destinationId: destinationId, guideId: guideId)),
          ),
        ),
        data: (guide) => _GuideDetailContent(guide: guide),
      ),
    );
  }
}

// ── Loading placeholder ──────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        DestinationHeroSkeleton(height: 340),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: ListItemSkeleton(count: 5),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// MAIN CONTENT
// ══════════════════════════════════════════════════════════════

class _GuideDetailContent extends StatelessWidget {
  final Guide guide;

  const _GuideDetailContent({required this.guide});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Stack(
      children: [
        SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero section with mountain backdrop + profile photo
              _HeroSection(guide: guide),

              // Content body on forestGreen
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: TourPakColors.forestGreen,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(32)),
                ),
                transform: Matrix4.translationValues(0, -32, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Info cards row
                    _InfoCardsRow(guide: guide),
                    const SizedBox(height: 24),

                    // Specialties
                    if (guide.specialties.isNotEmpty)
                      _SpecialtiesSection(specialties: guide.specialties),
                    if (guide.specialties.isNotEmpty)
                      const SizedBox(height: 24),

                    // Bio
                    _BioSection(guide: guide),
                    const SizedBox(height: 24),

                    // Contact
                    _ContactSection(guide: guide),

                    // Bottom spacer
                    SizedBox(height: 32 + bottomInset),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Back button ─────────────────────────────────────────
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          child: GlassCard(
            borderRadius: 22,
            padding: const EdgeInsets.all(10),
            onTap: () => context.pop(),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: TourPakColors.textPrimary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// HERO SECTION — Mountain backdrop + profile photo + name
// ══════════════════════════════════════════════════════════════

class _HeroSection extends StatelessWidget {
  final Guide guide;

  const _HeroSection({required this.guide});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Mountain backdrop at low opacity
          Positioned.fill(
            child: Opacity(
              opacity: 0.12,
              child: Image.network(
                'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: TourPakColors.obsidian,
                ),
              ),
            ),
          ),

          // Top gradient fade
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    TourPakColors.obsidian,
                    TourPakColors.obsidian.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // Bottom gradient fade
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    TourPakColors.forestGreen,
                    TourPakColors.forestGreen.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // Profile content
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 48,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile photo
                _ProfilePhoto(photoUrl: guide.photoUrl),
                const SizedBox(height: 16),

                // Name
                Text(
                  guide.name,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: TourPakColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 400.ms, curve: Curves.easeOut)
                    .slideY(
                      begin: 0.1,
                      end: 0,
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    ),
                const SizedBox(height: 8),

                // Verified badge
                if (guide.isVerified)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        color: TourPakColors.goldAction,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'TourPak Verified',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: TourPakColors.goldAction,
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 150.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Profile photo with gold ring ─────────────────────────────

class _ProfilePhoto extends StatelessWidget {
  final String? photoUrl;

  const _ProfilePhoto({required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: TourPakColors.goldAction,
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: TourPakColors.goldAction.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 55,
        backgroundColor: TourPakColors.forestLight,
        backgroundImage:
            photoUrl != null ? CachedNetworkImageProvider(photoUrl!) : null,
        child: photoUrl == null
            ? const Icon(
                Icons.person_rounded,
                color: TourPakColors.textSecondary,
                size: 40,
              )
            : null,
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, curve: Curves.easeOut)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: 500.ms,
          curve: Curves.easeOut,
        );
  }
}

// ══════════════════════════════════════════════════════════════
// INFO CARDS ROW — Rating, Languages, Rate, Experience
// ══════════════════════════════════════════════════════════════

class _InfoCardsRow extends StatelessWidget {
  final Guide guide;

  const _InfoCardsRow({required this.guide});

  @override
  Widget build(BuildContext context) {
    final cards = <({IconData icon, String label, String value})>[
      (
        icon: Icons.star_rounded,
        label: 'Rating',
        value: guide.rating != null
            ? '${guide.rating!.toStringAsFixed(1)} (${guide.reviewCount ?? 0})'
            : 'N/A',
      ),
      (
        icon: Icons.translate_rounded,
        label: 'Languages',
        value: guide.languages.isNotEmpty
            ? guide.languages.join(', ')
            : 'N/A',
      ),
      (
        icon: Icons.payments_rounded,
        label: 'Daily Rate',
        value: guide.formattedRate,
      ),
      (
        icon: Icons.timeline_rounded,
        label: 'Experience',
        value: guide.formattedExperience,
      ),
    ];

    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: cards.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final card = cards[index];
          return GlassCard(
            borderRadius: 16,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(card.icon, color: TourPakColors.goldAction, size: 18),
                const SizedBox(height: 8),
                Text(
                  card.label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: TourPakColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  card.value,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: TourPakColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(
                duration: 300.ms,
                delay: (index * 80 + 200).ms,
                curve: Curves.easeOut,
              )
              .slideX(
                begin: 0.1,
                end: 0,
                duration: 300.ms,
                delay: (index * 80 + 200).ms,
                curve: Curves.easeOut,
              );
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// SPECIALTIES — Wrap of gold-bordered pills
// ══════════════════════════════════════════════════════════════

class _SpecialtiesSection extends StatelessWidget {
  final List<String> specialties;

  const _SpecialtiesSection({required this.specialties});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Specialties',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: TourPakColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: specialties.asMap().entries.map((entry) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: TourPakColors.goldAction.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  entry.value,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: TourPakColors.textPrimary,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(
                    duration: 300.ms,
                    delay: (entry.key * 60 + 300).ms,
                    curve: Curves.easeOut,
                  )
                  .scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1, 1),
                    duration: 300.ms,
                    delay: (entry.key * 60 + 300).ms,
                    curve: Curves.easeOut,
                  );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 400.ms);
  }
}

// ══════════════════════════════════════════════════════════════
// BIO SECTION — Expandable read-more
// ══════════════════════════════════════════════════════════════

class _BioSection extends StatefulWidget {
  final Guide guide;

  const _BioSection({required this.guide});

  @override
  State<_BioSection> createState() => _BioSectionState();
}

class _BioSectionState extends State<_BioSection> {
  bool _expanded = false;
  static const _maxLines = 4;

  @override
  Widget build(BuildContext context) {
    if (widget.guide.bio == null || widget.guide.bio!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About ${widget.guide.name}',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: TourPakColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          AnimatedCrossFade(
            firstChild: Text(
              widget.guide.bio!,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: TourPakColors.textSecondary,
                height: 1.6,
              ),
              maxLines: _maxLines,
              overflow: TextOverflow.ellipsis,
            ),
            secondChild: Text(
              widget.guide.bio!,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: TourPakColors.textSecondary,
                height: 1.6,
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(
              _expanded ? 'Show less' : 'Read more',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: TourPakColors.goldAction,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 500.ms);
  }
}

// ══════════════════════════════════════════════════════════════
// CONTACT SECTION — Call + WhatsApp buttons
// ══════════════════════════════════════════════════════════════

class _ContactSection extends StatelessWidget {
  final Guide guide;

  const _ContactSection({required this.guide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: TourPakColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Contact card
          GlassCard.dark(
            borderRadius: 20,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Buttons row
                Row(
                  children: [
                    // Call — outline gold
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _makeCall(guide.phone),
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: TourPakColors.goldAction,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.call_rounded,
                                color: TourPakColors.goldAction,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Call',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: TourPakColors.goldAction,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // WhatsApp — filled green
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _openWhatsApp(guide.phone),
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFF25D366),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.chat_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'WhatsApp',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Booking note
                Text(
                  'In-app booking coming soon',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: TourPakColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 600.ms);
  }

  Future<void> _makeCall(String? phone) async {
    if (phone == null) return;
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp(String? phone) async {
    if (phone == null) return;
    // Strip leading + for wa.me format
    final number = phone.replaceAll('+', '');
    final uri = Uri.parse('https://wa.me/$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
