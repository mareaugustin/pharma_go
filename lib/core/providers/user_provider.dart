// lib/core/providers/user_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _userModel; // Renommez pour éviter la confusion
  User? _firebaseUser; // Utilisateur Firebase

  UserModel? get user => _userModel;
  User? get firebaseUser => _firebaseUser;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchUser(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

      if (doc.exists) {
        _userModel = UserModel.fromFirestore(doc);
        _firebaseUser = FirebaseAuth.instance.currentUser; // Mettre à jour aussi l'utilisateur Firebase
        notifyListeners();
      } else {
      debugPrint('Document utilisateur non trouvé');
      }
    } catch (e) {
      debugPrint('Error fetching user: $e');
      throw Exception('Impossible de charger le profil. Veuillez réessayer.');
    }
  }

  Future<void> updateUserProfile({
    String? name,
    String? phoneNumber,
    String? deliveryAddress,
  }) async {
    if (_userModel == null) return;

    try {
      await _firestore.collection('users').doc(_userModel!.uid).update({
        if (name != null) 'name': name,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
        if (deliveryAddress != null) 'deliveryAddress': deliveryAddress,
      });

      // Mettre à jour localement
      _userModel = UserModel(
        uid: _userModel!.uid,
        name: name ?? _userModel!.name,
        email: _userModel!.email,
        phoneNumber: phoneNumber ?? _userModel!.phoneNumber,
        deliveryAddress: deliveryAddress ?? _userModel!.deliveryAddress,
        role: _userModel!.role,
        createdAt: _userModel!.createdAt,
      );
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating user: $e');
      rethrow;
    }
  }

  void clearUser() {
    _userModel = null;
    notifyListeners();
  }
}