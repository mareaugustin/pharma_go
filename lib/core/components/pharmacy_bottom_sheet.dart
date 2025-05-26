import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PharmacyBottomSheet extends StatelessWidget {
  final Map<String, dynamic> pharmacy;
  final VoidCallback onClose;

  const PharmacyBottomSheet({
    super.key,
    required this.pharmacy,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(top: 8, bottom: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Détails de la pharmacie',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                IconButton(
                  icon: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Feather.x,
                      size: 20,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  onPressed: onClose,
                ),
              ],
            ),
          ),
          
          // Contenu scrollable
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Image de la pharmacie
                  CachedNetworkImage(
                    imageUrl: pharmacy['image'],
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  
                  // Contenu
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nom et note
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                pharmacy['name'],
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      FontAwesome.star,
                                      size: 16,
                                      color: Color(0xFFB45309),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      pharmacy['rating'].toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFFB45309),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Adresse
                        _buildInfoItem(
                          icon: MaterialCommunityIcons.map_marker,
                          text: pharmacy['address'],
                        ),
                        
                        // Téléphone
                        _buildInfoItem(
                          icon: MaterialCommunityIcons.phone,
                          text: pharmacy['phone'],
                        ),
                        
                        // Horaires
                        _buildInfoItem(
                          icon: MaterialCommunityIcons.clock,
                          text: pharmacy['hours'],
                          color: const Color(0xFF10B981),
                        ),
                        
                        // Bouton itinéraire
                        Container(
                          margin: const EdgeInsets.only(top: 4, bottom: 20),
                          child: TextButton.icon(
                            onPressed: () {
                              // Action itinéraire
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFFEFF6FF),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(
                              MaterialCommunityIcons.navigation,
                              size: 18,
                              color: Color(0xFF3B82F6),
                            ),
                            label: Text(
                              'Itinéraire',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                        ),
                        
                        // Diviseur
                        const Divider(
                          color: Color(0xFFE2E8F0),
                          thickness: 1,
                          height: 20,
                        ),
                        
                        // Médicaments disponibles
                        Text(
                          'Médicaments disponibles',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Liste des médicaments
                        _buildMedicationItem(
                          imageUrl:
                              'https://images.pexels.com/photos/159211/headache-pain-pills-medication-159211.jpeg',
                          name: 'Paracétamol 500mg',
                          price: '1 500 FCFA',
                        ),
                        _buildMedicationItem(
                          imageUrl:
                              'https://images.pexels.com/photos/593451/pexels-photo-593451.jpeg',
                          name: 'Ibuprofène 400mg',
                          price: '2 200 FCFA',
                        ),
                        
                        // Bouton Voir tout
                        TextButton(
                          onPressed: () {
                            // Action voir tout
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
                  ),
                ],
              ),
            ),
          ),
          
          // Boutons d'action
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: const Color(0xFFF1F5F9),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Bouton Appeler
                Expanded(
                  flex: 1,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Action appeler
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(
                      MaterialCommunityIcons.phone,
                      size: 20,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Appeler',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Bouton Réserver
                Expanded(
                  flex: 1,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Action réserver
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(
                      MaterialCommunityIcons.shopping,
                      size: 20,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Réserver',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String text,
    Color color = const Color(0xFF64748B),
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationItem({
    required String imageUrl,
    required String name,
    required String price,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Image du médicament
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Info médicament
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  price,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),
          
          // Bouton ajouter
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              MaterialCommunityIcons.shopping,
              size: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}