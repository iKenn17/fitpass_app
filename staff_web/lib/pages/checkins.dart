import 'package:flutter/material.dart';
import '../widgets/fitpass_layout.dart';
import '../data/gym_data.dart';

class CheckInsPage extends StatefulWidget {
  const CheckInsPage({super.key});

  @override
  State<CheckInsPage> createState() => _CheckInsPageState();
}

class _CheckInsPageState extends State<CheckInsPage> {
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: GymData.instance,
      builder: (context, child) {
        final gym = GymData.instance;

        List<Map<String, String>> filteredLogs =
            gym.logs.where((log) {
          if (selectedFilter == 'All') {
            return true;
          }

          if (selectedFilter == 'QR Code') {
            return log['method'] == 'QR Code';
          }

          if (selectedFilter == 'Manual') {
            return log['method'] == 'Manual';
          }

          if (selectedFilter == 'Currently In') {
            return log['action'] == 'Check In';
          }

          return true;
        }).toList();

        return FitpassLayout(
          currentPage: '/checkins',
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ==================================================
                // TITLE
                // ==================================================

                const Text(
                  'Check-ins',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // ==================================================
                // FILTERS
                // ==================================================

                Row(
                  children: [
                    _filterButton('All'),
                    const SizedBox(width: 5),
                    _filterButton('QR Code'),
                    const SizedBox(width: 5),
                    _filterButton('Manual'),
                    const SizedBox(width: 5),
                    _filterButton('Currently In'),
                  ],
                ),

                const SizedBox(height: 10),

                // ==================================================
                // SUMMARY CARDS
                // ==================================================

                Row(
                  children: [

                    _summaryCard(
                      'Check-ins',
                      gym.todayCheckIns.toString(),
                      Icons.login,
                    ),

                    _summaryCard(
                      'Check-outs',
                      gym.todayCheckOuts.toString(),
                      Icons.logout,
                    ),

                    _summaryCard(
                      'Currently In',
                      (gym.todayCheckIns -
                              gym.todayCheckOuts)
                          .toString(),
                      Icons.fitness_center,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ==================================================
                // ACTION BUTTONS
                // ==================================================

                Row(
                  children: [

                    _actionButton(
                      'CHECK IN',
                      Icons.login,
                      () {
                        _showTimeDialog(
                          isCheckIn: true,
                        );
                      },
                    ),

                    const SizedBox(width: 6),

                    _actionButton(
                      'CHECK OUT',
                      Icons.logout,
                      () {
                        _showTimeDialog(
                          isCheckIn: false,
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ==================================================
                // LOG TABLE
                // ==================================================

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

                      const Text(
                        "Today's Check-in Logs",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Row(
                        children: [

                          Expanded(
                            flex: 2,
                            child: Text(
                              'Name',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 7,
                              ),
                            ),
                          ),

                          Expanded(
                            child: Text(
                              'Action',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 7,
                              ),
                            ),
                          ),

                          Expanded(
                            child: Text(
                              'Method',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 7,
                              ),
                            ),
                          ),

                          Expanded(
                            child: Text(
                              'Time',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 7,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 3),

                      if (filteredLogs.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(15),
                          child: Center(
                            child: Text(
                              'No logs found.',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ),

                      ...filteredLogs.map(
                        (log) => _logRow(log),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==============================================================
  // FILTER BUTTON
  // ==============================================================

  Widget _filterButton(String title) {
    final selected = selectedFilter == title;

    return SizedBox(
      height: 28,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedFilter = title;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: selected
              ? const Color(0xFF22C55E)
              : const Color(0xFF252525),
          foregroundColor:
              selected ? Colors.black : Colors.white70,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(
              color: selected
                  ? const Color(0xFF22C55E)
                  : Colors.white12,
            ),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 7,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // SUMMARY CARD
  // ==============================================================

  Widget _summaryCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        height: 65,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF252525),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: const Color(0xFF3A3A3A),
          ),
        ),
        child: Row(
          children: [

            Icon(
              icon,
              color: const Color(0xFF22C55E),
              size: 17,
            ),

            const SizedBox(width: 8),

            Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 6,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // ACTION BUTTON
  // ==============================================================

  Widget _actionButton(
    String title,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      height: 28,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 12,
        ),
        label: Text(
          title,
          style: const TextStyle(
            fontSize: 7,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color(0xFF22C55E),
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // LOG ROW
  // ==============================================================

  Widget _logRow(Map<String, String> log) {
    final isCheckIn = log['action'] == 'Check In';

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white10,
          ),
        ),
      ),
      child: Row(
        children: [

          Expanded(
            flex: 2,
            child: Text(
              log['name'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 7,
              ),
            ),
          ),

          Expanded(
            child: Text(
              log['action'] ?? '',
              style: TextStyle(
                color: isCheckIn
                    ? Colors.greenAccent
                    : Colors.orangeAccent,
                fontSize: 7,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Text(
              log['method'] ?? '',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 7,
              ),
            ),
          ),

          Expanded(
            child: Text(
              log['time'] ?? '',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 7,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // CHECK IN / CHECK OUT DIALOG
  // ==============================================================

  void _showTimeDialog({
    required bool isCheckIn,
  }) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF252525),

          title: Text(
            isCheckIn ? 'Check In' : 'Check Out',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),

          content: TextField(
            controller: controller,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'Enter member name',
              hintStyle: const TextStyle(
                color: Colors.white38,
              ),
              enabledBorder:
                  const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white24,
                ),
              ),
              focusedBorder:
                  const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF22C55E),
                ),
              ),
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'CANCEL',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                final name =
                    controller.text.trim();

                if (name.isEmpty) {
                  return;
                }

                if (isCheckIn) {
                  GymData.instance.checkIn(
                    name: name,
                    method: 'Manual',
                  );
                } else {
                  GymData.instance.checkOut(
                    name: name,
                    method: 'Manual',
                  );
                }

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(
                      isCheckIn
                          ? '$name checked in successfully.'
                          : '$name checked out successfully.',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF22C55E),
                foregroundColor: Colors.black,
              ),
              child: Text(
                isCheckIn
                    ? 'CHECK IN'
                    : 'CHECK OUT',
              ),
            ),
          ],
        );
      },
    );
  }
}