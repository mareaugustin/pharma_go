import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:pharma_go/core/components/headers/map_header.dart';
import 'package:pharma_go/core/components/pharmacy_bottom_sheet.dart';

class Pharmacy {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String hours;
  final double rating;
  final double latitude;
  final double longitude;
  final String image;

  Pharmacy({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.hours,
    required this.rating,
    required this.latitude,
    required this.longitude,
    required this.image,
  });
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  // @override
  // _MapScreenState createState() => _MapScreenState();
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Pharmacy? selectedPharmacy;
  bool showBottomSheet = false;

  final List<Pharmacy> pharmacies = [
    Pharmacy(
      id: '1',
      name: 'Pharmacie NabaKoom',
      address: '123 Rue Principale, Ouagadougou',
      phone: '+226 25 30 12 34',
      hours: '08:00 - 20:00',
      rating: 4.7,
      latitude: 12.3714,
      longitude: -1.5197,
      image: 'https://images.pexels.com/photos/3683082/pexels-photo-3683082.jpeg',
    ),
    Pharmacy(
      id: '2',
      name: 'Pharmacie du Centre',
      address: '45 Avenue de la Liberté, Ouagadougou',
      phone: '+226 25 31 23 45',
      hours: '08:00 - 22:00',
      rating: 4.5,
      latitude: 12.3814,
      longitude: -1.5297,
      image: 'https://images.pexels.com/photos/8942581/pexels-photo-8942581.jpeg',
    ),
    Pharmacy(
      id: '3',
      name: 'Pharmacie Saint-Jean',
      address: '78 Boulevard de l\'Indépendance, Ouagadougou',
      phone: '+226 25 32 34 56',
      hours: '07:30 - 21:00',
      rating: 4.2,
      latitude: 12.3614,
      longitude: -1.5097,
      image: 'https://images.pexels.com/photos/5699514/pexels-photo-5699514.jpeg',
    ),
  ];

  final LatLng _center = const LatLng(12.3714, -1.5197);
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() {
    for (var pharmacy in pharmacies) {
      _markers.add(
        Marker(
          markerId: MarkerId(pharmacy.id),
          position: LatLng(pharmacy.latitude, pharmacy.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          onTap: () => _handleMarkerPress(pharmacy),
        ),
      );
    }
  }

  void _handleMarkerPress(Pharmacy pharmacy) {
    setState(() {
      selectedPharmacy = pharmacy;
      showBottomSheet = true;
    });
  }

  void _closeBottomSheet() {
    setState(() {
      showBottomSheet = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            MapHeader(), // Ton composant MapHeader converti
            
            Expanded(
              child: kIsWeb 
                ? _buildWebPlaceholder()
                : GoogleMap(
                    onMapCreated: (controller) {
                      setState(() {
                        mapController = controller;
                      });
                    },
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 14.0,
                    ),
                    markers: _markers,
                  ),
            ),
          ],
        ),
      ),
      
      bottomSheet: showBottomSheet && selectedPharmacy != null
          ? PharmacyBottomSheet(
              pharmacy: {
                'id': selectedPharmacy!.id,
                'name': selectedPharmacy!.name,
                'address': selectedPharmacy!.address,
                'phone': selectedPharmacy!.phone,
                'hours': selectedPharmacy!.hours,
                'rating': selectedPharmacy!.rating,
                'latitude': selectedPharmacy!.latitude,
                'longitude': selectedPharmacy!.longitude,
                'image': selectedPharmacy!.image,
              },
              onClose: _closeBottomSheet,
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildWebPlaceholder() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(
            Feather.map_pin,
            size: 40,
            color: Color(0xFF10B981),
          ),
          const SizedBox(height: 16),
          Text(
            'La carte des pharmacies s\'affiche ici sur un appareil mobile',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: pharmacies.map((pharmacy) => _buildPharmacyCard(pharmacy)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPharmacyCard(Pharmacy pharmacy) {
    return GestureDetector(
      onTap: () => _handleMarkerPress(pharmacy),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 3,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                pharmacy.image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pharmacy.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Feather.star,
                          size: 14,
                          color: Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          pharmacy.rating.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      pharmacy.address,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      pharmacy.hours,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF10B981),
                      ),
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
}