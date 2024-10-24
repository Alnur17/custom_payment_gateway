import 'package:custom_payment_gateway/services/stripe_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() {
    return _PaymentScreenState();
  }
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _currencyController =
      TextEditingController(text: "usd");

  Map<String, dynamic>? paymentMethod;

  @override
  Widget build(BuildContext context) {
    // Detecting dark mode
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Payment Gateway'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Payment Information",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Enter Amount',
                  labelStyle: const TextStyle(color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.teal),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true), // Accept decimal values
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _currencyController,
                decoration: InputDecoration(
                  labelText: 'Enter Currency (e.g., usd)',
                  labelStyle: const TextStyle(color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.teal),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Card Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              CardFormField(
                style: CardFormStyle(
                  backgroundColor: Colors.teal,
                  textColor: Colors.white,
                  placeholderColor: Colors.white,
                  borderRadius: 8,
                ),
                onCardChanged: (card) {
                  paymentMethod = card?.toJson();
                },
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final amount = double.tryParse(
                        _amountController.text); // Parse as double
                    final currency = _currencyController.text;

                    if (amount != null &&
                        currency.isNotEmpty &&
                        paymentMethod != null) {
                      await StripeService.instance.makePaymentWithCard(
                        amount: amount,
                        currency: currency,
                        paymentMethod: paymentMethod!,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter valid details')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Make Payment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
