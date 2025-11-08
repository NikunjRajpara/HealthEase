import 'package:flutter/material.dart';

class Product {
  final String name;
  final String quantity;
  final double price;
  final double mrp;
  final int discount; // in %
  final String imageAsset;

  const Product({
    required this.name,
    required this.quantity,
    required this.price,
    required this.mrp,
    required this.discount,
    required this.imageAsset,
  });
}

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
      appBar: AppBar(
        title: Text(title),
      ),
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
                  // Smaller ratio = taller tile → prevents overflow
                  childAspectRatio: 0.66,
                ),
                itemBuilder: (context, i) => _ProductCard(product: products[i]),
              ),
            ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Product details page if needed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selected: ${product.name}')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image area gets flexible height so text never overflows
              Expanded(
                child: Stack(
                  children: [
                    // Product image
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Image.asset(
                          product.imageAsset,
                          fit: BoxFit.contain,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    // Discount chip
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF16A34A).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: const Color(0xFF16A34A).withOpacity(0.25),
                          ),
                        ),
                        child: Text(
                          '-${product.discount}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Name (2 lines max)
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 4),

              // Quantity (muted, 1 line)
              Text(
                product.quantity,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 8),

              // Price row
              Row(
                children: [
                  Text(
                    '₹${product.price.toStringAsFixed(0)}',
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '₹${product.mrp.toStringAsFixed(0)}',
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.black38,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Add button fits in remaining width, small height
              SizedBox(
                height: 38,
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: () {
                    // TODO: add to cart logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added to cart: ${product.name}')),
                    );
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
