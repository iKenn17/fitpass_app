import 'package:flutter/material.dart';
import 'analytics.dart';
import 'audit_logs.dart';
import 'check_in.dart';
import 'members.dart';
import 'staff_management.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Sidebar
          const SidebarWidget(currentRoute: 'Overview'),

          // Main Dashboard Body
          Expanded(
            child: Column(
              children: [
                // Top Header Bar
                const HeaderWidget(),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DASHBOARD',
                          style: TextStyle(
                            color: Color(0xFF00FF66),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Metric Cards
                        LayoutBuilder(
                          builder: (context, constraints) {
                            double cardWidth = (constraints.maxWidth - 36) / 4;
                            return Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _buildMetricCard('Total Member', '1,200',
                                    '↑ 15% vs yesterday', cardWidth),
                                _buildMetricCard('Total Check-ins', '5,200',
                                    '↑ 10.8% vs yesterday', cardWidth),
                                _buildMetricCard('Active Member', '342',
                                    '↑ 8% vs last month', cardWidth),
                                _buildMetricCard('Active Revenue', '₱284,200',
                                    'vs last month', cardWidth),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Recent Check-ins & Graph Row
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: RecentCheckInsWidget()),
                            SizedBox(width: 16),
                            Expanded(flex: 3, child: CheckInsOverviewWidget()),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Bottom Section
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: TopPerformingDaysWidget()),
                            SizedBox(width: 16),
                            Expanded(child: MemberByTypeWidget()),
                            SizedBox(width: 16),
                            Expanded(child: SystemStatusWidget()),
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

  Widget _buildMetricCard(
      String title, String value, String subtext, double width) {
    return Container(
      width: width < 180 ? 180 : width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(subtext,
              style: const TextStyle(color: Color(0xFF00FF66), fontSize: 10)),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SIDEBAR WIDGET WITH ROUTING — matched to screenshot (icons + spacing)
// -----------------------------------------------------------------------------
class SidebarWidget extends StatelessWidget {
  final String currentRoute;
  const SidebarWidget({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
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
                'images/logo.png',
                width: 70,
                height: 70,
                fit: BoxFit.contain,
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
                              height: 1.0),
                        ),
                        TextSpan(
                          text: 'PASS',
                          style: TextStyle(
                              color: Color(0xFF9AE04A),
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                              height: 1.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text('GYM',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w500)),
                ],
              )
            ],
          ),
          const SizedBox(height: 32),
          _buildNavItem(
            context,
            Icons.dashboard_customize_outlined,
            'Dashboard',
            isActive: currentRoute == 'Overview',
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const OverviewScreen()),
            ),
          ),
          _buildNavItem(
            context,
            Icons.show_chart,
            'Analytics',
            isActive: currentRoute == 'Analytics',
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
            ),
          ),
          _buildNavItem(
            context,
            Icons.people_alt_outlined,
            'Members',
            isActive: currentRoute == 'Members',
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MembersScreen()),
            ),
          ),
          _buildNavItem(
            context,
            Icons.assignment_ind_outlined,
            'Staff Management',
            isActive: currentRoute == 'Staff Management',
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const StaffManagementScreen()),
            ),
          ),
          _buildNavItem(
            context,
            Icons.settings_outlined,
            'Check-in',
            isActive: currentRoute == 'Check-in',
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CheckInScreen()),
            ),
          ),
          _buildNavItem(
            context,
            Icons.description_outlined,
            'Audit Logs',
            isActive: currentRoute == 'Audit Logs',
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AuditLogsScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String title, {
    bool isActive = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF294A31) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        leading: Icon(icon,
            color: isActive ? Colors.white : Colors.white70, size: 20),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13.5,
          ),
        ),
        onTap: onTap ?? () {},
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// HEADER WITH WORKING SEARCH BAR
//
//  • Default ("page search"): type to see matching pages, then tap one (or
//    press Enter) to jump there. Works on every screen with no extra code.
//  • If a screen passes [onSearchChanged], the bar filters that screen's own
//    content live instead (e.g. the staff list on Staff Management).
// -----------------------------------------------------------------------------
class _SearchTarget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> keywords;
  final Widget Function() builder;

  const _SearchTarget({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.keywords,
    required this.builder,
  });

  bool matches(String query) {
    final q = query.toLowerCase();
    return title.toLowerCase().contains(q) ||
        keywords.any((k) => k.contains(q));
  }
}

