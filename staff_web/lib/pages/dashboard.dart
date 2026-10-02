import 'package:flutter/material.dart';

import '../widgets/fitpass_layout.dart';
import '../data/gym_data.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selectedPeriod = 'This Week';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: GymData.instance,
      builder: (context, child) {
        final gym = GymData.instance;

        return FitpassLayout(
          currentPage: '/dashboard',
          child: Container(
            color: const Color(0xFF202020),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(5, 5, 14, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==================================================
                      // DASHBOARD TITLE
                      // ==================================================

                      const Padding(
                        padding: EdgeInsets.only(
                          left: 8,
                          bottom: 9,
                        ),
                        child: Text(
                          'DASHBOARD',
                          style: TextStyle(
                            color: Color(0xFF22C55E),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // ==================================================
                      // STAT CARDS
                      // ==================================================

                      _buildStatsRow(gym),

                      const SizedBox(height: 8),

                      // ==================================================
                      // RECENT CHECK-INS + OVERVIEW
                      // ==================================================

                      _buildMiddleRow(gym),

                      const SizedBox(height: 8),

                      // ==================================================
                      // TODAY'S LOGS
                      // ==================================================

                      _buildBottomRow(gym),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // STAT CARDS
  // ============================================================

  Widget _buildStatsRow(GymData gym) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Check-ins Today',
            value: gym.todayCheckIns.toString(),
            percentage: '15%',
            comparison: 'vs yesterday',
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _buildStatCard(
            title: 'Check-outs Today',
            value: gym.todayCheckOuts.toString(),
            percentage: '15%',
            comparison: 'vs yesterday',
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _buildStatCard(
            title: 'Active Member',
            value: gym.activeMembers.toString(),
            percentage: '8%',
            comparison: 'vs last month',
          ),
        ),
      ],
    );
  }

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget _buildStatCard({
    required String title,
    required String value,
    required String percentage,
    required String comparison,
  }) {
    return Container(
      height: 77,
      decoration: BoxDecoration(
        color: const Color(0xFF202020),
        border: Border.all(
          color: const Color(0xFF3A3A3A),
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      padding: const EdgeInsets.fromLTRB(
        10,
        8,
        10,
        6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              height: 1.0,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              height: 1.0,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 2),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '↑',
                style: TextStyle(
                  color: Color(0xFF22C55E),
                  fontSize: 10,
                  height: 1.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                ' $percentage ',
                style: const TextStyle(
                  color: Color(0xFF22C55E),
                  fontSize: 9,
                  height: 1.0,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Text(
                comparison,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 9,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MIDDLE ROW
  // ============================================================

  Widget _buildMiddleRow(GymData gym) {
    return SizedBox(
      height: 207,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 38,
            child: _buildRecentCheckIns(gym),
          ),

          const SizedBox(width: 12),

          Expanded(
            flex: 62,
            child: _buildOverviewChart(),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RECENT CHECK-INS
  // ============================================================

  Widget _buildRecentCheckIns(GymData gym) {
    final recentLogs = gym.logs.take(5).toList();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF3A3A3A),
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      padding: const EdgeInsets.fromLTRB(
        8,
        7,
        8,
        5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Check-ins',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 8),

          // HEADER
          const Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Name',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                  ),
                ),
              ),

              Expanded(
                flex: 2,
                child: Text(
                  'Type',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                  ),
                ),
              ),

              Expanded(
                flex: 2,
                child: Text(
                  'Time',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                  ),
                ),
              ),

              Expanded(
                flex: 3,
                child: Text(
                  'Methods',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),

          const Divider(
            color: Color(0xFF4A4A4A),
            height: 5,
          ),

          // DATA
          ...recentLogs.map((log) {
            final memberName = log['name'] ?? '';

            final member = gym.members.where(
              (m) => m['name'] == memberName,
            );

            final type = member.isNotEmpty
                ? member.first['type'] ?? ''
                : '';

            return _buildRecentRow(
              name: memberName,
              type: type,
              time: log['time'] ?? '',
              method: log['method'] ?? '',
            );
          }),

          if (recentLogs.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'No recent check-ins',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                  ),
                ),
              ),
            )
          else
            const Spacer(),

          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                '/checkins',
              );
            },
            child: const Center(
              child: Text(
                'View All',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RECENT ROW
  // ============================================================

  Widget _buildRecentRow({
    required String name,
    required String type,
    required String time,
    required String method,
  }) {
    return Container(
      height: 24,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF555555),
            width: 0.7,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              type,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              time,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                method,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // OVERVIEW CHART
  // ============================================================

  Widget _buildOverviewChart() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF3A3A3A),
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      padding: const EdgeInsets.fromLTRB(
        9,
        7,
        8,
        5,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Check-ins Overview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),

              const Spacer(),

              // ==================================================
              // PERIOD DROPDOWN
              // ==================================================

              Container(
                width: 105,
                height: 25,
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF444444),
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedPeriod,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF292929),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white54,
                      size: 15,
                    ),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 8,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'This Week',
                        child: Text(
                          'This Week',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 8,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Last Week',
                        child: Text(
                          'Last Week',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 8,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'This Month',
                        child: Text(
                          'This Month',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 8,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Last Month',
                        child: Text(
                          'Last Month',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedPeriod = value;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Expanded(
            child: CustomPaint(
              painter: _ChartPainter(),
              child: const SizedBox.expand(),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 22,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),

              const SizedBox(width: 12),

              const Text(
                'Check-ins',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 9,
                ),
              ),

              const SizedBox(width: 32),

              Container(
                width: 22,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),

              const SizedBox(width: 12),

              const Text(
                'Check-outs',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM ROW
  // ============================================================

  Widget _buildBottomRow(GymData gym) {
    return SizedBox(
      height: 228,
      child: _buildTodaysLogs(gym),
    );
  }

  // ============================================================
  // TODAY'S LOGS
  // ============================================================

  Widget _buildTodaysLogs(GymData gym) {
    final manualEntries = gym.logs
        .where((log) => log['method'] == 'Manual')
        .length;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF3A3A3A),
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      padding: const EdgeInsets.fromLTRB(
        11,
        7,
        9,
        8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Today’s Logs',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),

              const Spacer(),

              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/checkins',
                  );
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          _buildLogRow(
            'Total Check-Ins',
            gym.todayCheckIns.toString(),
          ),

          _buildLogRow(
            'Total Check-Outs',
            gym.todayCheckOuts.toString(),
          ),

          _buildLogRow(
            'Manual Entries',
            manualEntries.toString(),
          ),

          _buildLogRow(
            'Active Members',
            gym.activeMembers.toString(),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOG ROW
  // ============================================================

  Widget _buildLogRow(
    String title,
    String value,
  ) {
    return Container(
      height: 40,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFF4A4A4A),
            width: 0.8,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// CHART
// ================================================================

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double left = 28;
    const double top = 10;
    const double right = 7;
    const double bottom = 28;

    final chartWidth = size.width - left - right;

    final chartHeight = size.height - top - bottom;

    final gridPaint = Paint()
      ..color = const Color(0xFF555555)
      ..strokeWidth = 1;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // ------------------------------------------------------------
    // GRID
    // ------------------------------------------------------------

    const values = [
      '150',
      '100',
      '50',
      '0',
    ];

    for (int i = 0; i < 4; i++) {
      final y = top + (chartHeight / 3) * i;

      canvas.drawLine(
        Offset(left, y),
        Offset(size.width - right, y),
        gridPaint,
      );

      textPainter.text = TextSpan(
        text: values[i],
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 8,
        ),
      );

      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(1, y - 5),
      );
    }

    // ------------------------------------------------------------
    // DATES
    // ------------------------------------------------------------

    const dates = [
      'May 12',
      'May 13',
      'May 14',
      'May 15',
      'May 16',
      'May 17',
      'May 18',
    ];

    final spacing = chartWidth / (dates.length - 1);

    for (int i = 0; i < dates.length; i++) {
      final x = left + spacing * i;

      textPainter.text = TextSpan(
        text: dates[i],
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 8,
        ),
      );

      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          size.height - 18,
        ),
      );
    }

    // ------------------------------------------------------------
    // CHECK-IN LINE
    // ------------------------------------------------------------

    final greenPaint = Paint()
      ..color = const Color(0xFF22C55E)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final checkInPath = Path();

    const checkIns = [
      70.0,
      90.0,
      115.0,
      105.0,
      135.0,
      125.0,
      128.0,
    ];

    for (int i = 0; i < checkIns.length; i++) {
      final x = left + spacing * i;

      final y = top +
          chartHeight -
          ((checkIns[i] / 150) * chartHeight);

      if (i == 0) {
        checkInPath.moveTo(x, y);
      } else {
        checkInPath.lineTo(x, y);
      }
    }

    canvas.drawPath(
      checkInPath,
      greenPaint,
    );

    // ------------------------------------------------------------
    // CHECK-OUT LINE
    // ------------------------------------------------------------

    final greyPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final checkOutPath = Path();

    const checkOuts = [
      55.0,
      75.0,
      85.0,
      92.0,
      105.0,
      110.0,
      116.0,
    ];

    for (int i = 0; i < checkOuts.length; i++) {
      final x = left + spacing * i;

      final y = top +
          chartHeight -
          ((checkOuts[i] / 150) * chartHeight);

      if (i == 0) {
        checkOutPath.moveTo(x, y);
      } else {
        checkOutPath.lineTo(x, y);
      }
    }

    canvas.drawPath(
      checkOutPath,
      greyPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}