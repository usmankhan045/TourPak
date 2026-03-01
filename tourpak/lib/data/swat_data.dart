import '../models/guide_model.dart';
import '../models/package_model.dart';
import '../models/restaurant_model.dart';
import '../models/spot_model.dart';

// ══════════════════════════════════════════════════════════════
// IMAGE URLS
// ══════════════════════════════════════════════════════════════

const _imgValley =
    'https://images.unsplash.com/photo-1586500036706-41963de24d8b?w=800&q=80';
const _imgLake =
    'https://images.unsplash.com/photo-1566837945700-30057527ade0?w=800&q=80';
const _imgMountain =
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80';
const _imgHistorical =
    'https://images.unsplash.com/photo-1548013146-72479768bada?w=800&q=80';
const _imgDefault =
    'https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f?w=800&q=80';

// ══════════════════════════════════════════════════════════════
// SPOTS (20)
// ══════════════════════════════════════════════════════════════

const swatSpots = <SpotModel>[
  SpotModel(
    id: 'swat_spot_01',
    destinationId: 'swat',
    name: 'Kalam Valley',
    category: 'Valley',
    description:
        'The crown jewel of Swat, Kalam is a lush green valley surrounded by '
        'snow-capped peaks, dense forests, and the gushing Swat River. It serves '
        'as the gateway to Mahodand Lake and Ushu Forest.',
    coverImageUrl: _imgValley,
    latitude: 35.4755,
    longitude: 72.5807,
    distanceFromCity: 99,
    elevation: 2000,
    bestTimeToVisit: 'March – October',
    activities: ['Hiking', 'Photography', 'Camping', 'Fishing'],
    isFeatured: true,
  ),
  SpotModel(
    id: 'swat_spot_02',
    destinationId: 'swat',
    name: 'Mahodand Lake',
    category: 'Lake',
    description:
        'A crystal-clear glacial lake at 2,865 m surrounded by alpine meadows '
        'and snow-covered mountains. Accessible via jeep track from Kalam, '
        'it is one of the most beautiful lakes in Pakistan.',
    coverImageUrl: _imgLake,
    latitude: 35.7130,
    longitude: 72.6410,
    distanceFromCity: 115,
    elevation: 2865,
    bestTimeToVisit: 'June – September',
    activities: ['Fishing', 'Photography', 'Camping', 'Horseback Riding'],
    isFeatured: true,
  ),
  SpotModel(
    id: 'swat_spot_03',
    destinationId: 'swat',
    name: 'Ushu Forest',
    category: 'Forest',
    description:
        'One of the thickest juniper and pine forests in Asia, Ushu Forest '
        'near Kalam offers peaceful walking trails under a towering canopy '
        'with views of the Ushu River below.',
    coverImageUrl: _imgDefault,
    latitude: 35.5020,
    longitude: 72.6030,
    distanceFromCity: 105,
    elevation: 2100,
    bestTimeToVisit: 'March – November',
    activities: ['Hiking', 'Nature Walks', 'Bird Watching', 'Photography'],
  ),
  SpotModel(
    id: 'swat_spot_04',
    destinationId: 'swat',
    name: 'Malam Jabba Ski Resort',
    category: 'Ski Resort',
    description:
        'Pakistan\'s premier ski resort at 2,804 m offering skiing, '
        'snowboarding, zip-lining, and a chair lift. In summer it transforms '
        'into a scenic meadow with adventure activities.',
    coverImageUrl: _imgMountain,
    latitude: 34.7990,
    longitude: 72.5620,
    distanceFromCity: 40,
    elevation: 2804,
    bestTimeToVisit: 'December – March (ski) · June – September (summer)',
    activities: ['Skiing', 'Snowboarding', 'Zip-lining', 'Chair Lift'],
    isFeatured: true,
  ),
  SpotModel(
    id: 'swat_spot_05',
    destinationId: 'swat',
    name: 'Fizagat Park',
    category: 'Park',
    description:
        'A family-friendly recreational park along the Swat River on the '
        'outskirts of Mingora. Popular for picnics, boating, and evening walks '
        'with lush greenery and well-maintained grounds.',
    coverImageUrl: _imgDefault,
    latitude: 34.7560,
    longitude: 72.3280,
    distanceFromCity: 2,
    elevation: 1000,
    bestTimeToVisit: 'Year-round',
    activities: ['Picnicking', 'Boating', 'Walking', 'Photography'],
  ),
  SpotModel(
    id: 'swat_spot_06',
    destinationId: 'swat',
    name: 'Bahrain',
    category: 'Valley',
    description:
        'A scenic hill station at the confluence of the Swat and Daral rivers. '
        'Bahrain is a popular stopover on the way to Kalam, known for its emerald '
        'rivers, trout fishing, and riverside bazaars.',
    coverImageUrl: _imgValley,
    latitude: 35.2090,
    longitude: 72.5560,
    distanceFromCity: 60,
    elevation: 1400,
    bestTimeToVisit: 'March – October',
    activities: ['Sightseeing', 'Rafting', 'Shopping', 'Photography'],
    isFeatured: true,
  ),
  SpotModel(
    id: 'swat_spot_07',
    destinationId: 'swat',
    name: 'Madyan',
    category: 'Valley',
    description:
        'A charming riverside town nestled between terraced hills. Madyan is '
        'famous for its natural hot springs, handicraft markets, and traditional '
        'Swati architecture along narrow bazaar lanes.',
    coverImageUrl: _imgValley,
    latitude: 35.1410,
    longitude: 72.5380,
    distanceFromCity: 50,
    elevation: 1321,
    bestTimeToVisit: 'March – October',
    activities: ['Shopping', 'Hot Springs', 'Sightseeing', 'Photography'],
  ),
  SpotModel(
    id: 'swat_spot_08',
    destinationId: 'swat',
    name: 'Swat Museum',
    category: 'Historical',
    description:
        'Houses an impressive collection of Gandhara-era Buddhist sculptures, '
        'coins, weapons, and ethnographic items spanning over 2,000 years of '
        'Swat Valley\'s rich cultural history.',
    coverImageUrl: _imgHistorical,
    latitude: 34.7470,
    longitude: 72.3370,
    distanceFromCity: 1,
    elevation: 980,
    bestTimeToVisit: 'Year-round',
    activities: ['Museum Tour', 'Photography', 'History'],
  ),
  SpotModel(
    id: 'swat_spot_09',
    destinationId: 'swat',
    name: 'Jahanabad Buddha Rock',
    category: 'Historical',
    description:
        'A 7th-century rock carving of a seated Buddha, one of the largest in '
        'South Asia. This Gandhara-period relic stands tall on a cliff face and '
        'is a testament to Swat\'s Buddhist heritage.',
    coverImageUrl: _imgHistorical,
    latitude: 34.8250,
    longitude: 72.3150,
    distanceFromCity: 10,
    elevation: 1050,
    bestTimeToVisit: 'Year-round',
    activities: ['Sightseeing', 'History', 'Photography'],
  ),
  SpotModel(
    id: 'swat_spot_10',
    destinationId: 'swat',
    name: 'Kandol Lake',
    category: 'Lake',
    description:
        'A high-altitude glacial lake at 3,500 m accessible via a challenging '
        'trek from Utror Valley. The turquoise waters ringed by rocky peaks '
        'reward trekkers with one of Swat\'s most spectacular views.',
    coverImageUrl: _imgLake,
    latitude: 35.4570,
    longitude: 72.6500,
    distanceFromCity: 110,
    elevation: 3500,
    bestTimeToVisit: 'June – September',
    activities: ['Trekking', 'Camping', 'Photography'],
    isFeatured: true,
  ),
  SpotModel(
    id: 'swat_spot_11',
    destinationId: 'swat',
    name: 'Kundol Lake',
    category: 'Lake',
    description:
        'A pristine turquoise lake at 3,200 m surrounded by alpine meadows '
        'and towering peaks. The trek from Utror takes about 4 hours through '
        'dense forests and rocky terrain.',
    coverImageUrl: _imgLake,
    latitude: 35.3920,
    longitude: 72.5800,
    distanceFromCity: 95,
    elevation: 3200,
    bestTimeToVisit: 'June – September',
    activities: ['Trekking', 'Camping', 'Fishing', 'Photography'],
  ),
  SpotModel(
    id: 'swat_spot_12',
    destinationId: 'swat',
    name: 'Jarogo Waterfall',
    category: 'Waterfall',
    description:
        'A spectacular multi-tiered waterfall cascading down moss-covered rocks '
        'in a dense forest setting. The short hike to the falls passes through '
        'beautiful pine forests near Bahrain.',
    coverImageUrl: _imgDefault,
    latitude: 35.3450,
    longitude: 72.5650,
    distanceFromCity: 80,
    elevation: 1800,
    bestTimeToVisit: 'April – October',
    activities: ['Hiking', 'Photography', 'Swimming'],
  ),
  SpotModel(
    id: 'swat_spot_13',
    destinationId: 'swat',
    name: 'White Palace (Marghazar)',
    category: 'Historical',
    description:
        'A grand Italian-marble palace built in 1941 as the summer residence of '
        'the Wali of Swat. Set against a mountain backdrop with terraced gardens, '
        'it offers panoramic views of the Swat Valley.',
    coverImageUrl: _imgHistorical,
    latitude: 34.8170,
    longitude: 72.3220,
    distanceFromCity: 13,
    elevation: 1250,
    bestTimeToVisit: 'Year-round',
    activities: ['Sightseeing', 'History', 'Photography'],
    isFeatured: true,
  ),
  SpotModel(
    id: 'swat_spot_14',
    destinationId: 'swat',
    name: 'Shingardar Stupa',
    category: 'Historical',
    description:
        'An ancient Buddhist stupa dating back to the 2nd century CE, perched '
        'on a hillock overlooking paddy fields. One of the best-preserved '
        'stupas in the Gandhara region.',
    coverImageUrl: _imgHistorical,
    latitude: 34.7620,
    longitude: 72.3680,
    distanceFromCity: 5,
    elevation: 1020,
    bestTimeToVisit: 'Year-round',
    activities: ['History', 'Archaeology', 'Photography'],
  ),
  SpotModel(
    id: 'swat_spot_15',
    destinationId: 'swat',
    name: 'Butkara Buddhist Ruins',
    category: 'Historical',
    description:
        'Extensive archaeological remains of a major Buddhist monastery '
        'and stupa complex dating from the 3rd century BCE to the 10th century '
        'CE. Excavated by Italian archaeologists in the 1950s.',
    coverImageUrl: _imgHistorical,
    latitude: 34.7430,
    longitude: 72.3400,
    distanceFromCity: 2,
    elevation: 970,
    bestTimeToVisit: 'Year-round',
    activities: ['History', 'Archaeology', 'Photography'],
  ),
  SpotModel(
    id: 'swat_spot_16',
    destinationId: 'swat',
    name: 'Gabin Jabba',
    category: 'Meadow',
    description:
        'A picturesque alpine meadow near Malam Jabba, covered with wild '
        'flowers in summer and snow in winter. An ideal spot for camping and '
        'a peaceful escape from the city.',
    coverImageUrl: _imgMountain,
    latitude: 34.8250,
    longitude: 72.5300,
    distanceFromCity: 35,
    elevation: 2500,
    bestTimeToVisit: 'May – October',
    activities: ['Hiking', 'Camping', 'Picnicking', 'Photography'],
  ),
  SpotModel(
    id: 'swat_spot_17',
    destinationId: 'swat',
    name: 'Daral Lake',
    category: 'Lake',
    description:
        'A remote and pristine lake at 2,850 m accessible via a trek from '
        'Bahrain. The trail winds through dense forests along the Daral '
        'stream, and the lake is surrounded by snow peaks.',
    coverImageUrl: _imgLake,
    latitude: 35.2500,
    longitude: 72.6100,
    distanceFromCity: 75,
    elevation: 2850,
    bestTimeToVisit: 'June – September',
    activities: ['Trekking', 'Camping', 'Photography'],
  ),
  SpotModel(
    id: 'swat_spot_18',
    destinationId: 'swat',
    name: 'Saidu Sharif',
    category: 'Historical',
    description:
        'The former capital of the Princely State of Swat, home to the royal '
        'palace, Saidu Baba shrine, and the Swat Museum. A cultural hub with '
        'deep historical significance.',
    coverImageUrl: _imgHistorical,
    latitude: 34.7460,
    longitude: 72.3380,
    distanceFromCity: 1,
    elevation: 975,
    bestTimeToVisit: 'Year-round',
    activities: ['History', 'Museum', 'Sightseeing'],
  ),
  SpotModel(
    id: 'swat_spot_19',
    destinationId: 'swat',
    name: 'Shingrai Waterfall',
    category: 'Waterfall',
    description:
        'A hidden gem waterfall near Madyan, surrounded by lush vegetation. '
        'The falls drop into a natural pool, making it a popular spot for '
        'locals during summer months.',
    coverImageUrl: _imgDefault,
    latitude: 35.1300,
    longitude: 72.5100,
    distanceFromCity: 45,
    elevation: 1500,
    bestTimeToVisit: 'April – October',
    activities: ['Hiking', 'Photography', 'Swimming'],
  ),
  SpotModel(
    id: 'swat_spot_20',
    destinationId: 'swat',
    name: 'Mingora City',
    category: 'Urban',
    description:
        'The largest city and commercial hub of Swat Valley. Known for its '
        'famous emerald mines nearby, vibrant bazaars, and as the base camp '
        'for all Swat Valley excursions.',
    coverImageUrl: _imgDefault,
    latitude: 34.7717,
    longitude: 72.3600,
    distanceFromCity: 0,
    elevation: 984,
    bestTimeToVisit: 'Year-round',
    activities: ['Shopping', 'Food', 'Culture'],
  ),
];

