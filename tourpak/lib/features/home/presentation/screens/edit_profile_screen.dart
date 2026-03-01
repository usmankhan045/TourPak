import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/supabase_constants.dart';
import '../../../../core/theme/colors.dart';

// ══════════════════════════════════════════════════════════════
// EDIT PROFILE SCREEN
// ══════════════════════════════════════════════════════════════

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  String? _avatarUrl;
  Uint8List? _pickedBytes;
  bool _saving = false;

  User get _user => Supabase.instance.client.auth.currentUser!;

  @override
  void initState() {
    super.initState();
    final meta = _user.userMetadata;
    _nameController = TextEditingController(
      text: meta?['full_name'] as String? ?? '',
    );
    _avatarUrl = meta?['avatar_url'] as String?;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ── Pick photo from gallery ─────────────────────────────────

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() => _pickedBytes = bytes);
  }

  // ── Save changes to Supabase ────────────────────────────────

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      String? newUrl = _avatarUrl;

      // Upload new photo if a new one was picked
      if (_pickedBytes != null) {
        final path = 'avatars/${_user.id}.jpg';
        try {
          await Supabase.instance.client.storage
              .from(SupabaseConstants.profilePhotosBucket)
              .uploadBinary(
                path,
                _pickedBytes!,
                fileOptions: const FileOptions(
                  contentType: 'image/jpeg',
                  upsert: true,
                ),
              );
          newUrl = Supabase.instance.client.storage
              .from(SupabaseConstants.profilePhotosBucket)
              .getPublicUrl(path);
        } catch (uploadError) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Photo upload failed: $uploadError',
                    style: GoogleFonts.inter(color: Colors.white)),
                backgroundColor: TourPakColors.errorRed,
                duration: const Duration(seconds: 5),
              ),
            );
          }
          // Continue saving name even if photo upload fails
        }
      }

      // Update user metadata
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          data: {
            'full_name': _nameController.text.trim(),
            if (newUrl != null) 'avatar_url': newUrl,
          },
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated',
                style: GoogleFonts.inter(color: Colors.white)),
            backgroundColor: TourPakColors.forestLight,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e',
                style: GoogleFonts.inter(color: Colors.white)),
            backgroundColor: TourPakColors.errorRed,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ── Build ───────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    // Determine avatar image
    ImageProvider? bgImage;
    if (_pickedBytes != null) {
      bgImage = MemoryImage(_pickedBytes!);
    } else if (_avatarUrl != null) {
      bgImage = CachedNetworkImageProvider(_avatarUrl!);
    }

    final initials = _getInitials(_nameController.text);

    return Scaffold(
      backgroundColor: TourPakColors.obsidian,
      body: Column(
        children: [
          // ── App bar ──────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(8, topInset + 8, 8, 0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: TourPakColors.textPrimary),
                ),
                Text(
                  'Edit Profile',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: TourPakColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // ── Avatar picker ──────────────────────────────
          Center(
            child: GestureDetector(
              onTap: _pickPhoto,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: const Color(0xFFE8A838),
                    backgroundImage: bgImage,
                    child: bgImage == null
                        ? Text(
                            initials,
                            style: GoogleFonts.inter(
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: TourPakColors.goldAction,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: TourPakColors.obsidian, width: 3),
                      ),
                      child: const Icon(Icons.camera_alt_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _pickPhoto,
            child: Text(
              'Change Photo',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: TourPakColors.goldAction,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // ── Name field ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Full Name',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: TourPakColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: TourPakColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16,
                      color: TourPakColors.textSecondary
                          .withValues(alpha: 0.5),
                    ),
                    filled: true,
                    fillColor:
                        TourPakColors.forestGreen.withValues(alpha: 0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: TourPakColors.forestLight
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: TourPakColors.forestLight
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: TourPakColors.goldAction,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // ── Save button ────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TourPakColors.goldAction,
                  foregroundColor: TourPakColors.obsidian,
                  disabledBackgroundColor:
                      TourPakColors.goldAction.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _saving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: TourPakColors.obsidian,
                        ),
                      )
                    : Text(
                        'Save Changes',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
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
