import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'overview.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _adminController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  // Entrance animation (logo scale/fade in, text fades up shortly after)
  late final AnimationController _entranceController;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  // Looping ambient animation (gentle float + glow breathing)
  late final AnimationController _ambientController;
  late final Animation<double> _floatOffset;
  late final Animation<double> _glowPulse;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _logoFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );
    _textFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
      ),
    );
    _entranceController.forward();

    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
    _floatOffset = Tween<double>(begin: -4.0, end: 4.0).animate(
      CurvedAnimation(parent: _ambientController, curve: Curves.easeInOut),
    );
    _glowPulse = Tween<double>(begin: 0.25, end: 0.45).animate(
      CurvedAnimation(parent: _ambientController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _ambientController.dispose();
    _adminController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;

    final email = _adminController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter your email and password.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Sign in with Firebase Authentication
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;
      if (user == null) {
        _showError('Login failed. Please try again.');
        return;
      }

      // 2. Read the user's role from Firestore: users/{uid}
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final role = doc.data()?['role'];

      // 3. Only the owner/admin may enter this app
      if (role != 'admin') {
        await FirebaseAuth.instance.signOut();
        _showError('This account does not have owner/admin access.');
        return;
      }

      // 4. Success: go to the dashboard
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OverviewScreen()),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('Login auth error: ${e.code}');
      switch (e.code) {
        case 'invalid-email':
          _showError('Please enter a valid email address.');
          break;
        case 'user-disabled':
          _showError('This account has been disabled.');
          break;
        case 'too-many-requests':
          _showError('Too many attempts. Please try again later.');
          break;
        case 'network-request-failed':
          _showError('Network error. Check your internet connection.');
          break;
        default:
          // invalid-credential, user-not-found, wrong-password
          _showError('Incorrect email or password.');
      }
    } on FirebaseException catch (e) {
      debugPrint('Login Firestore error: ${e.code}');
      await FirebaseAuth.instance.signOut();
      if (e.code == 'permission-denied') {
        _showError('Permission denied while reading your profile.');
      } else {
        _showError('Could not verify your account. Please try again.');
      }
    } catch (e) {
      debugPrint('Login error: $e');
      _showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      body: Row(
        children: [
          // Left Panel - Logo & Branding
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                // Subtle radial gradient backdrop for depth
                gradient: RadialGradient(
                  center: Alignment(0, -0.1),
                  radius: 1.1,
                  colors: [Color(0xFF2A2A2A), Color(0xFF1C1C1C)],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: AnimatedBuilder(
                      animation: Listenable.merge(
                          [_entranceController, _ambientController]),
                      builder: (context, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Logo — fade/scale entrance + gentle float + breathing glow
                            Transform.translate(
                              offset: Offset(0, _floatOffset.value),
                              child: Opacity(
                                opacity: _logoFade.value,
                                child: Transform.scale(
                                  scale: _logoScale.value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF00FF66)
                                              .withValues(
                                                  alpha: _glowPulse.value),
                                          blurRadius: 55,
                                          spreadRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      'images/logo.png', // Update path to match your asset registration
                                      height: 170,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.fitness_center,
                                          size: 90,
                                          color: Color(0xFF00FF66),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // FITPASS GYM wordmark — fades/slides up right under the logo
                            Opacity(
                              opacity: _textFade.value,
                              child: Transform.translate(
                                offset: Offset(0, _textSlide.value.dy * 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'FIT',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 28,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'PASS',
                                            style: TextStyle(
                                              color: Color(0xFF00FF66),
                                              fontSize: 28,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'GYM',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // Bottom Left Label
                  const Positioned(
                    left: 32,
                    bottom: 28,
                    child: Text(
                      'OWNER',
                      style: TextStyle(
                        color: Colors.white30,
                        fontSize: 14,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right Panel - Login Form
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0xFF2B2B2B),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 380),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email Input
                      TextField(
                        controller: _adminController,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: const TextStyle(
                              color: Colors.white54, fontSize: 14),
                          filled: true,
                          fillColor: const Color(0xFF424242),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xFF00FF66), width: 1.4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password Input
                      TextField(
                        controller: _passwordController,
                        enabled: !_isLoading,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _handleLogin(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: const TextStyle(
                              color: Colors.white54, fontSize: 14),
                          filled: true,
                          fillColor: const Color(0xFF424242),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xFF00FF66), width: 1.4),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.white54,
                              size: 20,
                            ),
                            splashRadius: 18,
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // LOG IN Button — subtle hover/press feedback
                      _AnimatedLoginButton(
                        onPressed: _handleLogin,
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Login button with a subtle scale-down press effect and hover brightness
class _AnimatedLoginButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const _AnimatedLoginButton({
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<_AnimatedLoginButton> createState() => _AnimatedLoginButtonState();
}

class _AnimatedLoginButtonState extends State<_AnimatedLoginButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool disabled = widget.isLoading;

    return MouseRegion(
      cursor: disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) {
          if (!disabled) setState(() => _isPressed = true);
        },
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: disabled ? null : widget.onPressed,
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: disabled
                  ? const Color(0xFF1E8F52)
                  : _isHovered
                      ? const Color(0xFF34E27E)
                      : const Color(0xFF28C76F),
              borderRadius: BorderRadius.circular(8),
              boxShadow: _isHovered && !disabled
                  ? [
                      BoxShadow(
                        color: const Color(0xFF28C76F).withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: widget.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                : const Text(
                    'LOG IN',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
