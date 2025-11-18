import 'package:flutter/material.dart';
import 'package:mywallet/screens/pages/add_acard.dart';

class CreditCardPage extends StatefulWidget {
  const CreditCardPage({super.key});

  @override
  _CreditCardPageState createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardPage> {
  int _currentCardIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.85);

  // Mock Data for Cards
  final List<Map<String, dynamic>> _cards = [
    {
      'balance': '3,469.52',
      'number': '4756 •••• •••• 9018',
      'expiry': '12/25',
      'holder': 'GEGA SMITH',
      'type': 'VISA',
      'color1': Colors.blue.shade800,
      'color2': Colors.blue.shade600,
    },
    {
      'balance': '1,250.00',
      'number': '5412 •••• •••• 4421',
      'expiry': '09/26',
      'holder': 'GEGA SMITH',
      'type': 'MasterCard',
      'color1': Colors.purple.shade800,
      'color2': Colors.deepPurple.shade600,
    },
    {
      'balance': '520.40',
      'number': '3782 •••• •••• 1001',
      'expiry': '01/24',
      'holder': 'GEGA SMITH',
      'type': 'Amex',
      'color1': Colors.black,
      'color2': Colors.grey.shade900,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('My Cards', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddAcard()),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // UNIFIED DEEP BLUE GRADIENT
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
              const SizedBox(height: 20),
              
              // 1. CARD CAROUSEL
              SizedBox(
                height: 220,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _cards.length,
                  onPageChanged: (index) {
                    setState(() => _currentCardIndex = index);
                  },
                  itemBuilder: (context, index) {
                    return _buildCreditCard(index);
                  },
                ),
              ),
              
              const SizedBox(height: 15),
              
              // Page Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _cards.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentCardIndex == index ? Colors.orangeAccent : Colors.white24,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 2. QUICK ACTIONS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionBtn(Icons.ac_unit, 'Freeze'),
                    _buildActionBtn(Icons.lock_outline, 'Change PIN'),
                    _buildActionBtn(Icons.speed, 'Limits'),
                    _buildActionBtn(Icons.settings_outlined, 'Settings'),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 3. TRANSACTIONS LIST
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Recent Activity", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            _buildTransactionItem("Netflix Subscription", "- \$15.99", Icons.movie_creation_outlined, Colors.redAccent),
                            _buildTransactionItem("Amazon Purchase", "- \$84.20", Icons.shopping_cart_outlined, Colors.orangeAccent),
                            _buildTransactionItem("Salary Deposit", "+ \$3,200.00", Icons.attach_money, Colors.greenAccent),
                            _buildTransactionItem("Uber Ride", "- \$12.50", Icons.directions_car, Colors.blueAccent),
                          ],
                        ),
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

  // --- WIDGETS ---

  Widget _buildCreditCard(int index) {
    final card = _cards[index];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [card['color1'], card['color2']],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(top: -20, right: -30, child: CircleAvatar(radius: 60, backgroundColor: Colors.white.withOpacity(0.1))),
          Positioned(bottom: -40, left: -20, child: CircleAvatar(radius: 80, backgroundColor: Colors.white.withOpacity(0.1))),
          
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.nfc, color: Colors.white70, size: 30),
                    Text(card['type'], style: const TextStyle(color: Colors.white, fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('\$${card['balance']}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(card['number'], style: const TextStyle(color: Colors.white70, fontSize: 16, letterSpacing: 1.5)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('CARD HOLDER', style: TextStyle(color: Colors.white54, fontSize: 10)),
                        Text(card['holder'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('EXPIRES', style: TextStyle(color: Colors.white54, fontSize: 10)),
                        Text(card['expiry'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white10),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildTransactionItem(String title, String amount, IconData icon, Color iconColor) {
    final isPositive = amount.startsWith('+');
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15)),
                const SizedBox(height: 4),
                Text("Today, 12:40 PM", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: isPositive ? Colors.greenAccent : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}