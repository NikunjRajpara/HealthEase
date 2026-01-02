import 'package:flutter/material.dart';
import 'models/product.dart';
import 'services/cart_service.dart';
import 'services/auth_service.dart';
import 'login_screen.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String title;
  final List<Product> products;

  const CategoryProductsScreen({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: products.isEmpty
          ? Center(
              child: Text(
                'No products yet',
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.66,
                ),
                itemBuilder: (context, i) => _ProductCard(product: products[i]),
              ),
            ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  final cart = CartService.instance;
  final auth = AuthService.instance;

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

  void _onCartChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final item =
        cart.items.where((e) => e.product.name == product.name).cast().toList();

    final qty = item.isEmpty ? 0 : item.first.qty;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      product.imageAsset,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.medication_outlined, size: 48),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '-${product.discount}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              product.quantity,
              style: text.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '₹${product.price.toStringAsFixed(0)}',
                  style:
                      text.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(width: 6),
                Text(
                  '₹${product.mrp.toStringAsFixed(0)}',
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ---------------- ADD / QTY CONTROLLER ----------------

            SizedBox(
              height: 38,
              width: double.infinity,
              child: qty == 0
                  ? FilledButton.tonal(
                      onPressed: () {
                        if (!auth.isLoggedIn) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                          );
                          return;
                        }

                        cart.add(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('${product.name} added to cart')),
                        );
                      },
                      child: const Text('Add'),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => cart.updateQty(product, qty - 1),
                          ),
                          Text(
                            '$qty',
                            style: text.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => cart.updateQty(product, qty + 1),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
