import 'package:flutter/material.dart';

class FitpassLayout extends StatelessWidget {
  final String currentPage;
  final Widget child;

  const FitpassLayout({
    super.key,
    required this.currentPage,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      body: Row(
        children: [
          _buildSidebar(context),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(context),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // SIDEBAR (admin design)
  // ===========================================================

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 220,
      color: const Color(0xFF1B1B1B),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/fitpass_logo.png',
                width: 70,
                height: 70,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    width: 70,
                    height: 70,
                    child: Center(
                      child: Icon(
                        Icons.fitness_center,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'FIT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                            height: 1.0,
                          ),
                        ),
                        TextSpan(
                          text: 'PASS',
                          style: TextStyle(
                            color: Color(0xFF9AE04A),
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'GYM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          _navItem(
            context,
            Icons.dashboard_customize_outlined,
            'Dashboard',
            '/dashboard',
          ),
          _navItem(context, Icons.login, 'Check-ins', '/checkins'),
          _navItem(context, Icons.payments_outlined, 'Payments', '/payments'),
          _navItem(context, Icons.people_alt_outlined, 'Members', '/members'),
          _navItem(
            context,
            Icons.access_time,
            'Manual Time in/out',
            '/manual-time',
          ),
          _navItem(
            context,
            Icons.notifications_none,
            'Notifications',
            '/notifications',
          ),
          _navItem(context, Icons.qr_code_scanner, 'Scanner', '/scanner'),

          const Spacer(),
        ],
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    final bool isActive = currentPage == route;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF294A31) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        leading: Icon(
          icon,
          color: isActive ? Colors.white : Colors.white70,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13.5,
          ),
        ),
        onTap: () {
          if (currentPage != route) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
      ),
    );
  }

  // ===========================================================
  // TOP BAR (admin design)
  // ===========================================================

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFF1B1B1B),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 36,
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: const Color(0xFF2B2B2B),
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: const TextField(
                  cursorColor: Color(0xFF00FF66),
                  style: TextStyle(color: Colors.white, fontSize: 13),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: 'Search Member...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    border: InputBorder.none,
                    isCollapsed: true,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 18,
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 40,
                      minHeight: 36,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
          ),

          // STAFF PROFILE + LOGOUT DROPDOWN
          PopupMenuButton<String>(
            color: const Color(0xFF2B2B2B),
            offset: const Offset(0, 45),
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.redAccent, size: 18),
                    SizedBox(width: 10),
                    Text(
                      'Logout',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white, size: 18),
                ),
                SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Staff User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Staff',
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
                SizedBox(width: 6),
                Icon(Icons.arrow_drop_down, color: Colors.white70, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
