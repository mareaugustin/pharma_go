import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma_go/core/components/headers/orders_header.dart';
import 'package:pharma_go/app/tabs_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> orders = []; // Utilisez votre classe Order existante

  
  @override
  void initState() {
    super.initState();
    // Charger les commandes existantes (à remplacer par votre logique de base de données)
    _loadOrders();
  }

  void _loadOrders() {
    // Simule le chargement de commandes
    setState(() {
      orders = [
        Order(
          id: '1',
          status: 'processing',
          date: '26 Mai 2025',
          pharmacy: 'Pharmacie Centrale',
          pharmacyImage: 'https://images.pexels.com/photos/3683082/pexels-photo-3683082.jpeg',
          items: [
            OrderItem(
              id: '1',
              name: 'Paracétamol 500mg',
              quantity: 2,
              price: 1500,
            ),
          ],
          total: 3000,
          pickupTime: '27 Mai, 14:00 - 18:00',
        ),
      ];
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _addNewOrder(args);
    }
  }

  void _addNewOrder(Map<String, dynamic> orderData) {
    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      status: 'processing', // Nouvelle commande = en préparation
      date: '${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
      pharmacy: orderData['pharmacy'],
      pharmacyImage: _getPharmacyImage(orderData['pharmacy']),
      items: [
        OrderItem(
          id: '1',
          name: orderData['medication'],
          quantity: int.parse(orderData['quantity']),
          price: _calculatePrice(orderData['medication'], int.parse(orderData['quantity'])),
        ),
      ],
      total: _calculatePrice(orderData['medication'], int.parse(orderData['quantity'])),
      pickupTime: orderData['delivery'] == 'Retrait en pharmacie' 
          ? '${DateTime.now().day + 1} ${_getMonthName(DateTime.now().month)}, 14:00 - 18:00'
          : null,
      deliveryTime: orderData['delivery'] == 'Livraison à domicile'
          ? '${DateTime.now().day + 1} ${_getMonthName(DateTime.now().month)}, 16:30 - 18:00'
          : null,
    );

    setState(() {
      orders.insert(0, newOrder); // Ajoute en tête de liste
    });
  }

  // Helper methods
  String _getMonthName(int month) {
    const months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
    return months[month - 1];
  }

  String _getPharmacyImage(String pharmacy) {
    // Simulez des images différentes selon la pharmacie
    const images = [
      'https://images.pexels.com/photos/3683082/pexels-photo-3683082.jpeg',
      'https://images.pexels.com/photos/8942581/pexels-photo-8942581.jpeg',
      'https://images.pexels.com/photos/5699514/pexels-photo-5699514.jpeg',
    ];
    return images[pharmacy.length % images.length];
  }

  int _calculatePrice(String medication, int quantity) {
    // Simulez un prix selon le médicament
    final basePrices = {
      'Paracétamol': 750,
      'Doliprane': 800,
      'Ibuprofène': 1200,
      'Amoxicilline': 2000,
      'Vitamine': 1500,
    };
    
    final basePrice = basePrices.entries
        .firstWhere((e) => medication.contains(e.key), orElse: () => MapEntry('', 1000))
        .value;
    
    return basePrice * quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            OrdersHeader(), // Ton composant OrdersHeader converti
            
            Expanded(
              child: orders.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return OrderCard(order: orders[index]);
                      },
                    )
                  : const EmptyOrdersState(),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.date,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Commande N°${order.id}',
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
          
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    order.pharmacyImage,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.pharmacy,
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
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(
              children: order.items.map((item) => _buildOrderItem(item)).toList(),
            ),
          ),
          
          if (order.status == 'in-transit' || order.status == 'processing')
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      order.status == 'in-transit'
                          ? MaterialIcons.local_shipping
                          : MaterialIcons.access_time,
                      size: 16,
                      color: order.status == 'in-transit'
                          ? const Color(0xFFF59E0B)
                          : const Color(0xFF3B82F6),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      order.status == 'in-transit'
                          ? 'Livraison prévue: ${order.deliveryTime}'
                          : 'Retrait prévu: ${order.pickupTime}',
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
          
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
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
                  '${order.total} FCFA',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Action détails
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF10B981),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Détails',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        MaterialIcons.chevron_right,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              item.name,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
          Row(
            children: [
              Text(
                'x${item.quantity}',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${item.price} FCFA',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
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
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String label;

    switch (status) {
      case 'delivered':
        backgroundColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF10B981);
        icon = MaterialIcons.check_circle;
        label = 'Livré';
        break;
      case 'in-transit':
        backgroundColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFFF59E0B);
        icon = MaterialIcons.local_shipping;
        label = 'En livraison';
        break;
      case 'processing':
        backgroundColor = const Color(0xFFE0F2FE);
        textColor = const Color(0xFF3B82F6);
        icon = MaterialIcons.access_time;
        label = 'En préparation';
        break;
      default:
        backgroundColor = const Color(0xFFF1F5F9);
        textColor = const Color(0xFF64748B);
        icon = MaterialIcons.access_time;
        label = 'En attente';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
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
              MaterialIcons.inventory,
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
                fontWeight: FontWeight.normal,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Action recherche
                final tabsScreenState = context.findAncestorStateOfType<TabsScreenState>();
                  // ignore: invalid_use_of_protected_member
                  tabsScreenState?.setState(() {
                    tabsScreenState.currentIndex = 1; // Index du recherche
                  });
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

// Modèles de données
class Order {
  final String id;
  final String status;
  final String date;
  final String pharmacy;
  final String pharmacyImage;
  final List<OrderItem> items;
  final int total;
  final String? deliveryTime;
  final String? pickupTime;

  Order({
    required this.id,
    required this.status,
    required this.date,
    required this.pharmacy,
    required this.pharmacyImage,
    required this.items,
    required this.total,
    this.deliveryTime,
    this.pickupTime,
  });
}

class OrderItem {
  final String id;
  final String name;
  final int quantity;
  final int price;

  OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });
}

