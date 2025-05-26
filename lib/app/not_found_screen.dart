import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oops!'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Cette page n\'existe pas.',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  // Retour à l'accueil
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Retour à l\'accueil!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}