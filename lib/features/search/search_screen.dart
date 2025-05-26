import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pharma_go/core/components/headers/search_header.dart';
import 'package:pharma_go/core/components/search_filter_chips.dart';
import 'package:pharma_go/core/components/recent_searches.dart';
import 'package:pharma_go/core/components/medication_item.dart';

import 'package:image_picker/image_picker.dart';
import 'package:pharma_go/features/search/barcode_scanner_screen.dart';
import 'package:pharma_go/features/search/photo_search_service.dart';
import 'dart:io';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  // @override
  // _SearchScreenState createState() => _SearchScreenState();
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showRecentSearches = true;

  final List<Map<String, dynamic>> _recentMedications = [
    {
      'id': '1',
      'name': 'Paracétamol 500mg',
      'type': 'Douleur et Fièvre',
      'image':
          'https://images.pexels.com/photos/139398/himalayan-blue-poppy-meconopsis-betonicifolia-139398.jpeg',
    },
    {
      'id': '2',
      'name': 'Ibuprofène 400mg',
      'type': 'Anti-inflammatoire',
      'image':
          'https://images.pexels.com/photos/159211/headache-pain-pills-medication-159211.jpeg',
    },
    {
      'id': '3',
      'name': 'Amoxicilline 500mg',
      'type': 'Antibiotique',
      'image':
          'https://images.pexels.com/photos/208512/pexels-photo-208512.jpeg',
    },
    {
      'id': '4',
      'name': 'Doliprane 1000mg',
      'type': 'Douleur et Fièvre',
      'image':
          'https://images.pexels.com/photos/593451/pexels-photo-593451.jpeg',
    },
  ];

  String _currentFilter = 'Tous';
  double _maxPrice = 20000;
  bool _availableOnly = false;
  bool _deliveryAvailable = false;

  List<Map<String, dynamic>> get _filteredMedications {
    return _recentMedications.where((med) {
      final priceMatch = (med['price'] ?? 0) <= _maxPrice;
      final categoryMatch = _currentFilter == 'Tous' || 
          med['category'] == _currentFilter;
      final availabilityMatch = !_availableOnly || med['available'] == true;
      final deliveryMatch = !_deliveryAvailable || med['delivery'] == true;
      
      return priceMatch && categoryMatch && availabilityMatch && deliveryMatch;
    }).toList();
  }

  Future<void> searchByPhoto() async {
  final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 80,
    );

    if (image != null) {
      final result = await PhotoSearchService.searchByPhoto(File(image.path));
      if (result != null) {
        setState(() {
          _searchController.text = result;
          _handleSearch();
        });
      }
    }
  }

  Future<void> scanBarcode() async {
    final barcode = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const BarcodeScannerScreen(),
      ),
    );

    if (barcode != null) {
      setState(() {
        _searchController.text = barcode;
        _handleSearch();
      });
    }
  }

  // Ajoutez cette méthode pour mettre à jour les filtres
  void _updateFilters(Map<String, dynamic> filters) {
    setState(() {
      _currentFilter = filters['category'] ?? 'Tous';
      _maxPrice = filters['price'] ?? 20000;
      _availableOnly = filters['availableOnly'] ?? false;
      _deliveryAvailable = filters['deliveryAvailable'] ?? false;
    });
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            String selectedCategory = _currentFilter;
            double priceRange = _maxPrice;
            bool availableOnly = _availableOnly;
            bool deliveryAvailable = _deliveryAvailable;

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  // ... (le reste de votre contenu de filtre)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              selectedCategory = 'Tous';
                              priceRange = 20000;
                              availableOnly = false;
                              deliveryAvailable = false;
                            });
                          },
                          child: Text('Réinitialiser'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _updateFilters({
                              'category': selectedCategory,
                              'price': priceRange,
                              'availableOnly': availableOnly,
                              'deliveryAvailable': deliveryAvailable,
                            });
                            Navigator.pop(context);
                          },
                          child: Text('Appliquer'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _handleSearch() {
    if (_searchController.text.trim().isNotEmpty) {
      setState(() {
        _showRecentSearches = false;
      });
    }
  }

  void _handleClearSearch() {
    setState(() {
      _searchController.clear();
      _showRecentSearches = true;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            SearchHeader(onFilterPressed: () => _showFilterBottomSheet(context),), // Ton composant SearchHeader converti

            // Barre de recherche
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              color: Colors.white,
              child: Column(
                children: [
                  // Champ de recherche
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(
                            MaterialIcons.search,
                            size: 20,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Rechercher un médicament',
                              hintStyle: GoogleFonts.poppins(
                                color: const Color(0xFF94A3B8),
                              ),
                              border: InputBorder.none,
                            ),
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF1E293B),
                            ),
                            onSubmitted: (_) => _handleSearch(),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          TextButton(
                            onPressed: _handleClearSearch,
                            child: Text(
                              'Effacer',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF10B981),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Méthodes alternatives de recherche
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            // Action recherche par photo
                          },
                          icon: const Icon(
                            MaterialIcons.photo_camera,
                            size: 20,
                            color: Color(0xFF10B981),
                          ),
                          label: Text(
                            'Photo',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF10B981),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 20,
                          color: const Color(0xFFE2E8F0),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            // Action scan code barre
                          },
                          icon: const Icon(
                            MaterialCommunityIcons.barcode_scan,
                            size: 20,
                            color: Color(0xFF10B981),
                          ),
                          label: Text(
                            'Scannez',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF10B981),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Filtres de recherche
            SearchFilterChips(),

            // Contenu principal
            Expanded(
              child: _showRecentSearches
                  ? SingleChildScrollView(
                      child: Column(
                        children:  [
                          RecentSearches(),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Médicaments populaires',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ..._filteredMedications.map((medication) =>
                                    MedicationItem(medication: medication)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        Text(
                          'Résultats pour "${_searchController.text}"',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ..._filteredMedications.map((medication) =>
                            MedicationItem(medication: medication)),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}