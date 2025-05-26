import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FeaturedPharmacies extends StatelessWidget {
  FeaturedPharmacies({super.key});
  final List<Map<String, dynamic>> pharmacies = [
    {
      'id': '1',
      'name': 'Pharmacie Naba Koom',
      'distance': '1.2 km',
      'hours': 'Ouvert · Ferme à 20:00',
      'isOpen': true,
      'rating': 4.7,
      'image':
          'https://images.pexels.com/photos/3683082/pexels-photo-3683082.jpeg',
    },
    {
      'id': '2',
      'name': 'Pharmacie du Centre',
      'distance': '2.5 km',
      'hours': 'Ouvert · Ferme à 22:00',
      'isOpen': true,
      'rating': 4.5,
      'image':
          'https://images.pexels.com/photos/8942581/pexels-photo-8942581.jpeg',
    },
    {
      'id': '3',
      'name': 'Pharmacie Saint-Jean',
      'distance': '3.1 km',
      'hours': 'Fermé · Ouvre à 08:00',
      'isOpen': false,
      'rating': 4.2,
      'image':
          'https://images.pexels.com/photos/5699514/pexels-photo-5699514.jpeg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260, // Hauteur ajustable selon vos besoins
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        itemCount: pharmacies.length,
        itemBuilder: (context, index) {
          final pharmacy = pharmacies[index];
          return Container(
            width: 190,
            margin: const EdgeInsets.only(right: 12),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // Action lorsqu'on clique sur une pharmacie
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image de la pharmacie
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12)),
                      child: CachedNetworkImage(
                        imageUrl: pharmacy['image'],
                        height: 98,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    // Contenu texte
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Note
                          Row(
                            children: [
                              const Icon(
                                FontAwesome.star,
                                size: 12,
                                color: Color(0xFFF59E0B),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                pharmacy['rating'].toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // Nom
                          Text(
                            pharmacy['name'],
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Distance
                          Row(
                            children: [
                              const Icon(
                                MaterialCommunityIcons.map_marker,
                                size: 12,
                                color: Color(0xFF64748B),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                pharmacy['distance'],
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // Horaires
                          Row(
                            children: [
                              Icon(
                                Ionicons.time,
                                size: 12,
                                color: pharmacy['isOpen']
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFEF4444),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                pharmacy['hours'],
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: pharmacy['isOpen']
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFEF4444),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}