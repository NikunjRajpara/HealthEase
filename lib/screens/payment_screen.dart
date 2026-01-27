import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../services/cart_service.dart';
import '../models/order_item.dart';

class PaymentScreen extends StatefulWidget {
  final String customerName;
  final String deliveryAddress;
  final String doctorName;
  final String prescriptionText;
  final String? prescriptionImageUrl;

  const PaymentScreen({
    super.key,
    required this.customerName,
    required this.deliveryAddress,
    required this.doctorName,
    required this.prescriptionText,
    this.prescriptionImageUrl,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final cart = CartService.instance;
  final auth = FirebaseAuth.instance;

  late Razorpay _razorpay;

  bool _loading = false;
  String _paymentMethod = 'cod'; // cod | razorpay

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  /* -------------------------------------------------------------------------- */
  /*                              CREATE ORDER                                   */
  /* -------------------------------------------------------------------------- */

  Future<void> _createOrder({
    required String paymentMethod,
    required String paymentStatus,
    String? paymentId,
  }) async {
    final user = auth.currentUser;
    if (user == null) return;

    try {
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();

      await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),

        // Order
        'status': 'awaiting_doctor_approval',
        'total': cart.subtotal,

        // Payment
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'paymentId': paymentId,

        // Customer
        'customerName': widget.customerName,
        'deliveryAddress': widget.deliveryAddress,

        // Prescription
        'doctorName': widget.doctorName,
        'prescriptionText': widget.prescriptionText,
        'prescriptionImageUrl': widget.prescriptionImageUrl,

        // Items
        'items': cart.items
            .map(
              (e) => OrderItem(
                name: e.product.name,
                qty: e.qty,
                price: e.product.price,
              ).toMap(),
            )
            .toList(),
      });

      cart.clear();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed. Waiting for doctor approval'),
        ),
      );

      // ✅ SAFE FOR WEB + ANDROID
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                               RAZORPAY FLOW                                 */
  /* -------------------------------------------------------------------------- */

  void _openRazorpay() {
    final user = auth.currentUser;
    if (user == null) return;

    final options = {
      'key': 'rzp_test_S0AdzdVdXCPpKd',
      'amount': (cart.subtotal * 100).toInt(),
      'name': 'HealthEase',
      'description': 'Medicine Order',
      'prefill': {
        'email': user.email ?? '',
      },
      'theme': {
        'color': '#2E7D32',
      },
    };

    _razorpay.open(options);
  }

  void _onPaymentSuccess(PaymentSuccessResponse response) async {
    await _createOrder(
      paymentMethod: 'Razorpay',
      paymentStatus: 'paid',
      paymentId: response.paymentId,
    );
  }

  void _onPaymentError(PaymentFailureResponse response) {
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment failed. Please try again')),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                                   SUBMIT                                   */
  /* -------------------------------------------------------------------------- */

  Future<void> _submit() async {
    if (_loading) return;

    setState(() => _loading = true);

    if (_paymentMethod == 'cod') {
      await _createOrder(
        paymentMethod: 'Cash on Delivery',
        paymentStatus: 'unpaid',
      );
    } else {
      _openRazorpay();
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                                     UI                                     */
  /* -------------------------------------------------------------------------- */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            RadioListTile<String>(
              value: 'cod',
              groupValue: _paymentMethod,
              title: const Text('Cash on Delivery'),
              onChanged: (v) => setState(() => _paymentMethod = v!),
            ),
            RadioListTile<String>(
              value: 'razorpay',
              groupValue: _paymentMethod,
              title: const Text('Pay Online (Razorpay)'),
              onChanged: (v) => setState(() => _paymentMethod = v!),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        _paymentMethod == 'cod'
                            ? 'Place Order'
                            : 'Pay & Place Order',
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
