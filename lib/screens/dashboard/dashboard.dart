import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../history/history.dart';
import '../membership/membership.dart';
import '../profile/profile.dart';

class Dashboard extends StatefulWidget {
  /// The value encoded in the QR code — e.g. a user/member ID or token.
  /// Pass this in when navigating here (defaults to a placeholder).
  final String qrData;

  const Dashboard({super.key, this.qrData = 'fitpass-user-placeholder'});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<String> _tabs = const ['Home', 'History', 'Membership'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            const SizedBox(height: 8),
            _buildNavBar(),
            const Divider(color: Colors.white12, height: 1),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  HomeTab(qrData: widget.qrData),
                  const HistoryTab(),
                  const MembershipTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Top app bar: "Hellojaspher" + avatar ----
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Hello, jaspher!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 250, 250, 250),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white24,
              // Replace with your logged-in user's avatar/image provider.
              child: Icon(Icons.person, color: Colors.white70, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Clickable navbar: Home | History | Membership ----
  Widget _buildNavBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: false,
      indicatorColor: Colors.transparent,
      labelColor: const Color(0xFF3ECF4A),
      unselectedLabelColor: Colors.white54,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      unselectedLabelStyle:
          const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      tabs: _tabs.map((t) => Tab(text: t)).toList(),
    );
  }
}

// =====================================================
// HOME TAB — QR code + Time In / Time Out buttons
// =====================================================
class HomeTab extends StatelessWidget {
  final String qrData;

  const HomeTab({super.key, required this.qrData});

  void _handleTimeIn(BuildContext context) {
    // TODO: hook up to your API / backend call for clocking in.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Timed in successfully')),
    );
  }

  void _handleTimeOut(BuildContext context) {
    // TODO: hook up to your API / backend call for clocking out.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Timed out successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          const SizedBox(height: 24),
          const Text(
            'Scan this QR',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 220,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 48),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleTimeIn(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3ECF4A),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Time in',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleTimeOut(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A2A2A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Time out',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
