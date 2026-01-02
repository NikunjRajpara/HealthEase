class OrderItem {
  final String name;
  final int qty;
  final double price;

  const OrderItem({
    required this.name,
    required this.qty,
    required this.price,
  });

  // ---------------- FROM FIRESTORE ----------------
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      name: map['name'] as String,
      qty: (map['qty'] as num).toInt(),
      price: (map['price'] as num).toDouble(),
    );
  }

  // ---------------- TO FIRESTORE ----------------
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'qty': qty,
      'price': price,
    };
  }
}
