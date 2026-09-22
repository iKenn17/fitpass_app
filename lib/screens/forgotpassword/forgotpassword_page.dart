import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

/// Colors matching the app's existing dark theme with green accent.
class _AppColors {
  static const bg = Color(0xFF0D0D0D);
  static const field = Color(0xFF1C1C1C);
  static const fieldBorder = Color(0xFF2B2B2B);
  static const placeholder = Color(0xFF7A7A7A);
  static const text = Color(0xFFF5F5F5);
  static const muted = Color(0xFF9A9A9A);
  static const accent = Color(0xFF3DDC5B);
  static const inactiveBtn = Color(0xFF2A2A2A);
  static const inactiveBtnText = Color(0xFF6A6A6A);
}

/// Entry point for the forgot-password flow.
///
/// Handles both steps in one page:
///   Step 1 - user enters their email, we "send" a verification code.
///   Step 2 - user enters the 6-digit code plus a new password.
///
/// Wire up [onSendCode] and [onResetPassword] to your actual auth/API calls.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({
    super.key,
    this.onSendCode,
    this.onVerifyCode,
    this.onResendCode,
    this.onResetPassword,
  });

  /// Called when the user submits their email on step 1.
  /// Return true if the code was sent successfully.
  final Future<bool> Function(String email)? onSendCode;

  /// Optional: called to verify the code before allowing password reset.
  /// Return true if the code is valid.
  final Future<bool> Function(String email, String code)? onVerifyCode;

  /// Called when the user taps "Resend" on step 2.
  final Future<void> Function(String email)? onResendCode;

  /// Called when the user submits the new password on step 2.
  /// Return true on success.
  final Future<bool> Function(String email, String code, String newPassword)?
      onResetPassword;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  int _step = 1;
  bool _isLoading = false;
  String? _errorText;

  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final List<TextEditingController> _codeControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _codeFocusNodes = List.generate(6, (_) => FocusNode());

  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    for (final c in _codeControllers) {
      c.dispose();
    }
    for (final f in _codeFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _email => _emailController.text.trim();

  String get _code => _codeControllers.map((c) => c.text).join();

  bool get _hasMinLength => _newPasswordController.text.length >= 8;
  bool get _hasUppercase =>
      RegExp(r'[A-Z]').hasMatch(_newPasswordController.text);
  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(_newPasswordController.text);

  double get _passwordStrength {
    final pw = _newPasswordController.text;
    double score = 0;
    if (pw.length >= 8) score += 1 / 3;
    if (RegExp(r'[A-Z]').hasMatch(pw)) score += 1 / 3;
    if (RegExp(r'[0-9]').hasMatch(pw)) score += 1 / 3;
    return score;
  }

  Future<void> _handleSendCode() async {
    if (_email.isEmpty || !_email.contains('@')) {
      setState(() => _errorText = 'Enter a valid email address');
      return;
    }
    setState(() {
      _isLoading = true;
      _errorText = null;
    });
    try {
      final success =
          widget.onSendCode != null ? await widget.onSendCode!(_email) : true;
      if (!mounted) return;
      if (success) {
        setState(() => _step = 2);
      } else {
        setState(() => _errorText = 'Could not send code. Try again.');
      }
    } catch (e) {
      setState(() => _errorText = 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleResendCode() async {
    setState(() => _errorText = null);
    await widget.onResendCode?.call(_email);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verification code resent')),
    );
  }

  Future<void> _handleResetPassword() async {
    if (_code.length < 6) {
      setState(() => _errorText = 'Enter the 6-digit code');
      return;
    }
    if (_newPasswordController.text.length < 8) {
      setState(() => _errorText = 'Password must be at least 8 characters');
      return;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() => _errorText = 'Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      if (widget.onVerifyCode != null) {
        final validCode = await widget.onVerifyCode!(_email, _code);
        if (!validCode) {
          setState(() => _errorText = 'Invalid verification code');
          return;
        }
      }

      final success = widget.onResetPassword != null
          ? await widget.onResetPassword!(
              _email, _code, _newPasswordController.text)
          : true;

      if (!mounted) return;
      if (success) {
        Navigator.of(context).pop(true);
      } else {
        setState(() => _errorText = 'Could not reset password. Try again.');
      }
    } catch (e) {
      setState(() => _errorText = 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _goBack() {
    if (_step == 2) {
      setState(() {
        _step = 1;
        _errorText = null;
      });
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBackButton(),
              const SizedBox(height: 24),
              _buildStepIndicator(),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: _step == 1 ? _buildStep1() : _buildStep2(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _goBack,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: _AppColors.field,
          shape: BoxShape.circle,
          border: Border.all(color: _AppColors.fieldBorder),
        ),
        child: const Icon(Icons.arrow_back, color: _AppColors.text, size: 18),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: [
        Expanded(child: _dot(active: true)),
        const SizedBox(width: 6),
        Expanded(child: _dot(active: _step == 2)),
      ],
    );
  }

  Widget _dot({required bool active}) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: active ? _AppColors.accent : _AppColors.fieldBorder,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: _AppColors.text,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Enter the email linked to your account. We'll send a "
          'verification code to reset your password.',
          style: TextStyle(fontSize: 14, height: 1.5, color: _AppColors.muted),
        ),
        const SizedBox(height: 32),
        _buildLabel('Email'),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _emailController,
          hint: 'Email',
          keyboardType: TextInputType.emailAddress,
        ),
        if (_errorText != null) _buildErrorText(),
        const SizedBox(height: 32),
        _buildPrimaryButton(
          label: 'Send verification code',
          onPressed: _handleSendCode,
        ),
        const SizedBox(height: 20),
        _buildFooterLink(
          leading: 'Remembered your password? ',
          action: 'Log in',
          onTap: () => Navigator.of(context).maybePop(),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reset Password',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: _AppColors.text,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            style: const TextStyle(
                fontSize: 14, height: 1.5, color: _AppColors.muted),
            children: [
              const TextSpan(text: 'Enter the code sent to '),
              TextSpan(
                text: _email.isEmpty ? 'your email' : _email,
                style: const TextStyle(
                    color: _AppColors.text, fontWeight: FontWeight.w600),
              ),
              const TextSpan(text: ' and choose a new password.'),
            ],
          ),
        ),
        const SizedBox(height: 28),
        _buildLabel('Verification code'),
        const SizedBox(height: 8),
        _buildCodeRow(),
        const SizedBox(height: 10),
        _buildResendRow(),
        const SizedBox(height: 24),
        _buildLabel('New password'),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _newPasswordController,
          hint: 'New password',
          obscure: !_showNewPassword,
          onChanged: (_) => setState(() {}),
          trailing: _buildEyeToggle(
            shown: _showNewPassword,
            onTap: () => setState(() => _showNewPassword = !_showNewPassword),
          ),
        ),
        const SizedBox(height: 10),
        _buildStrengthBar(),
        const SizedBox(height: 12),
        _buildPasswordRequirements(),
        const SizedBox(height: 20),
        _buildLabel('Confirm new password'),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _confirmPasswordController,
          hint: 'Confirm new password',
          obscure: !_showConfirmPassword,
          trailing: _buildEyeToggle(
            shown: _showConfirmPassword,
            onTap: () =>
                setState(() => _showConfirmPassword = !_showConfirmPassword),
          ),
        ),
        if (_errorText != null) _buildErrorText(),
        const SizedBox(height: 32),
        _buildPrimaryButton(
          label: 'Reset password',
          onPressed: _handleResetPassword,
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: _AppColors.muted),
      ),
    );
  }

  Widget _buildErrorText() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4),
      child: Text(
        _errorText!,
        style: const TextStyle(fontSize: 12, color: Color(0xFFFF5C5C)),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _AppColors.field,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _AppColors.fieldBorder),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: const TextStyle(color: _AppColors.text, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: _AppColors.placeholder),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          suffixIcon: trailing,
        ),
      ),
    );
  }

  Widget _buildEyeToggle({required bool shown, required VoidCallback onTap}) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        shown ? Icons.visibility : Icons.visibility_off,
        size: 20,
        color: _AppColors.muted,
      ),
      splashRadius: 20,
    );
  }

  Widget _buildCodeRow() {
    return Row(
      children: List.generate(6, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == 5 ? 0 : 10),
            child: Container(
              decoration: BoxDecoration(
                color: _AppColors.field,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _AppColors.fieldBorder),
              ),
              child: TextField(
                controller: _codeControllers[index],
                focusNode: _codeFocusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: const TextStyle(
                  color: _AppColors.text,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && index < 5) {
                    _codeFocusNodes[index + 1].requestFocus();
                  } else if (value.isEmpty && index > 0) {
                    _codeFocusNodes[index - 1].requestFocus();
                  }
                },
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildResendRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: _AppColors.muted),
          children: [
            const TextSpan(text: "Didn't get a code? "),
            TextSpan(
              text: 'Resend',
              style: const TextStyle(
                color: _AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
              recognizer: TapGestureRecognizer()..onTap = _handleResendCode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthBar() {
    final strength = _passwordStrength;
    const segments = 3;
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: List.generate(segments, (i) {
          final filled = strength * segments > i;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == segments - 1 ? 0 : 6),
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: filled
                      ? _strengthColor(strength)
                      : _AppColors.fieldBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _requirementRow('At least 8 characters long', _hasMinLength),
          const SizedBox(height: 6),
          _requirementRow('At least one uppercase letter (A–Z)', _hasUppercase),
          const SizedBox(height: 6),
          _requirementRow('At least one number (0–9)', _hasNumber),
        ],
      ),
    );
  }

  Widget _requirementRow(String text, bool met) {
    return Row(
      children: [
        Icon(
          met ? Icons.check_circle : Icons.circle_outlined,
          size: 15,
          color: met ? _AppColors.accent : _AppColors.muted,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: met ? _AppColors.text : _AppColors.muted,
          ),
        ),
      ],
    );
  }

  Color _strengthColor(double strength) {
    if (strength <= 1 / 3) return const Color(0xFFFF5C5C);
    if (strength <= 2 / 3) return const Color(0xFFFFA23D);
    return _AppColors.accent;
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _AppColors.accent,
          disabledBackgroundColor: _AppColors.inactiveBtn,
          foregroundColor: _AppColors.bg,
          disabledForegroundColor: _AppColors.inactiveBtnText,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(_AppColors.bg),
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  Widget _buildFooterLink({
    required String leading,
    required String action,
    required VoidCallback onTap,
  }) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: _AppColors.muted),
          children: [
            TextSpan(text: leading),
            TextSpan(
              text: action,
              style: const TextStyle(
                color: _AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ],
        ),
      ),
    );
  }
}
