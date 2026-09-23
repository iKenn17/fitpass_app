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

enum _ClockAction { none, timeIn, timeOut }

class HomeTab extends StatefulWidget {
  final String qrData;

  const HomeTab({super.key, required this.qrData});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  _ClockAction _lastAction = _ClockAction.none;
  DateTime? _lastActionTime;

  void _handleTimeIn() {
    // TODO: hook up to your API / backend call for clocking in.
    setState(() {
      _lastAction = _ClockAction.timeIn;
      _lastActionTime = DateTime.now();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Timed in successfully')),
    );
  }

  void _handleTimeOut() {
    // TODO: hook up to your API / backend call for clocking out.
    setState(() {
      _lastAction = _ClockAction.timeOut;
      _lastActionTime = DateTime.now();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Timed out successfully')),
    );
  }

  String _formatTime(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
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
              data: widget.qrData,
              version: QrVersions.auto,
              size: 220,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 32),

          // ---- Status line reflecting the last action taken ----
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _lastAction == _ClockAction.none
                ? const SizedBox(key: ValueKey('none'), height: 20)
                : Row(
                    key: ValueKey(_lastAction),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _lastAction == _ClockAction.timeIn
                            ? Icons.check_circle
                            : Icons.logout,
                        size: 16,
                        color: _lastAction == _ClockAction.timeIn
                            ? const Color(0xFF3ECF4A)
                            : Colors.orangeAccent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _lastAction == _ClockAction.timeIn
                            ? 'Timed in at ${_formatTime(_lastActionTime!)}'
                            : 'Timed out at ${_formatTime(_lastActionTime!)}',
                        style: TextStyle(
                          color: _lastAction == _ClockAction.timeIn
                              ? const Color(0xFF3ECF4A)
                              : Colors.orangeAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _ClockButton(
                  label: 'Time in',
                  isActive: _lastAction == _ClockAction.timeIn,
                  activeColor: const Color(0xFF3ECF4A),
                  baseBackground: const Color(0xFF3ECF4A),
                  baseForeground: Colors.black,
                  onPressed: _handleTimeIn,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ClockButton(
                  label: 'Time out',
                  isActive: _lastAction == _ClockAction.timeOut,
                  activeColor: Colors.orangeAccent,
                  baseBackground: const Color(0xFF2A2A2A),
                  baseForeground: Colors.white,
                  onPressed: _handleTimeOut,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---- Reusable button that highlights itself when it's the active action ----
class _ClockButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color activeColor;
  final Color baseBackground;
  final Color baseForeground;
  final VoidCallback onPressed;

  const _ClockButton({
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.baseBackground,
    required this.baseForeground,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isActive ? activeColor : Colors.transparent,
          width: 2,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: activeColor.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: baseBackground,
          foregroundColor: baseForeground,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              const Icon(Icons.check, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}
