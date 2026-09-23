import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/log_in.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color _bgColor = Color(0xFF0E0E0E);
  static const Color _cardColor = Color(0xFF1C1C1C);
  static const Color _colorGreen = Color(0xFF3ECF4A);

  bool _personalInfoExpanded = false;
  bool _notificationsEnabled = true;

  // ---- Change password controllers/state ---- //
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor,
        title: const Text('Log out', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Log out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // TODO: persist this to Firestore (e.g. users/{uid}.notificationsEnabled)
  Future<void> _toggleNotifications(bool value) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'notificationsEnabled': value});
    } catch (e) {
      _showSnack('Update Failed');
    }
  }

  // ---- Change password flow ----

  void _showChangePasswordForm(BuildContext context) {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    _obscureCurrentPassword = true;
    _obscureNewPassword = true;
    _obscureConfirmPassword = true;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              backgroundColor: _cardColor,
              title: const Text('Change password',
                  style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _currentPasswordController,
                      obscureText: _obscureCurrentPassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Current password',
                        labelStyle: const TextStyle(color: Colors.white54),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureCurrentPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white54,
                          ),
                          onPressed: () => setDialogState(() =>
                              _obscureCurrentPassword =
                                  !_obscureCurrentPassword),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _newPasswordController,
                      obscureText: _obscureNewPassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'New password',
                        labelStyle: const TextStyle(color: Colors.white54),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNewPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white54,
                          ),
                          onPressed: () => setDialogState(
                              () => _obscureNewPassword = !_obscureNewPassword),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Confirm new password',
                        labelStyle: const TextStyle(color: Colors.white54),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white54,
                          ),
                          onPressed: () => setDialogState(() =>
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => _submitNewPassword(dialogContext),
                  child: const Text('Confirm',
                      style: TextStyle(color: _colorGreen)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _submitNewPassword(BuildContext dialogContext) async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      _showSnack('Please fill in all fields.');
      return;
    }
    if (newPassword.length < 6) {
      _showSnack('New password must be at least 6 characters.');
      return;
    }
    if (newPassword != confirmPassword) {
      _showSnack('New passwords do not match.');
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) return;

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      if (!dialogContext.mounted) return;
      Navigator.pop(dialogContext);
      _showSnack('Password updated successfully.');
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          message = 'Current password is incorrect.';
          break;
        case 'weak-password':
          message = 'New password is too weak.';
          break;
        default:
          message = e.message ?? 'Failed to update password.';
      }
      _showSnack(message);
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: uid == null
            ? const Center(
                child: Text('Not logged in.',
                    style: TextStyle(color: Colors.white70)),
              )
            : StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(color: _colorGreen));
                  }
                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      !snapshot.data!.exists) {
                    return const Center(
                      child: Text('Could not load profile.',
                          style: TextStyle(color: Colors.white70)),
                    );
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final username = data['username'] as String? ?? 'No name';
                  final email = data['email'] as String? ?? '';
                  final phoneNumber = data['phoneNumber'] as String? ?? '';
                  final memberType = data['memberType'] as String? ?? '';
                  final notificationsEnabled =
                      data['notificationsEnabled'] as bool? ?? true;

                  return Column(
                    children: [
                      _buildTopBar(context),
                      const SizedBox(height: 12),
                      _buildAvatarSection(username, email),
                      const SizedBox(height: 28),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildSettingsCard(
                            context,
                            username: username,
                            email: email,
                            phoneNumber: phoneNumber,
                            memberType: memberType,
                            notificationsEnabled: notificationsEnabled,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'Profile',
            style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.w600),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(String name, String email) {
    return Column(
      children: [
        Container(
          width: 92,
          height: 92,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white24, width: 2),
          ),
          child: const CircleAvatar(
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white70, size: 40),
          ),
        ),
        const SizedBox(height: 14),
        Text(name,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(email,
            style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required String username,
    required String email,
    required String phoneNumber,
    required String memberType,
    required bool notificationsEnabled,
  }) {
    return Container(
      decoration: BoxDecoration(
          color: _cardColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // ---- Personal Information (expandable) ----
          _buildRow(
            label: 'Personal Information',
            trailing: AnimatedRotation(
              turns: _personalInfoExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.keyboard_arrow_down,
                  color: Colors.white54, size: 20),
            ),
            onTap: () {
              setState(() {
                _personalInfoExpanded = !_personalInfoExpanded;
              });
            },
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _personalInfoExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: _buildPersonalInfoDetails(username, email),
            secondChild: const SizedBox(width: double.infinity),
          ),
          _buildDivider(),

          _buildRow(
              label: 'Change Password',
              onTap: () => _showChangePasswordForm(context)),
          _buildDivider(),

          // ---- Notification (on/off toggle) ---- //
          _buildRow(
            label: 'Notification',
            trailing: Switch(
              value: notificationsEnabled,
              activeThumbColor: _colorGreen,
              onChanged: _toggleNotifications,
            ),
            onTap: () => _toggleNotifications(!_notificationsEnabled),
          ),
          _buildDivider(),

          _buildRow(
            label: 'Help & Support',
            trailing:
                const Icon(Icons.help_outline, color: Colors.white54, size: 18),
            onTap: () {},
          ),
          _buildDivider(),
          _buildRow(
              label: 'Log out',
              labelColor: Colors.redAccent,
              onTap: () => _handleLogout(context)),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoDetails(String username, String email) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailLine('Username', username),
          const SizedBox(height: 10),
          _buildDetailLine('Email', email),
        ],
      ),
    );
  }

  Widget _buildDetailLine(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: const TextStyle(
                color: Colors.white54,
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? '—' : value,
            style: const TextStyle(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildRow({
    required String label,
    Widget? trailing,
    Color labelColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    color: labelColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() => const Divider(color: Colors.white12, height: 1);
}
