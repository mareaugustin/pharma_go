import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchHeader extends StatelessWidget {
  // const SearchHeader({super.key});
  final Function() onFilterPressed;
  
  const SearchHeader({super.key, required this.onFilterPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFF1F5F9),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Section gauche - Bouton retour
          const Expanded(
            flex: 1,
            child: SizedBox(), // Espace vide à la place du bouton retour
          ),

          // Section centrale - Titre
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                'Recherche',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
          ),

          // Section droite - Bouton filtre
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: onFilterPressed,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Feather.sliders,
                    size: 20,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // Variables pour les filtres
  String _selectedCategory = 'Tous';
  double _priceRange = 5000;
  bool _availableOnly = false;
  bool _deliveryAvailable = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filtrer',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(height: 24),

          // Catégories
          Text(
            'Catégories',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Tous', 'Médicaments', 'Pharmacies', 'Parapharmacie']
                .map((category) => ChoiceChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),

          // Plage de prix
          Text(
            'Plage de prix (jusqu\'à ${_priceRange.toInt()} FCFA)',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          Slider(
            value: _priceRange,
            min: 1000,
            max: 20000,
            divisions: 19,
            label: _priceRange.toInt().toString(),
            onChanged: (value) {
              setState(() {
                _priceRange = value;
              });
            },
          ),
          const SizedBox(height: 24),

          // Options de disponibilité
          Row(
            children: [
              Checkbox(
                value: _availableOnly,
                onChanged: (value) {
                  setState(() {
                    _availableOnly = value!;
                  });
                },
                activeColor: const Color(0xFF10B981),
              ),
              const SizedBox(width: 8),
              Text(
                'Disponible maintenant',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _deliveryAvailable,
                onChanged: (value) {
                  setState(() {
                    _deliveryAvailable = value!;
                  });
                },
                activeColor: const Color(0xFF10B981),
              ),
              const SizedBox(width: 8),
              Text(
                'Livraison disponible',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Boutons d'action
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = 'Tous';
                      _priceRange = 5000;
                      _availableOnly = false;
                      _deliveryAvailable = false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFF10B981)),
                  ),
                  child: Text(
                    'Réinitialiser',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF10B981),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Appliquer les filtres
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Appliquer',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}