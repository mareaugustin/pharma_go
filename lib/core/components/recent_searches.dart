import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma_go/services/search_service.dart';

class RecentSearches extends StatelessWidget {
  final SearchService _searchService = SearchService();
  RecentSearches({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recherches récentes
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _searchService.getRecentSearches(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Column(
                  children: [
                    _buildSectionHeader(
                      icon: Feather.clock,
                      title: 'Recherches récentes',
                      actionText: 'Effacer tout',
                      onAction: () => _searchService.clearRecentSearches(),
                    ),
                    _buildSearchesList(
                      snapshot.data!.map((item) => Map<String, String>.from(item)).toList(),
                      Feather.clock,
                      Feather.x,
                      onTap: (query) {
                        // Gérer la sélection de la recherche
                      },
                      onDelete: (id) => _searchService.deleteRecentSearch(id),
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Tendances
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _searchService.getTrendingSearches(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    _buildSectionHeader(
                      icon: Feather.trending_up,
                      title: 'Tendances',
                    ),
                    _buildSearchesList(
                      snapshot.data!.map((item) => Map<String, String>.from(item)).toList(),
                      Feather.trending_up,
                      Feather.arrow_up_right,
                      onTap: (query) {
                        // Gérer la sélection de la recherche
                      },
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
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
    IconData suffixIcon, {
    Function(String)? onTap,
    Function(String)? onDelete,
  }) {
    return Column(
      children: [
        for (var search in searches)
          Column(
            children: [
              InkWell(
                onTap: onTap != null ? () => onTap(search['query'] ?? '',) : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(prefixIcon,
                              size: 16, color: const Color(0xFF94A3B8)),
                          const SizedBox(width: 12),
                          Text(
                            search['query'] ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                      if (onDelete != null)
                        IconButton(
                          icon: Icon(suffixIcon,
                              size: 16, color: const Color(0xFF94A3B8)),
                          onPressed: () => onDelete(search['id'] ?? ''),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
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