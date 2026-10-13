import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/app_theme.dart';
import 'data/demo_data.dart';
import 'screens/splash_screen.dart';
import 'services/radio_player_controller.dart';
import 'services/supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'edu.sunway.sun4u.audio',
    androidNotificationChannelName: 'SUN4U Radio Playback',
    androidNotificationOngoing: true,
  );

  if (SupabaseConfig.isConfigured) {
    try {
      await Supabase.initialize(
        url: SupabaseConfig.projectUrl,
        anonKey: SupabaseConfig.clientKey,
      );
      if (kDebugMode) {
        debugPrint(
          'SUN4U Supabase initialized using '
          '${SupabaseConfig.usesBuildTimeOverride ? 'build-time configuration' : 'project fallback configuration'}.',
        );
      }
      await loadSun4UDataFromSupabase();
    } on Object catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('SUN4U Supabase initialization failed. Using local demo data: $error');
        debugPrint('$stackTrace');
      }
    }
  } else if (kDebugMode) {
    debugPrint('SUN4U Supabase configuration is invalid. Using local demo data.');
  }

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const Sun4URadioApp(),
    ),
  );
}

class Sun4URadioApp extends StatefulWidget {
  const Sun4URadioApp({super.key});

  @override
  State<Sun4URadioApp> createState() => _Sun4URadioAppState();
}

class _Sun4URadioAppState extends State<Sun4URadioApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    RadioPlayerController.instance.handleLifecycle(state);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SUN4U Radio',
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: AppTheme.dark(),
      home: const SplashScreen(),
    );
  }
}
