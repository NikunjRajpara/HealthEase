import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/order_model.dart';

class OrdersService {
  OrdersService._();
  static final instance = OrdersService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔹 ADD ORDER → GLOBAL orders collection (existing, DO NOT BREAK)
  Future<void> addOrder(OrderModel order) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _firestore.collection('orders').doc(order.id).set({
      ...order.toMap(),
      'userId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// 🔴 NEW: ADD ORDER FROM PREPARED MAP (for prescription flow)
  /// Used when extra fields (doctorName, prescription, imageUrl) are added
  /// Does NOT affect existing flows
  Future<void> addOrderFromMap(Map<String, dynamic> data) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _firestore.collection('orders').add({
      ...data,
      'userId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// 🔹 CUSTOMER: FETCH MY ORDERS
  Stream<List<OrderModel>> ordersStream() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((d) => OrderModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }
}
