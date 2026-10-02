import 'package:flutter/material.dart';
import 'overview.dart'; // Imports SidebarWidget and HeaderWidget

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  String selectedFilter = 'All';

  final List<Map<String, String>> checkInLogs = [
    {
      'initials': 'JS',
      'name': 'Jaspher Sibayan',
      'title': 'Regular',
      'timeIn': '6:00 AM',
      'timeOut': '----',
      'method': 'MANUAL',
      'status': 'In Gym',
    },
    {
      'initials': 'AM',
      'name': 'Ahrone Magtibay',
      'title': 'Student',
      'timeIn': '6:00 AM',
      'timeOut': '7:00 AM',
      'method': 'QR Code',
      'status': 'Checked Out',
    },
    {
      'initials': 'EJ',
      'name': 'Emman Jalal',
      'title': 'Regular',
      'timeIn': '6:00 AM',
      'timeOut': '----',
      'method': 'QR Code',
      'status': 'Checked Out',
    },
    {
      'initials': 'FD',
      'name': 'Fabs Dela Cruz',
      'title': 'Senior',
      'timeIn': '6:00 AM',
      'timeOut': '8:00 AM',
      'method': 'MANUAL',
      'status': 'In Gym',
    },
    {
      'initials': 'DT',
      'name': 'Dwayne Tore',
      'title': 'Regular',
      'timeIn': '6:00 AM',
      'timeOut': '----',
      'method': 'QR Code',
      'status': 'Checked Out',
    },
  ];

  List<Map<String, String>> get filteredLogs {
    if (selectedFilter == 'All') return checkInLogs;
    if (selectedFilter == 'QR-code') {
      return checkInLogs.where((log) => log['method'] == 'QR Code').toList();
    }
    if (selectedFilter == 'Manual') {
      return checkInLogs.where((log) => log['method'] == 'MANUAL').toList();
    }
    if (selectedFilter == 'Currently In') {
      return checkInLogs.where((log) => log['status'] == 'In Gym').toList();
    }
    return checkInLogs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      body: Row(
        children: [
          // Sidebar Widget with 'Check-in' active
          const SidebarWidget(currentRoute: 'Check-in'),

          // Main Content
          Expanded(
            child: Column(
              children: [
                const HeaderWidget(),

                // Scrollable Content Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CHECK-INS',
                          style: TextStyle(
                            color: Color(0xFF00FF66),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Metric Cards Row
                        LayoutBuilder(
                          builder: (context, constraints) {
                            double cardWidth = (constraints.maxWidth - 36) / 4;
                            return Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _buildMetricCard(
                                    'Check-ins Today',
                                    '128',
                                    '↑ 15% vs yesterday',
                                    const Color(0xFF00FF66),
                                    cardWidth),
                                _buildMetricCard(
                                    'Check-outs Today',
                                    '116',
                                    '↑ 15% vs yesterday',
                                    const Color(0xFF00FF66),
                                    cardWidth),
                                _buildMetricCard(
                                    'Still in GyM',
                                    '12',
                                    '↓ 4 since noon',
                                    Colors.redAccent,
                                    cardWidth),
                                _buildMetricCard(
                                    'Manual Entries',
                                    '24',
                                    '↑ 8% vs last month',
                                    const Color(0xFF00FF66),
                                    cardWidth),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        // Today's Check-in Logs Container
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF232323),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Today's Check-in Logs",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Filter Pills & Export / Action Buttons Row
                              Row(
                                children: [
                                  Wrap(
                                    spacing: 8,
                                    children: [
                                      _buildFilterChip('All'),
                                      _buildFilterChip('QR-code'),
                                      _buildFilterChip('Manual'),
                                      _buildFilterChip('Currently In'),
                                    ],
                                  ),
                                  const Spacer(),
                                  _buildExportButton(),
                                  const SizedBox(width: 8),
                                  _buildManualEntryButton(),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Table Headers
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width:
                                            44), // Alignment spacing for Avatar Initials
                                    Expanded(
                                      flex: 3,
                                      child: Text('MEMBER',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text('TITLE',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text('TIME IN',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text('TIME OUT',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text('METHOD',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text('STATUS',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Check-in Log Items List
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredLogs.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  return _buildLogRow(filteredLogs[index]);
                                },
                              ),
                            ],
                          ),
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

  // Filter Chip Widget
  Widget _buildFilterChip(String label) {
    bool isSelected = selectedFilter == label;
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: GestureDetector(
            onTap: () {
              this.setState(() {
                selectedFilter = label;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF383838)
                    : (isHovered
                        ? const Color(0xFF333333)
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF00FF66)
                      : (isHovered ? Colors.white38 : Colors.white24),
                  width: isSelected ? 1.2 : 1.0,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFF00FF66)
                      : (isHovered ? Colors.white : Colors.white70),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Export Action Button
  Widget _buildExportButton() {
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isHovered
                    ? const Color(0xFF333333)
                    : const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white24),
              ),
              child: const Text(
                'Export',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Manual Entry Action Button
  Widget _buildManualEntryButton() {
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isHovered
                    ? const Color(0xFF00E65C)
                    : const Color(0xFF1E3A29),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFF00FF66),
                  width: 1,
                ),
              ),
              child: Text(
                '+ Manual Entry',
                style: TextStyle(
                  color: isHovered ? Colors.black : const Color(0xFF00FF66),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Row Card for Check-in Log Items
  Widget _buildLogRow(Map<String, String> log) {
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color:
                  isHovered ? const Color(0xFF333333) : const Color(0xFF2B2B2B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isHovered
                    ? const Color(0xFF00FF66).withValues(alpha: 0.5)
                    : Colors.white12,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF444444),
                  child: Text(
                    log['initials']!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Text(
                    log['name']!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    log['title']!,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    log['timeIn']!,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    log['timeOut']!,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: _buildMethodBadge(log['method']!),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _buildStatusBadge(log['status']!),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Method Pill Tag (MANUAL / QR Code)
  Widget _buildMethodBadge(String method) {
    bool isManual = method == 'MANUAL';
    Color color = isManual ? Colors.blueAccent : const Color(0xFF00FF66);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            method,
            style: TextStyle(
                color: color, fontSize: 9, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Status Badge Tag (In Gym / Checked Out)
  Widget _buildStatusBadge(String status) {
    bool isInGym = status == 'In Gym';
    Color textColor = isInGym ? const Color(0xFF00FF66) : Colors.grey;
    Color borderColor = isInGym
        ? const Color(0xFF00FF66).withValues(alpha: 0.4)
        : Colors.white12;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isInGym
            ? const Color(0xFF00FF66).withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(
            color: textColor, fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }

  // Metric Header Card
  Widget _buildMetricCard(String title, String value, String subtext,
      Color subtextColor, double width) {
    return Container(
      width: width < 180 ? 180 : width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF232323),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtext,
            style: TextStyle(color: subtextColor, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
