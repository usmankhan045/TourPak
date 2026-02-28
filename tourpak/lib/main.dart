import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/constants/supabase_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Hive at the app documents directory
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  // Register Hive adapters (add generated TypeAdapters here)
  // e.g. Hive.registerAdapter(MyModelAdapter());

  // Open Hive boxes
  await Future.wait([
    Hive.openBox(AppConstants.cacheBox),
    Hive.openBox(AppConstants.settingsBox),
    Hive.openBox(AppConstants.favoritesBox),
  ]);

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConstants.supabaseUrl,
    anonKey: SupabaseConstants.supabaseAnonKey,
  );

  // TODO: Initialize Firebase
  // await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: TourPakApp(),
    ),
  );
}

class TourPakApp extends ConsumerWidget {
  const TourPakApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'TourPak',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
