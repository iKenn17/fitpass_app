import 'package:flutter/material.dart';
import '../widgets/fitpass_layout.dart';
import '../data/gym_data.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  static const List<String> _memberTypes = ['Regular', 'Student', 'Senior'];

  static const Color _cardColor = Color(0xFF2B2B2B);
  static const Color _green = Color(0xFF00FF66);
  static const Color _buttonGreen = Color(0xFF28C76F);

  BoxDecoration get _cardDecoration => BoxDecoration(
    color: _cardColor,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.white10),
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: GymData.instance,
      builder: (context, child) {
        final gym = GymData.instance;
        final members = gym.members;

        final activeMembers = members
            .where((m) => m['status'] == 'Active')
            .length;
        final studentMembers = members
            .where((m) => m['type'] == 'Student')
            .length;
        final seniorMembers = members
            .where((m) => m['type'] == 'Senior')
            .length;

        return FitpassLayout(
          currentPage: '/members',
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // TITLE
                // ==================================================
                const Text(
                  'MEMBERS',
                  style: TextStyle(
                    color: _green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 16),

                // ==================================================
                // SUMMARY CARDS
                // ==================================================
                Row(
                  children: [
                    Expanded(
                      child: _summaryCard(
                        'Total Members',
                        members.length.toString(),
                        Icons.people_alt_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _summaryCard(
                        'Active',
                        activeMembers.toString(),
                        Icons.verified_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _summaryCard(
                        'Students',
                        studentMembers.toString(),
                        Icons.school_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _summaryCard(
                        'Seniors',
                        seniorMembers.toString(),
                        Icons.elderly,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ==================================================
                // ADD MEMBER
                // ==================================================
                _actionButton(
                  'ADD MEMBER',
                  Icons.person_add,
                  () => _showMemberDialog(),
                ),

                const SizedBox(height: 16),

                // ==================================================
                // MEMBER LIST
                // ==================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: _cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Member List',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _tableHeader(),

                      const Divider(color: Colors.white10),

                      if (members.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Text(
                              'No members found.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),

                      ...members.map(_memberRow),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==============================================================
  // ACTION BUTTON
  // ==============================================================

  Widget _actionButton(String text, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      height: 32,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _buttonGreen,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  // ==============================================================
  // TABLE HEADER
  // ==============================================================

  Widget _tableHeader() {
    const style = TextStyle(color: Colors.grey, fontSize: 11);

    return const Row(
      children: [
        Expanded(flex: 2, child: Text('Name', style: style)),
        Expanded(child: Text('Type', style: style)),
        Expanded(flex: 2, child: Text('Contact', style: style)),
        Expanded(child: Text('Status', style: style)),
        Expanded(child: Text('Action', style: style)),
      ],
    );
  }

  // ==============================================================
  // MEMBER ROW
  // ==============================================================

  Widget _memberRow(Map<String, String> member) {
    final status = member['status'] ?? '';
    final isActive = status == 'Active';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              member['name'] ?? '',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              member['type'] ?? '',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              member['contact'] ?? '',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF294A31) : Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: isActive ? _green : Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Edit',
                  onPressed: () => _showMemberDialog(member: member),
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.white70,
                    size: 18,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                IconButton(
                  tooltip: 'Delete',
                  onPressed: () => _deleteMember(member),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 18,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // SUMMARY CARD
  // ==============================================================

  Widget _summaryCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF294A31),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: _green, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // ADD / EDIT MEMBER DIALOG
  // Pass a member to edit it, or nothing to add a new one.
  // ==============================================================

  void _showMemberDialog({Map<String, String>? member}) {
    final isEdit = member != null;

    final nameController = TextEditingController(text: member?['name']);
    final contactController = TextEditingController(text: member?['contact']);

    String type = member?['type'] ?? 'Regular';
    if (!_memberTypes.contains(type)) type = 'Regular';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: _cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.white10),
              ),
              title: Text(
                isEdit ? 'Edit Member' : 'Add Member',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                width: 320,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      autofocus: true,
                      cursorColor: _green,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: _inputDecoration('Member name'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: contactController,
                      cursorColor: _green,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: _inputDecoration('Contact number'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: type,
                      dropdownColor: _cardColor,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: _inputDecoration('Member type'),
                      items: _memberTypes
                          .map(
                            (t) => DropdownMenuItem<String>(
                              value: t,
                              child: Text(t),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => type = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final contact = contactController.text.trim();

                    if (name.isEmpty) return;

                    if (isEdit) {
                      GymData.instance.editMember(
                        member: member,
                        name: name,
                        type: type,
                        contact: contact,
                      );
                    } else {
                      GymData.instance.addMember(
                        name: name,
                        type: type,
                        contact: contact,
                      );
                    }

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isEdit
                              ? 'Member updated successfully.'
                              : '$name added successfully.',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _buttonGreen,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(isEdit ? 'SAVE' : 'ADD'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==============================================================
  // DELETE MEMBER
  // ==============================================================

  void _deleteMember(Map<String, String> member) {
    final name = member['name'] ?? 'Member';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: _cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.white10),
          ),
          title: const Text(
            'Delete Member',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete $name?',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'CANCEL',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                GymData.instance.deleteMember(member);

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$name deleted successfully.')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }

  // ==============================================================
  // INPUT DECORATION (admin style)
  // ==============================================================

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFF424242),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _green, width: 1.4),
      ),
    );
  }
}
