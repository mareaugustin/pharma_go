import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pharma_go/core/components/headers/orders_header.dart';
import 'package:pharma_go/app/tabs_screen.dart';
import 'package:pharma_go/core/models/order.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<OrderModel> _orders = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      setState(() {
        _orders = snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de chargement des commandes';
        _isLoading = false;
      });
    }
  }

  Future<void> _addNewOrder(Map<String, dynamic> orderData) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final newOrder = OrderModel(
        id: _firestore.collection('orders').doc().id,
        userId: userId,
        status: 'processing',
        date: DateTime.now(),
        pharmacyId: orderData['pharmacyId'] ?? 'pharmacy_unknown',
        pharmacyName: orderData['pharmacyName'] ?? 'Pharmacie Inconnue',
        pharmacyImage: orderData['pharmacyImage'] ?? 'https://via.placeholder.com/150',
        items: [
          OrderItem(
            id: orderData['medicationId'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
            medicationId: orderData['medicationId'] ?? '',
            name: orderData['medicationName'] ?? 'Médicament Inconnu',
            quantity: int.tryParse(orderData['quantity'].toString()) ?? 1,
            price: int.tryParse(orderData['price'].toString()) ?? 0,
            imageUrl: orderData['medicationImage'] ?? 'https://via.placeholder.com/150',
          ),
        ],
        total: (int.tryParse(orderData['price'].toString()) ?? 0) * 
               (int.tryParse(orderData['quantity'].toString()) ?? 1),
        pickupTime: orderData['deliveryType'] == 'pickup' 
            ? DateTime.now().add(const Duration(days: 1))
            : null,
        deliveryTime: orderData['deliveryType'] == 'delivery'
            ? DateTime.now().add(const Duration(days: 1))
            : null,
        deliveryAddress: orderData['deliveryAddress'] as String?,
      );

      await _firestore.collection('orders').doc(newOrder.id).set(newOrder.toMap());
      
      setState(() {
        _orders.insert(0, newOrder);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Commande passée avec succès!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _addNewOrder(args);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            const OrdersHeader(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : _orders.isEmpty
                          ? const EmptyOrdersState()
                          : RefreshIndicator(
                              onRefresh: _loadOrders,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: _orders.length,
                                itemBuilder: (context, index) {
                                  return OrderCard(order: _orders[index]);
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateFormat.format(order.date),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Commande #${order.id.substring(0, 8)}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                OrderStatusBadge(status: order.status),
              ],
            ),
          ),
          
          // Info pharmacie
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    order.pharmacyImage,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 40,
                      height: 40,
                      color: Colors.grey[200],
                      child: const Icon(Icons.local_pharmacy),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.pharmacyName,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${order.items.length} article${order.items.length > 1 ? 's' : ''}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const Divider(height: 24, thickness: 1, indent: 16, endIndent: 16),
          
          // Liste des articles
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: order.items.map((item) => _buildOrderItem(item)).toList(),
            ),
          ),
          
          // Info livraison/retrait
          if (order.deliveryTime != null || order.pickupTime != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      order.deliveryTime != null
                          ? Icons.delivery_dining
                          : Icons.access_time,
                      size: 16,
                      color: order.deliveryTime != null
                          ? const Color(0xFFF59E0B)
                          : const Color(0xFF3B82F6),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      order.deliveryTime != null
                          ? 'Livraison prévue: ${timeFormat.format(order.deliveryTime!)}'
                          : 'Retrait prévu: ${dateFormat.format(order.pickupTime!)} ${timeFormat.format(order.pickupTime!)}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Total
          const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
                Text(
                  '${NumberFormat('#,##0').format(order.total)} FCFA',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          
          // Bouton Détails
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  // Navigation vers les détails
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF10B981),
                ),
                icon: const Icon(Icons.chevron_right, size: 20),
                label: Text(
                  'Détails',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 50,
                height: 50,
                color: Colors.grey[200],
                child: const Icon(Icons.medication),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${NumberFormat('#,##0').format(item.price)} FCFA x ${item.quantity}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${NumberFormat('#,##0').format(item.subtotal)} FCFA',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderStatusBadge extends StatelessWidget {
  final String status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (Color bgColor, Color textColor, IconData icon, String label) = switch (status) {
      'delivered' => (const Color(0xFFDCFCE7), const Color(0xFF10B981), Icons.check_circle, 'Livré'),
      'ready' => (const Color(0xFFFEF3C7), const Color(0xFFF59E0B), Icons.local_shipping, 'Prête'),
      'processing' => (const Color(0xFFE0F2FE), const Color(0xFF3B82F6), Icons.access_time, 'En cours'),
      'cancelled' => (const Color(0xFFFEE2E2), const Color(0xFFEF4444), Icons.cancel, 'Annulée'),
      _ => (const Color(0xFFF1F5F9), const Color(0xFF64748B), Icons.access_time, 'En attente'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyOrdersState extends StatelessWidget {
  const EmptyOrdersState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inventory,
              size: 60,
              color: Color(0xFFCBD5E1),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune commande',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vous n\'avez pas encore passé de commande. Recherchez un médicament pour commencer.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final tabsState = context.findAncestorStateOfType<TabsScreenState>();
                tabsState?.setState(() => tabsState.currentIndex = 1);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Rechercher un médicament',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}