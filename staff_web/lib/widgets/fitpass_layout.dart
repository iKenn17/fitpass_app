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

          // =====================================================
          // SIDEBAR
          // =====================================================

          _buildSidebar(context),

          // =====================================================
          // RIGHT SIDE
          // =====================================================

          Expanded(
            child: Column(
              children: [

                // TOP BAR
                _buildTopBar(context),

                // PAGE CONTENT
                Expanded(
                  child: child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // SIDEBAR
  // ===========================================================

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 218,
      color: const Color(0xFF202020),

      child: Column(
        children: [

          const SizedBox(height: 8),

          // =====================================================
          // FITPASS LOGO + TEXT
          // =====================================================

          SizedBox(
            height: 72,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // -------------------------------------------------
                // LOGO
                // -------------------------------------------------

                Padding(
                  padding: const EdgeInsets.only(
                    left: 7,
                  ),
                  child: Image.asset(
                    'assets/fitpass_logo.png',
                    width: 52,
                    height: 58,
                    fit: BoxFit.contain,

                    errorBuilder:
                        (context, error, stackTrace) {
                      return const SizedBox(
                        width: 52,
                        height: 58,
                        child: Center(
                          child: Icon(
                            Icons.fitness_center,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 3),

                // -------------------------------------------------
                // FITPASS + GYM
                // -------------------------------------------------

                Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    // FITPASS
                    RichText(
                      text: const TextSpan(
                        children: [

                          // FIT
                          TextSpan(
                            text: 'FIT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1,
                            ),
                          ),

                          // PASS
                          TextSpan(
                            text: 'PASS',
                            style: TextStyle(
                              color: Color(0xFF22C55E),
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // GYM
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 39,
                        top: 0,
                      ),
                      child: Text(
                        'GYM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // =====================================================
          // DASHBOARD
          // =====================================================

          _sidebarButton(
            context,
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            route: '/dashboard',
          ),

          // =====================================================
          // CHECK-INS
          // =====================================================

          _sidebarButton(
            context,
            icon: Icons.login,
            title: 'Check-ins',
            route: '/checkins',
          ),

          // =====================================================
          // MEMBERS
          // =====================================================

          _sidebarButton(
            context,
            icon: Icons.people_outline,
            title: 'Members',
            route: '/members',
          ),

          // =====================================================
          // MANUAL TIME
          // =====================================================

          _sidebarButton(
            context,
            icon: Icons.access_time,
            title: 'Manual Time in/out',
            route: '/manual-time',
          ),

          // =====================================================
          // NOTIFICATIONS
          // =====================================================

          _sidebarButton(
            context,
            icon: Icons.notifications_none,
            title: 'Notifications',
            route: '/notifications',
          ),

          // =====================================================
          // SCANNER
          // =====================================================

          _sidebarButton(
            context,
            icon: Icons.qr_code_scanner,
            title: 'Scanner',
            route: '/scanner',
          ),

          const Spacer(),
        ],
      ),
    );
  }

  // ===========================================================
  // SIDEBAR BUTTON
  // ===========================================================

  Widget _sidebarButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    final bool selected = currentPage == route;

    return GestureDetector(
      onTap: () {
        if (currentPage != route) {
          Navigator.pushReplacementNamed(
            context,
            route,
          );
        }
      },

      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 7,
          vertical: 2,
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 9,
          vertical: 9,
        ),

        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF245C37)
              : Colors.transparent,

          borderRadius: BorderRadius.circular(6),
        ),

        child: Row(
          children: [

            // ICON
            Icon(
              icon,
              color: Colors.black,
              size: 21,
            ),

            const SizedBox(width: 10),

            // TITLE
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // TOP BAR
  // ===========================================================

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 70,

      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),

      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF363636),
          ),
        ),
      ),

      child: Row(
        children: [

          // =====================================================
          // SEARCH
          // =====================================================

          Container(
            width: 315,
            height: 36,

            decoration: BoxDecoration(
              color: const Color(0xFF494949),
              borderRadius:
                  BorderRadius.circular(6),
            ),

            child: const Row(
              children: [

                SizedBox(width: 12),

                Icon(
                  Icons.search,
                  color: Colors.white70,
                  size: 22,
                ),

                SizedBox(width: 15),

                Text(
                  'Search Member.....',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // =====================================================
          // STAFF PROFILE + LOGOUT DROPDOWN
          // =====================================================

          PopupMenuButton<String>(
            color: const Color(0xFF292929),

            offset: const Offset(0, 55),

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
                    Icon(
                      Icons.logout,
                      color: Colors.redAccent,
                      size: 18,
                    ),

                    SizedBox(width: 10),

                    Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            child: const Row(
              children: [

                // STAFF PROFILE
                CircleAvatar(
                  radius: 23,

                  backgroundColor:
                      Color(0xFF777777),

                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 25,
                  ),
                ),

                SizedBox(width: 12),

                Text(
                  'Staff User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),

                SizedBox(width: 15),

                Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 20,
                ),

                SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}