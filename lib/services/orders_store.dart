import 'package:flutter/foundation.dart';
import '../models/order_model.dart';

class OrdersStore extends ChangeNotifier {
  OrdersStore._();
  static final OrdersStore instance = OrdersStore._();

  final List<OrderModel> _orders = [];

  // Read-only list for UI
  List<OrderModel> get orders => List.unmodifiable(_orders);

  // Add new order (latest on top)
  void addOrder(OrderModel order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  // Optional: clear orders (for logout/testing)
  void clear() {
    _orders.clear();
    notifyListeners();
  }
}