// ══════════════════════════════════════════════════════════════
// RESTAURANTS (5)
// ══════════════════════════════════════════════════════════════

const swatRestaurants = <RestaurantModel>[
  RestaurantModel(
    id: 'swat_rest_01',
    destinationId: 'swat',
    name: 'Kalam Trout Farm Restaurant',
    cuisineType: 'Trout',
    priceRange: '₨₨',
    rating: 4.5,
    reviewCount: 128,
    address: 'Main Kalam Road, Kalam',
    areaName: 'Kalam',
    phone: '+923001234567',
    latitude: 35.4920,
    longitude: 72.5780,
    coverImageUrl: _imgDefault,
  ),
  RestaurantModel(
    id: 'swat_rest_02',
    destinationId: 'swat',
    name: 'Mingora Desi Dhaba',
    cuisineType: 'Pakistani',
    priceRange: '₨',
    rating: 4.2,
    reviewCount: 95,
    address: 'GT Road, Mingora',
    areaName: 'Mingora',
    phone: '+923001234568',
    latitude: 34.7710,
    longitude: 72.3580,
    coverImageUrl: _imgDefault,
  ),
  RestaurantModel(
    id: 'swat_rest_03',
    destinationId: 'swat',
    name: 'Bahrain River Cafe',
    cuisineType: 'Cafe',
    priceRange: '₨₨',
    rating: 4.3,
    reviewCount: 67,
    address: 'Riverside Road, Bahrain',
    areaName: 'Bahrain',
    phone: '+923001234569',
    latitude: 35.1940,
    longitude: 72.5570,
    coverImageUrl: _imgDefault,
  ),
  RestaurantModel(
    id: 'swat_rest_04',
    destinationId: 'swat',
    name: 'Malam Jabba Restaurant',
    cuisineType: 'Pakistani',
    priceRange: '₨₨₨',
    rating: 4.0,
    reviewCount: 42,
    address: 'Malam Jabba Ski Resort, Malam Jabba',
    areaName: 'Malam Jabba',
    phone: '+923001234570',
    latitude: 34.8010,
    longitude: 72.5510,
    coverImageUrl: _imgDefault,
    isSponsored: true,
  ),
  RestaurantModel(
    id: 'swat_rest_05',
    destinationId: 'swat',
    name: 'Swat Continental',
    cuisineType: 'Continental',
    priceRange: '₨₨₨',
    rating: 4.4,
    reviewCount: 83,
    address: 'Saidu Sharif Road, Mingora',
    areaName: 'Mingora',
    phone: '+923001234571',
    latitude: 34.7730,
    longitude: 72.3620,
    coverImageUrl: _imgDefault,
    isSponsored: true,
  ),
];

