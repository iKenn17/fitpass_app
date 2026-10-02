import 'package:flutter/material.dart';
import 'overview.dart';

/// ---------------------------------------------------------------------
/// DESIGN NOTE
/// Same scoreboard-style layout as before (flat panels, hairline rules,
/// segmented bar for revenue, intensity bars for peak hours, sparkline for
/// member growth) — but recolored to match the rest of the app's existing
/// dark theme instead of introducing a new palette.
///
/// Palette (matches overview.dart / the rest of the system):
///   Chrome (sidebar/header)  #1B1B1B
///   Panel fill               #2B2B2B
///   Border                   Colors.white10
///   Primary text             Colors.white
///   Secondary text           Colors.grey
///   Accent                   #00FF66  (same green used everywhere else)
///   Secondary data color     Colors.lightBlueAccent (matches the old donut)
/// ---------------------------------------------------------------------

const _panelFill = Color(0xFF2B2B2B);
const _border = Colors.white10;
const _accent = Color(0xFF00FF66);
const _secondary = Colors.lightBlueAccent;

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          SidebarWidget(currentRoute: 'Analytics'),
          Expanded(
            child: Column(
              children: [
                HeaderWidget(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ANALYTICS',
                          style: TextStyle(
                            color: _accent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Metric strip — one panel, four blocks divided
                        // by hairlines instead of four separate cards.
                        _MetricStrip(),
                        SizedBox(height: 16),

                        // Middle section
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: _CheckInPanel()),
                            SizedBox(width: 16),
                            Expanded(flex: 2, child: _RevenueByPlanPanel()),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Bottom section
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: _PeakHoursPanel()),
                            SizedBox(width: 16),
                            Expanded(flex: 2, child: _MemberGrowthPanel()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shared panel chrome — matches the Container/BoxDecoration used
/// everywhere else in the app (overview.dart cards, etc).
class _Panel extends StatelessWidget {
  final Widget child;
  final double? height;
  const _Panel({required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _panelFill,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _border),
      ),
      child: child,
    );
  }
}

class _PanelTitle extends StatelessWidget {
  final String title;
  final String? trailing;
  const _PanelTitle({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    if (trailing == null) {
      return Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Text(trailing!,
                  style: const TextStyle(color: Colors.white, fontSize: 10)),
              const Icon(Icons.arrow_drop_down, color: Colors.white, size: 14),
            ],
          ),
        ),
      ],
    );
  }
}

/// ---- Metric strip -----------------------------------------------------

class _MetricStrip extends StatelessWidget {
  const _MetricStrip();

