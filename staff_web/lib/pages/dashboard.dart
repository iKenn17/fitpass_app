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

  static const List<String> _periods = [
    'This Week',
    'Last Week',
    'This Month',
    'Last Month',
  ];

  static const Color _cardColor = Color(0xFF2B2B2B);
  static const Color _green = Color(0xFF00FF66);

  BoxDecoration get _cardDecoration => BoxDecoration(
    color: _cardColor,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.white10),
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: GymData.instance,
      builder: (context, child) {
        final gym = GymData.instance;

        return FitpassLayout(
          currentPage: '/dashboard',
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DASHBOARD',
                  style: TextStyle(
                    color: _green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),

                _buildStatsRow(gym),
                const SizedBox(height: 16),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildRecentCheckIns(gym)),
                    const SizedBox(width: 16),
                    Expanded(flex: 3, child: _buildOverviewChart()),
                  ],
                ),
                const SizedBox(height: 16),

                _buildTodaysLogs(gym),
              ],
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildStatCard(
            'Check-ins Today',
            gym.todayCheckIns.toString(),
            '↑ 15% vs yesterday',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Check-outs Today',
            gym.todayCheckOuts.toString(),
            '↑ 15% vs yesterday',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Active Member',
            gym.activeMembers.toString(),
            '↑ 8% vs last month',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String subtext) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(subtext, style: const TextStyle(color: _green, fontSize: 10)),
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
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Check-ins',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),

          const Row(
            children: [
              Expanded(
                child: Text(
                  'Name',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ),
              Expanded(
                child: Text(
                  'Type',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ),
              Expanded(
                child: Text(
                  'Time',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ),
              Expanded(
                child: Text(
                  'Methods',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white10),

          ...recentLogs.map((log) {
            final memberName = log['name'] ?? '';
            final member = gym.members.where((m) => m['name'] == memberName);
            final type = member.isNotEmpty ? member.first['type'] ?? '' : '';

            return _buildRecentRow(
              memberName,
              type,
              log['time'] ?? '',
              log['method'] ?? '',
            );
          }),

          if (recentLogs.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No recent check-ins',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ),
            ),

          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/checkins'),
              child: const Text(
                'View All',
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRow(String name, String type, String time, String method) {
    const style = TextStyle(color: Colors.white70, fontSize: 12);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(name, overflow: TextOverflow.ellipsis, style: style),
          ),
          Expanded(
            child: Text(type, overflow: TextOverflow.ellipsis, style: style),
          ),
          Expanded(
            child: Text(time, overflow: TextOverflow.ellipsis, style: style),
          ),
          Expanded(
            child: Text(method, overflow: TextOverflow.ellipsis, style: style),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CHECK-INS OVERVIEW CHART
  // ============================================================

  Widget _buildOverviewChart() {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Check-ins Overview',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Container(
                height: 28,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedPeriod,
                    isDense: true,
                    dropdownColor: _cardColor,
                    borderRadius: BorderRadius.circular(6),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                      size: 16,
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                    items: _periods
                        .map(
                          (p) => DropdownMenuItem<String>(
                            value: p,
                            child: Text(p),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedPeriod = value);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Expanded(
            child: CustomPaint(
              painter: _ChartPainter(),
              child: const SizedBox.expand(),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 22,
                height: 6,
                decoration: BoxDecoration(
                  color: _green,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Check-ins',
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
              const SizedBox(width: 28),
              Container(
                width: 22,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Check-outs',
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
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
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Today’s Logs',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/checkins'),
                child: const Text(
                  'View All',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildLogRow('Total Check-Ins', gym.todayCheckIns.toString()),
          _buildLogRow('Total Check-Outs', gym.todayCheckOuts.toString()),
          _buildLogRow('Manual Entries', manualEntries.toString()),
          _buildLogRow('Active Members', gym.activeMembers.toString()),
        ],
      ),
    );
  }

  Widget _buildLogRow(String title, String value) {
    return Container(
      height: 40,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
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
    const double top = 6;
    const double right = 7;
    const double bottom = 22;

    final chartWidth = size.width - left - right;
    final chartHeight = size.height - top - bottom;

    final gridPaint = Paint()
      ..color = Colors.white10
      ..strokeWidth = 1;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    const labelStyle = TextStyle(color: Colors.grey, fontSize: 10);

    // GRID + Y LABELS
    const values = ['150', '100', '50', '0'];

    for (int i = 0; i < 4; i++) {
      final y = top + (chartHeight / 3) * i;

      canvas.drawLine(
        Offset(left, y),
        Offset(size.width - right, y),
        gridPaint,
      );

      textPainter.text = TextSpan(text: values[i], style: labelStyle);
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - textPainter.height / 2));
    }

    // X LABELS
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

      textPainter.text = TextSpan(text: dates[i], style: labelStyle);
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - textPainter.height),
      );
    }

    // LINES
    void drawLine(List<double> data, Color color) {
      final paint = Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round;

      final path = Path();

      for (int i = 0; i < data.length; i++) {
        final x = left + spacing * i;
        final y = top + chartHeight - ((data[i] / 150) * chartHeight);

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, paint);
    }

    drawLine(const [
      70.0,
      90.0,
      115.0,
      105.0,
      135.0,
      125.0,
      128.0,
    ], const Color(0xFF00FF66));
    drawLine(const [55.0, 75.0, 85.0, 92.0, 105.0, 110.0, 116.0], Colors.grey);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
