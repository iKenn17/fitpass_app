import 'package:flutter/material.dart';
import 'overview.dart'; // Imports SidebarWidget and HeaderWidget

class AuditLogsScreen extends StatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> {
  String selectedTab = 'Audit Logs';

  final List<Map<String, String>> auditLogs = [
    {
      'time': 'Today 5:00 AM',
      'user': 'Jaspher Sibayan',
      'action': 'updated the Student plan price to 800.',
    },
    {
      'time': 'Today 8:00 AM',
      'user': 'Ahrone Magtibay',
      'action': 'logged in as Admin',
    },
    {
      'time': 'Today 12:00 PM',
      'user': 'System',
      'action': 'Completed the nighty database backup',
    },
    {
      'time': 'Today 5:00 PM',
      'user': 'Fabs Dela Cruz',
      'action': 'manually checked in boss oma',
    },
    {
      'time': 'Today 10:00 AM',
      'user': 'Dwayne Tore',
      'action': 'deactivated staff account Mark Reyes',
    },
    {
      'time': 'Today 6:00 AM',
      'user': 'Emman Pico',
      'action': 'added new member john loyd',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      body: Row(
        children: [
          // Sidebar Widget with 'Audit Logs' active
          const SidebarWidget(currentRoute: 'Audit Logs'),

          // Main Screen Content
          Expanded(
            child: Column(
              children: [
                const HeaderWidget(),

                // Scrollable Body Area
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'REPORTS & AUDIT LOGS',
                          style: TextStyle(
                            color: Color(0xFF00FF66),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Main Container Housing Navigation & Log List
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
                              // Tab Bar Switcher (Reports / Audit Logs)
                              Row(
                                children: [
                                  _buildTabButton('Reports'),
                                  const SizedBox(width: 8),
                                  _buildTabButton('Audit Logs'),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Audit Log List Items
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: auditLogs.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  return _buildAuditLogRow(auditLogs[index]);
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

  // Tab Selector Button (Reports / Audit Logs)
  Widget _buildTabButton(String label) {
    bool isSelected = selectedTab == label;
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: GestureDetector(
            onTap: () {
              this.setState(() {
                selectedTab = label;
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

  // Audit Log Entry Row
  Widget _buildAuditLogRow(Map<String, String> log) {
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color:
                  isHovered ? const Color(0xFF333333) : const Color(0xFF2B2B2B),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isHovered
                    ? const Color(0xFF00FF66).withValues(alpha: 0.5)
                    : Colors.white12,
              ),
            ),
            child: Row(
              children: [
                // Timestamp
                SizedBox(
                  width: 120,
                  child: Text(
                    log['time']!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Cyan Status Dot Indicator
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00E5FF),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),

                // User & Action Description Text
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white70),
                      children: [
                        TextSpan(
                          text: '${log['user']!} ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: log['action']!,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
