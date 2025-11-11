import 'package:flutter/material.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({Key? key}) : super(key: key);

  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController amountController = TextEditingController();
  String? selectedPaymentMethod;
  bool isLoading = false; // Loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900, // Deep Blue Background
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900, // Deep Blue Theme
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Withdraw Funds',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _bankCard(), // Bank Balance Display
            const SizedBox(height: 30),

            // Amount Input Field
            const Text(
              'Enter Amount',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            _buildInputField(amountController, 'Enter amount to withdraw', Icons.attach_money),

            const SizedBox(height: 20),

            // Payment Method Dropdown
            const Text(
              'Choose Payment Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            _buildDropdown(),

            const SizedBox(height: 30),

            // Confirm Button
            Center(
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleWithdraw,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLoading ? Colors.grey : Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Confirm Withdrawal',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bank Card Display
  Widget _bankCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.blue.shade800, // Deep Blue Card
        border: Border.all(color: Colors.orangeAccent, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account Balance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 5),
          const Text(
            '\$3,469.52', // Example Balance
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Account No: 4756 •••• •••• 9018',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  'VISA',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Input Field Widget
  Widget _buildInputField(TextEditingController controller, String hintText, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.blue.shade800,
        prefixIcon: Icon(icon, color: Colors.orangeAccent),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Dropdown Widget
  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonFormField<String>(
        dropdownColor: Colors.blue.shade800,
        value: selectedPaymentMethod,
        items: const [
          DropdownMenuItem(value: 'Bank', child: Text('Bank Transfer', style: TextStyle(color: Colors.white))),
          DropdownMenuItem(value: 'Mpesa', child: Text('Mpesa', style: TextStyle(color: Colors.white))),
          DropdownMenuItem(value: 'PayPal', child: Text('PayPal', style: TextStyle(color: Colors.white))),
          DropdownMenuItem(value: 'Stripe', child: Text('Stripe', style: TextStyle(color: Colors.white))),
        ],
        onChanged: (value) {
          setState(() {
            selectedPaymentMethod = value;
          });
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.payment, color: Colors.orangeAccent),
          hintText: 'Select a method',
          hintStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // Handle Withdrawal Logic
  void _handleWithdraw() async {
    final String amount = amountController.text.trim();

    if (amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }

    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    // Simulate API Call (Withdrawal Processing)
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 3)); // Simulate network delay

    setState(() {
      isLoading = false;
    });

    // Fake response
    bool isSuccess = _processWithdrawal(amount, selectedPaymentMethod!);

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Withdrawal of \$$amount via $selectedPaymentMethod successful!'),
          backgroundColor: Colors.green,
        ),
      );
      amountController.clear();
      setState(() {
        selectedPaymentMethod = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Withdrawal failed. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Simulated Withdrawal API Response
  bool _processWithdrawal(String amount, String method) {
    if (amount == '0' || amount.isEmpty) {
      return false; // Invalid amount
    }
    return true; // Simulated success
  }
}