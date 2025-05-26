import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pharma_go/core/components/featured_pharmacies.dart';
import 'package:pharma_go/core/components/medication_categories.dart';
import 'package:pharma_go/core/components/headers/header.dart';

import 'package:pharma_go/app/tabs_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              Header(), // Ton composant Header converti
              
              // Hero Section
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Pharma-go',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFE2F8F0),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Trouvez vos médicaments facilement',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Localisez, comparez les prix et réservez vos médicaments en quelques clics',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  // Action de recherche
                                  final tabsScreenState = context.findAncestorStateOfType<TabsScreenState>();
                              // ignore: invalid_use_of_protected_member
                                  tabsScreenState?.setState(() {
                                    tabsScreenState.currentIndex = 1; // Index de la recherche
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Feather.search,
                                        size: 20,
                                        color: Color(0xFF10B981),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Que voulez-vous aujourd\'hui ?',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Features Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFeatureCard(
                      icon: Feather.map_pin,
                      iconColor: const Color(0xFF3B82F6),
                      title: 'Localiser',
                      description: 'Trouvez les pharmacies proches de vous',
                    ),
                    _buildFeatureCard(
                      icon: Feather.trending_up,
                      iconColor: const Color(0xFFF59E0B),
                      title: 'Comparer',
                      description: 'Comparez les prix des médicaments',
                    ),
                    _buildFeatureCard(
                      icon: Feather.package,
                      iconColor: const Color(0xFF10B981),
                      title: 'Livraison',
                      description: 'Faites-vous livrer à domicile',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Catégories Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Catégories',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Action "Voir tout"
                            Navigator.pushNamed(context, '/categories');
                          },
                          child: Text(
                            'Voir tout',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    MedicationCategories(), // Ton composant converti
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Pharmacies Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pharmacies à proximité',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Action "Voir carte"
                            final tabsScreenState = context.findAncestorStateOfType<TabsScreenState>();
                              // ignore: invalid_use_of_protected_member
                              tabsScreenState?.setState(() {
                                tabsScreenState.currentIndex = 2;
                              });
                          },
                          child: Text(
                            'Voir carte',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    FeaturedPharmacies(), // Ton composant converti
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Trust Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 2),
                      blurRadius: 3,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Feather.shield,
                      size: 32,
                      color: Color(0xFF10B981),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Votre santé, notre priorité',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Toutes les pharmacies partenaires sont vérifiées et certifiées pour vous garantir un service de qualité.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF64748B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: iconColor),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}