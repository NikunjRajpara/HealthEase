import 'package:flutter/material.dart';

// screens
import 'category_products_screen.dart';
import 'ask_pharmacist_screen.dart';
import 'consult_doctor_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/orders_screen.dart';

// models & services
import '../models/product.dart';
import '../services/cart_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CartService cart = CartService.instance;

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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // ---------------- FULL CATEGORY PRODUCT MAP ----------------
    final Map<String, List<Product>> productsByCategory = {
      'Skin Care': const [
        Product(
          name: 'Cetaphil Gentle Cleanser',
          quantity: '200 ml Bottle',
          price: 245,
          mrp: 280,
          discount: 12,
          imageAsset: 'assets/images/skin_care.png',
        ),
        Product(
          name: 'Cetaphil Gentle Cleanser',
          quantity: '200 ml Bottle',
          price: 245,
          mrp: 280,
          discount: 12,
          imageAsset: 'assets/images/skin_care.png',
        ),
        Product(
          name: 'Cetaphil Gentle Cleanser',
          quantity: '200 ml Bottle',
          price: 245,
          mrp: 280,
          discount: 12,
          imageAsset: 'assets/images/skin_care.png',
        ),
        Product(
          name: 'Cetaphil Gentle Cleanser',
          quantity: '200 ml Bottle',
          price: 245,
          mrp: 280,
          discount: 12,
          imageAsset: 'assets/images/skin_care.png',
        ),
        Product(
          name: 'Cetaphil Gentle Cleanser',
          quantity: '200 ml Bottle',
          price: 245,
          mrp: 280,
          discount: 12,
          imageAsset: 'assets/images/skin_care.png',
        ),
        Product(
          name: 'Cetaphil Gentle Cleanser',
          quantity: '200 ml Bottle',
          price: 245,
          mrp: 280,
          discount: 12,
          imageAsset: 'assets/images/skin_care.png',
        ),
        Product(
          name: 'Cetaphil Gentle Cleanser',
          quantity: '200 ml Bottle',
          price: 245,
          mrp: 280,
          discount: 12,
          imageAsset: 'assets/images/skin_care.png',
        ),
        Product(
          name: 'Cetaphil Gentle Cleanser',
          quantity: '200 ml Bottle',
          price: 245,
          mrp: 280,
          discount: 12,
          imageAsset: 'assets/images/skin_care.png',
        ),
        Product(
          name: 'Cetaphil Gentle Cleanser',
          quantity: '200 ml Bottle',
          price: 245,
          mrp: 280,
          discount: 12,
          imageAsset: 'assets/images/skin_care.png',
        ),
        Product(
          name: 'Cetaphil Gentle Cleanser',
          quantity: '200 ml Bottle',
          price: 245,
          mrp: 280,
          discount: 12,
          imageAsset: 'assets/images/skin_care.png',
        ),
      ],
      'Men Care': const [
        Product(
          name: 'Gillette Fusion5 Blades',
          quantity: 'Pack of 4',
          price: 799,
          mrp: 899,
          discount: 11,
          imageAsset: 'assets/images/men_care.png',
        ),
        Product(
          name: 'Gillette Fusion5 Blades',
          quantity: 'Pack of 4',
          price: 799,
          mrp: 899,
          discount: 11,
          imageAsset: 'assets/images/men_care.png',
        ),
        Product(
          name: 'Gillette Fusion5 Blades',
          quantity: 'Pack of 4',
          price: 799,
          mrp: 899,
          discount: 11,
          imageAsset: 'assets/images/men_care.png',
        ),
        Product(
          name: 'Gillette Fusion5 Blades',
          quantity: 'Pack of 4',
          price: 799,
          mrp: 899,
          discount: 11,
          imageAsset: 'assets/images/men_care.png',
        ),
        Product(
          name: 'Gillette Fusion5 Blades',
          quantity: 'Pack of 4',
          price: 799,
          mrp: 899,
          discount: 11,
          imageAsset: 'assets/images/men_care.png',
        ),
        Product(
          name: 'Gillette Fusion5 Blades',
          quantity: 'Pack of 4',
          price: 799,
          mrp: 899,
          discount: 11,
          imageAsset: 'assets/images/men_care.png',
        ),
        Product(
          name: 'Gillette Fusion5 Blades',
          quantity: 'Pack of 4',
          price: 799,
          mrp: 899,
          discount: 11,
          imageAsset: 'assets/images/men_care.png',
        ),
        Product(
          name: 'Gillette Fusion5 Blades',
          quantity: 'Pack of 4',
          price: 799,
          mrp: 899,
          discount: 11,
          imageAsset: 'assets/images/men_care.png',
        ),
        Product(
          name: 'Gillette Fusion5 Blades',
          quantity: 'Pack of 4',
          price: 799,
          mrp: 899,
          discount: 11,
          imageAsset: 'assets/images/men_care.png',
        ),
        Product(
          name: 'Gillette Fusion5 Blades',
          quantity: 'Pack of 4',
          price: 799,
          mrp: 899,
          discount: 11,
          imageAsset: 'assets/images/men_care.png',
        ),
      ],
      'Pain Relief': const [
        Product(
          name: 'Saridon',
          quantity: 'Strip of 10 Tablets',
          price: 35,
          mrp: 40,
          discount: 13,
          imageAsset: 'assets/images/pain_relief.png',
        ),
        Product(
          name: 'Saridon',
          quantity: 'Strip of 10 Tablets',
          price: 35,
          mrp: 40,
          discount: 13,
          imageAsset: 'assets/images/pain_relief.png',
        ),
        Product(
          name: 'Saridon',
          quantity: 'Strip of 10 Tablets',
          price: 35,
          mrp: 40,
          discount: 13,
          imageAsset: 'assets/images/pain_relief.png',
        ),
        Product(
          name: 'Saridon',
          quantity: 'Strip of 10 Tablets',
          price: 35,
          mrp: 40,
          discount: 13,
          imageAsset: 'assets/images/pain_relief.png',
        ),
        Product(
          name: 'Saridon',
          quantity: 'Strip of 10 Tablets',
          price: 35,
          mrp: 40,
          discount: 13,
          imageAsset: 'assets/images/pain_relief.png',
        ),
        Product(
          name: 'Saridon',
          quantity: 'Strip of 10 Tablets',
          price: 35,
          mrp: 40,
          discount: 13,
          imageAsset: 'assets/images/pain_relief.png',
        ),
        Product(
          name: 'Saridon',
          quantity: 'Strip of 10 Tablets',
          price: 35,
          mrp: 40,
          discount: 13,
          imageAsset: 'assets/images/pain_relief.png',
        ),
        Product(
          name: 'Saridon',
          quantity: 'Strip of 10 Tablets',
          price: 35,
          mrp: 40,
          discount: 13,
          imageAsset: 'assets/images/pain_relief.png',
        ),
        Product(
          name: 'Saridon',
          quantity: 'Strip of 10 Tablets',
          price: 35,
          mrp: 40,
          discount: 13,
          imageAsset: 'assets/images/pain_relief.png',
        ),
        Product(
          name: 'Saridon',
          quantity: 'Strip of 10 Tablets',
          price: 35,
          mrp: 40,
          discount: 13,
          imageAsset: 'assets/images/pain_relief.png',
        ),
      ],
      'Cardiac Care': const [
        Product(
          name: 'Cod Liver Oil',
          quantity: '60 Capsules',
          price: 299,
          mrp: 360,
          discount: 17,
          imageAsset: 'assets/images/cardiac_care.png',
        ),
        Product(
          name: 'Cod Liver Oil',
          quantity: '60 Capsules',
          price: 299,
          mrp: 360,
          discount: 17,
          imageAsset: 'assets/images/cardiac_care.png',
        ),
        Product(
          name: 'Cod Liver Oil',
          quantity: '60 Capsules',
          price: 299,
          mrp: 360,
          discount: 17,
          imageAsset: 'assets/images/cardiac_care.png',
        ),
        Product(
          name: 'Cod Liver Oil',
          quantity: '60 Capsules',
          price: 299,
          mrp: 360,
          discount: 17,
          imageAsset: 'assets/images/cardiac_care.png',
        ),
        Product(
          name: 'Cod Liver Oil',
          quantity: '60 Capsules',
          price: 299,
          mrp: 360,
          discount: 17,
          imageAsset: 'assets/images/cardiac_care.png',
        ),
        Product(
          name: 'Cod Liver Oil',
          quantity: '60 Capsules',
          price: 299,
          mrp: 360,
          discount: 17,
          imageAsset: 'assets/images/cardiac_care.png',
        ),
        Product(
          name: 'Cod Liver Oil',
          quantity: '60 Capsules',
          price: 299,
          mrp: 360,
          discount: 17,
          imageAsset: 'assets/images/cardiac_care.png',
        ),
        Product(
          name: 'Cod Liver Oil',
          quantity: '60 Capsules',
          price: 299,
          mrp: 360,
          discount: 17,
          imageAsset: 'assets/images/cardiac_care.png',
        ),
        Product(
          name: 'Cod Liver Oil',
          quantity: '60 Capsules',
          price: 299,
          mrp: 360,
          discount: 17,
          imageAsset: 'assets/images/cardiac_care.png',
        ),
        Product(
          name: 'Cod Liver Oil',
          quantity: '60 Capsules',
          price: 299,
          mrp: 360,
          discount: 17,
          imageAsset: 'assets/images/cardiac_care.png',
        ),
        Product(
          name: 'Cod Liver Oil',
          quantity: '60 Capsules',
          price: 299,
          mrp: 360,
          discount: 17,
          imageAsset: 'assets/images/cardiac_care.png',
        ),
      ],
      'Digestive Health': const [
        Product(
          name: 'ENO Lemon',
          quantity: 'Pack of 6',
          price: 85,
          mrp: 95,
          discount: 11,
          imageAsset: 'assets/images/digestive_care.png',
        ),
        Product(
          name: 'ENO Lemon',
          quantity: 'Pack of 6',
          price: 85,
          mrp: 95,
          discount: 11,
          imageAsset: 'assets/images/digestive_care.png',
        ),
        Product(
          name: 'ENO Lemon',
          quantity: 'Pack of 6',
          price: 85,
          mrp: 95,
          discount: 11,
          imageAsset: 'assets/images/digestive_care.png',
        ),
        Product(
          name: 'ENO Lemon',
          quantity: 'Pack of 6',
          price: 85,
          mrp: 95,
          discount: 11,
          imageAsset: 'assets/images/digestive_care.png',
        ),
        Product(
          name: 'ENO Lemon',
          quantity: 'Pack of 6',
          price: 85,
          mrp: 95,
          discount: 11,
          imageAsset: 'assets/images/digestive_care.png',
        ),
        Product(
          name: 'ENO Lemon',
          quantity: 'Pack of 6',
          price: 85,
          mrp: 95,
          discount: 11,
          imageAsset: 'assets/images/digestive_care.png',
        ),
        Product(
          name: 'ENO Lemon',
          quantity: 'Pack of 6',
          price: 85,
          mrp: 95,
          discount: 11,
          imageAsset: 'assets/images/digestive_care.png',
        ),
        Product(
          name: 'ENO Lemon',
          quantity: 'Pack of 6',
          price: 85,
          mrp: 95,
          discount: 11,
          imageAsset: 'assets/images/digestive_care.png',
        ),
        Product(
          name: 'ENO Lemon',
          quantity: 'Pack of 6',
          price: 85,
          mrp: 95,
          discount: 11,
          imageAsset: 'assets/images/digestive_care.png',
        ),
        Product(
          name: 'ENO Lemon',
          quantity: 'Pack of 6',
          price: 85,
          mrp: 95,
          discount: 11,
          imageAsset: 'assets/images/digestive_care.png',
        ),
      ],
      'Fitness Supplements': const [
        Product(
          name: 'Whey Protein',
          quantity: '1 kg Jar',
          price: 1899,
          mrp: 2299,
          discount: 17,
          imageAsset: 'assets/images/fitness_care.png',
        ),
        Product(
          name: 'Whey Protein',
          quantity: '1 kg Jar',
          price: 1899,
          mrp: 2299,
          discount: 17,
          imageAsset: 'assets/images/fitness_care.png',
        ),
        Product(
          name: 'Whey Protein',
          quantity: '1 kg Jar',
          price: 1899,
          mrp: 2299,
          discount: 17,
          imageAsset: 'assets/images/fitness_care.png',
        ),
        Product(
          name: 'Whey Protein',
          quantity: '1 kg Jar',
          price: 1899,
          mrp: 2299,
          discount: 17,
          imageAsset: 'assets/images/fitness_care.png',
        ),
        Product(
          name: 'Whey Protein',
          quantity: '1 kg Jar',
          price: 1899,
          mrp: 2299,
          discount: 17,
          imageAsset: 'assets/images/fitness_care.png',
        ),
        Product(
          name: 'Whey Protein',
          quantity: '1 kg Jar',
          price: 1899,
          mrp: 2299,
          discount: 17,
          imageAsset: 'assets/images/fitness_care.png',
        ),
        Product(
          name: 'Whey Protein',
          quantity: '1 kg Jar',
          price: 1899,
          mrp: 2299,
          discount: 17,
          imageAsset: 'assets/images/fitness_care.png',
        ),
        Product(
          name: 'Whey Protein',
          quantity: '1 kg Jar',
          price: 1899,
          mrp: 2299,
          discount: 17,
          imageAsset: 'assets/images/fitness_care.png',
        ),
        Product(
          name: 'Whey Protein',
          quantity: '1 kg Jar',
          price: 1899,
          mrp: 2299,
          discount: 17,
          imageAsset: 'assets/images/fitness_care.png',
        ),
        Product(
          name: 'Whey Protein',
          quantity: '1 kg Jar',
          price: 1899,
          mrp: 2299,
          discount: 17,
          imageAsset: 'assets/images/fitness_care.png',
        ),
      ],
      'Diabetes Care': const [
        Product(
          name: 'Glucometer Strips',
          quantity: 'Pack of 50',
          price: 549,
          mrp: 699,
          discount: 21,
          imageAsset: 'assets/images/diabetes_care.png',
        ),
        Product(
          name: 'Glucometer Strips',
          quantity: 'Pack of 50',
          price: 549,
          mrp: 699,
          discount: 21,
          imageAsset: 'assets/images/diabetes_care.png',
        ),
        Product(
          name: 'Glucometer Strips',
          quantity: 'Pack of 50',
          price: 549,
          mrp: 699,
          discount: 21,
          imageAsset: 'assets/images/diabetes_care.png',
        ),
        Product(
          name: 'Glucometer Strips',
          quantity: 'Pack of 50',
          price: 549,
          mrp: 699,
          discount: 21,
          imageAsset: 'assets/images/diabetes_care.png',
        ),
        Product(
          name: 'Glucometer Strips',
          quantity: 'Pack of 50',
          price: 549,
          mrp: 699,
          discount: 21,
          imageAsset: 'assets/images/diabetes_care.png',
        ),
        Product(
          name: 'Glucometer Strips',
          quantity: 'Pack of 50',
          price: 549,
          mrp: 699,
          discount: 21,
          imageAsset: 'assets/images/diabetes_care.png',
        ),
        Product(
          name: 'Glucometer Strips',
          quantity: 'Pack of 50',
          price: 549,
          mrp: 699,
          discount: 21,
          imageAsset: 'assets/images/diabetes_care.png',
        ),
        Product(
          name: 'Glucometer Strips',
          quantity: 'Pack of 50',
          price: 549,
          mrp: 699,
          discount: 21,
          imageAsset: 'assets/images/diabetes_care.png',
        ),
        Product(
          name: 'Glucometer Strips',
          quantity: 'Pack of 50',
          price: 549,
          mrp: 699,
          discount: 21,
          imageAsset: 'assets/images/diabetes_care.png',
        ),
        Product(
          name: 'Glucometer Strips',
          quantity: 'Pack of 50',
          price: 549,
          mrp: 699,
          discount: 21,
          imageAsset: 'assets/images/diabetes_care.png',
        ),
      ],
      'Hair Care': const [
        Product(
          name: 'Anti-Dandruff Shampoo',
          quantity: '180 ml Bottle',
          price: 169,
          mrp: 199,
          discount: 15,
          imageAsset: 'assets/images/hair_care.png',
        ),
        Product(
          name: 'Anti-Dandruff Shampoo',
          quantity: '180 ml Bottle',
          price: 169,
          mrp: 199,
          discount: 15,
          imageAsset: 'assets/images/hair_care.png',
        ),
        Product(
          name: 'Anti-Dandruff Shampoo',
          quantity: '180 ml Bottle',
          price: 169,
          mrp: 199,
          discount: 15,
          imageAsset: 'assets/images/hair_care.png',
        ),
        Product(
          name: 'Anti-Dandruff Shampoo',
          quantity: '180 ml Bottle',
          price: 169,
          mrp: 199,
          discount: 15,
          imageAsset: 'assets/images/hair_care.png',
        ),
        Product(
          name: 'Anti-Dandruff Shampoo',
          quantity: '180 ml Bottle',
          price: 169,
          mrp: 199,
          discount: 15,
          imageAsset: 'assets/images/hair_care.png',
        ),
        Product(
          name: 'Anti-Dandruff Shampoo',
          quantity: '180 ml Bottle',
          price: 169,
          mrp: 199,
          discount: 15,
          imageAsset: 'assets/images/hair_care.png',
        ),
        Product(
          name: 'Anti-Dandruff Shampoo',
          quantity: '180 ml Bottle',
          price: 169,
          mrp: 199,
          discount: 15,
          imageAsset: 'assets/images/hair_care.png',
        ),
        Product(
          name: 'Anti-Dandruff Shampoo',
          quantity: '180 ml Bottle',
          price: 169,
          mrp: 199,
          discount: 15,
          imageAsset: 'assets/images/hair_care.png',
        ),
        Product(
          name: 'Anti-Dandruff Shampoo',
          quantity: '180 ml Bottle',
          price: 169,
          mrp: 199,
          discount: 15,
          imageAsset: 'assets/images/hair_care.png',
        ),
        Product(
          name: 'Anti-Dandruff Shampoo',
          quantity: '180 ml Bottle',
          price: 169,
          mrp: 199,
          discount: 15,
          imageAsset: 'assets/images/hair_care.png',
        ),
      ],
    };

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('HealthEase'),
        actions: [
          // ---------------- CART WITH BADGE ----------------
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              if (cart.totalCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${cart.totalCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // ---------------- ORDERS ----------------
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrdersScreen()),
              );
            },
          ),
        ],
      ),

      // ---------------- BODY ----------------
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- GIF BANNER ----------------
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

              // ---------------- ASK PHARMACIST ----------------
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

              // ---------------- SERVICES ----------------
              Row(
                children: [
                  Expanded(
                    child: _ServiceCard(
                      title: 'Pharmacy',
                      subtitle: 'Order medicines quickly',
                      imageAsset: 'assets/images/pharmacy_care.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryProductsScreen(
                              title: 'Pharmacy',
                              products:
                                  productsByCategory['Digestive Health'] ?? [],
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

              // ---------------- CATEGORIES ----------------
              Text(
                'Leading Categories',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
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
                      imageAsset: 'assets/images/fitness_care.png'),
                  CategoryItem(
                      title: 'Diabetes Care',
                      imageAsset: 'assets/images/diabetes_care.png'),
                  CategoryItem(
                      title: 'Hair Care',
                      imageAsset: 'assets/images/hair_care.png'),
                ],
                onCategoryTap: (category) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryProductsScreen(
                        title: category.title,
                        products:
                            productsByCategory[category.title] ?? const [],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // ---------------- PAYDAY SALE ----------------
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

/* -------------------------------------------------------------------------- */
/*                               SUPPORT WIDGETS                               */
/* -------------------------------------------------------------------------- */

class CategoryItem {
  final String title;
  final String imageAsset;
  const CategoryItem({required this.title, required this.imageAsset});
}

class _HelpCard extends StatelessWidget {
  final VoidCallback onTap;
  const _HelpCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.secondaryContainer.withOpacity(0.4),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: const [
              Icon(Icons.medical_services_outlined),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Not sure what to buy?\nDescribe your symptoms',
                  maxLines: 2,
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageAsset;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Image.asset(imageAsset, height: 60),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle,
                  style: TextStyle(color: Theme.of(context).hintColor)),
            ],
          ),
        ),
      ),
    );
  }
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (_, i) {
        final c = categories[i];
        return GestureDetector(
          onTap: () => onCategoryTap(c),
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(c.imageAsset, height: 60),
                const SizedBox(height: 8),
                Text(c.title),
              ],
            ),
          ),
        );
      },
    );
  }
}
