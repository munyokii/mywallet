import 'package:flutter/material.dart';

class PayTheBillPage extends StatefulWidget {
  const PayTheBillPage({super.key});

  @override
  _PayTheBillPageState createState() => _PayTheBillPageState();
}

class _PayTheBillPageState extends State<PayTheBillPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _billNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  
  String _selectedBillType = 'Electricity';
  bool isProcessing = false;
  
  final Map<String, IconData> _billIcons = {
    'Electricity': Icons.lightbulb_outline,
    'Water': Icons.water_drop_outlined,
    'Internet': Icons.wifi,
    'Rent': Icons.home_outlined,
    'Gas': Icons.local_fire_department_outlined,
  };

  @override
  void dispose() {
    _billNumberController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _handlePayBill() {
    FocusScope.of(context).unfocus();

    // 2. Validate Form
    if (_formKey.currentState!.validate()) {
      setState(() => isProcessing = true);

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => isProcessing = false);
          
          // Success Message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                    child: Icon(_billIcons[_selectedBillType], color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Payment Successful', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Paid \$${_amountController.text} for $_selectedBillType'),
                      ],
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
          
          _billNumberController.clear();
          _amountController.clear();
        }
      });
    } else {
      // Error Message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fix the errors in red'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Pay Bill', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.orangeAccent),
            onPressed: () {
              // QR Scan Logic
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
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
                  const Text("Saved Bills", style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  _buildSavedBillsList(),
                  const SizedBox(height: 30),
                  
                  const Text("New Payment", style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  // 1. Bill Type Dropdown
                  _buildDropdownField(),
                  const SizedBox(height: 20),

                  // 2. Bill Number Input
                  _buildTextField(
                    controller: _billNumberController,
                    label: 'Bill / Customer ID',
                    icon: Icons.receipt_long,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Bill number is required';
                      if (value.trim().length < 5) return 'Bill number too short';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // 3. Amount Input
                  _buildTextField(
                    controller: _amountController,
                    label: 'Amount',
                    icon: Icons.attach_money,
                    isNumber: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Please enter an amount';
                      final number = double.tryParse(value);
                      if (number == null) return 'Invalid amount';
                      if (number <= 0) return 'Amount must be greater than 0';
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 40),
                  _buildPayButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildSavedBillsList() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildSavedBillItem("Home WiFi", Icons.wifi, Colors.purpleAccent),
          _buildSavedBillItem("Electricity", Icons.lightbulb, Colors.yellowAccent),
          _buildSavedBillItem("Office Water", Icons.water_drop, Colors.blueAccent),
          // Pass isAdd: true for the last item
          _buildSavedBillItem("Add New", Icons.add, Colors.white54, isAdd: true),
        ],
      ),
    );
  }

  Widget _buildSavedBillItem(String title, IconData icon, Color color, {bool isAdd = false}) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isAdd ? Colors.white.withOpacity(0.05) : color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              // FIX: Changed BorderStyle.dashed to BorderStyle.solid
              border: isAdd ? Border.all(color: Colors.white24, width: 1, style: BorderStyle.solid) : null,
            ),
            child: Icon(icon, color: isAdd ? Colors.white : color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            title, 
            style: const TextStyle(color: Colors.white70, fontSize: 12), 
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedBillType,
      dropdownColor: const Color(0xFF0A1931),
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.orangeAccent),
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        labelText: "Bill Type",
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        prefixIcon: Icon(_billIcons[_selectedBillType], color: Colors.orangeAccent),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.orangeAccent),
        ),
      ),
      items: _billIcons.keys.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Row(
            children: [
              Text(value),
            ],
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedBillType = newValue!;
        });
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.orangeAccent,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.orangeAccent),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.orangeAccent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isProcessing ? null : _handlePayBill,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orangeAccent,
          disabledBackgroundColor: Colors.orangeAccent.withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 5,
          shadowColor: Colors.orangeAccent.withOpacity(0.4),
        ),
        child: isProcessing 
          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
          : const Text(
              'Pay Bill',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
      ),
    );
  }
}