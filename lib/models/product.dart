// lib/models/product.dart
class Product {
  final String name;
  final String quantity;
  final double price;
  final double mrp;
  final int discount;
  final String imageAsset;

  const Product({
    required this.name,
    required this.quantity,
    required this.price,
    required this.mrp,
    required this.discount,
    required this.imageAsset,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'quantity': quantity,
        'price': price,
        'mrp': mrp,
        'discount': discount,
        'imageAsset': imageAsset,
      };
}
