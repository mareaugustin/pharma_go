import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Douleur et Fièvre',
      'medications': [
        {'name': 'Paracétamol 500mg', 'price': '500 FCFA'},
        {'name': 'Doliprane 1000mg', 'price': '800 FCFA'},
        {'name': 'Advil 400mg', 'price': '1200 FCFA'},
      ],
    },
    {
      'name': 'Anti-inflammatoire',
      'medications': [
        {'name': 'Ibuprofène 400mg', 'price': '750 FCFA'},
        {'name': 'Voltarene 50mg', 'price': '1500 FCFA'},
      ],
    },
    {
      'name': 'Antibiotiques',
      'medications': [
        {'name': 'Amoxicilline 500mg', 'price': '2000 FCFA'},
        {'name': 'Ciprofloxacine 500mg', 'price': '2500 FCFA'},
      ],
    },
    {
      'name': 'Vitamines',
      'medications': [
        {'name': 'Vitamine C 500mg', 'price': '1000 FCFA'},
        {'name': 'Vitamine D3', 'price': '1500 FCFA'},
      ],
    },
    {
      'name': 'Ophtalmologie',
      'medications': [
        {'name': 'Larmes artificielles', 'price': '1200 FCFA'},
        {'name': 'Collyre antibiotique', 'price': '1800 FCFA'},
      ],
    },
    {
      'name': 'Cardiaque',
      'medications': [
        {'name': 'Aspirine 100mg', 'price': '600 FCFA'},
        {'name': 'Atorvastatine 20mg', 'price': '2000 FCFA'},
      ],
    },
    {
      'name': 'Neurologie',
      'medications': [
        {'name': 'Acide valproïque 500mg', 'price': '2500 FCFA'},
        {'name': 'Lamotrigine 100mg', 'price': '3000 FCFA'},
      ],
    },
    {
      'name': 'Respiratoire',
      'medications': [
        {'name': 'Salbutamol 100mcg', 'price': '800 FCFA'},
        {'name': 'Budesonide 200mcg', 'price': '1200 FCFA'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Toutes les catégories',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              title: Text(
                category['name'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
              children: [
                ...category['medications'].map<Widget>((med) => ListTile(
                      title: Text(med['name']),
                      trailing: Text(
                        med['price'],
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}