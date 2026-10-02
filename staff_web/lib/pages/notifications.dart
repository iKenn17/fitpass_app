import 'package:flutter/material.dart';
import '../widgets/fitpass_layout.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() =>
      _NotificationsPageState();
}

class _NotificationsPageState
    extends State<NotificationsPage> {

  String selectedFilter = 'All';

  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Membership expiring soon',
      'description':
          'Ahrone Dela Cruz quarterly plan in 4 days.',
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
      'title':
          'New member checked in for the first time',
      'description':
          'Liza Mendoza completed her first check-in using QR CODE.',
      'time': '2 days ago',
      'type': 'QR-code',
      'icon': Icons.check_circle,
      'color': Colors.greenAccent,
      'background': Color(0xFF21663A),
      'read': false,
    },
    {
      'title': '3 members expiring next week',
      'description':
          'Review the Member page to send renewal reminders.',
      'time': '3 days ago',
      'type': 'Manual',
      'icon': Icons.warning_amber_rounded,
      'color': Colors.amber,
      'background': Color(0xFF5A4827),
      'read': false,
    },
    {
      'title': 'Backup complete',
      'description':
          'Nightly database backup finished successfully.',
      'time': '2 days ago',
      'type': 'Manual',
      'icon': Icons.settings,
      'color': Colors.lightBlueAccent,
      'background': Color(0xFF1457A0),
      'read': false,
    },
  ];

  List<Map<String, dynamic>>
      get filteredNotifications {

    if (selectedFilter == 'All') {
      return notifications;
    }

    return notifications
        .where(
          (notification) {
            if (selectedFilter ==
                'Currently In') {
              return notification['type'] ==
                  'Currently In';
            }

            return notification['type'] ==
                selectedFilter;
          },
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FitpassLayout(
      currentPage: '/notifications',

      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // ================= TITLE =================

            const Text(
              'Notifications',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 10),

            // ================= HEADER =================

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(10),

              decoration: BoxDecoration(
                color: const Color(0xFF252525),

                borderRadius:
                    BorderRadius.circular(5),

                border: Border.all(
                  color: const Color(0xFF3A3A3A),
                ),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [

                      const Text(
                        'All Notification',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      GestureDetector(
                        onTap: _markAllAsRead,

                        child: Container(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),

                          decoration:
                              BoxDecoration(
                            border: Border.all(
                              color:
                                  Colors.white24,
                            ),

                            borderRadius:
                                BorderRadius
                                    .circular(
                              4,
                            ),
                          ),

                          child: const Text(
                            'Mark all as read',
                            style: TextStyle(
                              color:
                                  Colors.white70,
                              fontSize: 7,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // FILTERS

                  Row(
                    children: [

                      _filterButton('All'),

                      const SizedBox(width: 5),

                      _filterButton('QR-code'),

                      const SizedBox(width: 5),

                      _filterButton('Manual'),

                      const SizedBox(width: 5),

                      _filterButton('Currently In'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ================= NOTIFICATIONS =================

            ...filteredNotifications.map(
              (notification) =>
                  _notificationCard(
                notification,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // FILTER BUTTON
  // ==========================================================

  Widget _filterButton(
    String title,
  ) {
    final selected =
        selectedFilter == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = title;
        });
      },

      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 9,
          vertical: 5,
        ),

        decoration:
            BoxDecoration(
          color: selected
              ? const Color(0xFF22C55E)
              : const Color(0xFF252525),

          borderRadius:
              BorderRadius.circular(4),

          border: Border.all(
            color: selected
                ? const Color(0xFF22C55E)
                : Colors.white12,
          ),
        ),

        child: Text(
          title,

          style: TextStyle(
            color: selected
                ? Colors.black
                : Colors.white70,

            fontSize: 7,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // NOTIFICATION CARD
  // ==========================================================

  Widget _notificationCard(
    Map<String, dynamic> notification,
  ) {
    return Container(
      width: double.infinity,

      margin:
          const EdgeInsets.only(
        bottom: 6,
      ),

      padding:
          const EdgeInsets.all(8),

      decoration:
          BoxDecoration(
        color:
            const Color(0xFF252525),

        borderRadius:
            BorderRadius.circular(5),

        border: Border.all(
          color:
              const Color(0xFF3A3A3A),
        ),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Container(
            width: 32,
            height: 32,

            decoration:
                BoxDecoration(
              color:
                  notification['background'],

              borderRadius:
                  BorderRadius.circular(5),
            ),

            child: Icon(
              notification['icon'],
              color:
                  notification['color'],
              size: 18,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  notification['title'],

                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  notification[
                      'description'],

                  style:
                      const TextStyle(
                    color:
                        Colors.white70,
                    fontSize: 7,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  notification['time'],

                  style:
                      const TextStyle(
                    color:
                        Colors.white38,
                    fontSize: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // MARK ALL AS READ
  // ==========================================================

  void _markAllAsRead() {
    setState(() {
      for (final notification
          in notifications) {
        notification['read'] = true;
      }
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'All notifications marked as read.',
        ),

        backgroundColor:
            Color(0xFF22C55E),
      ),
    );
  }
}