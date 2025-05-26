import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class MedicationCategories extends StatelessWidget {
  MedicationCategories({super.key});
  final List<Map<String, dynamic>> categories = [
    {
      'id': '1',
      'name': 'Douleur',
      'icon': MaterialIcons.medical_services,
      'color': Color(0xFF3B82F6),
      'bgColor': Color(0xFFDBEAFE),
    },
    {
      'id': '2',
      'name': 'Fièvre',
      'icon': MaterialCommunityIcons.thermometer,
      'color': Color(0xFFEF4444),
      'bgColor': Color(0xFFFEE2E2),
    },
    {
      'id': '3',
      'name': 'Cardiaque',
      'icon': FontAwesome.heart,
      'color': Color(0xFFEC4899),
      'bgColor': Color(0xFFFCE7F3),
    },
    {
      'id': '4',
      'name': 'Antibiotiques',
      'icon': MaterialCommunityIcons.bacteria,
      'color': Color(0xFF8B5CF6),
      'bgColor': Color(0xFFEDE9FE),
    },
    {
      'id': '5',
      'name': 'Neurologie',
      'icon': MaterialCommunityIcons.brain,
      'color': Color(0xFFF59E0B),
      'bgColor': Color(0xFFFEF3C7),
    },
    {
      'id': '6',
      'name': 'Ophtalmologie',
      'icon': MaterialCommunityIcons.eye,
      'color': Color(0xFF10B981),
      'bgColor': Color(0xFFDCFCE7),
    },
    {
      'id': '7',
      'name': 'Respiratoire',
      'icon': MaterialCommunityIcons.lungs,
      'color': Color(0xFF0EA5E9),
      'bgColor': Color(0xFFE0F2FE),
    },
    {
      'id': '8',
      'name': 'Dentaire',
      'icon': MaterialCommunityIcons.tooth,
      'color': Color(0xFF6366F1),
      'bgColor': Color(0xFFE0E7FF),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120, // Hauteur ajustable selon vos besoins
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 12),
            child: Material(
              color: category['bgColor'],
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // Action lorsqu'on clique sur une catégorie
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        category['icon'],
                        size: 24,
                        color: category['color'],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['name'],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1E293B),
                          // textAlign: TextAlign.center,
                        ),
                        textAlign: TextAlign.center, // Déplacé comme propriété du Text
                        maxLines: 2, // Limite à 2 lignes
                        overflow: TextOverflow.ellipsis, // Ajoute ... si le texte est trop long
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}