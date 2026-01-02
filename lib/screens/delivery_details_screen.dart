import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/cart_service.dart';
import '../services/orders_service.dart';
import '../models/order_model.dart';
import '../models/order_item.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  const DeliveryDetailsScreen({super.key});

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  bool _loading = false;

  final cart = CartService.instance;
  final ordersService = OrdersService.instance;
  final auth = FirebaseAuth.instance;

  Future<void> _placeOrder() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final user = auth.currentUser;
    if (user == null) return;

    setState(() => _loading = true);

    try {
      final order = OrderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.uid,
        date: DateTime.now(),
        paymentMethod: 'Cash on Delivery',
        status: 'pending',
        total: cart.subtotal,
        customerName: _nameCtrl.text.trim(),
        deliveryAddress: _addressCtrl.text.trim(),
        items: cart.items
            .map(
              (e) => OrderItem(
                name: e.product.name,
                qty: e.qty,
                price: e.product.price,
              ),
            )
            .toList(),
      );

      await ordersService.addOrder(order);
      cart.clear();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully')),
      );

      Navigator.popUntil(context, (r) => r.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Name required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Delivery Address',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Address required' : null,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _loading ? null : _placeOrder,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Place Order (COD)'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
