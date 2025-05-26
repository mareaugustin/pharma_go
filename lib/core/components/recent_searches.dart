import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentSearches extends StatelessWidget {
  RecentSearches({super.key});
  final List<Map<String, String>> recentSearches = [
    {'id': '1', 'query': 'Paracétamol 500mg'},
    {'id': '2', 'query': 'Ibuprofène 400mg'},
    {'id': '3', 'query': 'Amoxicilline'},
  ];

  final List<Map<String, String>> trendingSearches = [
    {'id': '1', 'query': 'Doliprane 1000mg'},
    {'id': '2', 'query': 'Vitamines C'},
    {'id': '3', 'query': 'Efferalgan 500mg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recherches récentes
          if (recentSearches.isNotEmpty) ...[
            _buildSectionHeader(
              icon: Feather.clock,
              title: 'Recherches récentes',
              actionText: 'Effacer tout',
              onAction: () {
                // Action pour effacer tout
              },
            ),
            _buildSearchesList(recentSearches, Feather.clock, Feather.x),
            const SizedBox(height: 8),
          ],

          // Tendances
          _buildSectionHeader(
            icon: Feather.trending_up,
            title: 'Tendances',
          ),
          _buildSearchesList(trendingSearches, Feather.trending_up, Feather.arrow_up_right),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF64748B)),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          if (actionText != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionText,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF10B981),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchesList(
    List<Map<String, String>> searches,
    IconData prefixIcon,
    IconData suffixIcon,
  ) {
    return Column(
      children: [
        for (var search in searches)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(prefixIcon, size: 16, color: const Color(0xFF94A3B8)),
                        const SizedBox(width: 12),
                        Text(
                          search['query']!,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(suffixIcon, size: 16, color: const Color(0xFF94A3B8)),
                      onPressed: () {
                        // Action pour chaque item
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1,
                color: Color(0xFFF1F5F9),
              ),
            ],
          ),
      ],
    );
  }
}