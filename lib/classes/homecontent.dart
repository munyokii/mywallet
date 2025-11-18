import 'package:flutter/material.dart';
import 'package:mywallet/screens/pages/account.dart';
import 'package:mywallet/screens/pages/credit_card.dart';
import 'package:mywallet/screens/pages/mobile_recharge.dart';
import 'package:mywallet/screens/pages/pay_bill.dart';
import 'package:mywallet/screens/pages/transaction_report.dart';
import 'package:mywallet/screens/pages/transfer.dart';
import 'package:mywallet/screens/pages/withdraw.dart';

class Homecontent extends StatelessWidget {
  const Homecontent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set background color here as a safety fallback
      backgroundColor: Colors.blue.shade900,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade900, 
              const Color(0xFF0A1931) // Dark deep blue
            ], 
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(), // Makes scrolling feel smoother
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildCreditCard(),
                const SizedBox(height: 30),
                const Text(
                  "Services",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _buildGridMenu(context),
                
                // Add extra space at the bottom so the last items aren't stuck 
                // behind the navigation bar or bottom edge
                const SizedBox(height: 80), 
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. Header
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Good Morning,',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 4),
            Text(
              'Job!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.orangeAccent, width: 2),
          ),
          child: const CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white),
          ),
        )
      ],
    );
  }

  // 2. Credit Card
  Widget _buildCreditCard() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade800, Colors.blue.shade600],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: CircleAvatar(radius: 50, backgroundColor: Colors.white.withOpacity(0.1)),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: CircleAvatar(radius: 40, backgroundColor: Colors.white.withOpacity(0.1)),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Balance',
                          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '\$3,469.52',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.contactless, color: Colors.white70, size: 30),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildDot(), _buildDot(), _buildDot(), _buildDot(),
                        const SizedBox(width: 8),
                        _buildDot(), _buildDot(), _buildDot(), _buildDot(),
                        const SizedBox(width: 8),
                        _buildDot(), _buildDot(), _buildDot(), _buildDot(),
                        const SizedBox(width: 8),
                        const Text(
                          '9018',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                         Text(
                          'Gega Smith',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'VISA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
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

  Widget _buildDot() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: Colors.white70,
        shape: BoxShape.circle,
      ),
    );
  }

  // 3. Grid Menu
  Widget _buildGridMenu(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {'icon': Icons.account_balance_wallet_outlined, 'label': 'Account', 'page': const AccountAndCardPage()},
      {'icon': Icons.swap_horiz, 'label': 'Transfer', 'page': const TransferPage()},
      {'icon': Icons.attach_money, 'label': 'Withdraw', 'page': const WithdrawPage()},
      {'icon': Icons.phone_android, 'label': 'Recharge', 'page': const MobileRechargePage()},
      {'icon': Icons.receipt_long, 'label': 'Bill Pay', 'page': const PayTheBillPage()},
      {'icon': Icons.credit_card, 'label': 'Cards', 'page': const CreditCardPage()},
      {'icon': Icons.insert_chart_outlined, 'label': 'Reports', 'page': const TransactionReportPage()},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        return _buildMenuItem(
          context,
          menuItems[index]['icon'],
          menuItems[index]['label'],
          menuItems[index]['page'],
        );
      },
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String label, Widget page) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.orangeAccent.withOpacity(0.2),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.orangeAccent, size: 26),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}