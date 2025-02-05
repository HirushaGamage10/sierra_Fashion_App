import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:stripe_payment/stripe_payment.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  double productTotal = 0.0;
  double shippingCost = 0.0;
  double finalTotal = 0.0;
  bool isLoading = true;
  bool isProcessingPayment = false;
  String? stripeToken;

  @override
  void initState() {
    super.initState();
    _fetchOrderSummary();
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: "pk_test_51QV38mFVKelcnDgXwVJcPyvWgOof6Fwph0BT1OrCQdZ3ale0lvf0z3TqTaofpKitZ2hujeQCOnCgZxCeFrLEI4gI00251N5tXX", // Replace with your Stripe publishable key
        merchantId: "Test",
        androidPayMode: 'test',
      ),
    );
  }

  Future<void> _fetchOrderSummary() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('https://sierrafashion.store/api/checkout'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            productTotal = data['productTotal'];
            shippingCost = data['shippingPrice'];
            finalTotal = data['finalTotal'];
            amountController.text = finalTotal.toString();
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load order summary. Please try again later.')),
          );
        }
      } catch (error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load order summary. Please try again later.')),
        );
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isProcessingPayment = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');

    if (token != null) {
      try {
        final paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest(),
        );

        final response = await http.post(
          Uri.parse('https://sierrafashion.store/api/process-payment'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'name': nameController.text,
            'email': emailController.text,
            'address': addressController.text,
            'city': cityController.text,
            'phone': phoneController.text,
            'postal_code': postalCodeController.text,
            'stripeToken': paymentMethod.id, // Use the generated Stripe token
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment processed successfully.')),
          );
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          final error = json.decode(response.body)['message'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to process payment: $error')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to process payment. Please try again later.')),
        );
      } finally {
        setState(() {
          isProcessingPayment = false;
        });
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontFamily: 'Poly',
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Shipping Details'),
                    const SizedBox(height: 10),
                    _buildTextField('Name', nameController),
                    _buildTextField('Email', emailController),
                    _buildTextField('Address', addressController),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('City', cityController)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildTextField('Postal Code', postalCodeController)),
                      ],
                    ),
                    _buildTextField('Phone Number', phoneController),
                    const SizedBox(height: 20),
                    _sectionTitle('Amount'),
                    _buildAmountField('Amount', amountController),
                    const SizedBox(height: 20),
                    _sectionTitle('Card Details'),
                    ElevatedButton(
                      onPressed: _processPayment,
                      child: Text('Enter Card Details'),
                    ),
                    const SizedBox(height: 20),
                    _sectionTitle('Order Summary'),
                    _buildOrderSummary(),
                    const SizedBox(height: 30),
                    _buildPlaceOrderButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildAmountField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        readOnly: true, // Make the amount field read-only
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _orderSummaryRow('Product Total', 'Rs $productTotal'),
            _orderSummaryRow('Shipping Cost', 'Rs $shippingCost'),
            const Divider(),
            _orderSummaryRow(
              'Final Total',
              'Rs $finalTotal',
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: isProcessingPayment ? null : _processPayment,
        child: isProcessingPayment
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : const Text(
                'Place Order',
                style: TextStyle(fontSize: 18),
              ),
      ),
    );
  }
}