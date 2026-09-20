import 'package:flutter/material.dart';

import '../auth/log_in.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    this.name = 'Jaspher sibayan',
    this.email = 'jasphersibayan@gmail.com',
    this.avatarUrl,
  });

  final String name;
  final String email;
  final String? avatarUrl;

  static const Color _bgColor = Color(0xFF0E0E0E);
  static const Color _cardColor = Color(0xFF1C1C1C);
  static const Color _colorGreen = Color(0xFF3ECF4A);

  void _handleLogout(BuildContext context) {
    // TODO: also clear any stored session/auth token here (e.g. SharedPreferences,
    // secure storage, or your auth provider's sign-out call) before navigating.
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
            onPressed: () {
              // Close the dialog first, then wipe the entire navigation
              // stack (Profile, Dashboard, everything) and drop the user
              // back on the login screen with no way to swipe/back into
              // the app.
              Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            const SizedBox(height: 12),
            _buildAvatarSection(),
            const SizedBox(height: 28),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildSettingsCard(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Back arrow + centered "Profile" title ----
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
              fontWeight: FontWeight.w600,
            ),
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

  // ---- Avatar ring + name + email ----
  Widget _buildAvatarSection() {
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
          child: CircleAvatar(
            backgroundColor: Colors.white24,
            backgroundImage:
                avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? const Icon(Icons.person, color: Colors.white70, size: 40)
                : null,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  // ---- Settings card: Personal Info / Password / Notifications / etc ----
  Widget _buildSettingsCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildRow(
            label: 'Personal Information',
            trailing: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white54,
              size: 20,
            ),
            onTap: () {
              // TODO: expand/navigate to personal information details.
            },
          ),
          _buildDivider(),
          _buildRow(
            label: 'Change Password',
            onTap: () {
              // TODO: navigate to change-password flow.
            },
          ),
          _buildDivider(),
          _buildRow(
            label: 'Notification',
            trailing: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white54,
              size: 20,
            ),
            onTap: () {
              // TODO: expand/navigate to notification settings.
            },
          ),
          _buildDivider(),
          _buildRow(
            label: 'Help & Support',
            trailing: const Icon(
              Icons.help_outline,
              color: Colors.white54,
              size: 18,
            ),
            onTap: () {
              // TODO: navigate to help & support screen.
            },
          ),
          _buildDivider(),
          _buildRow(
            label: 'Log out',
            labelColor: Colors.redAccent,
            onTap: () => _handleLogout(context),
          ),
        ],
      ),
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
            Text(
              label,
              style: TextStyle(
                color: labelColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Colors.white12, height: 1);
  }
}
