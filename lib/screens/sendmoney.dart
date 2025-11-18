import 'package:flutter/material.dart';
import 'package:mywallet/screens/pages/account.dart';

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({super.key});

  @override
  _SendMoneyPageState createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<AccountAndCardPage> {
  // Form Key for validation
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String? paymentMethod;
  bool isFavorite = false; // Toggle state

  // Function to validate and navigate
  void _processTransaction() {
    if (_formKey.currentState!.validate()) {
      // Hide keyboard
      FocusScope.of(context).unfocus();
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionConfirmationPage(
            recipient: _recipientController.text,
            amount: double.parse(_amountController.text),
            paymentMethod: paymentMethod!,
            isFavorite: isFavorite,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fix the errors above'),
          backgroundColor: Colors.redAccent.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Send Money', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade900, const Color(0xFF0A1931)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Who are you sending to?",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  
                  // 1. Recipient Input
                  _buildTextField(
                    controller: _recipientController,
                    label: 'Recipient Name or ID',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Recipient is required';
                      if (value.length < 3) return 'Name must be at least 3 characters';
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  const Text(
                    "How much?",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 10),

                  // 2. Amount Input
                  _buildTextField(
                    controller: _amountController,
                    label: 'Amount',
                    icon: Icons.attach_money,
                    isNumber: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Amount is required';
                      final n = double.tryParse(value);
                      if (n == null) return 'Please enter a valid number';
                      if (n <= 0) return 'Amount must be greater than 0';
                      if (n > 10000) return 'Daily limit is \$10,000';
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 10),
                  _buildQuickAmounts(), // Quick chips

                  const SizedBox(height: 24),

                  // 3. Payment Method Dropdown
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.blue.shade900, // Dark menu background
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('Payment Method', Icons.payment),
                    value: paymentMethod,
                    items: const [
                      DropdownMenuItem(value: 'Bank Account', child: Text('Bank Account (...9018)')),
                      DropdownMenuItem(value: 'Mobile Wallet', child: Text('Mobile Wallet')),
                      DropdownMenuItem(value: 'Credit Card', child: Text('Visa (...4421)')),
                    ],
                    onChanged: (value) => setState(() => paymentMethod = value),
                    validator: (value) => value == null ? 'Please select a payment method' : null,
                  ),

                  const SizedBox(height: 24),

                  // 4. Favorite Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: SwitchListTile(
                      activeColor: Colors.orangeAccent,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      title: const Text(
                        "Save as Favorite",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text(
                        "Save for faster payments next time",
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      value: isFavorite,
                      onChanged: (bool value) {
                        setState(() {
                          isFavorite = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 5. Proceed Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _processTransaction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Proceed to Confirm',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper for Quick Amount Chips
  Widget _buildQuickAmounts() {
    return Row(
      children: [50, 100, 200, 500].map((amount) {
        return GestureDetector(
          onTap: () => _amountController.text = amount.toString(),
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
            ),
            child: Text(
              "\$$amount",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Helper for TextFields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white), // Input text color
      cursorColor: Colors.orangeAccent,
      validator: validator,
      decoration: _inputDecoration(label, icon),
    );
  }

  // Shared Input Decoration Style
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white60),
      prefixIcon: Icon(icon, color: Colors.orangeAccent),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05), // Glassmorphism
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.orangeAccent),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}

// --- CONFIRMATION PAGE ---

class TransactionConfirmationPage extends StatelessWidget {
  final String recipient;
  final double amount;
  final String paymentMethod;
  final bool isFavorite;

  const TransactionConfirmationPage({
    Key? key,
    required this.recipient,
    required this.amount,
    required this.paymentMethod,
    required this.isFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1931),
      appBar: AppBar(
        title: const Text('Confirm Transaction', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Receipt Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                   const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white10,
                    child: Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 30),
                  ),
                  const SizedBox(height: 16),
                  const Text("Sending", style: TextStyle(color: Colors.white54)),
                  const SizedBox(height: 8),
                  Text(
                    "\$${amount.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  
                  _buildDetailRow("To", recipient),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: Colors.white24)),
                  _buildDetailRow("Payment Method", paymentMethod),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: Colors.white24)),
                  _buildDetailRow("Transaction Fee", "\$2.00"),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: Colors.white24)),
                  _buildDetailRow(
                    "Favorite", 
                    isFavorite ? "Yes" : "No", 
                    color: isFavorite ? Colors.orangeAccent : Colors.white54
                  ),
                ],
              ),
            ),
            
            const Spacer(),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Money Sent Successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Confirm & Send', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 14)),
        Text(value, style: TextStyle(color: color ?? Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }
}