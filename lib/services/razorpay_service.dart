import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late Razorpay _razorpay;

  void init({
    required Function(String) onSuccess,
    required Function(String) onError,
    required Function() onExternalWallet,
  }) {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        (PaymentSuccessResponse res) => onSuccess(res.paymentId!));

    _razorpay.on(
        Razorpay.EVENT_PAYMENT_ERROR,
        (PaymentFailureResponse res) =>
            onError(res.message ?? 'Payment failed'));

    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (_) => onExternalWallet());
  }

  void openCheckout({
    required int amount,
    required String name,
    required String description,
    required String email,
    required String phone,
  }) {
    _razorpay.open({
      'key': 'YOUR_RAZORPAY_KEY_ID',
      'amount': amount * 100, // paise
      'name': name,
      'description': description,
      'prefill': {
        'email': email,
        'contact': phone,
      },
    });
  }

  void dispose() {
    _razorpay.clear();
  }
}
