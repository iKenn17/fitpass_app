import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                  HomeTab(
                    qrData:
                        FirebaseAuth.instance.currentUser?.uid ?? widget.qrData,
                  ),
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
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, snap) {
              final name = snap.data?.data()?['username'] ?? '';
              return Text(
                'Hello, $name!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 250, 250, 250),
                ),
              );
            },
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

class HomeTab extends StatelessWidget {
  final String qrData;

  const HomeTab({super.key, required this.qrData});

  String _formatTime(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

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
          const SizedBox(height: 32),
          if (uid != null)
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('attendance')
                  .where('uid', isEqualTo: uid)
                  .orderBy('timestamp', descending: true)
                  .limit(1)
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData || snap.data!.docs.isEmpty) {
                  return const Text(
                    'No check-ins yet',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  );
                }

                final d = snap.data!.docs.first.data();
                final ts = (d['timestamp'] as Timestamp?)?.toDate();
                if (ts == null) return const SizedBox(height: 20);

                final isIn = d['type'] == 'time_in';
                final color =
                    isIn ? const Color(0xFF3ECF4A) : Colors.orangeAccent;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(isIn ? Icons.check_circle : Icons.logout,
                        size: 16, color: color),
                    const SizedBox(width: 6),
                    Text(
                      '${isIn ? 'Timed in' : 'Timed out'} at ${_formatTime(ts)}',
                      style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
