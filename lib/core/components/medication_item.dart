import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pharma_go/features/orders/order_form_screen.dart';
import 'package:pharma_go/app/tabs_screen.dart';

class MedicationItem extends StatelessWidget {
  final Map<String, dynamic> medication;

  const MedicationItem({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Action lorsqu'on clique sur le médicament
           _showOrderConfirmationDialog(context);
        },
        child: Row(
          children: [
            // Image du médicament
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: medication['image'],
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),

            // Informations sur le médicament
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom du médicament
                    Text(
                      medication['name'],
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Type de médicament
                    Text(
                      medication['type'],
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Prix et disponibilité
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Section prix
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'À partir de',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            Text(
                              '1 500 FCFA',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                        // Section disponibilité
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Disponible',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Commander ce médicament ?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Voulez-vous commander ${medication['name']} ?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () async {
            Navigator.pop(context); // Ferme la boîte de dialogue
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderFormScreen(medication: medication),
              ),
            );
            
            if (result != null && result is Map<String, dynamic>) {
              // Trouver le TabsScreenState pour changer d'onglet
              // ignore: use_build_context_synchronously
              final tabsScreenState = context.findAncestorStateOfType<TabsScreenState>();
              // ignore: invalid_use_of_protected_member
                tabsScreenState?.setState(() {
                  tabsScreenState.currentIndex = 3; // Index de la commande
                });
            }
          },
          child: Text('Oui'),
        ),
      ],
    ),
  );
  }
}