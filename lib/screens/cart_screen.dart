import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/cart_service.dart';
import '../screens/delivery_details_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService cart = CartService.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    cart.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    cart.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() => setState(() {});

  // ---------------- PROCEED TO DELIVERY DETAILS ----------------
  void _proceedToCheckout() {
    final user = _auth.currentUser;

    // 🔒 LOGIN REQUIRED
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to place an order')),
      );
      return;
    }

    if (cart.items.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DeliveryDetailsScreen(),
      ),
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final items = cart.items;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: items.isEmpty
            ? const Center(
                child: Text(
                  'Your cart is empty',
                  style: TextStyle(fontSize: 16),
                ),
              )
            : Column(
                children: [
                  // ---------------- CART ITEMS ----------------
                  Expanded(
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (_, i) {
                        final item = items[i];
                        return Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.product.name,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: item.qty > 1
                                  ? () =>
                                      cart.updateQty(item.product, item.qty - 1)
                                  : null,
                            ),
                            Text(
                              '${item.qty}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () =>
                                  cart.updateQty(item.product, item.qty + 1),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ---------------- SUBTOTAL ----------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '₹${cart.subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ---------------- CHECKOUT BUTTON ----------------
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: _proceedToCheckout,
                      child: const Text(
                        'Checkout (Cash on Delivery)',
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
