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
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF16C84E),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final bool isTimeIn = nextAction == 'time_in';

    return FitpassLayout(
      currentPage: 'scanner',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'QR CHECK-IN SCANNER',
              style: TextStyle(
                color: Color(0xFF16C84E),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 10),

            Center(
              child: Column(
                children: [
                  _buildScannerBox(),

                  const SizedBox(height: 14),

                  _buildMemberCard(),

                  const SizedBox(height: 16),

                  if (memberFound)
                    SizedBox(
                      width: 394,
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: isSaving ? null : checkInMember,
                              icon: Icon(
                                isTimeIn ? Icons.login : Icons.logout,
                                size: 19,
                              ),
                              label: Text(isTimeIn ? 'CHECK IN' : 'CHECK OUT'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isTimeIn
                                    ? const Color(0xFF16C84E)
                                    : Colors.orangeAccent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: startScanning,
                              icon: const Icon(Icons.qr_code_scanner, size: 19),
                              label: const Text('SCAN AGAIN'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF16C84E),
                                side: const BorderSide(
                                  color: Color(0xFF16C84E),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SCANNER BOX
  // ============================================================

  Widget _buildScannerBox() {
    return Container(
      width: 394,
      height: 300,
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(27),
        border: Border.all(color: const Color(0xFF0FAE36), width: 1.2),
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
            Container(
              color: const Color(0xFF252525),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF16C84E),
                      size: 70,
                    ),
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
            ),

          if (isScanning) ...[
            Positioned.fill(
              child: CustomPaint(painter: ScannerOverlayPainter()),
            ),

            const Positioned(
              top: 18,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'SCAN MEMBER QR CODE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const Positioned(
              bottom: 18,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Place the QR code inside the frame',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
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
    return Container(
      width: 394,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(27),
        border: Border.all(color: const Color(0xFF0FAE36), width: 1.2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF444444),
                  border: Border.all(color: const Color(0xFF777777)),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white70,
                  size: 29,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memberName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$memberType - ID $memberId',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),

          Row(
            children: [
              Expanded(child: _infoBox('TIME', memberTime)),
              const SizedBox(width: 30),
              Expanded(
                child: _infoBox(
                  'METHOD',
                  memberMethod,
                  valueColor: const Color(0xFF00D639),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _infoBox(
                  'MEMBERSHIP',
                  memberStatus,
                  valueColor: const Color(0xFF00D639),
                ),
              ),
              const SizedBox(width: 30),
              Expanded(child: _infoBox('VISIT THIS MONTH', memberVisits)),
            ],
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
      height: 64,
      padding: const EdgeInsets.fromLTRB(12, 9, 12, 8),
      decoration: BoxDecoration(
        color: const Color(0xFF292929),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF444444)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 8),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 13,
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
      ..color = const Color(0xFF35E65E)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double boxSize = 180;

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
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
