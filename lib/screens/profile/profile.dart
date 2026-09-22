import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/log_in.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color _bgColor = Color(0xFF0E0E0E);
  static const Color _cardColor = Color(0xFF1C1C1C);
  static const Color _colorGreen = Color(0xFF3ECF4A);

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
                              context, phoneNumber, memberType),
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
      BuildContext context, String phoneNumber, String memberType) {
    return Container(
      decoration: BoxDecoration(
          color: _cardColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _buildRow(
            label: 'Personal Information',
            trailing: const Icon(Icons.keyboard_arrow_down,
                color: Colors.white54, size: 20),
            onTap: () {
              // TODO: expand/navigate to personal information details
              // (could show phoneNumber / memberType here).
            },
          ),
          _buildDivider(),
          _buildRow(label: 'Change Password', onTap: () {}),
          _buildDivider(),
          _buildRow(
            label: 'Notification',
            trailing: const Icon(Icons.keyboard_arrow_down,
                color: Colors.white54, size: 20),
            onTap: () {},
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
