import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchFilterChips extends StatefulWidget {
  const SearchFilterChips({super.key});

  @override
  State<SearchFilterChips> createState() => _SearchFilterChipsState();
}

class _SearchFilterChipsState extends State<SearchFilterChips> {
  final List<Map<String, String>> filterOptions = [
    {'id': '1', 'label': 'Tous'},
    {'id': '2', 'label': 'Médicaments'},
    {'id': '3', 'label': 'Pharmacies'},
    {'id': '4', 'label': 'Parapharmacie'},
    {'id': '5', 'label': 'Disponible'},
    {'id': '6', 'label': 'Livraison'},
    {'id': '7', 'label': 'Prix bas'},
  ];

  String selectedFilter = '1';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96, // Hauteur fixe pour le scroll horizontal
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        itemCount: filterOptions.length,
        itemBuilder: (context, index) {
          final option = filterOptions[index];
          final isSelected = selectedFilter == option['id'];
          
          return Padding(
            padding: EdgeInsets.only(right: 8), // Espacement entre les chips
            child: ChoiceChip(
              label: Text(
                option['label']!,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedFilter = option['id']!;
                });
              },
              backgroundColor: const Color(0xFFF1F5F9),
              selectedColor: const Color(0xFF10B981),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          );
        },
      ),
    );
  }
}