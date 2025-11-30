import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_s0mango/screens/auth/splashscreen.dart';
import 'package:kasir_s0mango/screens/dashboard_screen.dart';
import 'package:kasir_s0mango/screens/product/product_screen.dart';
import 'package:kasir_s0mango/screens/stock/stock_screen.dart';
import 'package:kasir_s0mango/screens/user/user_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await dotenv.load(fileName: ".env");
  await SupabaseConfig.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primaryTextTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF9FDF2),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7C9D43)),
      ),
      home: Supabase.instance.client.auth.currentUser != null
          ? const StockScreen()
          : const SplashScreen(),
    );
  }
}
