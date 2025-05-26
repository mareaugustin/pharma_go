import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class CreditCardScreen extends StatefulWidget {
  const CreditCardScreen({super.key});

  @override
  State<CreditCardScreen> createState() => _CreditCardScreenState();
}

class _CreditCardScreenState extends State<CreditCardScreen> {
  String _selectedMethod = 'Orange Money';

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'Orange Money',
      'icon': FontAwesome.mobile,
      'color': const Color(0xFFF7931E),
      'description': 'Paiement via votre compte Orange Money'
    },
    {
      'name': 'Moov Money',
      'icon': FontAwesome.mobile,
      'color': const Color(0xFFED1C24),
      'description': 'Paiement via votre compte Moov Money'
    },
    {
      'name': 'Wave',
      'icon': FontAwesome.money,
      'color': const Color(0xFF00B2A9),
      'description': 'Paiement via l\'application Wave'
    },
    {
      'name': 'Carte bancaire',
      'icon': MaterialIcons.credit_card,
      'color': const Color(0xFF3B82F6),
      'description': 'Visa, Mastercard, etc.'
    },
    {
      'name': 'Paiement à la livraison',
      'icon': MaterialIcons.local_atm,
      'color': const Color(0xFF10B981),
      'description': 'Payer en espèces lors de la réception'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Méthodes de paiement',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Message d'information
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF3B82F6)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Sélectionnez votre méthode de paiement préférée',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Liste des méthodes de paiement
            Expanded(
              child: ListView.separated(
                itemCount: _paymentMethods.length,
                separatorBuilder: (context, index) => const Divider(height: 16),
                itemBuilder: (context, index) {
                  final method = _paymentMethods[index];
                  return _buildPaymentMethodCard(method, index);
                },
              ),
            ),

            // Bouton de confirmation
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Enregistrer la méthode sélectionnée
                  Navigator.pop(context, _selectedMethod);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Confirmer',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method, int index) {
    final isSelected = _selectedMethod == method['name'];
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected 
              ? const Color(0xFF10B981) 
              : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            _selectedMethod = method['name'];
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: method['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  method['icon'],
                  color: method['color'],
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method['name'],
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      method['description'],
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF10B981),
                ),
            ],
          ),
        ),
      ),
    );
  }
}