final List<_SearchTarget> _searchTargets = [
  _SearchTarget(
    title: 'Overview',
    subtitle: 'Dashboard & key metrics',
    icon: Icons.dashboard_customize_outlined,
    keywords: ['dashboard', 'home', 'metrics', 'revenue', 'summary'],
    builder: () => const OverviewScreen(),
  ),
  _SearchTarget(
    title: 'Analytics',
    subtitle: 'Charts, trends & performance',
    icon: Icons.show_chart,
    keywords: ['chart', 'charts', 'graph', 'report', 'trends', 'statistics'],
    builder: () => const AnalyticsScreen(),
  ),
  _SearchTarget(
    title: 'Members',
    subtitle: 'Member list & membership types',
    icon: Icons.people_alt_outlined,
    keywords: ['member', 'membership', 'regular', 'student', 'senior'],
    builder: () => const MembersScreen(),
  ),
  _SearchTarget(
    title: 'Staff Management',
    subtitle: 'Staff, roles & shifts',
    icon: Icons.assignment_ind_outlined,
    keywords: [
      'staff',
      'employee',
      'trainer',
      'trainers',
      'front desk',
      'admin',
      'admins',
      'shift',
      'role',
    ],
    builder: () => const StaffManagementScreen(),
  ),
  _SearchTarget(
    title: 'Check-in',
    subtitle: 'Scan & log member check-ins',
    icon: Icons.settings_outlined,
    keywords: ['checkin', 'check in', 'attendance', 'scan', 'qr'],
    builder: () => const CheckInScreen(),
  ),
  _SearchTarget(
    title: 'Audit Logs',
    subtitle: 'Activity history',
    icon: Icons.description_outlined,
    keywords: ['audit', 'log', 'logs', 'history', 'activity', 'security'],
    builder: () => const AuditLogsScreen(),
  ),
];

class HeaderWidget extends StatefulWidget {
  /// When provided, the search bar filters the current screen's content and
  /// calls this on every keystroke (and with '' when cleared).
  final ValueChanged<String>? onSearchChanged;

  /// Optional hint text. Defaults to "Search pages..." (or "Search..." when
  /// [onSearchChanged] is set).
  final String? hintText;

