import 'package:flutter/material.dart';
import '../widgets/fitpass_layout.dart';
import '../data/gym_data.dart';

class ManualTimePage extends StatefulWidget {
  const ManualTimePage({super.key});

  @override
  State<ManualTimePage> createState() => _ManualTimePageState();
}

class _ManualTimePageState extends State<ManualTimePage> {
  final TextEditingController nameController =
      TextEditingController();

  String selectedAction = 'Time In';

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

        return FitpassLayout(
          currentPage: '/manual-time',
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                const Text(
                  'Manual Time In / Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // ==================================================
                // MANUAL ENTRY
                // ==================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
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
                        'Manual Time Entry',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: nameController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        decoration:
                            const InputDecoration(
                          hintText:
                              'Enter member name',
                          hintStyle: TextStyle(
                            color: Colors.white38,
                            fontSize: 8,
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white54,
                            size: 14,
                          ),
                          enabledBorder:
                              OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white24,
                            ),
                          ),
                          focusedBorder:
                              OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF22C55E),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [

                          _typeButton(
                            'Time In',
                            Icons.login,
                          ),

                          const SizedBox(width: 6),

                          _typeButton(
                            'Time Out',
                            Icons.logout,
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        height: 30,
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _recordTime,
                          icon: const Icon(
                            Icons.check,
                            size: 13,
                          ),
                          label: const Text(
                            'RECORD TIME',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF22C55E),
                            foregroundColor:
                                Colors.black,
                            elevation: 0,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                4,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ==================================================
                // RECENT ENTRIES
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
                        'Recent Manual Entries',
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

                      ...gym.logs
                          .where(
                            (log) =>
                                log['method'] ==
                                'Manual',
                          )
                          .map(
                            (log) =>
                                _recordRow(log),
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
  // TIME IN / OUT BUTTON
  // ==============================================================

  Widget _typeButton(
    String title,
    IconData icon,
  ) {
    final selected =
        selectedAction == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedAction = title;
          });
        },
        child: Container(
          height: 30,
          decoration: BoxDecoration(
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
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [

              Icon(
                icon,
                size: 12,
                color: selected
                    ? Colors.black
                    : Colors.white70,
              ),

              const SizedBox(width: 5),

              Text(
                title,
                style: TextStyle(
                  color: selected
                      ? Colors.black
                      : Colors.white70,
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // RECORD TIME
  // ==============================================================

  void _recordTime() {
    final name =
        nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a member name.',
          ),
        ),
      );

      return;
    }

    final action =
        selectedAction == 'Time In'
            ? 'Check In'
            : 'Check Out';

    GymData.instance.manualTime(
      name: name,
      action: action,
    );

    nameController.clear();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          '$selectedAction recorded for $name.',
        ),
      ),
    );
  }

  // ==============================================================
  // RECORD ROW
  // ==============================================================

  Widget _recordRow(
    Map<String, String> record,
  ) {
    final isTimeIn =
        record['action'] == 'Check In';

    return Container(
      padding:
          const EdgeInsets.symmetric(
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
              record['name'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 7,
              ),
            ),
          ),

          Expanded(
            child: Text(
              record['action'] ?? '',
              style: TextStyle(
                color: isTimeIn
                    ? Colors.greenAccent
                    : Colors.orangeAccent,
                fontSize: 7,
              ),
            ),
          ),

          Expanded(
            child: Text(
              record['time'] ?? '',
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
}