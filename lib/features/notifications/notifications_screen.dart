import 'package:flutter/material.dart';
// import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildNotificationItem(
              icon: Icons.discount,
              iconColor: Colors.blue,
              title: 'Promotion spéciale',
              subtitle: '20% de réduction sur tous les produits ce week-end',
              time: 'Il y a 2 heures',
              isRead: false,
            ),
            _buildNotificationItem(
              icon: Icons.local_shipping,
              iconColor: Colors.green,
              title: 'Commande expédiée',
              subtitle: 'Votre commande #12345 a été expédiée',
              time: 'Il y a 1 jour',
              isRead: true,
            ),
            _buildNotificationItem(
              icon: Icons.account_circle,
              iconColor: Colors.purple,
              title: 'Profil mis à jour',
              subtitle: 'Vos informations ont été mises à jour avec succès',
              time: 'Il y a 2 jours',
              isRead: true,
            ),
            _buildNotificationItem(
              icon: Icons.payment,
              iconColor: Colors.orange,
              title: 'Paiement reçu',
              subtitle: 'Votre paiement de 25 000 FCFA a été reçu',
              time: 'Il y a 3 jours',
              isRead: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    required bool isRead,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
        trailing: !isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
              )
            : null,
        onTap: () {
          // Action lorsqu'une notification est cliquée
        },
      ),
    );
  }
}