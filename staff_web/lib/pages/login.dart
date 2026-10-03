import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool hidePassword = true;
  bool isLoading = false;

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  Future<void> login() async {
    final email = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter your email and password.');
      return;
    }

    setState(() => isLoading = true);

    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check the role stored in Firestore: users/{uid}
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .get();

      final role = doc.data()?['role'];

      if (role != 'staff' && role != 'admin') {
        await FirebaseAuth.instance.signOut();
        _showError('This account does not have staff access.');
        return;
      }

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          _showError('Please enter a valid email address.');
          break;
        case 'too-many-requests':
          _showError('Too many attempts. Try again later.');
          break;
        default:
          _showError('Incorrect email or password.');
      }
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF292929),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          // Left side is approximately 35% of the screen.
          final leftWidth = width * 0.355;

          return Row(
            children: [
              // ==================================================
              // LEFT PANEL
              // ==================================================
              SizedBox(
                width: leftWidth,
                height: height,
                child: Container(
                  color: const Color(0xFF242424),

                  child: Center(child: _buildBranding(leftWidth)),
                ),
              ),

              // ==================================================
              // RIGHT PANEL
              // ==================================================
              Expanded(
                child: Container(
                  height: height,
                  color: const Color(0xFF292929),

                  child: Stack(
                    children: [
                      // STAFF LOGIN header (top center)
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 48),
                          child: _buildStaffHeader(),
                        ),
                      ),

                      // Form (center)
                      Center(
                        child: SingleChildScrollView(child: _buildLoginForm()),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // FITPASS BRANDING
  // ============================================================

  Widget _buildBranding(double leftWidth) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // --------------------------------------------------------
        // LOGO IMAGE
        // --------------------------------------------------------
        Image.asset(
          'assets/fitpass_logo.png',
          width: leftWidth * 0.43,
          height: 150,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,

          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 130,
              height: 130,
              alignment: Alignment.center,
              child: const Icon(
                Icons.fitness_center,
                color: Colors.white,
                size: 70,
              ),
            );
          },
        ),

        const SizedBox(width: 5),

        // --------------------------------------------------------
        // FITPASS TEXT
        // --------------------------------------------------------
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FITPASS
            RichText(
              text: const TextSpan(
                children: [
                  // FIT
                  TextSpan(
                    text: 'FIT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 29,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.2,
                    ),
                  ),

                  // PASS
                  TextSpan(
                    text: 'PASS',
                    style: TextStyle(
                      color: Color(0xFF22C55E),
                      fontSize: 29,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.2,
                    ),
                  ),
                ],
              ),
            ),

            // GYM
            const Padding(
              padding: EdgeInsets.only(left: 74, top: 0),
              child: Text(
                'GYM',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // STAFF LOGIN HEADER
  // ============================================================

  Widget _buildStaffHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon badge
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0x2622C55E),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF22C55E), width: 2),
          ),
          child: const Icon(
            Icons.admin_panel_settings,
            color: Color(0xFF22C55E),
            size: 36,
          ),
        ),

        const SizedBox(height: 14),

        // Title
        const Text(
          'STAFF LOGIN',
          style: TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
          ),
        ),

        const SizedBox(height: 8),

        // Green accent line
        Container(
          width: 70,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFF22C55E),
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        const SizedBox(height: 10),

        // Subtitle
        const Text(
          'Authorized personnel only',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 13,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LOGIN FORM
  // ============================================================

  Widget _buildLoginForm() {
    return SizedBox(
      width: 315,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ======================================================
          // ADMINISTRATOR
          // ======================================================
          SizedBox(
            width: 315,
            height: 36,

            child: TextField(
              controller: usernameController,

              style: const TextStyle(color: Colors.white, fontSize: 14),

              cursorColor: const Color(0xFF22C55E),

              decoration: InputDecoration(
                hintText: 'Administrator',

                hintStyle: const TextStyle(
                  color: Color.fromRGBO(255, 254, 254, 0.493),
                  fontSize: 14,
                ),

                filled: true,

                fillColor: const Color(0xFF555555),

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 0,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(
                    color: Color(0xFF22C55E),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),

          // ======================================================
          // SPACE
          // ======================================================
          const SizedBox(height: 28),

          // ======================================================
          // PASSWORD
          // ======================================================
          SizedBox(
            width: 315,
            height: 36,

            child: TextField(
              controller: passwordController,

              obscureText: hidePassword,

              onSubmitted: (_) {
                login();
              },

              style: const TextStyle(color: Colors.white, fontSize: 14),

              cursorColor: const Color(0xFF22C55E),

              decoration: InputDecoration(
                hintText: 'Password',

                hintStyle: const TextStyle(
                  color: Color.fromRGBO(255, 254, 254, 0.493),
                  fontSize: 14,
                ),

                filled: true,

                fillColor: const Color(0xFF555555),

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 0,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(
                    color: Color(0xFF22C55E),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),

          // ======================================================
          // SPACE
          // ======================================================
          const SizedBox(height: 24),

          // ======================================================
          // LOG IN BUTTON
          // ======================================================
          SizedBox(
            width: 195,
            height: 36,

            child: ElevatedButton(
              onPressed: isLoading ? null : login,
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Text(
                      'LOG IN',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
