import 'package:flutter/material.dart';
import 'category_products_screen.dart';
import 'ask_pharmacist_screen.dart';
import 'consult_doctor_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Per-category sample products (2 each). You can edit anytime.
    final Map<String, List<Product>> productsByCategory = {
      'Skin Care': const [
        Product(
          name: 'Cetaphil Gentle Cleanser',
          quantity: '200 ml Bottle',
          price: 245.00,
          mrp: 280.00,
          discount: 12,
          imageAsset: 'assets/images/skin_care.png',
        ),
        Product(
          name: 'Nivea Body Milk',
          quantity: '400 ml Bottle',
          price: 299.00,
          mrp: 350.00,
          discount: 15,
          imageAsset: 'assets/images/skin_care.png',
        ),
      ],
      'Men Care': const [
        Product(
          name: 'Gillette Fusion5 Blades',
          quantity: 'Pack of 4',
          price: 799.00,
          mrp: 899.00,
          discount: 11,
          imageAsset: 'assets/images/men_care.png',
        ),
        Product(
          name: 'Nivea Men Face Wash',
          quantity: '100 ml Tube',
          price: 169.00,
          mrp: 199.00,
          discount: 15,
          imageAsset: 'assets/images/men_care.png',
        ),
      ],
      'Pain Relief': const [
        Product(
          name: 'Saridon',
          quantity: 'Strip of 10 Tablets',
          price: 35.00,
          mrp: 40.00,
          discount: 13,
          imageAsset: 'assets/images/pain_relief.png',
        ),
        Product(
          name: 'Moov Pain Relief Gel',
          quantity: '50 g Tube',
          price: 92.00,
          mrp: 110.00,
          discount: 16,
          imageAsset: 'assets/images/pain_relief.png',
        ),
      ],
      'Cardiac Care': const [
        Product(
          name: 'Cod Liver Oil',
          quantity: '60 Capsules',
          price: 299.00,
          mrp: 360.00,
          discount: 17,
          imageAsset: 'assets/images/cardiac_care.png',
        ),
        Product(
          name: 'Arjuna Capsules',
          quantity: '30 Capsules',
          price: 220.00,
          mrp: 260.00,
          discount: 15,
          imageAsset: 'assets/images/cardiac_care.png',
        ),
      ],
      'Digestive Health': const [
        Product(
          name: 'ENO Lemon',
          quantity: 'Pack of 6',
          price: 85.00,
          mrp: 95.00,
          discount: 11,
          imageAsset: 'assets/images/digestive_care.png',
        ),
        Product(
          name: 'Panchasrishta',
          quantity: '450 ml',
          price: 140.00,
          mrp: 160.00,
          discount: 12,
          imageAsset: 'assets/images/digestive_care.png',
        ),
      ],
      'Fitness Supplements': const [
        Product(
          name: 'Whey Protein',
          quantity: '1 kg Jar',
          price: 1899.00,
          mrp: 2299.00,
          discount: 17,
          imageAsset: 'assets/images/fitness_care.png',
        ),
        Product(
          name: 'Multivitamin Tablets',
          quantity: 'Pack of 60',
          price: 349.00,
          mrp: 449.00,
          discount: 22,
          imageAsset: 'assets/images/fitness_care.png',
        ),
      ],
      'Diabetes Care': const [
        Product(
          name: 'Glucometer Strips',
          quantity: 'Pack of 50',
          price: 549.00,
          mrp: 699.00,
          discount: 21,
          imageAsset: 'assets/images/diabetes_care.png',
        ),
        Product(
          name: 'Diabetes Care Protein',
          quantity: '400 g Tin',
          price: 399.00,
          mrp: 480.00,
          discount: 17,
          imageAsset: 'assets/images/diabetes_care.png',
        ),
      ],
      'Hair Care': const [
        Product(
          name: 'Anti-Dandruff Shampoo',
          quantity: '180 ml Bottle',
          price: 169.00,
          mrp: 199.00,
          discount: 15,
          imageAsset: 'assets/images/hair_care.png',
        ),
        Product(
          name: 'Hair Serum',
          quantity: '100 ml',
          price: 299.00,
          mrp: 349.00,
          discount: 14,
          imageAsset: 'assets/images/hair_care.png',
        ),
      ],
    };

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('HealthEase'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: navigate to cart screen
            },
            icon: const Icon(Icons.shopping_cart_outlined),
            tooltip: 'Cart',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner (GIF)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    'assets/images/banner.gif',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Help card -> Ask Pharmacist
              _HelpCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AskPharmacistScreen()),
                  );
                },
              ),

              const SizedBox(height: 16),

              // TWO SERVICE CARDS with images
              Row(
                children: [
                  Expanded(
                    child: _ServiceCard(
                      title: 'Pharmacy',
                      subtitle: 'Order medicines quickly',
                      imageAsset: 'assets/images/pharmacy_care.png',
                      onTap: () {
                        final items = productsByCategory['Digestive Health'] ??
                            const <Product>[];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryProductsScreen(
                              title: 'Pharmacy',
                              products: items,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ServiceCard(
                      title: 'Consult Doctor',
                      subtitle: 'Talk to qualified doctors anytime',
                      imageAsset: 'assets/images/consult_doctor.png',
                      onTap: () {
                        // ✅ Opens dedicated Consult Doctor page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ConsultDoctorScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                'Leading Categories',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),

              _CategoriesGrid(
                categories: const [
                  CategoryItem(
                      title: 'Skin Care',
                      imageAsset: 'assets/images/skin_care.png'),
                  CategoryItem(
                      title: 'Men Care',
                      imageAsset: 'assets/images/men_care.png'),
                  CategoryItem(
                      title: 'Pain Relief',
                      imageAsset: 'assets/images/pain_relief.png'),
                  CategoryItem(
                      title: 'Cardiac Care',
                      imageAsset: 'assets/images/cardiac_care.png'),
                  CategoryItem(
                      title: 'Digestive Health',
                      imageAsset: 'assets/images/digestive_care.png'),
                  CategoryItem(
                      title: 'Fitness Supplements',
                      imageAsset: 'assets/images/fitness_care.png',
                      badge: 'New'),
                  CategoryItem(
                      title: 'Diabetes Care',
                      imageAsset: 'assets/images/diabetes_care.png'),
                  CategoryItem(
                      title: 'Hair Care',
                      imageAsset: 'assets/images/hair_care.png',
                      badge: 'Trending'),
                ],
                onCategoryTap: (category) {
                  final list =
                      productsByCategory[category.title] ?? const <Product>[];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryProductsScreen(
                        title: category.title,
                        products: list,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Payday Sale
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/payday_sale.png',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ----------------------------- Help Card ------------------------------ */

class _HelpCard extends StatelessWidget {
  final VoidCallback? onTap;
  const _HelpCard({this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.secondaryContainer.withOpacity(0.4),
      borderRadius: BorderRadius.circular(20),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: cs.onSecondaryContainer.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.medical_services_outlined, color: cs.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Not Sure What to Get?',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(
                      'Describe your symptoms and get a recommendation.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withOpacity(0.8),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------------------- Service Card ---------------------------- */

class _ServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageAsset;
  final VoidCallback? onTap;

  const _ServiceCard({
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surface,
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant.withOpacity(0.6)),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Positioned(
                right: 8,
                bottom: 44,
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: Image.asset(imageAsset, fit: BoxFit.contain),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFCECEC),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    subtitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                      color: Color(0xFFB55555),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* -------------------------- Categories Section ------------------------ */

class CategoryItem {
  final String title;
  final String? imageAsset;
  final String? badge;

  const CategoryItem({required this.title, this.imageAsset, this.badge});
}

class _CategoriesGrid extends StatelessWidget {
  final List<CategoryItem> categories;
  final void Function(CategoryItem) onCategoryTap;

  const _CategoriesGrid({
    required this.categories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GridView.builder(
      padding: const EdgeInsets.only(top: 4),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final item = categories[index];
        return _CategoryCard(
          item: item,
          onTap: () => onCategoryTap(item),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryItem item;
  final VoidCallback onTap;

  const _CategoryCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant.withOpacity(0.6)),
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0E9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: item.imageAsset != null
                      ? Image.asset(item.imageAsset!, fit: BoxFit.contain)
                      : Icon(Icons.category_outlined,
                          size: 48, color: cs.primary),
                ),
              ),
              if (item.badge != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9361).withOpacity(0.25),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item.badge!,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFCC5C2E),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
                child: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
