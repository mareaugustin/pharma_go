// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({super.key});

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _fullNameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     super.dispose();
//   }

//   void _saveProfile() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         // Récupérer l'utilisateur connecté
//         User? user = FirebaseAuth.instance.currentUser;
//         if (user == null) {
//           throw Exception("Utilisateur non connecté");
//         }

//         // Mettre à jour le nom d'affichage dans Firebase Auth
//         await user.updateDisplayName(_fullNameController.text);
//         await user.reload();
        
//         // Sauvegarder les informations supplémentaires dans Firestore
//         final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
        
//         // On peut appeler set avec merge:true pour ne pas écraser d'autres données
//         await userDoc.set({
//           'phone': _phoneController.text,
//           'address': _addressController.text,
//         }, SetOptions(merge: true));
        
//         // Afficher un message de succès ou revenir en arrière
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Profil mis à jour avec succès.')),
//           );
//           Navigator.pop(context);
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Erreur lors de la mise à jour: ${e.toString()}")),
//           );
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Modifier Profil', style: GoogleFonts.poppins()),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _fullNameController,
//                 decoration: const InputDecoration(labelText: 'Nom complet'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Veuillez entrer votre nom complet';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: const InputDecoration(labelText: 'Numéro de téléphone'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Veuillez entrer votre numéro de téléphone';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _addressController,
//                 decoration: const InputDecoration(labelText: 'Adresse de livraison'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Veuillez entrer votre adresse de livraison';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: _saveProfile,
//                 child: Text('Enregistrer', style: GoogleFonts.poppins()),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }