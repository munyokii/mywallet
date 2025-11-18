import 'package:flutter/material.dart';
import 'package:mywallet/screens/pages/add_acard.dart';

class AccountAndCardPage extends StatefulWidget {
  const AccountAndCardPage({super.key});

  @override
  _AccountAndCardPageState createState() => _AccountAndCardPageState();
}

class _AccountAndCardPageState extends State<AccountAndCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Cards & Accounts',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
            onPressed: () {},
          )
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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroCard(),
                      const SizedBox(height: 30),
                      const Text(
                        "Card Details",
                        style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 15),
                      _buildDetailTile(Icons.person_outline, "Card Holder", "Gega Smith"),
                      _buildDetailTile(Icons.account_balance_outlined, "Bank Name", "OverBridge Bank"),
                      _buildDetailTile(Icons.credit_card_outlined, "Card Type", "Amazon Platinum • Debit"),
                      _buildDetailTile(Icons.location_on_outlined, "Billing Address", "123 Innovation Dr, Tech City"),
                    ],
                  ),
                ),
              ),
              _buildAddCardButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Premium Credit Card Widget
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [Colors.indigo.shade500, Colors.purple.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned(
            right: -50,
            top: -50,
            child: CircleAvatar(radius: 100, backgroundColor: Colors.white.withOpacity(0.05)),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Chip Icon
                    Row(
                      children: [
                        Icon(Icons.sim_card_outlined, color: Colors.orangeAccent.shade100, size: 36),
                        const SizedBox(width: 10),
                        const Icon(Icons.wifi, color: Colors.white54, size: 24),
                      ],
                    ),
                    const Text(
                      "VISA",
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "4756  ••••  ••••  9018",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Courier', // Monospace look for numbers
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Card Holder", style: TextStyle(color: Colors.white54, fontSize: 10)),
                            SizedBox(height: 4),
                            Text("GEGA SMITH", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Expires", style: TextStyle(color: Colors.white54, fontSize: 10)),
                            SizedBox(height: 4),
                            Text("12/28", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. Reusable Info Tiles
  Widget _buildDetailTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade900.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.orangeAccent, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Icon(Icons.edit_outlined, color: Colors.white.withOpacity(0.3), size: 18),
        ],
      ),
    );
  }

  // 3. Sticky Bottom Button
  Widget _buildAddCardButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1931), // Matches background to blend in
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
            elevation: 5,
            shadowColor: Colors.orangeAccent.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddAcard()),
            );
          },
          icon: const Icon(Icons.add_card, color: Colors.black87),
          label: const Text(
            'Add New Card',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}