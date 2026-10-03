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

  static const List<String> _filters = [
    'All',
    'QR Code',
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: GymData.instance,
      builder: (context, child) {
        final gym = GymData.instance;

        final List<Map<String, String>> filteredLogs = gym.logs.where((log) {
          switch (selectedFilter) {
            case 'QR Code':
              return log['method'] == 'QR Code';
            case 'Manual':
              return log['method'] == 'Manual';
            case 'Currently In':
              return log['action'] == 'Check In';
            default:
              return true;
          }
        }).toList();

        return FitpassLayout(
          currentPage: '/checkins',
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // TITLE
                // ==================================================
                const Text(
                  'CHECK-INS',
                  style: TextStyle(
                    color: _green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 16),

                // ==================================================
                // SUMMARY CARDS
                // ==================================================
                Row(
                  children: [
                    Expanded(
                      child: _summaryCard(
                        'Check-ins',
                        gym.todayCheckIns.toString(),
                        Icons.login,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _summaryCard(
                        'Check-outs',
                        gym.todayCheckOuts.toString(),
                        Icons.logout,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _summaryCard(
                        'Currently In',
                        (gym.todayCheckIns - gym.todayCheckOuts).toString(),
                        Icons.fitness_center,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ==================================================
                // FILTERS + ACTION BUTTONS
                // ==================================================
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ..._filters.map(_filterButton),
                    const SizedBox(width: 16),
                    _actionButton(
                      'CHECK IN',
                      Icons.login,
                      () => _showTimeDialog(isCheckIn: true),
                    ),
                    _actionButton(
                      'CHECK OUT',
                      Icons.logout,
                      () => _showTimeDialog(isCheckIn: false),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ==================================================
                // LOG TABLE
                // ==================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: _cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Today's Check-in Logs",
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
                            flex: 2,
                            child: Text(
                              'Name',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Action',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Method',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Time',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Divider(color: Colors.white10),

                      if (filteredLogs.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Text(
                              'No logs found.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),

                      ...filteredLogs.map(_logRow),
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
      height: 32,
      child: ElevatedButton(
        onPressed: () => setState(() => selectedFilter = title),
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? _buttonGreen : _cardColor,
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

  // ==============================================================
  // SUMMARY CARD
  // ==============================================================

  Widget _summaryCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF294A31),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: _green, size: 20),
          ),

          const SizedBox(width: 14),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // ACTION BUTTON
  // ==============================================================

  Widget _actionButton(String title, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      height: 32,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _buttonGreen,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              log['name'] ?? '',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              log['action'] ?? '',
              style: TextStyle(
                color: isCheckIn ? _green : Colors.orangeAccent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              log['method'] ?? '',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              log['time'] ?? '',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // CHECK IN / CHECK OUT DIALOG
  // ==============================================================

  void _showTimeDialog({required bool isCheckIn}) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: _cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.white10),
          ),
          title: Text(
            isCheckIn ? 'Check In' : 'Check Out',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: 320,
            child: TextField(
              controller: controller,
              autofocus: true,
              cursorColor: _green,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Enter member name',
                hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
                filled: true,
                fillColor: const Color(0xFF424242),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _green, width: 1.4),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'CANCEL',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final name = controller.text.trim();

                if (name.isEmpty) return;

                if (isCheckIn) {
                  GymData.instance.checkIn(name: name, method: 'Manual');
                } else {
                  GymData.instance.checkOut(name: name, method: 'Manual');
                }

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
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
                backgroundColor: _buttonGreen,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(isCheckIn ? 'CHECK IN' : 'CHECK OUT'),
            ),
          ],
        );
      },
    );
  }
}