// Données fictives
final List<Order> orders = [
  // Order(
  //   id: '1',
  //   status: 'delivered',
  //   date: '15 Mai 2025',
  //   pharmacy: 'Pharmacie Centrale',
  //   pharmacyImage: 'https://images.pexels.com/photos/3683082/pexels-photo-3683082.jpeg',
  //   items: [
  //     OrderItem(id: '1', name: 'Paracétamol 500mg', quantity: 2, price: 1500),
  //     OrderItem(id: '2', name: 'Ibuprofène 400mg', quantity: 1, price: 2200),
  //   ],
  //   total: 5200,
  // ),
  // Order(
  //   id: '2',
  //   status: 'in-transit',
  //   date: '14 Mai 2025',
  //   pharmacy: 'Pharmacie du Soleil',
  //   pharmacyImage: 'https://images.pexels.com/photos/8942581/pexels-photo-8942581.jpeg',
  //   items: [
  //     OrderItem(id: '3', name: 'Amoxicilline 500mg', quantity: 1, price: 4500),
  //   ],
  //   total: 4500,
  //   deliveryTime: '16:30 - 17:00',
  // ),
  // Order(
  //   id: '3',
  //   status: 'processing',
  //   date: '14 Mai 2025',
  //   pharmacy: 'Pharmacie Saint-Jean',
  //   pharmacyImage: 'https://images.pexels.com/photos/5699514/pexels-photo-5699514.jpeg',
  //   items: [
  //     OrderItem(id: '4', name: 'Doliprane 1000mg', quantity: 2, price: 1800),
  //     OrderItem(id: '5', name: 'Vitamines C', quantity: 1, price: 3000),
  //   ],
  //   total: 6600,
  //   pickupTime: '15 Mai, 14:00 - 18:00',
  // ),
];