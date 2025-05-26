import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma_go/app/tabs_screen.dart';
import 'package:pharma_go/features/notifications/notifications_screen.dart';
import 'package:pharma_go/features/paiement/credit_card_screen.dart';
import 'package:pharma_go/features/categories/categories_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pharma_go',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10B981), // Couleur principale de l'app
        ),
        useMaterial3: true, // Utiliser Material 3
      ),
      home: const TabsScreen(),
      routes: {
        '/notifications': (context) => const NotificationsScreen(),
        '/credit_card': (context) => const CreditCardScreen(),
        '/categories': (context) => CategoriesScreen(),
      },
    );
  }
}