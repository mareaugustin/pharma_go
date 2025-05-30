import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:pharma_go/app/tabs_screen.dart';
import 'package:pharma_go/features/notifications/notifications_screen.dart';
import 'package:pharma_go/features/paiement/credit_card_screen.dart';
import 'package:pharma_go/features/categories/categories_screen.dart';
import 'package:pharma_go/features/auth/login_screen.dart';
import 'package:pharma_go/features/auth/register_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:pharma_go/core/providers/user_provider.dart';
import 'package:pharma_go/services/auth_service.dart';
import 'package:pharma_go/core/providers/order_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> _initializeApp() async {
    // You can add any additional initialization logic here if needed
    await Future.delayed(const Duration(milliseconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        Provider<OrderRepository>(create: (_) => OrderRepository()),
      ],
      child: MaterialApp(
        title: 'Pharma_go',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed( 
            seedColor: const Color(0xFF10B981), // Couleur principale de l'app
          ),
          useMaterial3: true, // Utiliser Material 3
        ),
        home: FutureBuilder(
          future: _initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, authSnapshot) {
                  if (authSnapshot.connectionState == ConnectionState.active) {
                    return authSnapshot.hasData ? const TabsScreen() : const LoginScreen();
                  }
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                },
              );
            }
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ); // SplashScreen remplacé par un indicateur de chargement
          },
        ),
        
        routes: {
          '/order': (context) => const TabsScreen(), // Exemple de route pour l'onglet des commandes
          '/notifications': (context) => const NotificationsScreen(),
          '/credit_card': (context) => const CreditCardScreen(),
          '/categories': (context) => CategoriesScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
        },
      ),
    );
  }
}