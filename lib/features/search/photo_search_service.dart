import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class PhotoSearchService {
  static Future<String?> searchByPhoto(File imageFile) async {
    try {
      // 1. Envoyer l'image à votre API
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.pharma-go.com/search-by-image'),
      );
      
      request.files.add(await http.MultipartFile.fromPath(
        'image', 
        imageFile.path,
      ));

      // 2. Traiter la réponse
      var response = await request.send();
      if (response.statusCode == 200) {
        return await response.stream.bytesToString();
      }
      return null;
    } catch (e) {
      debugPrint('Erreur recherche par photo: $e');
      return null;
    }
  }
}