  const HeaderWidget({super.key, this.onSearchChanged, this.hintText});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool get _isLocalSearch => widget.onSearchChanged != null;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onSearchChanged?.call('');
    setState(() {});
  }

  void _goTo(_SearchTarget target) {
    _focusNode.unfocus();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => target.builder()),
    );
  }

  // The dark rounded search box (same look as before, plus a clear button)
  Widget _buildSearchBox({VoidCallback? onSubmit}) {
    return Container(
      height: 36,
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        cursorColor: const Color(0xFF00FF66),
        style: const TextStyle(color: Colors.white, fontSize: 13),
        textAlignVertical: TextAlignVertical.center,
        onChanged: (value) {
          widget.onSearchChanged?.call(value);
          setState(() {}); // refresh the clear (x) button
        },
        onSubmitted: onSubmit == null ? null : (_) => onSubmit(),
        decoration: InputDecoration(
          hintText: widget.hintText ??
              (_isLocalSearch ? 'Search...' : 'Search pages...'),
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
          border: InputBorder.none,
          isCollapsed: true,
          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 18),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 36,
          ),
          suffixIcon: _controller.text.isEmpty
              ? null
              : InkWell(
                  onTap: _clear,
                  borderRadius: BorderRadius.circular(10),
                  child: const Icon(Icons.close, color: Colors.grey, size: 16),
                ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 36,
            minHeight: 36,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  // Search box with a dropdown of matching pages
  Widget _buildPageSearch() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double menuWidth = constraints.maxWidth;

        return RawAutocomplete<_SearchTarget>(
          textEditingController: _controller,
          focusNode: _focusNode,
          displayStringForOption: (target) => target.title,
          optionsBuilder: (TextEditingValue value) {
            final query = value.text.trim();
            if (query.isEmpty) return const Iterable<_SearchTarget>.empty();
            return _searchTargets.where((t) => t.matches(query));
          },
          onSelected: _goTo,
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return _buildSearchBox(onSubmit: onFieldSubmitted);
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Material(
                  color: const Color(0xFF2B2B2B),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.white12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: menuWidth, maxHeight: 280),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options.elementAt(index);
                        final bool highlighted =
                            AutocompleteHighlightedOption.of(context) == index;

                        return InkWell(
                          onTap: () => onSelected(option),
                          hoverColor: Colors.white10,
                          child: Container(
                            color: highlighted
                                ? const Color(0xFF383838)
                                : Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            child: Row(
                              children: [
                                Icon(option.icon,
                                    size: 18, color: const Color(0xFF00FF66)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(option.title,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 2),
                                      Text(option.subtitle,
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFF1B1B1B),
      child: Row(
        children: [
          Expanded(
            child: _isLocalSearch ? _buildSearchBox() : _buildPageSearch(),
          ),
          const Spacer(),
          const Row(
            children: [
              CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white, size: 18)),
              SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Super Admin',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  Text('Owner',
                      style: TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class RecentCheckInsWidget extends StatelessWidget {
  const RecentCheckInsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Check-ins',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                  child: Text('Name',
                      style: TextStyle(color: Colors.grey, fontSize: 11))),
              Expanded(
                  child: Text('Type',
                      style: TextStyle(color: Colors.grey, fontSize: 11))),
              Expanded(
                  child: Text('Time',
                      style: TextStyle(color: Colors.grey, fontSize: 11))),
              Expanded(
                  child: Text('Methods',
                      style: TextStyle(color: Colors.grey, fontSize: 11))),
            ],
          ),
          const Divider(color: Colors.white10),
          _buildRow('boss oma', '', '', ''),
          _buildRow('Jaspher', '', '', 'Manual'),
          _buildRow('Arhone', '', '', 'QR Code'),
          _buildRow('Dwayne', '', '', 'QR Code'),
          _buildRow('emman', '', '', 'Manual'),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('View All',
                  style: TextStyle(color: Colors.grey, fontSize: 11)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRow(String name, String type, String time, String method) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
              child: Text(name,
                  style: const TextStyle(color: Colors.white70, fontSize: 12))),
          Expanded(
              child: Text(type,
                  style: const TextStyle(color: Colors.white70, fontSize: 12))),
          Expanded(
              child: Text(time,
                  style: const TextStyle(color: Colors.white70, fontSize: 12))),
          Expanded(
              child: Text(method,
                  style: const TextStyle(color: Colors.white70, fontSize: 12))),
        ],
      ),
    );
  }
}

class CheckInsOverviewWidget extends StatefulWidget {
  const CheckInsOverviewWidget({super.key});

  @override
  State<CheckInsOverviewWidget> createState() => _CheckInsOverviewWidgetState();
}

class _CheckInsOverviewWidgetState extends State<CheckInsOverviewWidget> {
  static const List<String> _ranges = [
    'This Week',
    'Last Week',
    'This Month',
    'Last Month',
  ];

  // Placeholder x-axis labels per range (replace with real data later)
  static const Map<String, List<String>> _labels = {
    'This Week': [
      'May 12',
      'May 13',
      'May 14',
      'May 15',
      'May 16',
      'May 17',
      'May 18'
    ],
    'Last Week': [
      'May 5',
      'May 6',
      'May 7',
      'May 8',
      'May 9',
      'May 10',
      'May 11'
    ],
    'This Month': ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
    'Last Month': ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
  };

  String _selected = 'This Week';

  @override
  Widget build(BuildContext context) {
    final labels = _labels[_selected]!;

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Check-ins Overview',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              Container(
                height: 28,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selected,
                    isDense: true,
                    dropdownColor: const Color(0xFF2B2B2B),
                    borderRadius: BorderRadius.circular(6),
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Colors.white, size: 16),
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                    items: _ranges
                        .map((r) => DropdownMenuItem<String>(
                              value: r,
                              child: Text(r),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _selected = value);
                      // TODO: reload chart data for the selected range here
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _AxisLine(label: '150'),
                _AxisLine(label: '100'),
                _AxisLine(label: '50'),
                _AxisLine(label: '0'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: labels
                .map((l) => Text(l,
                    style: const TextStyle(color: Colors.grey, fontSize: 10)))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _AxisLine extends StatelessWidget {
  final String label;
  const _AxisLine({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: 24,
            child: Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 10))),
        const Expanded(child: Divider(color: Colors.white10, height: 1)),
      ],
    );
  }
}

class TopPerformingDaysWidget extends StatelessWidget {
  const TopPerformingDaysWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top performing Days',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          const SizedBox(height: 12),
          _buildRow('1. May 19, 2025', '200'),
          _buildRow('2. May 19, 2025', '200'),
          _buildRow('3. May 19, 2025', '200'),
          _buildRow('4. May 19, 2025', '200'),
          _buildRow('5. May 19, 2025', '200'),
          _buildRow('6. May 19, 2025', '200'),
        ],
      ),
    );
  }

  Widget _buildRow(String day, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
          Text(count,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class MemberByTypeWidget extends StatelessWidget {
  const MemberByTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Member by Type',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              height: 80,
              width: 80,
              child: CustomPaint(painter: DonutChartPainter()),
            ),
          ),
          const SizedBox(height: 12),
          _buildLegendRow(const Color(0xFF00FF66), 'Regular', '50%'),
          _buildLegendRow(Colors.lightBlueAccent, 'Student', '24%'),
          _buildLegendRow(Colors.blue, 'Senior', '5%'),
        ],
      ),
    );
  }

  Widget _buildLegendRow(Color color, String label, String percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const Spacer(),
          Text(percentage,
              style: const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 10.0;
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    paint.color = const Color(0xFF00FF66);
    canvas.drawArc(rect, -1.57, 3.14, false, paint);

    paint.color = Colors.lightBlueAccent;
    canvas.drawArc(rect, 1.57, 1.5, false, paint);

    paint.color = Colors.blue;
    canvas.drawArc(rect, 3.07, 0.3, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SystemStatusWidget extends StatelessWidget {
  const SystemStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('System Status',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          const SizedBox(height: 12),
          _buildStatusRow('QR Scanner', 'Online'),
          _buildStatusRow('Data Base', 'Online'),
          _buildStatusRow('Payment Gateway', 'Online'),
          _buildStatusRow('Backup', 'Online'),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String title, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
          Text(status,
              style: const TextStyle(
                  color: Color(0xFF00FF66),
                  fontSize: 11,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