// ══════════════════════════════════════════════════════════════
// GUIDES (4)
// ══════════════════════════════════════════════════════════════

const swatGuides = <GuideModel>[
  GuideModel(
    id: 'swat_guide_01',
    destinationId: 'swat',
    name: 'Zubair Khan',
    photoUrl: _imgDefault,
    languages: ['Pashto', 'Urdu', 'English'],
    speciality: 'Trekking & Adventure',
    pricePerDay: 3500,
    rating: 4.9,
    reviewCount: 87,
    isVerified: true,
    yearsExperience: 8,
    about:
        'Certified mountain guide with 8 years of experience leading treks '
        'to Kandol Lake, Mahodand, and other high-altitude destinations in '
        'Swat and Kalam valleys.',
    phone: '+923001234572',
    whatsapp: '+923001234572',
  ),
  GuideModel(
    id: 'swat_guide_02',
    destinationId: 'swat',
    name: 'Faisal Ahmed',
    photoUrl: _imgDefault,
    languages: ['Urdu', 'English'],
    speciality: 'Historical & Buddhist Sites',
    pricePerDay: 2500,
    rating: 4.7,
    reviewCount: 54,
    isVerified: true,
    yearsExperience: 5,
    about:
        'History enthusiast and licensed tour guide specialising in Gandhara '
        'Buddhist sites across Swat. Offers immersive storytelling tours of '
        'Butkara, Shingardar Stupa, and Jahanabad Buddha.',
    phone: '+923001234573',
    whatsapp: '+923001234573',
  ),
  GuideModel(
    id: 'swat_guide_03',
    destinationId: 'swat',
    name: 'Hamza Gul',
    photoUrl: _imgDefault,
    languages: ['Pashto', 'Urdu'],
    speciality: 'Photography Tours',
    pricePerDay: 2000,
    rating: 4.5,
    reviewCount: 31,
    isVerified: false,
    yearsExperience: 3,
    about:
        'Passionate photographer and local guide who knows the best sunrise '
        'and sunset points across Swat Valley. Ideal for photography-focused '
        'trips to Kalam, Bahrain, and Mahodand.',
    phone: '+923001234574',
    whatsapp: '+923001234574',
  ),
  GuideModel(
    id: 'swat_guide_04',
    destinationId: 'swat',
    name: 'Amir Khan',
    photoUrl: _imgDefault,
    languages: ['Pashto', 'Urdu', 'English'],
    speciality: 'Kalam Valley Expert',
    pricePerDay: 4000,
    rating: 5.0,
    reviewCount: 142,
    isVerified: true,
    yearsExperience: 12,
    about:
        'Born and raised in Kalam with unrivalled knowledge of every trail, '
        'village, and hidden waterfall in the upper Swat region. Top-rated '
        'guide on TourPak with 142 five-star reviews.',
    phone: '+923001234575',
    whatsapp: '+923001234575',
  ),
];

