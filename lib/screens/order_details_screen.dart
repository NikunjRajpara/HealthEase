import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/order_item.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;
  final DateTime orderDate;
  final String paymentMethod;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;

  /// Existing constructor (DO NOT BREAK)
  const OrderDetailsScreen({
    super.key,
    required this.orderId,
    required this.orderDate,
    required this.paymentMethod,
    required this.items,
    required this.totalAmount,
    this.status = 'Confirmed',
  });

  /// ✅ NEW: Constructor that accepts OrderModel
  factory OrderDetailsScreen.fromOrder(OrderModel order) {
    return OrderDetailsScreen(
      orderId: order.id,
      orderDate: order.date,
      paymentMethod: order.paymentMethod,
      items: order.items,
      totalAmount: order.total,
      status: order.status,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---------------- ORDER SUMMARY ----------------
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('Order ID', orderId),
                  const SizedBox(height: 8),
                  _infoRow(
                    'Order Date',
                    '${orderDate.day}/${orderDate.month}/${orderDate.year} '
                        '${orderDate.hour}:${orderDate.minute.toString().padLeft(2, '0')}',
                  ),
                  const SizedBox(height: 8),
                  _infoRow('Payment Method', paymentMethod),
                  const SizedBox(height: 8),
                  _infoRow('Status', status, valueColor: Colors.green),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ---------------- ITEMS ----------------
          Text(
            'Items',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => Divider(color: Colors.grey.shade200),
              itemBuilder: (context, i) {
                final item = items[i];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      Text('x${item.qty}'),
                      const SizedBox(width: 12),
                      Text(
                        '₹${(item.price * item.qty).toStringAsFixed(0)}',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // ---------------- TOTAL ----------------
          Card(
            elevation: 0,
            color: Colors.grey.shade100,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Amount', style: theme.textTheme.titleMedium),
                  Text(
                    '₹${totalAmount.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.black54)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
