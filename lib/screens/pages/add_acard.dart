import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui'; // Required for ImageFilter (Blur)

class AddAcard extends StatefulWidget {
  const AddAcard({Key? key}) : super(key: key);

  @override
  _AddAcardState createState() => _AddAcardState();
}

class _AddAcardState extends State<AddAcard> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _cardNumberController = TextEditingController();
  final _cardHolderNameController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  // State for Live Preview
  String _cardNumber = '';
  String _cardHolder = '';
  String _expiry = '';
  // Note: CVV state variable removed as it's not shown on the card preview
  CardType _cardType = CardType.others;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderNameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  // --- LOGIC: Card Type Detection ---
  void _updateCardType(String input) {
    String cleanNum = input.replaceAll(' ', '');
    setState(() {
      if (cleanNum.startsWith('4')) {
        _cardType = CardType.visa;
      } else if (cleanNum.startsWith(RegExp(r'^(5[1-5]|2[2-7])'))) {
        _cardType = CardType.mastercard;
      } else if (cleanNum.startsWith(RegExp(r'^3[47]'))) {
        _cardType = CardType.amex;
      } else if (cleanNum.startsWith('6')) {
        _cardType = CardType.discover;
      } else {
        _cardType = CardType.others;
      }
      _cardNumber = input;
    });
  }

  // --- LOGIC: Validators ---
  
  // 1. Luhn Algorithm for Card Validity
  String? _validateCardNum(String? input) {
    if (input == null || input.isEmpty) return 'Card number is required';
    String cleanNum = input.replaceAll(' ', '');
    if (cleanNum.length < 8) return 'Number is too short';

    int sum = 0;
    int length = cleanNum.length;
    for (var i = 0; i < length; i++) {
      // Get digits in reverse order
      int digit = int.parse(cleanNum[length - i - 1]);
      // Double every second digit
      if (i % 2 == 1) {
        digit *= 2;
      }
      // Sum digits (e.g., 18 becomes 1+8=9) -> logic: if >9, subtract 9
      sum += digit > 9 ? (digit - 9) : digit;
    }

    if (sum % 10 != 0) return 'Invalid card number';
    return null;
  }

  // 2. Expiry Date Logic
  String? _validateDate(String? input) {
    if (input == null || input.isEmpty) return 'Required';
    if (!input.contains('/') || input.length < 5) return 'Invalid format';

    List<String> split = input.split('/');
    int month = int.tryParse(split[0]) ?? 0;
    int year = int.tryParse('20${split[1]}') ?? 0; // Assuming 20xx

    if (month < 1 || month > 12) return 'Invalid month';

    final now = DateTime.now();
    final cardDate = DateTime(year, month);
    // Check if card expires before the current month/year
    if (cardDate.isBefore(DateTime(now.year, now.month))) {
      return 'Card has expired';
    }
    return null;
  }

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Card verified & added!'),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
      
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Add New Card', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade900, const Color(0xFF0A1931)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // 1. Glassmorphism Card
                _buildGlassCard(),
                
                const SizedBox(height: 40),
                
                // 2. Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("PAYMENT DETAILS", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      const SizedBox(height: 20),

                      // Card Number
                      _buildModernTextField(
                        controller: _cardNumberController,
                        label: 'Card Number',
                        hint: '0000 0000 0000 0000',
                        icon: Icons.credit_card,
                        isNumber: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16), 
                          _CardNumberFormatter(),
                        ],
                        onChanged: _updateCardType,
                        validator: _validateCardNum,
                      ),
                      
                      const SizedBox(height: 20),

                      // Card Holder
                      _buildModernTextField(
                        controller: _cardHolderNameController,
                        label: 'Card Holder Name',
                        hint: 'John Doe',
                        icon: Icons.person_outline,
                        onChanged: (val) => setState(() => _cardHolder = val),
                        validator: (value) => value!.isEmpty ? 'Name is required' : null,
                      ),

                      const SizedBox(height: 20),

                      // Expiry & CVV Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildModernTextField(
                              controller: _expiryController,
                              label: 'Expiry Date',
                              hint: 'MM/YY',
                              icon: Icons.calendar_today_outlined,
                              isNumber: true,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(5),
                                _ExpiryDateFormatter(),
                              ],
                              onChanged: (val) => setState(() => _expiry = val),
                              validator: _validateDate,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildModernTextField(
                              controller: _cvvController,
                              label: 'CVV',
                              hint: '***',
                              icon: Icons.lock_outline,
                              isNumber: true,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(4), // Amex uses 4
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              // onChanged removed as we don't display CVV live
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Required';
                                if (value.length < 3) return 'Invalid';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 50),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 5,
                            shadowColor: Colors.orangeAccent.withOpacity(0.5),
                          ),
                          child: const Text(
                            'Save Card',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildGlassCard() {
    return Center(
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          // Gradient for the card background
          gradient: const LinearGradient(
            colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)], 
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 25,
              spreadRadius: -5,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Decorative Background Circles (for depth)
              Positioned(top: -50, right: -50, child: CircleAvatar(radius: 100, backgroundColor: Colors.white.withOpacity(0.1))),
              Positioned(bottom: -50, left: -50, child: CircleAvatar(radius: 100, backgroundColor: Colors.white.withOpacity(0.05))),
              
              // Frosted Glass Effect Overlay
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Header: Chip & Logo
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.nfc, color: Colors.white70, size: 32),
                          _getCardTypeIcon(_cardType),
                        ],
                      ),
                      
                      // Card Number
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          _cardNumber.isEmpty ? '**** **** **** ****' : _cardNumber,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            letterSpacing: 3,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Courier', // Important for number alignment
                            shadows: [Shadow(color: Colors.black26, blurRadius: 2, offset: Offset(1, 1))]
                          ),
                        ),
                      ),
                      
                      // Footer: Name & Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("CARD HOLDER", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(
                                _cardHolder.isEmpty ? 'YOUR NAME' : _cardHolder.toUpperCase(),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("EXPIRES", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(
                                _expiry.isEmpty ? 'MM/YY' : _expiry,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getCardTypeIcon(CardType type) {
    switch (type) {
      case CardType.visa:
        return const Text("VISA", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic));
      case CardType.mastercard:
        return Row(children: [
          CircleAvatar(radius: 12, backgroundColor: Colors.red.withOpacity(0.8)),
          Transform.translate(offset: const Offset(-10, 0), child: CircleAvatar(radius: 12, backgroundColor: Colors.orange.withOpacity(0.8))),
        ]);
      case CardType.amex:
        return const Text("AMEX", style: TextStyle(color: Colors.cyanAccent, fontSize: 20, fontWeight: FontWeight.w900));
      case CardType.discover:
        return const Text("Discover", style: TextStyle(color: Colors.orangeAccent, fontSize: 20, fontWeight: FontWeight.bold));
      default:
        return const Icon(Icons.credit_card, color: Colors.white, size: 30);
    }
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isNumber = false,
    List<TextInputFormatter>? inputFormatters,
    Function(String)? onChanged,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      cursorColor: Colors.orangeAccent,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.1)),
        prefixIcon: Icon(icon, color: Colors.white70, size: 22),
        filled: true,
        fillColor: const Color(0xFF2C3E50), // Dark blue-grey fill
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.orangeAccent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.redAccent.shade200, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.redAccent.shade200, width: 1.5),
        ),
      ),
    );
  }
}

// --- ENUMS & FORMATTERS ---

enum CardType { visa, mastercard, amex, discover, others }

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    if (newText.length > 0 && newText.length < 3) return newValue;
    
    if (oldValue.text.length == 2 && newText.length == 3 && !newText.contains('/')) {
      var buffer = StringBuffer();
      buffer.write('${newText.substring(0, 2)}/${newText.substring(2)}');
      return newValue.copyWith(text: buffer.toString(), selection: TextSelection.collapsed(offset: buffer.length));
    }
    return newValue;
  }
}