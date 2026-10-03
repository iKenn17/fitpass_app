import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/fitpass_layout.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  late MobileScannerController controller;

  static const Color _cardColor = Color(0xFF2B2B2B);
  static const Color _green = Color(0xFF00FF66);
  static const Color _buttonGreen = Color(0xFF28C76F);

  BoxDecoration get _cardDecoration => BoxDecoration(
    color: _cardColor,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.white10),
  );

  // ------------------------------------------------------------
  // SCANNER STATE
  // ------------------------------------------------------------
  bool isScanning = true;
  bool memberFound = false;
  bool isSaving = false;

  String scannedCode = '';

  // ------------------------------------------------------------
  // MEMBER CARD STATE
  // ------------------------------------------------------------
  String memberUid = '';
  String memberName = '—';
  String memberType = '—';
  String memberId = '—';
  String memberTime = '—';
  String memberMethod = 'QR CODE';
  String memberStatus = '—';
  String memberVisits = '—';

  // What the next confirmed scan will record: 'time_in' or 'time_out'
  String nextAction = 'time_in';

  @override
  void initState() {
    super.initState();

    controller = MobileScannerController(
      facing: CameraFacing.back,
      formats: const [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // ============================================================
  // SCAN HANDLING
  // ============================================================

  void handleScan(BarcodeCapture capture) {
    if (!isScanning) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    setState(() {
      isScanning = false;
      scannedCode = code;
    });

    findMember(code);
  }

  Future<void> findMember(String code) async {
    // A Firestore document ID cannot contain '/', so reject those early.
    if (code.contains('/')) {
      showMessage('QR code not recognized.', isError: true);
      startScanning();
      return;
    }

    try {
      final db = FirebaseFirestore.instance;

      // The QR contains the member's Firebase UID
      final userDoc = await db.collection('users').doc(code).get();

      if (!userDoc.exists) {
        showMessage('QR code not recognized.', isError: true);
        startScanning();
        return;
      }

      final data = userDoc.data()!;

      // Latest attendance record decides whether this scan is IN or OUT
      final last = await db
          .collection('attendance')
          .where('uid', isEqualTo: code)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      final lastType = last.docs.isEmpty
          ? null
          : last.docs.first.data()['type'];

      // Visits this month (counts time-ins)
      final now = DateTime.now();
      final monthStart = DateTime(now.year, now.month, 1);

      final visits = await db
          .collection('attendance')
          .where('uid', isEqualTo: code)
          .where('type', isEqualTo: 'time_in')
          .where(
            'timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(monthStart),
          )
          .count()
          .get();

      if (!mounted) return;

      setState(() {
        memberFound = true;
        memberUid = code;
        memberName = (data['username'] ?? 'Member').toString().toUpperCase();
        memberType = '${data['memberType'] ?? 'Regular'} Member';
        memberId = '#${code.length >= 6 ? code.substring(0, 6) : code}';
        memberTime = TimeOfDay.now().format(context);
        memberMethod = 'QR CODE';
        // Replace with your real membership field once you store one
        memberStatus = (data['membershipStatus'] ?? 'N/A')
            .toString()
            .toUpperCase();
        memberVisits = '${visits.count ?? 0}';
        nextAction = lastType == 'time_in' ? 'time_out' : 'time_in';
      });
    } catch (e) {
      debugPrint('findMember error: $e');
      showMessage('Could not look up this QR code.', isError: true);
      startScanning();
    }
  }

  // ============================================================
  // RESTART SCANNING
  // ============================================================

  void startScanning() {
    if (!mounted) return;

    setState(() {
      isScanning = true;
      memberFound = false;
      scannedCode = '';
    });

    _restartCamera();
  }

  Future<void> _restartCamera() async {
    try {
      await controller.start();
    } catch (e) {
      // Already running (some mobile_scanner versions auto-start); safe to ignore.
      debugPrint('Camera start skipped: $e');
    }
  }

  // ============================================================
  // SAVE CHECK-IN / CHECK-OUT
  // ============================================================

  Future<void> checkInMember() async {
    if (!memberFound || isSaving) return;

    setState(() => isSaving = true);

    final bool wasTimeIn = nextAction == 'time_in';
    final String name = memberName;

    try {
      await FirebaseFirestore.instance.collection('attendance').add({
        'uid': memberUid,
        'type': nextAction,
        'method': 'qr',
        'recordedBy': FirebaseAuth.instance.currentUser?.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      showMessage(
        '$name ${wasTimeIn ? 'checked in' : 'checked out'} successfully!',
      );

      startScanning(); // ready for the next member
    } catch (e) {
      debugPrint('checkInMember error: $e');
      showMessage('Could not save. Please try again.', isError: true);
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  // ============================================================
  // SNACKBAR
  // ============================================================

  void showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: isError ? Colors.redAccent : _buttonGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return FitpassLayout(
      currentPage: '/scanner',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'QR CHECK-IN SCANNER',
              style: TextStyle(
                color: _green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 16),

            LayoutBuilder(
              builder: (context, constraints) {
                final bool wide = constraints.maxWidth >= 900;

                if (wide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildScannerCard()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildMemberCard()),
                    ],
                  );
                }

                return Column(
                  children: [
                    _buildScannerCard(),
                    const SizedBox(height: 16),
                    _buildMemberCard(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SCANNER CARD
  // ============================================================

  Widget _buildScannerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Camera',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              _statusChip(),
            ],
          ),

          const SizedBox(height: 12),

          _buildScannerBox(),
        ],
      ),
    );
  }

  Widget _statusChip() {
    final String text = isScanning
        ? 'Ready to scan'
        : memberFound
        ? 'Member found'
        : 'Looking up...';

    final Color color = isScanning || memberFound ? _green : Colors.amber;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SCANNER BOX
  // ============================================================

  Widget _buildScannerBox() {
    return Container(
      width: double.infinity,
      height: 340,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (isScanning)
            Positioned.fill(
              child: MobileScanner(
                controller: controller,
                onDetect: handleScan,
              ),
            )
          else
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: _green, size: 64),
                  const SizedBox(height: 12),
                  const Text(
                    'QR CODE SCANNED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      scannedCode,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          if (isScanning) ...[
            Positioned.fill(
              child: CustomPaint(painter: ScannerOverlayPainter()),
            ),

            const Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'SCAN MEMBER QR CODE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),

            const Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Place the QR code inside the frame',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // MEMBER CARD
  // ============================================================

  Widget _buildMemberCard() {
    final bool isTimeIn = nextAction == 'time_in';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Member Details',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: memberFound
                      ? const Color(0xFF294A31)
                      : const Color(0xFF424242),
                ),
                child: Icon(
                  Icons.person,
                  color: memberFound ? _green : Colors.white54,
                  size: 28,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memberName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$memberType  •  ID $memberId',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(child: _infoBox('TIME', memberTime)),
              const SizedBox(width: 12),
              Expanded(
                child: _infoBox('METHOD', memberMethod, valueColor: _green),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _infoBox('MEMBERSHIP', memberStatus, valueColor: _green),
              ),
              const SizedBox(width: 12),
              Expanded(child: _infoBox('VISITS THIS MONTH', memberVisits)),
            ],
          ),

          const SizedBox(height: 16),

          if (memberFound)
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: isSaving ? null : checkInMember,
                      icon: isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : Icon(
                              isTimeIn ? Icons.login : Icons.logout,
                              size: 18,
                            ),
                      label: Text(
                        isTimeIn ? 'CHECK IN' : 'CHECK OUT',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isTimeIn
                            ? _buttonGreen
                            : Colors.orangeAccent,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: startScanning,
                      icon: const Icon(Icons.qr_code_scanner, size: 18),
                      label: const Text(
                        'SCAN AGAIN',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _buttonGreen,
                        side: const BorderSide(color: _buttonGreen),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Scan a member QR code to see their details.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoBox(
    String title,
    String value, {
    Color valueColor = Colors.white,
  }) {
    return Container(
      height: 68,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ==============================================================
// SCANNER OVERLAY (corner brackets)
// ==============================================================

class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF00FF66)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double boxSize = 200;

    final double left = (size.width - boxSize) / 2;
    final double top = (size.height - boxSize) / 2;

    const double corner = 28;

    final Path path = Path();

    // Top-left
    path.moveTo(left, top + corner);
    path.lineTo(left, top);
    path.lineTo(left + corner, top);

    // Top-right
    path.moveTo(left + boxSize - corner, top);
    path.lineTo(left + boxSize, top);
    path.lineTo(left + boxSize, top + corner);

    // Bottom-right
    path.moveTo(left + boxSize, top + boxSize - corner);
    path.lineTo(left + boxSize, top + boxSize);
    path.lineTo(left + boxSize - corner, top + boxSize);

    // Bottom-left
    path.moveTo(left + corner, top + boxSize);
    path.lineTo(left, top + boxSize);
    path.lineTo(left, top + boxSize - corner);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
