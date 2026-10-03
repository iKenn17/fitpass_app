import 'package:flutter/material.dart';
import '../widgets/fitpass_layout.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String selectedFilter = 'All';

  static const List<String> _filters = [
    'All',
    'QR-code',
    'Manual',
    'Currently In',
  ];

  static const Color _cardColor = Color(0xFF2B2B2B);
  static const Color _green = Color(0xFF00FF66);
  static const Color _buttonGreen = Color(0xFF28C76F);

  BoxDecoration get _cardDecoration => BoxDecoration(
    color: _cardColor,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.white10),
  );

  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Membership expiring soon',
      'description': 'Ahrone Dela Cruz quarterly plan in 4 days.',
      'time': '6 hours ago',
      'type': 'Manual',
      'icon': Icons.warning_amber_rounded,
      'color': Colors.amber,
      'background': Color(0xFF5A4827),
      'read': false,
    },
    {
      'title': 'Unusual check-in pattern',
      'description':
          'Jasper Sibayan check-in twice within 5 minutes at the front desk.',
      'time': '3 hours ago',
      'type': 'QR-code',
      'icon': Icons.check_circle,
      'color': Colors.greenAccent,
      'background': Color(0xFF21663A),
      'read': false,
    },
    {
      'title': 'Membership expired',
      'description':
          'Emman Jalal senior wellness plan expired yesterday and has not been renewed.',
      'time': '1 day ago',
      'type': 'Manual',
      'icon': Icons.warning,
      'color': Colors.redAccent,
      'background': Color(0xFF651B25),
      'read': false,
    },
    {
      'title': 'Daily reports',
      'description':
          'Yesterday check-in and revenue summary has been generated.',
      'time': '3 days ago',
      'type': 'Manual',
      'icon': Icons.settings,
      'color': Colors.lightBlueAccent,
      'background': Color(0xFF1457A0),
      'read': false,
    },
    {
      'title': 'New member checked in for the first time',
      'description': 'Liza Mendoza completed her first check-in using QR CODE.',
      'time': '2 days ago',
      'type': 'QR-code',
      'icon': Icons.check_circle,
      'color': Colors.greenAccent,
      'background': Color(0xFF21663A),
      'read': false,
    },
    {
      'title': '3 members expiring next week',
      'description': 'Review the Member page to send renewal reminders.',
      'time': '3 days ago',
      'type': 'Manual',
      'icon': Icons.warning_amber_rounded,
      'color': Colors.amber,
      'background': Color(0xFF5A4827),
      'read': false,
    },
    {
      'title': 'Backup complete',
      'description': 'Nightly database backup finished successfully.',
      'time': '2 days ago',
      'type': 'Manual',
      'icon': Icons.settings,
      'color': Colors.lightBlueAccent,
      'background': Color(0xFF1457A0),
      'read': false,
    },
  ];

  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedFilter == 'All') return notifications;

    return notifications.where((n) => n['type'] == selectedFilter).toList();
  }

  int get unreadCount => notifications.where((n) => n['read'] == false).length;

  @override
  Widget build(BuildContext context) {
    final items = filteredNotifications;

    return FitpassLayout(
      currentPage: '/notifications',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // TITLE
            // ==================================================
            const Text(
              'NOTIFICATIONS',
              style: TextStyle(
                color: _green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 16),

            // ==================================================
            // HEADER + FILTERS
            // ==================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'All Notifications',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      if (unreadCount > 0) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF294A31),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$unreadCount new',
                            style: const TextStyle(
                              color: _green,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],

                      const Spacer(),

                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: _markAllAsRead,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white24),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Mark all as read',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _filters.map(_filterButton).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ==================================================
            // NOTIFICATIONS
            // ==================================================
            if (items.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: _cardDecoration,
                child: const Center(
                  child: Text(
                    'No notifications found.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ),

            ...items.map(_notificationCard),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // FILTER BUTTON
  // ==========================================================

  Widget _filterButton(String title) {
    final selected = selectedFilter == title;

    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: () => setState(() => selectedFilter = title),
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? _buttonGreen : const Color(0xFF424242),
          foregroundColor: selected ? Colors.black : Colors.white70,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(color: selected ? _buttonGreen : Colors.white10),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ==========================================================
  // NOTIFICATION CARD
  // ==========================================================

  Widget _notificationCard(Map<String, dynamic> notification) {
    final bool isRead = notification['read'] == true;

    return Opacity(
      opacity: isRead ? 0.6 : 1.0,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: notification['background'],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                notification['icon'],
                color: notification['color'],
                size: 22,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    notification['description'],
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    notification['time'],
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),

            // Unread dot
            if (!isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4, left: 8),
                decoration: const BoxDecoration(
                  color: _green,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // MARK ALL AS READ
  // ==========================================================

  void _markAllAsRead() {
    setState(() {
      for (final notification in notifications) {
        notification['read'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read.'),
        backgroundColor: _buttonGreen,
      ),
    );
  }
}
