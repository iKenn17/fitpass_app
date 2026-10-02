import 'package:flutter/material.dart';

class MembershipInfo {
  final String planName;
  final DateTime expiryDate;
  final String memberType;
  final String memberId;
  final String status;

  const MembershipInfo({
    required this.planName,
    required this.expiryDate,
    required this.memberType,
    required this.memberId,
    required this.status,
  });

  int get daysLeft => expiryDate.difference(DateTime.now()).inDays;
}

class MembershipTab extends StatelessWidget {
  const MembershipTab({super.key});

  // TODO: replace with real membership data fetched from your
  // backend/database for the logged-in user.
  static final MembershipInfo _membership = MembershipInfo(
    planName: 'PREMIUM MEMBER',
    expiryDate: DateTime(2026, 6, 27),
    memberType: 'Student',
    memberId: 'FTS-000123',
    status: 'Active',
  );

  String _formatDate(DateTime date) {
    const months = [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPremiumCard(),
          const SizedBox(height: 16),
          _buildDetailsCard(),
          const SizedBox(height: 16),
          _buildRemindersCard(),
        ],
      ),
    );
  }

  // ---- Green "Premium Member" card with expiry + days left ----
  Widget _buildPremiumCard() {
    final daysLeft = _membership.daysLeft;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF6E), Color(0xFF3F9E5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _membership.planName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _formatDate(_membership.expiryDate),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            daysLeft >= 0 ? '$daysLeft days left' : 'Expired',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ---- Dark card: Member Type / Member ID / Status ----
  Widget _buildDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Member Type'),
          const SizedBox(height: 4),
          Text(
            _membership.memberType,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          _buildLabel('Member ID'),
          const SizedBox(height: 4),
          Text(
            _membership.memberId,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 18),
          _buildLabel('Status'),
          const SizedBox(height: 4),
          Text(
            _membership.status,
            style: const TextStyle(
              color: Color(0xFF3ECF4A),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ---- Reminders card ----
  Widget _buildRemindersCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reminders',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Your membership will expire on '
            '${_formatDate(_membership.expiryDate).toLowerCase()}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