// ══════════════════════════════════════════════════════════════
// PACKAGES (3)
// ══════════════════════════════════════════════════════════════

const swatPackages = <PackageModel>[
  PackageModel(
    id: 'swat_pkg_01',
    destinationId: 'swat',
    title: '3-Day Swat Highlights',
    operatorName: 'Pakistan Wander Tours',
    operatorVerified: true,
    coverImageUrl: _imgValley,
    durationDays: 3,
    durationNights: 2,
    startingCity: 'Lahore',
    pricePerPerson: 12500,
    packageType: 'family',
    inclusions: [
      'Transport (AC Coaster)',
      'Hotel (2 nights)',
      'Breakfast & Dinner',
      'Guided Sightseeing',
      'Malam Jabba Entry',
    ],
    exclusions: [
      'Lunch',
      'Personal expenses',
      'Adventure activities',
      'Travel insurance',
    ],
    pickupPoint: 'Lahore (Thokar Niaz Baig)',
    itinerary: [
      'Day 1: Lahore → Mingora – Swat Museum – Fizagat Park',
      'Day 2: Mingora → Malam Jabba – Bahrain – Madyan',
      'Day 3: Madyan → White Palace – Mingora → Lahore',
    ],
    rating: 4.6,
    maxGroupSize: 20,
  ),
  PackageModel(
    id: 'swat_pkg_02',
    destinationId: 'swat',
    title: '5-Day Complete Swat',
    operatorName: 'KPK Adventures',
    operatorVerified: true,
    coverImageUrl: _imgLake,
    durationDays: 5,
    durationNights: 4,
    startingCity: 'Islamabad',
    pricePerPerson: 22000,
    packageType: 'adventure',
    inclusions: [
      'Transport (4x4 Jeep)',
      'Hotel & Camping (4 nights)',
      'All Meals',
      'Professional Guide',
      'Camping Gear',
      'Malam Jabba + Kalam Entry',
    ],
    exclusions: [
      'Flights',
      'Personal gear',
      'Tips',
      'Travel insurance',
    ],
    pickupPoint: 'Islamabad (Faisal Mosque)',
    itinerary: [
      'Day 1: Islamabad → Mingora – Swat Museum – Saidu Sharif',
      'Day 2: Mingora → Malam Jabba – Gabin Jabba – return Mingora',
      'Day 3: Mingora → Bahrain → Kalam Valley – overnight Kalam',
      'Day 4: Kalam → Mahodand Lake → Ushu Forest – camp at Kalam',
      'Day 5: Kalam → Jarogo Waterfall → Madyan → Islamabad',
    ],
    rating: 4.8,
    maxGroupSize: 12,
  ),
  PackageModel(
    id: 'swat_pkg_03',
    destinationId: 'swat',
    title: 'Weekend Kalam Escape',
    operatorName: 'Swat Travel Club',
    operatorVerified: false,
    coverImageUrl: _imgMountain,
    durationDays: 2,
    durationNights: 1,
    startingCity: 'Peshawar',
    pricePerPerson: 8000,
    packageType: 'family',
    inclusions: [
      'Transport (Hiace Van)',
      'Hotel (1 night)',
      'Dinner & Breakfast',
      'Kalam Sightseeing',
    ],
    exclusions: [
      'Lunch',
      'Personal expenses',
      'Jeep rides to lakes',
      'Travel insurance',
    ],
    pickupPoint: 'Peshawar (University Town)',
    itinerary: [
      'Day 1: Peshawar → Bahrain → Kalam Valley – overnight Kalam',
      'Day 2: Kalam → Ushu Forest → Madyan → Peshawar',
    ],
    rating: 4.3,
    maxGroupSize: 30,
  ),
];
