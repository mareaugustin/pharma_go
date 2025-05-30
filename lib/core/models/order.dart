import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrderModel {
  final String id;
  final String userId;
  final String status;
  final DateTime date;
  final String pharmacyId;
  final String pharmacyName;
  final String pharmacyImage;
  final List<OrderItem> items;
  final int total;
  final DateTime? pickupTime;
  final DateTime? deliveryTime;
  final String? deliveryAddress;

  OrderModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.date,
    required this.pharmacyId,
    required this.pharmacyName,
    required this.pharmacyImage,
    required this.items,
    required this.total,
    this.pickupTime,
    this.deliveryTime,
    this.deliveryAddress,
  });

  // Convertir en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'status': status,
      'date': Timestamp.fromDate(date),
      'pharmacyId': pharmacyId,
      'pharmacyName': pharmacyName,
      'pharmacyImage': pharmacyImage,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'pickupTime': pickupTime != null ? Timestamp.fromDate(pickupTime!) : null,
      'deliveryTime': deliveryTime != null ? Timestamp.fromDate(deliveryTime!) : null,
      'deliveryAddress': deliveryAddress,
    };
  }

  // Créer à partir d'un DocumentSnapshot
  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: data['userId'],
      status: data['status'],
      date: (data['date'] as Timestamp).toDate(),
      pharmacyId: data['pharmacyId'],
      pharmacyName: data['pharmacyName'],
      pharmacyImage: data['pharmacyImage'],
      items: (data['items'] as List).map((item) => OrderItem.fromMap(item)).toList(),
      total: data['total'],
      pickupTime: data['pickupTime'] != null ? (data['pickupTime'] as Timestamp).toDate() : null,
      deliveryTime: data['deliveryTime'] != null ? (data['deliveryTime'] as Timestamp).toDate() : null,
      deliveryAddress: data['deliveryAddress'],
    );
  }

  // Formater la date pour l'affichage
  String formattedDate() {
    return DateFormat('dd MMM yyyy').format(date);
  }

  // Formater l'heure pour l'affichage
  String formattedTime() {
    return DateFormat('HH:mm').format(date);
  }
}

class OrderItem {
  final String id;
  final String medicationId;
  final String name;
  final int quantity;
  final int price;
  final String imageUrl;

  OrderItem({
    required this.id,
    required this.medicationId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'medicationId': medicationId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['medicationId'] ?? '',
      medicationId: map['medicationId'] ?? '',
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: map['price'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  int get subtotal => price * quantity;
}