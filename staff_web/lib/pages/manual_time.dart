import 'package:flutter/material.dart';
import '../widgets/fitpass_layout.dart';
import '../data/gym_data.dart';

class ManualTimePage extends StatefulWidget {
  const ManualTimePage({super.key});

  @override
  State<ManualTimePage> createState() => _ManualTimePageState();
}

class _ManualTimePageState extends State<ManualTimePage> {
  final TextEditingController nameController = TextEditingController();

  String selectedAction = 'Time In';

  static const Color _cardColor = Color(0xFF2B2B2B);
  static const Color _green = Color(0xFF00FF66);
  static const Color _buttonGreen = Color(0xFF28C76F);

  BoxDecoration get _cardDecoration => BoxDecoration(
    color: _cardColor,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.white10),
  );

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: GymData.instance,
      builder: (context, child) {
        final gym = GymData.instance;

        final manualLogs = gym.logs
            .where((log) => log['method'] == 'Manual')
            .toList();

        return FitpassLayout(
          currentPage: '/manual-time',
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // TITLE
                // ==================================================
                const Text(
                  'MANUAL TIME IN / OUT',
                  style: TextStyle(
                    color: _green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 16),

                // ==================================================
                // MANUAL ENTRY
                // ==================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: _cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Manual Time Entry',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // NAME FIELD
                      TextField(
                        controller: nameController,
                        cursorColor: _green,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _recordTime(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter member name',
                          hintStyle: const TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: Colors.white54,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF424242),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: _green,
                              width: 1.4,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // TIME IN / TIME OUT
                      Row(
                        children: [
                          _typeButton('Time In', Icons.login),
                          const SizedBox(width: 12),
                          _typeButton('Time Out', Icons.logout),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // RECORD BUTTON
                      SizedBox(
                        height: 44,
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _recordTime,
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text(
                            'RECORD TIME',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _buttonGreen,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ==================================================
                // RECENT ENTRIES
                // ==================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: _cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent Manual Entries',
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

                      if (manualLogs.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Text(
                              'No manual entries yet.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),

                      ...manualLogs.map(_recordRow),
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
  // TIME IN / OUT BUTTON
  // ==============================================================

  Widget _typeButton(String title, IconData icon) {
    final selected = selectedAction == title;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedAction = title),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: selected ? _buttonGreen : const Color(0xFF424242),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected ? _buttonGreen : Colors.white10,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: selected ? Colors.black : Colors.white70,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: selected ? Colors.black : Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // RECORD TIME
  // ==============================================================

  void _recordTime() {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a member name.')),
      );
      return;
    }

    final action = selectedAction == 'Time In' ? 'Check In' : 'Check Out';

    GymData.instance.manualTime(name: name, action: action);

    nameController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$selectedAction recorded for $name.')),
    );
  }

  // ==============================================================
  // RECORD ROW
  // ==============================================================

  Widget _recordRow(Map<String, String> record) {
    final isTimeIn = record['action'] == 'Check In';

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
              record['name'] ?? '',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              record['action'] ?? '',
              style: TextStyle(
                color: isTimeIn ? _green : Colors.orangeAccent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              record['time'] ?? '',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
