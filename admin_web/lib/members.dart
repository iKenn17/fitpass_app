import 'package:flutter/material.dart';
import 'overview.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  String selectedFilter = 'All';
  bool isTableView = true;

  final List<Map<String, String>> allMembers = [
    {
      'initials': 'JS',
      'name': 'Jaspher Sibayan',
      'plan': 'Regular',
      'type': 'Monthly Unlimited',
      'joined': 'Aug 10, 2026',
      'expires': 'Aug 10, 2026',
      'status': 'Active',
    },
    {
      'initials': 'AM',
      'name': 'Ahrone Magtibay',
      'plan': 'Student',
      'type': 'Quarterly',
      'joined': 'Oct 5, 2025',
      'expires': 'Oct 5, 2025',
      'status': 'Active',
    },
    {
      'initials': 'EJ',
      'name': 'Emman Jalal',
      'plan': 'Regular',
      'type': 'Student',
      'joined': 'Feb 20, 2025',
      'expires': 'Feb 20, 2025',
      'status': 'Expired',
    },
    {
      'initials': 'FD',
      'name': 'Fabs Dela Cruz',
      'plan': 'Senior',
      'type': 'Senior',
      'joined': 'Apr 10, 2026',
      'expires': 'Apr 10, 2026',
      'status': 'Active',
    },
    {
      'initials': 'DT',
      'name': 'Dwayne Tore',
      'plan': 'Regular',
      'type': 'Student',
      'joined': 'Jun 5, 2026',
      'expires': 'Jun 5, 2026',
      'status': 'Expiring soon',
    },
    {
      'initials': 'EP',
      'name': 'Emman Pico',
      'plan': 'Student',
      'type': 'Monthly Unlimited',
      'joined': 'Nov 9, 2026',
      'expires': 'Nov 9, 2026',
      'status': 'Expired',
    },
  ];

  List<Map<String, String>> get filteredMembers {
    if (selectedFilter == 'All') return allMembers;
    if (selectedFilter == 'Expiring soon') {
      return allMembers.where((m) => m['status'] == 'Expiring soon').toList();
    }
    return allMembers.where((m) => m['plan'] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Row(
        children: [
          const SidebarWidget(currentRoute: 'Members'),
          Expanded(
            child: Column(
              children: [
                const HeaderWidget(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MEMBERS',
                          style: TextStyle(
                            color: Color(0xFF9AE04A),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildMetricCardsRow(),
                        const SizedBox(height: 16),
                        _buildMembersTableContainer(),
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

  Widget _buildMetricCardsRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = (constraints.maxWidth - 36) / 4;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildMetricCard(
                'Total Member', '1,200', '↑ 15% vs yesterday', cardWidth),
            _buildMetricCard(
                'Total Check-ins', '5,200', '↑ 10.8% vs yesterday', cardWidth),
            _buildMetricCard(
                'Active Member', '342', '↑ 8% vs last month', cardWidth),
            _buildMetricCard(
                'Active Revenue', '₱284,200', 'vs last month', cardWidth),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard(
      String title, String value, String subtext, double width) {
    return Container(
      width: width < 180 ? 180 : width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1B),
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
              style: const TextStyle(color: Color(0xFF9AE04A), fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildMembersTableContainer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'All Members',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Wrap(
                spacing: 8,
                children: [
                  _buildFilterChip('All'),
                  _buildFilterChip('Regular'),
                  _buildFilterChip('Student'),
                  _buildFilterChip('Senior'),
                  _buildFilterChip('Expiring soon'),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFF252525),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    _buildToggleItem('Table', isTableView, () {
                      setState(() => isTableView = true);
                    }),
                    _buildToggleItem('Grid', !isTableView, () {
                      setState(() => isTableView = false);
                    }),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildManualEntryButton(),
            ],
          ),
          const SizedBox(height: 20),
          if (isTableView) ...[
            _buildTableHeader(),
            const Divider(color: Colors.white10),
            ...filteredMembers.map((member) => _buildMemberRow(member)),
          ] else ...[
            _buildGridView(),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final bool isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9AE04A) : const Color(0xFF252525),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildToggleItem(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1B1B1B) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.grey,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildManualEntryButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF9AE04A),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      onPressed: () {},
      icon: const Icon(Icons.add, size: 16),
      label: const Text('Manual Entry',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildTableHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 40),
          Expanded(
              flex: 3,
              child: Text('NAME',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child: Text('PLAN',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child: Text('TYPE',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child: Text('JOINED',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child: Text('EXPIRES',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child: Text('STATUS',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildMemberRow(Map<String, String> member) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF252525),
            child: Text(member['initials']!,
                style: const TextStyle(color: Colors.white, fontSize: 11)),
          ),
          const SizedBox(width: 8),
          Expanded(
              flex: 3,
              child: Text(member['name']!,
                  style: const TextStyle(color: Colors.white, fontSize: 13))),
          Expanded(
              flex: 2,
              child: Text(member['plan']!,
                  style: const TextStyle(color: Colors.white70, fontSize: 12))),
          Expanded(
              flex: 2,
              child: Text(member['type']!,
                  style: const TextStyle(color: Colors.white70, fontSize: 12))),
          Expanded(
              flex: 2,
              child: Text(member['joined']!,
                  style: const TextStyle(color: Colors.white70, fontSize: 12))),
          Expanded(
              flex: 2,
              child: Text(member['expires']!,
                  style: const TextStyle(color: Colors.white70, fontSize: 12))),
          Expanded(flex: 2, child: _buildStatusBadge(member['status']!)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    Color bgColor;

    switch (status) {
      case 'Active':
        color = const Color(0xFF9AE04A);
        bgColor = const Color(0xFF9AE04A).withValues(alpha: 0.15);
        break;
      case 'Expiring soon':
        color = Colors.orangeAccent;
        bgColor = Colors.orangeAccent.withValues(alpha: 0.15);
        break;
      default:
        color = Colors.redAccent;
        bgColor = Colors.redAccent.withValues(alpha: 0.15);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration:
          BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4)),
      child: Text(status,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: filteredMembers.length,
      itemBuilder: (context, index) {
        final m = filteredMembers[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF252525),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(m['name']!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
              const SizedBox(height: 4),
              Text('${m['plan']} • ${m['type']}',
                  style: const TextStyle(color: Colors.grey, fontSize: 11)),
              const Spacer(),
              _buildStatusBadge(m['status']!),
            ],
          ),
        );
      },
    );
  }
}
