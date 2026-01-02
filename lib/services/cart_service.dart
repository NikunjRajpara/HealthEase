import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int qty;

  CartItem({required this.product, this.qty = 1});

  double get lineTotal => product.price * qty;

  Map<String, dynamic> toJson() => {
        'name': product.name,
        'quantity': product.quantity,
        'price': product.price,
        'qty': qty,
        'image': product.imageAsset,
      };
}

class CartService extends ChangeNotifier {
  CartService._private();
  static final CartService instance = CartService._private();

  final Map<String, CartItem> _items = {};
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // -------------------- USER --------------------

  String? get userId => _auth.currentUser?.uid;

  bool get isLoggedIn => _auth.currentUser != null;

  // -------------------- CART GETTERS --------------------

  List<CartItem> get items => _items.values.toList();

  int get totalCount => _items.values.fold(0, (sum, item) => sum + item.qty);

  double get subtotal =>
      _items.values.fold(0.0, (sum, item) => sum + item.lineTotal);

  bool contains(Product p) => _items.containsKey(p.name);

  int quantityOf(Product p) => _items[p.name]?.qty ?? 0;

  // -------------------- CART ACTIONS --------------------

  void add(Product product, {int qty = 1}) {
    if (!isLoggedIn) return;

    final key = product.name;
    if (_items.containsKey(key)) {
      _items[key]!.qty += qty;
    } else {
      _items[key] = CartItem(product: product, qty: qty);
    }
    notifyListeners();
  }

  void updateQty(Product product, int qty) {
    if (!isLoggedIn) return;

    final key = product.name;
    if (!_items.containsKey(key)) return;

    if (qty <= 0) {
      _items.remove(key);
    } else {
      _items[key]!.qty = qty;
    }
    notifyListeners();
  }

  void remove(Product product) {
    final key = product.name;
    if (_items.remove(key) != null) {
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  // -------------------- ORDER LOGIC --------------------

  /// Creates an order payload (to be saved in Firestore)
  Map<String, dynamic> createOrderPayload() {
    return {
      'userId': userId,
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'totalItems': totalCount,
      'createdAt': DateTime.now().toIso8601String(),
      'status': 'PLACED',
      'paymentMethod': 'COD', // default, can be overridden
    };
  }

  /// Call this after successful payment / COD confirmation
  Future<Map<String, dynamic>> placeOrder({
    required String paymentMethod,
  }) async {
    if (!isLoggedIn || items.isEmpty) {
      throw Exception('User not logged in or cart empty');
    }

    final order = createOrderPayload()..['paymentMethod'] = paymentMethod;

    // 🔥 FUTURE (next step):
    // Save order to Firestore:
    // FirebaseFirestore.instance
    //   .collection('orders')
    //   .add(order);

    clear();
    return order;
  }

  // -------------------- AUTH SYNC --------------------

  /// Call this on logout
  void onUserLoggedOut() {
    clear();
  }
}
