import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Ajouter une recherche récente
  Future<void> addRecentSearch(String query) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('recent_searches')
          .add({
        'query': query,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les recherches récentes
  Stream<List<Map<String, dynamic>>> getRecentSearches() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('recent_searches')
        .orderBy('timestamp', descending: true)
        .limit(5)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'query': data['query'],
              'timestamp': data['timestamp'],
            };
          }).toList();
        });
  }

  // Supprimer une recherche récente
  Future<void> deleteRecentSearch(String searchId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('recent_searches')
          .doc(searchId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  // Effacer toutes les recherches récentes
  Future<void> clearRecentSearches() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final searchesRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('recent_searches');

      final searches = await searchesRef.get();
      final batch = _firestore.batch();

      for (var doc in searches.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les recherches tendances
  Stream<List<Map<String, dynamic>>> getTrendingSearches() {
    return _firestore
        .collection('trending_searches')
        .orderBy('count', descending: true)
        .limit(5)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'query': data['query'],
              'count': data['count'],
            };
          }).toList();
        });
  }

  // Mettre à jour les recherches tendances
  Future<void> updateTrendingSearch(String query) async {
    try {
      final trendingRef = _firestore.collection('trending_searches').doc(query);
      await _firestore.runTransaction((transaction) async {
        final trendingDoc = await transaction.get(trendingRef);

        if (trendingDoc.exists) {
          transaction.update(trendingRef, {
            'count': FieldValue.increment(1),
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        } else {
          transaction.set(trendingRef, {
            'query': query,
            'count': 1,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        }
      });
    } catch (e) {
      rethrow;
    }
  }
}