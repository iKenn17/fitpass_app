import 'package:flutter/material.dart';
import '../widgets/fitpass_layout.dart';
import '../data/gym_data.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: GymData.instance,
      builder: (context, child) {
        final gym = GymData.instance;

        final members = gym.members;

        final activeMembers = members
            .where(
              (member) =>
                  member['status'] == 'Active',
            )
            .length;

        final studentMembers = members
            .where(
              (member) =>
                  member['type'] == 'Student',
            )
            .length;

        return FitpassLayout(
          currentPage: '/members',
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                // ==================================================
                // TITLE
                // ==================================================

                const Text(
                  'Members',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // ==================================================
                // ADD MEMBER
                // ==================================================

                Row(
                  children: [
                    _actionButton(
                      'ADD MEMBER',
                      Icons.person_add,
                      _showAddMemberDialog,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ==================================================
                // MEMBER LIST
                // ==================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF252525),
                    borderRadius:
                        BorderRadius.circular(5),
                    border: Border.all(
                      color: const Color(0xFF3A3A3A),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      const Text(
                        'Member List',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      _tableHeader(),

                      const SizedBox(height: 3),

                      if (members.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(15),
                          child: Center(
                            child: Text(
                              'No members found.',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ),

                      ...members.map(
                        (member) =>
                            _memberRow(member),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ==================================================
                // SUMMARY
                // ==================================================

                Row(
                  children: [

                    _summaryCard(
                      'Total Members',
                      members.length.toString(),
                    ),

                    _summaryCard(
                      'Active',
                      activeMembers.toString(),
                    ),

                    _summaryCard(
                      'Students',
                      studentMembers.toString(),
                    ),
                  ],
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

  Widget _actionButton(
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      height: 28,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 12,
        ),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 7,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color(0xFF22C55E),
          foregroundColor: Colors.black,
          elevation: 0,
          padding:
              const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // TABLE HEADER
  // ==============================================================

  Widget _tableHeader() {
    return const Row(
      children: [

        Expanded(
          flex: 2,
          child: Text(
            'Name',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 7,
            ),
          ),
        ),

        Expanded(
          child: Text(
            'Type',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 7,
            ),
          ),
        ),

        Expanded(
          flex: 2,
          child: Text(
            'Contact',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 7,
            ),
          ),
        ),

        Expanded(
          child: Text(
            'Status',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 7,
            ),
          ),
        ),

        Expanded(
          child: Text(
            'Action',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 7,
            ),
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // MEMBER ROW
  // ==============================================================

  Widget _memberRow(
    Map<String, String> member,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 8,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white10,
          ),
        ),
      ),
      child: Row(
        children: [

          Expanded(
            flex: 2,
            child: Text(
              member['name'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 7,
              ),
            ),
          ),

          Expanded(
            child: Text(
              member['type'] ?? '',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 7,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              member['contact'] ?? '',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 7,
              ),
            ),
          ),

          Expanded(
            child: Text(
              member['status'] ?? '',
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 7,
              ),
            ),
          ),

          Expanded(
            child: Row(
              children: [

                IconButton(
                  onPressed: () {
                    _showEditMemberDialog(
                      member,
                    );
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white70,
                    size: 12,
                  ),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(),
                ),

                const SizedBox(width: 6),

                IconButton(
                  onPressed: () {
                    _deleteMember(member);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                    size: 12,
                  ),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(),
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

  Widget _summaryCard(
    String title,
    String value,
  ) {
    return Expanded(
      child: Container(
        margin:
            const EdgeInsets.only(right: 6),
        height: 65,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF252525),
          borderRadius:
              BorderRadius.circular(5),
          border: Border.all(
            color: const Color(0xFF3A3A3A),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 7,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // ADD MEMBER DIALOG
  // ==============================================================

  void _showAddMemberDialog() {
    final nameController =
        TextEditingController();

    final contactController =
        TextEditingController();

    String type = 'Regular';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder:
              (context, setDialogState) {
            return AlertDialog(
              backgroundColor:
                  const Color(0xFF252525),

              title: const Text(
                'Add Member',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),

              content: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [

                  TextField(
                    controller:
                        nameController,
                    style:
                        const TextStyle(
                      color: Colors.white,
                    ),
                    decoration:
                        _inputDecoration(
                      'Member name',
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller:
                        contactController,
                    style:
                        const TextStyle(
                      color: Colors.white,
                    ),
                    decoration:
                        _inputDecoration(
                      'Contact number',
                    ),
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<
                      String>(
                    value: type,
                    dropdownColor:
                        const Color(
                      0xFF252525,
                    ),
                    style:
                        const TextStyle(
                      color: Colors.white,
                    ),
                    decoration:
                        _inputDecoration(
                      'Member type',
                    ),
                    items: const [

                      DropdownMenuItem(
                        value: 'Regular',
                        child:
                            Text('Regular'),
                      ),

                      DropdownMenuItem(
                        value: 'Student',
                        child:
                            Text('Student'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          type = value;
                        });
                      }
                    },
                  ),
                ],
              ),

              actions: [

                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: () {

                    final name =
                        nameController.text
                            .trim();

                    final contact =
                        contactController.text
                            .trim();

                    if (name.isEmpty) {
                      return;
                    }

                    GymData.instance.addMember(
                      name: name,
                      type: type,
                      contact: contact,
                    );

                    Navigator.pop(
                      dialogContext,
                    );

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(
                          '$name added successfully.',
                        ),
                      ),
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(
                      0xFF22C55E,
                    ),
                    foregroundColor:
                        Colors.black,
                  ),
                  child: const Text(
                    'ADD',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==============================================================
  // EDIT MEMBER DIALOG
  // ==============================================================

  void _showEditMemberDialog(
    Map<String, String> member,
  ) {
    final nameController =
        TextEditingController(
      text: member['name'],
    );

    final contactController =
        TextEditingController(
      text: member['contact'],
    );

    String type =
        member['type'] ?? 'Regular';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder:
              (context, setDialogState) {
            return AlertDialog(
              backgroundColor:
                  const Color(0xFF252525),

              title: const Text(
                'Edit Member',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),

              content: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [

                  TextField(
                    controller:
                        nameController,
                    style:
                        const TextStyle(
                      color: Colors.white,
                    ),
                    decoration:
                        _inputDecoration(
                      'Member name',
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller:
                        contactController,
                    style:
                        const TextStyle(
                      color: Colors.white,
                    ),
                    decoration:
                        _inputDecoration(
                      'Contact number',
                    ),
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<
                      String>(
                    value: type,
                    dropdownColor:
                        const Color(
                      0xFF252525,
                    ),
                    style:
                        const TextStyle(
                      color: Colors.white,
                    ),
                    decoration:
                        _inputDecoration(
                      'Member type',
                    ),
                    items: const [

                      DropdownMenuItem(
                        value: 'Regular',
                        child:
                            Text('Regular'),
                      ),

                      DropdownMenuItem(
                        value: 'Student',
                        child:
                            Text('Student'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          type = value;
                        });
                      }
                    },
                  ),
                ],
              ),

              actions: [

                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: () {

                    final name =
                        nameController.text
                            .trim();

                    final contact =
                        contactController.text
                            .trim();

                    if (name.isEmpty) {
                      return;
                    }

                    GymData.instance.editMember(
                      member: member,
                      name: name,
                      type: type,
                      contact: contact,
                    );

                    Navigator.pop(
                      dialogContext,
                    );

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Member updated successfully.',
                        ),
                      ),
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(
                      0xFF22C55E,
                    ),
                    foregroundColor:
                        Colors.black,
                  ),
                  child: const Text(
                    'SAVE',
                  ),
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

  void _deleteMember(
    Map<String, String> member,
  ) {
    final name = member['name'] ?? 'Member';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              const Color(0xFF252525),

          title: const Text(
            'Delete Member',
            style: TextStyle(
              color: Colors.white,
            ),
          ),

          content: Text(
            'Are you sure you want to delete $name?',
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'CANCEL',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {

                GymData.instance
                    .deleteMember(member);

                Navigator.pop(
                  dialogContext,
                );

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    content: Text(
                      '$name deleted successfully.',
                    ),
                  ),
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.redAccent,
                foregroundColor:
                    Colors.white,
              ),
              child: const Text(
                'DELETE',
              ),
            ),
          ],
        );
      },
    );
  }

  // ==============================================================
  // INPUT DECORATION
  // ==============================================================

  InputDecoration _inputDecoration(
    String hint,
  ) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.white38,
      ),
      enabledBorder:
          const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white24,
        ),
      ),
      focusedBorder:
          const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.green,
        ),
      ),
    );
  }
}