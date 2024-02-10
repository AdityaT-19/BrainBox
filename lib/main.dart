import 'package:brainbox/bindings/splash_page_binding.dart';
import 'package:brainbox/routes/app_pages.dart';
import 'package:brainbox/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://qjaenniicvbaxoshppgo.supabase.co",
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFqYWVubmlpY3ZiYXhvc2hwcGdvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDY4ODUzMjQsImV4cCI6MjAyMjQ2MTMyNH0.Uvk4S8b5IedKm1Vq5pyBoM3oOMsGySl1nSFNTrrDOII',
  );

  await SplashPageBinding().dependencies();
  runApp(const MyApp());
}

const color = Color(0x00f907fc);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BrainBox',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: color,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: color,
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: AppRoutes.SPLASH,
      themeMode: ThemeMode.system,
      getPages: AppPages.routes,
    );
  }
}
