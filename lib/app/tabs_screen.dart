import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart'; // Pour les mêmes icônes Feather
import 'package:pharma_go/features/home/home_screen.dart';
import 'package:pharma_go/features/search/search_screen.dart';
import 'package:pharma_go/features/map/map_screen.dart';
import 'package:pharma_go/features/orders/orders_screen.dart';
import 'package:pharma_go/features/profile/profile_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => TabsScreenState();
}

class TabsScreenState extends State<TabsScreen> {
  int currentIndex = 0;

  // Liste de vos écrans (à remplacer par vos vrais écrans)
  final List<Widget> screens = [
    HomeScreen(),      // index
    SearchScreen(),    // search
    MapScreen(),       // map
    OrdersScreen(),    // orders
    ProfileScreen(),   // profile
  ];

  @override
  Widget build(BuildContext context) {
    // final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              offset: Offset(0, -2),
              blurRadius: 3,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF10B981),
          unselectedItemColor: Color(0xFF64748B),
          selectedLabelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 10,
            height: 1.6, // Pour simuler le marginBottom
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 10,
            height: 1.6,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Feather.home, size: 24),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Feather.search, size: 24),
              label: 'Recherche',
            ),
            BottomNavigationBarItem(
              icon: Icon(Feather.map_pin, size: 24),
              label: 'Carte',
            ),
            BottomNavigationBarItem(
              icon: Icon(Feather.shopping_bag, size: 24),
              label: 'Commandes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Feather.user, size: 24),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
