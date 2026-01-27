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

  // 🔴 Customer details
  final String customerName;
  final String deliveryAddress;

  // 🔴 Payment details (NEW – optional, safe)
  final String paymentStatus; // paid | unpaid
  final String? paymentId; // Razorpay paymentId

  // Rider
  final String? riderId;

  OrderModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.status,
    required this.paymentMethod,
    required this.total,
    required this.items,

    // Customer
    required this.customerName,
    required this.deliveryAddress,

    // 🔴 NEW (safe defaults)
    this.paymentStatus = 'unpaid',
    this.paymentId,

    // Rider
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

      // Customer (safe for old orders)
      customerName: map['customerName'] ?? '',
      deliveryAddress: map['deliveryAddress'] ?? '',

      // 🔴 Payment (safe for old orders)
      paymentStatus: map['paymentStatus'] ?? 'unpaid',
      paymentId: map['paymentId'],

      riderId: map['riderId'],
    );
  }

  // ---------------- TO FIRESTORE ----------------
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'paymentId': paymentId,
      'total': total,
      'status': status,
      'items': items.map((e) => e.toMap()).toList(),

      // Customer
      'customerName': customerName,
      'deliveryAddress': deliveryAddress,

      // Rider
      'riderId': riderId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
