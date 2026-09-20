import 'package:flutter/material.dart';

enum HistoryPeriod { week, month, year }

class HistoryEntry {
  final DateTime date;
  final String timeIn;
  final String? timeOut;
  final String? duration;

  const HistoryEntry({
    required this.date,
    required this.timeIn,
    this.timeOut,
    this.duration,
  });
}

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  HistoryPeriod _selectedPeriod = HistoryPeriod.week;

  // TODO: replace with a real date range + real data fetched from your
  // backend, driven by _selectedPeriod and the arrow navigation below.
  final String _rangeLabel = 'OCT 05 - OCT 16, 2025';

  final List<HistoryEntry> _entries = [
    HistoryEntry(
      date: DateTime(2026, 10, 18),
      timeIn: '07:32 PM',
      timeOut: null,
    ),
    HistoryEntry(
      date: DateTime(2026, 10, 20),
      timeIn: '07:32 PM',
      timeOut: '08:32 PM',
      duration: '1h 30m',
    ),
    HistoryEntry(
      date: DateTime(2026, 10, 25),
      timeIn: '07:32 PM',
      timeOut: '08:32 PM',
      duration: '1h 30m',
    ),
    HistoryEntry(
      date: DateTime(2026, 10, 30),
      timeIn: '07:32 PM',
      timeOut: null,
    ),
  ];

  void _goToPreviousRange() {
    // TODO: shift _rangeLabel / refetch entries for the previous period.
  }

  void _goToNextRange() {
    // TODO: shift _rangeLabel / refetch entries for the next period.
  }

  String _formatDate(DateTime date) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        _buildPeriodToggle(),
        const SizedBox(height: 16),
        _buildRangeNavigator(),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            itemCount: _entries.length,
            separatorBuilder: (_, __) => const Divider(
              color: Colors.white12,
              height: 1,
            ),
            itemBuilder: (context, index) => _buildEntryCard(_entries[index]),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // ---- Week / Month / Year toggle ----
  Widget _buildPeriodToggle() {
    Widget periodButton(String label, HistoryPeriod period) {
      final bool isSelected = _selectedPeriod == period;
      return GestureDetector(
        onTap: () => setState(() => _selectedPeriod = period),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF3ECF4A) : Colors.white54,
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        periodButton('WEEK', HistoryPeriod.week),
        periodButton('MONTH', HistoryPeriod.month),
        periodButton('YEAR', HistoryPeriod.year),
      ],
    );
  }

  // ---- "< OCT 05 - OCT 16, 2025 >" ----
  Widget _buildRangeNavigator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: _goToPreviousRange,
          icon: const Icon(Icons.chevron_left, color: Colors.white),
        ),
        Text(
          _rangeLabel,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
        IconButton(
          onPressed: _goToNextRange,
          icon: const Icon(Icons.chevron_right, color: Colors.white),
        ),
      ],
    );
  }

  // ---- Individual log card ----
  Widget _buildEntryCard(HistoryEntry entry) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(entry.date),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      'Time in',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entry.timeIn,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      'Time out',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entry.timeOut ?? '-',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (entry.duration != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Duration',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.duration!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          const Icon(Icons.chevron_right, color: Colors.white38),
        ],
      ),
    );
  }
}