  @override
  Widget build(BuildContext context) {
    return const _Panel(
      child: Row(
        children: [
          Expanded(
            child: _StatBlock(
              value: '1,200',
              label: 'Total Member',
              delta: '↑ 15% vs yesterday',
              positive: true,
            ),
          ),
          _StatDivider(),
          Expanded(
            child: _StatBlock(
              value: '5,200',
              label: 'Total Check-ins',
              delta: '↑ 10.8% vs yesterday',
              positive: true,
            ),
          ),
          _StatDivider(),
          Expanded(
            child: _StatBlock(
              value: '342',
              label: 'Active Member',
              delta: '↑ 8% vs last month',
              positive: true,
            ),
          ),
          _StatDivider(),
          Expanded(
            child: _StatBlock(
              value: '₱284,200',
              label: 'Active Revenue',
              delta: 'vs last month',
              positive: null,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: _border,
    );
  }
}

class _StatBlock extends StatelessWidget {
  final String value;
  final String label;
  final String delta;
  final bool? positive; // null = neutral, no accent color

  const _StatBlock({
    required this.value,
    required this.label,
    required this.delta,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          delta,
          style: TextStyle(
            color: positive == true ? _accent : Colors.grey,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

/// ---- Check-in panel -----------------------------------------------------

class _CheckInPanel extends StatelessWidget {
  const _CheckInPanel();

  static const _days = <_DayValue>[
    _DayValue('Mon', 0.55),
    _DayValue('Tue', 0.45),
    _DayValue('Wed', 0.85),
    _DayValue('Thu', 0.85),
    _DayValue('Fri', 0.55),
    _DayValue('Sat', 0.35),
    _DayValue('Sun', 0.55),
  ];

  @override
  Widget build(BuildContext context) {
    return _Panel(
      height: 236,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PanelTitle(
              title: 'Check-in ---- Last 7 Day', trailing: 'This week'),
          const SizedBox(height: 28),
          SizedBox(
            height: 130,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final d in _days)
                  _BarItem(day: d.day, heightFactor: d.value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayValue {
  final String day;
  final double value;
  const _DayValue(this.day, this.value);
}

class _BarItem extends StatelessWidget {
  final String day;
  final double heightFactor;
  const _BarItem({required this.day, required this.heightFactor});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: heightFactor,
              child: Container(
                width: 28,
                decoration: BoxDecoration(
                  color: _accent,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }
}

/// ---- Revenue by plan: segmented horizontal bar --------------------------

class RevenuePlanSlice {
  final String label;
  final Color color;
  final double share;
  const RevenuePlanSlice(
      {required this.label, required this.color, required this.share});
}

class _RevenueByPlanPanel extends StatelessWidget {
  const _RevenueByPlanPanel();

  static const _slices = [
    RevenuePlanSlice(label: 'Regular', color: _accent, share: 0.50),
    RevenuePlanSlice(label: 'Student', color: _secondary, share: 0.24),
    RevenuePlanSlice(label: 'Senior', color: Colors.blue, share: 0.05),
  ];

  double get _total => _slices.fold(0.0, (s, x) => s + x.share);

  @override
  Widget build(BuildContext context) {
    return _Panel(
      height: 236,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Revenue by plan',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              Text(
                '${(_total * 100).round()}% allocated',
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Segmented bar — fixed height, each segment's width is its
          // share of the whole; remainder reads as the gap in the ring.
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 14,
              child: Row(
                children: [
                  for (final s in _slices)
                    Expanded(
                      flex: (s.share * 1000).round(),
                      child: Container(color: s.color),
                    ),
                  Expanded(
                    flex: ((1 - _total).clamp(0.0, 1.0) * 1000).round(),
                    child: Container(color: const Color(0xFF1E1E1E)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          for (var i = 0; i < _slices.length; i++) ...[
            if (i != 0) const SizedBox(height: 12),
            _LegendRow(slice: _slices[i]),
          ],
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final RevenuePlanSlice slice;
  const _LegendRow({required this.slice});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: slice.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            slice.label,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          '${(slice.share * 100).round()}%',
          style: const TextStyle(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

/// ---- Peak hours: each row carries its own intensity bar -----------------

class _PeakHoursPanel extends StatelessWidget {
  const _PeakHoursPanel();

  // level: 0..1, used to size the little intensity bar beside each row.
  static const _rows = <_PeakRow>[
    _PeakRow('6:00 AM - 8:00 AM', 'High', 0.7),
    _PeakRow('6:00 AM - 8:00 AM', 'Medium', 0.5),
    _PeakRow('5:00 PM - 8:00 PM', 'Peak', 1.0),
    _PeakRow('9:00 PM - 10:00 PM', 'Low', 0.25),
    _PeakRow('11:00 PM - 12:00 AM', 'Soft', 0.15),
  ];

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Peak Hours',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 12),
          const Divider(color: _border),
          for (final r in _rows) _PeakHourRow(row: r),
        ],
      ),
    );
  }
}

class _PeakRow {
  final String time;
  final String status;
  final double level;
  const _PeakRow(this.time, this.status, this.level);
}

class _PeakHourRow extends StatelessWidget {
  final _PeakRow row;
  const _PeakHourRow({required this.row});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              row.time,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 6,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: row.level,
                  child: Container(
                    decoration: BoxDecoration(
                      color: row.status == 'Peak' ? _accent : _secondary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 56,
            child: Text(
              row.status,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---- Member growth: sparkline instead of a bar chart ---------------------

class _MemberGrowthPanel extends StatelessWidget {
  const _MemberGrowthPanel();

  static const _months = ['Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'];
  // Flat trend — the source data carries no distinguishing values between
  // months, so the line stays level rather than implying growth figures
  // that were never provided.
  static const _values = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _panelFill,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueAccent, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Member Growth (6 Months)',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 24),
          const SizedBox(
            height: 90,
            child: CustomPaint(
              painter: _SparklinePainter(values: _values),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final m in _months)
                Text(m,
                    style: const TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> values; // each 0..1
  const _SparklinePainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final dx = values.length > 1 ? size.width / (values.length - 1) : 0.0;
    final points = <Offset>[
      for (var i = 0; i < values.length; i++)
        Offset(dx * i, size.height * (1 - values[i])),
    ];

    final linePaint = Paint()
      ..color = _accent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()
      ..color = const Color(0xFF1E88E5); // matches the app's blue accent
    for (final p in points) {
      canvas.drawCircle(p, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
      oldDelegate.values != values;
}
