import 'package:flutter/material.dart';

// 1. MAIN RECHARGE SCREEN: CONTACT SELECTION
class MobileRechargePage extends StatelessWidget {
  const MobileRechargePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Recharge Mobile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade900, const Color(0xFF0A1931)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: _buildSearchBar(),
              ),
              const SizedBox(height: 20),
              
              // Recent Recharges Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("Recents", style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildRecentAvatar("Mom", Icons.favorite, Colors.pinkAccent),
                    _buildRecentAvatar("Jane", Icons.person, Colors.purpleAccent),
                    _buildRecentAvatar("Work", Icons.work, Colors.blueAccent),
                    _buildRecentAvatar("Dad", Icons.person, Colors.greenAccent),
                  ],
                ),
              ),
              
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("All Contacts", style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              
              // Contacts List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildContactTile(context, "Jane Cooper", "+1 923 555 0101"),
                    _buildContactTile(context, "Wade Warren", "+1 923 555 0123"),
                    _buildContactTile(context, "Esther Howard", "+1 923 555 0199"),
                    _buildContactTile(context, "Cameron Williamson", "+1 923 555 0202"),
                    _buildContactTile(context, "Robert Fox", "+1 923 555 0309"),
                    _buildContactTile(context, "Jacob Jones", "+1 923 555 0410"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.orangeAccent,
      decoration: InputDecoration(
        hintText: "Search name or number...",
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05), // Glassmorphism
        prefixIcon: const Icon(Icons.search, color: Colors.orangeAccent),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
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

  Widget _buildRecentAvatar(String label, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildContactTile(BuildContext context, String name, String phone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: Colors.orangeAccent.withOpacity(0.8),
          child: Text(name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        title: Text(name, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Text(phone, style: const TextStyle(color: Colors.white54)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white38),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RechargeAmountScreen(name: name, phone: phone)),
          );
        },
      ),
    );
  }
}

// 2. AMOUNT & PLAN SCREEN
class RechargeAmountScreen extends StatefulWidget {
  final String name;
  final String phone;
  const RechargeAmountScreen({super.key, required this.name, required this.phone});

  @override
  State<RechargeAmountScreen> createState() => _RechargeAmountScreenState();
}

class _RechargeAmountScreenState extends State<RechargeAmountScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Recharge Amount', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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
        // UNIFIED BACKGROUND GRADIENT
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade900, const Color(0xFF0A1931)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Contact & Provider Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.orangeAccent,
                        child: Text(widget.name[0], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.signal_cellular_alt, size: 14, color: Colors.greenAccent),
                              const SizedBox(width: 5),
                              Text("${widget.phone} • AT&T", style: const TextStyle(color: Colors.white54)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Amount Input
                const Text("Enter Amount", style: TextStyle(color: Colors.white54)),
                TextField(
                  controller: _amountController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                  cursorColor: Colors.orangeAccent,
                  decoration: const InputDecoration(
                    hintText: "\$0.00",
                    hintStyle: TextStyle(color: Colors.white24),
                    border: InputBorder.none,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Quick Amount Chips
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [10, 25, 50, 100].map((amt) => 
                    GestureDetector(
                      onTap: () => setState(() => _amountController.text = "\$$amt.00"),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Text("\$$amt", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    )
                  ).toList(),
                ),

                const SizedBox(height: 40),

                // Payment Method Selection
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.credit_card, color: Colors.orangeAccent),
                    ),
                    title: const Text("MasterCard **** 9018", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    subtitle: const Text("Balance: \$3,469.52", style: TextStyle(color: Colors.white54)),
                    trailing: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    onTap: () {},
                  ),
                ),

                const SizedBox(height: 40),

                // Recharge Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_amountController.text.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RechargeSuccessScreen(name: widget.name, amount: _amountController.text)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text("Please enter an amount"), backgroundColor: Colors.redAccent)
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 5,
                      shadowColor: Colors.orangeAccent.withOpacity(0.4),
                    ),
                    child: const Text("Recharge Now", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 3. SUCCESS SCREEN
class RechargeSuccessScreen extends StatelessWidget {
  final String name;
  final String amount;
  const RechargeSuccessScreen({super.key, required this.name, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // UNIFIED BACKGROUND GRADIENT
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade900, const Color(0xFF0A1931)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Animated Icon Container
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.greenAccent.withOpacity(0.1),
                ),
                child: const Icon(Icons.check_rounded, size: 60, color: Colors.greenAccent),
              ),
              const SizedBox(height: 30),
              
              const Text("Recharge Successful!", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "You have successfully recharged $amount for $name.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white60, fontSize: 16, height: 1.5),
                ),
              ),
              
              const Spacer(),

              // Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.05),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          side: BorderSide(color: Colors.white.withOpacity(0.1)),
                          elevation: 0,
                        ),
                        child: const Text("View Receipt", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                      child: const Text("Back to Home", style: TextStyle(color: Colors.orangeAccent, fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}