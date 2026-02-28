import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/guide.dart';

/// Fetches a single [Guide] by their ID (and parent destination ID).
///
/// The data layer (Supabase remote data source) will replace this stub
/// once the guides table is wired up.
final guideByIdProvider =
    FutureProvider.family<Guide, ({String destinationId, String guideId})>(
  (ref, params) async {
    // TODO: Replace with real data-layer call:
    // final repo = ref.read(guideRepositoryProvider);
    // return repo.getGuideById(params.destinationId, params.guideId);

    // ── Placeholder for UI development ───────────────────────
    await Future.delayed(const Duration(milliseconds: 500));
    return Guide(
      id: params.guideId,
      name: 'Ali Hassan',
      destinationId: params.destinationId,
      photoUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      bio: 'Born and raised in Hunza Valley, Ali has been guiding trekkers '
          'and tourists through the Karakoram mountains for over six years. '
          'He holds a certified mountaineering diploma, speaks fluent English '
          'and Urdu along with Burushaski, and specializes in multi-day treks '
          'to base camps and high-altitude lakes. His deep knowledge of '
          'local culture, history, and hidden trails makes every journey '
          'an authentic experience. Ali is known for his calm demeanor, '
          'attention to safety, and genuine hospitality that reflects '
          'the warmth of northern Pakistan.',
      phone: '+923001234567',
      isVerified: true,
      rating: 4.9,
      reviewCount: 127,
      languages: ['Urdu', 'English', 'Burushaski'],
      specialties: [
        'Trekking',
        'Mountaineering',
        'Cultural Tours',
        'Photography',
        'Camping',
      ],
      dailyRate: 2500,
      yearsExperience: 6,
    );
  },
);
