import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_item.dart';

class OrderModel {
  final String id;
  final String userId;
  final DateTime date;
  final String status;
  final String paymentMethod;
  final double total;
  final List<OrderItem> items;

  // 🔴 NEW FIELDS
  final String customerName;
  final String deliveryAddress;

  // Existing
  final String? riderId;

  OrderModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.status,
    required this.paymentMethod,
    required this.total,
    required this.items,

    // 🔴 NEW (required for new orders)
    required this.customerName,
    required this.deliveryAddress,
    this.riderId,
  });

  // ---------------- FROM FIRESTORE ----------------
  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['userId'],
      date: (map['createdAt'] as Timestamp).toDate(),
      status: map['status'] ?? 'pending',
      paymentMethod: map['paymentMethod'] ?? 'Cash on Delivery',
      total: (map['total'] as num).toDouble(),
      items: (map['items'] as List).map((e) => OrderItem.fromMap(e)).toList(),

      // 🔴 SAFE FALLBACKS (important for old orders)
      customerName: map['customerName'] ?? '',
      deliveryAddress: map['deliveryAddress'] ?? '',

      riderId: map['riderId'],
    );
  }

  // ---------------- TO FIRESTORE ----------------
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'paymentMethod': paymentMethod,
      'total': total,
      'status': status, // MUST be 'pending' initially
      'items': items.map((e) => e.toMap()).toList(),

      // 🔴 NEW FIELDS SAVED
      'customerName': customerName,
      'deliveryAddress': deliveryAddress,

      'riderId': riderId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
