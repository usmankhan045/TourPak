import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourpak/core/theme/colors.dart';

// ── Enum ────────────────────────────────────────────────────

enum RoadStatus {
  green,
  yellow,
  red;

  Color get color {
    switch (this) {
      case RoadStatus.green:
        return const Color(0xFF22C55E);
      case RoadStatus.yellow:
        return const Color(0xFFF59E0B);
      case RoadStatus.red:
        return const Color(0xFFEF4444);
    }
  }

  String get label {
    switch (this) {
      case RoadStatus.green:
        return 'Road Open';
      case RoadStatus.yellow:
        return 'Use Caution';
      case RoadStatus.red:
        return 'Road Closed';
    }
  }

  static RoadStatus fromString(String s) {
    switch (s.toLowerCase().trim()) {
      case 'green':
        return RoadStatus.green;
      case 'yellow':
        return RoadStatus.yellow;
      case 'red':
        return RoadStatus.red;
      default:
        return RoadStatus.green;
    }
  }
}

// ── Widget ──────────────────────────────────────────────────

/// Full-width road status pill badge with a pulsing indicator dot.
class RoadStatusBadge extends StatelessWidget {
  final String status;
  final String note;
  final String updatedAt;

  const RoadStatusBadge({
    super.key,
    required this.status,
    required this.note,
    this.updatedAt = '',
  });

  /// Convenience factory that parses the status string.
  factory RoadStatusBadge.fromString(
    String status, {
    Key? key,
    required String note,
    String updatedAt = '',
  }) {
    return RoadStatusBadge(
      key: key,
      status: status,
      note: note,
      updatedAt: updatedAt,
    );
  }

  @override
  Widget build(BuildContext context) {
    final roadStatus = RoadStatus.fromString(status);
    final statusColor = roadStatus.color;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // ── Pulsing dot ───────────────────────────────────
          _PulsingDot(color: statusColor),
          const SizedBox(width: 10),

          // ── Status text ───────────────────────────────────
          Expanded(
            child: Text(
              note.isEmpty ? roadStatus.label : note,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: TourPakColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // ── Updated timestamp ─────────────────────────────
          if (updatedAt.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              updatedAt,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: TourPakColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Pulsing Dot ─────────────────────────────────────────────

class _PulsingDot extends StatelessWidget {
  final Color color;

  const _PulsingDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.2, 1.2),
          duration: 1500.ms,
          curve: Curves.easeInOut,
        )
        .then()
        .scale(
          begin: const Offset(1.2, 1.2),
          end: const Offset(0.8, 0.8),
          duration: 1500.ms,
          curve: Curves.easeInOut,
        )
        .fadeIn(begin: 0.6, duration: 1500.ms, curve: Curves.easeInOut)
        .then()
        .fade(begin: 1.0, end: 0.6, duration: 1500.ms, curve: Curves.easeInOut);
  }
}
