import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        fontFamily: 'Roboto',
      ),
      home: const CreateAccountScreen(),
    );
  }
}

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool _agreedToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Selected value for the "Select Member type" dropdown.
  String? _selectedMemberType;
  static const List<String> _memberTypes = ['Student', 'Senior', 'Regular'];

  static const Color _bgColor = Color(0xFF0A0A0A);
  static const Color _fieldColor = Color(0xFF262626);
  static const Color _greenColor = Color(0xFF4CD964);
  static const Color _hintColor = Color(0xFF8A8A8A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Join us and start\nyour Fitness journey\ntoday!',
                style: TextStyle(
                  color: _hintColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              // Full Name
              _buildTextField(hint: 'Username'),
              const SizedBox(height: 16),

              // Email
              _buildTextField(hint: 'Email'),
              const SizedBox(height: 16),

              // Phone Number
              _buildTextField(hint: 'Phone Number'),
              const SizedBox(height: 16),

              // Password
              _buildTextField(
                hint: 'Password',
                obscureText: _obscurePassword,
                isPassword: true,
                onToggleObscure: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              const SizedBox(height: 16),

              // Confirm Password
              _buildTextField(
                hint: 'Confirm Password',
                obscureText: _obscureConfirmPassword,
                isPassword: true,
                onToggleObscure: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Select Member type dropdown
              _buildMemberTypeDropdown(),
              const SizedBox(height: 20),

              // Terms checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: Checkbox(
                      value: _agreedToTerms,
                      onChanged: (value) {
                        setState(() => _agreedToTerms = value ?? false);
                      },
                      side: const BorderSide(color: _hintColor, width: 1.5),
                      checkColor: Colors.black,
                      activeColor: _greenColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: const TextStyle(
                                color: _greenColor,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: null,
                            ),
                            const TextSpan(text: '\nand '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(
                                color: _greenColor,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Register button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: handle registration
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _greenColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'REGISTER',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Log in link
              Center(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 13),
                    children: [
                      TextSpan(text: 'Already have an account? '),
                      TextSpan(
                        text: 'Log in',
                        style: TextStyle(
                          color: _greenColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    bool obscureText = false,
    bool isPassword = false,
    VoidCallback? onToggleObscure,
  }) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: _fieldColor,
        borderRadius: BorderRadius.circular(27),
      ),
      child: TextField(
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          isCollapsed: true,
          hintText: hint,
          hintStyle: const TextStyle(color: _hintColor, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 17,
          ),
          suffixIcon: isPassword
              ? Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: _hintColor,
                      size: 20,
                    ),
                    onPressed: onToggleObscure,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  // "Select Member type" dropdown — Student / Senior / Regular.
  Widget _buildMemberTypeDropdown() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: _fieldColor,
        borderRadius: BorderRadius.circular(21),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedMemberType,
          isExpanded: true,
          hint: const Text(
            'Select Member type',
            style: TextStyle(color: _hintColor, fontSize: 14),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: _hintColor),
          dropdownColor: _fieldColor,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          borderRadius: BorderRadius.circular(16),
          items: _memberTypes
              .map(
                (type) => DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() => _selectedMemberType = value);
          },
        ),
      ),
    );
  }
}
