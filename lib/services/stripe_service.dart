import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../constants.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePaymentWithCard({
    required double amount, // Change this to double
    required String currency,
    required Map<String, dynamic> paymentMethod,
  }) async {
    try {
      // Create a payment intent
      String? paymentIntentClientSecret =
          await _createPaymentIntent(amount, currency);
      if (paymentIntentClientSecret == null) return;

      // Confirm the payment intent with card details
      await Stripe.instance.confirmPayment(
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData.fromJson(paymentMethod),
        ),
        paymentIntentClientSecret: paymentIntentClientSecret,
      );

      // Handle payment success
      print('Payment successful!');
    } catch (e) {
      print(e);
    }
  }

  Future<String?> _createPaymentIntent(double amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        'amount': _calculateAmount(amount),
        'currency': currency,
      };
      var response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );
      if (response.data != null) {
        print(response.data);
        return response.data['client_secret'];
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  // Future<void> _processPayment() async {
  //   try{
  //     await Stripe.instance.presentPaymentSheet();
  //   }catch (e){
  //     print(e);
  //   }
  // }

  String _calculateAmount(double amount) {
    final calculatedAmount = (amount * 100).round();
    return calculatedAmount.toString();
  }
}
