import 'package:flutter/material.dart';
import '../widgets/fitpass_layout.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  // ==============================================================
  // COLORS (same as Check-ins / Members pages)
  // ==============================================================
  static const Color _cardColor = Color(0xFF2B2B2B);
  static const Color _green = Color(0xFF00FF66);
  static const Color _buttonGreen = Color(0xFF28C76F);
  static const Color _gcashBlue = Color(0xFF00B4D8);

  BoxDecoration get _cardDecoration => BoxDecoration(
    color: _cardColor,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.white10),
  );

  // ==============================================================
  // COLUMN FLEX (shared by header and rows so they always line up)
  // ==============================================================
  static const int _flexName = 3;
  static const int _flexDate = 2;
  static const int _flexType = 2;
  static const int _flexAmount = 2;
  static const int _flexMethod = 2;

  // ==============================================================
  // FILTER
  // ==============================================================
  static const List<String> _filters = ['All', 'Monthly', 'Walk-in'];
  String _selectedFilter = 'All';

  // ==============================================================
  // SAMPLE DATA
  // TODO: replace with GymData.instance.payments when available
  // ==============================================================
  final List<Map<String, String>> _payments = const [
    {
      'name': 'Jasper Sibayan',
      'date': '09-07-26',
      'type': 'Monthly',
      'amount': '700',
      'method': 'Gcash',
    },
    {
      'name': 'Emman Parocha',
      'date': '09-04-26',
      'type': 'Monthly',
      'amount': '700',
      'method': 'Gcash',
    },
    {
      'name': 'Michael Jackson',
      'date': '09-04-26',
      'type': 'Walk-in',
      'amount': '80',
      'method': 'Cash',
    },
    {
      'name': 'Juan Delacruz',
      'date': '09-03-26',
      'type': 'Monthly',
      'amount': '700',
      'method': 'Gcash',
    },
    {
      'name': 'Juan Tamad',
      'date': '09-02-26',
      'type': 'Walk-in',
      'amount': '80',
      'method': 'Cash',
    },
    {
      'name': 'Chris Bumstead',
      'date': '09-02-26',
      'type': 'Walk-in',
      'amount': '80',
      'method': 'Cash',
    },
    {
      'name': 'David Laid',
      'date': '09-01-26',
      'type': 'Monthly',
      'amount': '700',
      'method': 'Gcash',
    },
    {
      'name': 'Liam Agustin',
      'date': '08-30-26',
      'type': 'Monthly',
      'amount': '700',
      'method': 'Gcash',
    },
    {
      'name': 'Liam Agustin',
      'date': '08-30-26',
      'type': 'Monthly',
      'amount': '700',
      'method': 'Gcash',
    },
  ];

  List<Map<String, String>> get _filteredPayments {
    switch (_selectedFilter) {
      case 'Monthly':
        return _payments.where((p) => p['type'] == 'Monthly').toList();
      case 'Walk-in':
        return _payments.where((p) => p['type'] == 'Walk-in').toList();
      default:
        return _payments;
    }
  }

  // ==============================================================
  // BUILD
  // ==============================================================
  @override
  Widget build(BuildContext context) {
    final payments = _filteredPayments;

    return FitpassLayout(
      currentPage: '/payments',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // TITLE
            // ==================================================
            const Text(
              'PAYMENTS',
              style: TextStyle(
                color: _green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 16),

            // ==================================================
            // FILTER BUTTONS
            // ==================================================
            Row(children: _filters.map(_filterButton).toList()),

            const SizedBox(height: 16),

            // ==================================================
            // PAYMENT LIST CARD
            // ==================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Records',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _tableHeader(),

                  const Divider(color: Colors.white10, height: 1),

                  if (payments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'No payments found.',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    ),

                  ...payments.map(_paymentRow),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // FILTER BUTTON (same look as Check-ins: All / QR Code / Manual)
  // ==============================================================
  Widget _filterButton(String label) {
    final selected = _selectedFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SizedBox(
        height: 32,
        child: ElevatedButton(
          onPressed: () => setState(() => _selectedFilter = label),
          style: ElevatedButton.styleFrom(
            backgroundColor: selected ? _buttonGreen : _cardColor,
            foregroundColor: selected ? Colors.black : Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: selected ? _buttonGreen : Colors.white10),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // TABLE HEADER
  // ==============================================================
  Widget _tableHeader() {
    const style = TextStyle(color: Colors.grey, fontSize: 11);

    return const Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: _flexName,
            child: Text('Name', style: style),
          ),
          Expanded(
            flex: _flexDate,
            child: Text('Date', style: style),
          ),
          Expanded(
            flex: _flexType,
            child: Text('Walk-in/Monthly', style: style),
          ),
          Expanded(
            flex: _flexAmount,
            child: Text('Amount', style: style),
          ),
          Expanded(
            flex: _flexMethod,
            child: Text('Method', style: style),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // PAYMENT ROW
  // ==============================================================
  Widget _paymentRow(Map<String, String> payment) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          // NAME
          Expanded(
            flex: _flexName,
            child: Text(
              payment['name'] ?? '',
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
          ),

          // DATE
          Expanded(
            flex: _flexDate,
            child: Text(payment['date'] ?? '', style: textStyle),
          ),

          // WALK-IN / MONTHLY
          Expanded(
            flex: _flexType,
            child: Text(payment['type'] ?? '', style: textStyle),
          ),

          // AMOUNT
          Expanded(
            flex: _flexAmount,
            child: Text(payment['amount'] ?? '', style: textStyle),
          ),

          // METHOD
          Expanded(
            flex: _flexMethod,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _methodPill(payment['method'] ?? ''),
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // METHOD PILL (Gcash = blue, Cash = dimmed green)
  // ==============================================================
  Widget _methodPill(String method) {
    final isGcash = method.toLowerCase() == 'gcash';
    final color = isGcash ? _gcashBlue : _green.withValues(alpha: 0.4);
    final textColor = isGcash
        ? _gcashBlue.withValues(alpha: 0.9)
        : _green.withValues(alpha: 0.4);

    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(method, style: TextStyle(color: textColor, fontSize: 11)),
        ],
      ),
    );
  }
}
