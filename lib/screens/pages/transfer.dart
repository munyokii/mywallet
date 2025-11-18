import 'package:flutter/material.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  int _currentPage = 0;
  
  // Controllers
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  
  // State Variables
  String recipientName = '';
  String amount = '';
  bool isProcessing = false;

  @override
  void dispose() {
    _searchController.dispose();
    _amountController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  // Navigation Logic
  void _navigateToNextPage() {
    // Hide keyboard before transition
    FocusScope.of(context).unfocus();
    setState(() {
      if (_currentPage < 2) _currentPage++;
    });
  }

  void _navigateToPreviousPage() {
    setState(() {
      if (_currentPage > 0) _currentPage--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar allows the gradient to go behind the top bar
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentPage > 0 && _currentPage < 2
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: _navigateToPreviousPage,
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
        title: const Text(
          'Transfer Money',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade900, const Color(0xFF0A1931)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Step Progress Indicator (Only show on input/confirm steps)
              if (_currentPage < 2) _buildStepIndicator(),
              
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                  child: _buildPage(_currentPage),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS: PROGRESS INDICATOR ---

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _stepDot(0),
          _stepLine(),
          _stepDot(1),
          _stepLine(),
          _stepDot(2),
        ],
      ),
    );
  }

  Widget _stepDot(int index) {
    bool isActive = _currentPage >= index;
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isActive ? Colors.orangeAccent : Colors.white10,
        shape: BoxShape.circle,
        border: Border.all(color: isActive ? Colors.orangeAccent : Colors.white24),
      ),
      child: Center(
        child: isActive 
          ? const Icon(Icons.check, size: 16, color: Colors.black)
          : Text('${index + 1}', style: const TextStyle(color: Colors.white54)),
      ),
    );
  }

  Widget _stepLine() {
    return Container(
      width: 40,
      height: 2,
      color: Colors.white10,
    );
  }

  // --- PAGE ROUTING ---

  Widget _buildPage(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return _buildSearchScreen();
      case 1:
        return _buildConfirmationScreen();
      case 2:
        return _buildSuccessScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  // --- SCREEN 1: INPUT & VALIDATION ---

  Widget _buildSearchScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Who are you sending to?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          
          // Recent Contacts Horizontal Scroll
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildRecentContact('Add New', Icons.add),
                _buildRecentContact('Alice', Icons.person),
                _buildRecentContact('Bob', Icons.person),
                _buildRecentContact('Mom', Icons.favorite),
              ],
            ),
          ),
          const SizedBox(height: 30),

          _buildGlassTextField(
            controller: _searchController,
            label: 'Recipient Name / Phone',
            icon: Icons.search,
          ),
          const SizedBox(height: 20),

          _buildGlassTextField(
            controller: _amountController,
            label: 'Enter Amount',
            icon: Icons.attach_money,
            isNumber: true,
          ),
          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                // --- FORM VALIDATION LOGIC ---
                String nameInput = _searchController.text.trim();
                String amountInput = _amountController.text.trim();

                // 1. Recipient Validation
                if (nameInput.isEmpty) {
                  _showErrorSnackbar('Please enter a recipient name');
                  return;
                }
                if (nameInput.length < 3) {
                  _showErrorSnackbar('Recipient name must be at least 3 characters');
                  return;
                }

                // 2. Amount Validation
                if (amountInput.isEmpty) {
                  _showErrorSnackbar('Please enter an amount');
                  return;
                }
                
                double? parsedAmount = double.tryParse(amountInput);
                if (parsedAmount == null) {
                  _showErrorSnackbar('Please enter a valid number');
                  return;
                }
                if (parsedAmount <= 0) {
                  _showErrorSnackbar('Amount must be greater than \$0');
                  return;
                }
                if (parsedAmount > 10000) {
                   _showErrorSnackbar('Daily transaction limit is \$10,000');
                   return;
                }

                // Validation Passed
                setState(() {
                  recipientName = nameInput;
                  amount = '\$${parsedAmount.toStringAsFixed(2)}';
                });
                _navigateToNextPage();
              },
              style: _buttonStyle(),
              child: const Text('Continue', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentContact(String name, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withOpacity(0.1),
            child: Icon(icon, color: Colors.orangeAccent),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  // --- SCREEN 2: CONFIRMATION (RECEIPT STYLE) ---

  Widget _buildConfirmationScreen() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Receipt Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                Text("Sending", style: TextStyle(color: Colors.white.withOpacity(0.6))),
                const SizedBox(height: 10),
                Text(amount, style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                const Divider(color: Colors.white10),
                const SizedBox(height: 24),
                _buildReceiptRow("To", recipientName),
                const SizedBox(height: 16),
                _buildReceiptRow("Fee", "\$0.00"),
                const SizedBox(height: 16),
                _buildReceiptRow("Total", amount, isTotal: true),
              ],
            ),
          ),
          const Spacer(),
          
          const Text("Enter PIN to Confirm", style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          
          // Secure PIN Field
          TextField(
            controller: _pinController,
            obscureText: true,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 4,
            style: const TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 10),
            decoration: InputDecoration(
              counterText: "",
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.orangeAccent),
              ),
            ),
          ),
          
          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                if (_pinController.text.length < 4) {
                  _showErrorSnackbar('Please enter your 4-digit PIN');
                } else {
                  // Simulate processing
                  setState(() => isProcessing = true);
                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() => isProcessing = false);
                    _navigateToNextPage();
                  });
                }
              },
              style: _buttonStyle(),
              child: isProcessing
                  ? const SizedBox(
                      height: 20, width: 20, 
                      child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2)
                    )
                  : const Text('Confirm Transfer', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white54, fontSize: 14)),
        Text(value, style: TextStyle(
          color: isTotal ? Colors.orangeAccent : Colors.white, 
          fontSize: isTotal ? 18 : 16, 
          fontWeight: isTotal ? FontWeight.bold : FontWeight.w500
        )),
      ],
    );
  }

  // --- SCREEN 3: SUCCESS ---

  Widget _buildSuccessScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.greenAccent.withOpacity(0.1),
              ),
              child: const Icon(Icons.check_rounded, color: Colors.greenAccent, size: 60),
            ),
            const SizedBox(height: 30),
            const Text(
              'Transfer Successful!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'You have successfully sent $amount to $recipientName.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60, fontSize: 16),
            ),
            const SizedBox(height: 50),
            
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Return to home
                },
                style: _buttonStyle(),
                child: const Text('Back to Home', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPERS ---

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.orangeAccent,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
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
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.orangeAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      shadowColor: Colors.orangeAccent.withOpacity(0.4),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message), 
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }
}