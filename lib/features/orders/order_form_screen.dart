// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class OrderFormScreen extends StatefulWidget {
//   final Map<String, dynamic> medication;

//   const OrderFormScreen({super.key, required this.medication});

//   @override
//   State<OrderFormScreen> createState() => _OrderFormScreenState();
// }

// class _OrderFormScreenState extends State<OrderFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _quantityController = TextEditingController(text: '1');
//   String _selectedPharmacy = '';
//   String _deliveryOption = 'Livraison à domicile';
//   final _addressController = TextEditingController();
//   final _phoneController = TextEditingController();

//   final List<String> _pharmacies = [
//     'Pharmacie du Centre',
//     'Pharmacie Saint Michel',
//     'Pharmacie La Source',
//     'Pharmacie les Cités'
//   ];

//   @override
//   void dispose() {
//     _quantityController.dispose();
//     _addressController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Nouvelle commande',
//           style: GoogleFonts.poppins(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             color: const Color(0xFF1E293B),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Info médicament
//               _buildMedicationInfo(),
//               const SizedBox(height: 24),

//               // Quantité
//               Text(
//                 'Quantité',
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _quantityController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   hintText: 'Entrez la quantité',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                 )),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Veuillez entrer une quantité';
//                   }
//                   if (int.tryParse(value) == null) {
//                     return 'Quantité invalide';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),

//               // Pharmacie
//               Text(
//                 'Pharmacie',
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               DropdownButtonFormField<String>(
//                 value: _selectedPharmacy.isNotEmpty ? _selectedPharmacy : null,
//                 items: _pharmacies.map((pharmacy) {
//                   return DropdownMenuItem(
//                     value: pharmacy,
//                     child: Text(pharmacy),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedPharmacy = value!;
//                   });
//                 },
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                 )),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Veuillez sélectionner une pharmacie';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),

//               // Options de livraison
//               Text(
//                 'Mode de livraison',
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Column(
//                 children: [
//                   RadioListTile(
//                     title: Text('Livraison à domicile'),
//                     value: 'Livraison à domicile',
//                     groupValue: _deliveryOption,
//                     onChanged: (value) {
//                       setState(() {
//                         _deliveryOption = value!;
//                       });
//                     },
//                   ),
//                   RadioListTile(
//                     title: Text('Retrait en pharmacie'),
//                     value: 'Retrait en pharmacie',
//                     groupValue: _deliveryOption,
//                     onChanged: (value) {
//                       setState(() {
//                         _deliveryOption = value!;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // Adresse (si livraison)
//               if (_deliveryOption == 'Livraison à domicile') ...[
//                 Text(
//                   'Adresse de livraison',
//                   style: GoogleFonts.poppins(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   controller: _addressController,
//                   decoration: InputDecoration(
//                     hintText: 'Entrez votre adresse complète',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                   )),
//                   validator: (value) {
//                     if (_deliveryOption == 'Livraison à domicile' && 
//                         (value == null || value.isEmpty)) {
//                       return 'Veuillez entrer une adresse';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//               ],

//               // Téléphone
//               Text(
//                 'Numéro de téléphone',
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _phoneController,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   hintText: 'Ex: 70123456',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                 )),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Veuillez entrer votre numéro';
//                   }
//                   if (!RegExp(r'^[0-9]{8}$').hasMatch(value)) {
//                     return 'Numéro invalide (8 chiffres)';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),

//               // Bouton de commande
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _submitOrder,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF10B981),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: Text(
//                     'Confirmer la commande',
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMedicationInfo() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             // Image placeholder
//             Container(
//               width: 60,
//               height: 60,
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(Icons.medication),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.medication['name'],
//                     style: GoogleFonts.poppins(
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   Text(
//                     widget.medication['type'],
//                     style: GoogleFonts.poppins(
//                       color: const Color(0xFF64748B),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _submitOrder() {
//     if (_formKey.currentState!.validate()) {
//       final orderData = {
//         'medication': widget.medication['name'],
//         'quantity': _quantityController.text,
//         'pharmacy': _selectedPharmacy,
//         'delivery': _deliveryOption,
//         'address': _deliveryOption == 'Livraison à domicile' 
//             ? _addressController.text 
//             : 'Retrait en pharmacie',
//         'phone': _phoneController.text,
//       };

//       // Retourne à l'écran précédent avec les données
//       Navigator.pop(context, orderData);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Commande passée avec succès !'),
//           backgroundColor: Colors.green[800],
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       );
//     }
//   }
// }