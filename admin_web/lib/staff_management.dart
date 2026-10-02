import 'package:flutter/material.dart';
import 'overview.dart'; // Imports SidebarWidget and HeaderWidget

class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  String selectedFilter = 'All';

  // Statuses available from the edit (pencil) menu
  static const List<String> _statusOptions = ['Active', 'Inactive', 'Off Duty'];

  // Roles used by the drawer (menu) button and the Add Staff form.
  // These match the filter chip labels.
  static const List<String> _roleOptions = [
    'Staff',
    'Front Desk',
    'Trainers',
    'Admins',
  ];

  final List<Map<String, String>> allStaff = [
    {
      'initials': 'JS',
      'name': 'Jaspher Sibayan',
      'role': 'Front Desk',
      'shift': '6:00 AM',
      'status': 'Off Duty',
      'lastLogin': 'Today 5:00 AM',
    },
    {
      'initials': 'AM',
      'name': 'Ahrone Magtibay',
      'role': 'Front Desk',
      'shift': '6:00 AM',
      'status': 'Active',
      'lastLogin': 'Today 8:00 AM',
    },
    {
      'initials': 'EJ',
      'name': 'Emman Jalal',
      'role': 'Front Desk',
      'shift': '6:00 AM',
      'status': 'Active',
      'lastLogin': 'Today 12:00 PM',
    },
    {
      'initials': 'FD',
      'name': 'Fabs Dela Cruz',
      'role': 'Front Desk',
      'shift': '6:00 AM',
      'status': 'Active',
      'lastLogin': 'Today 5:00 PM',
    },
    {
      'initials': 'DT',
      'name': 'Dwayne Tore',
      'role': 'Front Desk',
      'shift': '6:00 AM',
      'status': 'Active',
      'lastLogin': 'Today 10:00 AM',
    },
    {
      'initials': 'EP',
      'name': 'Emman Pico',
      'role': 'Front Desk',
      'shift': '6:00 AM',
      'status': 'Off Duty',
      'lastLogin': 'Today 6:00 AM',
    },
  ];

  List<Map<String, String>> get filteredStaff {
    if (selectedFilter == 'All') return allStaff;
    return allStaff.where((s) => s['role'] == selectedFilter).toList();
  }

  // ---------------------------------------------------------------------------
  // Status helpers & actions
  // ---------------------------------------------------------------------------

  Color _statusColor(String status) {
    switch (status) {
      case 'Active':
        return const Color(0xFF00FF66);
      case 'Inactive':
        return Colors.redAccent;
      case 'Off Duty':
      default:
        return Colors.grey;
    }
  }

  void _updateStatus(Map<String, String> staff, String newStatus) {
    setState(() {
      staff['status'] = newStatus;
    });
    _showSnack('${staff['name']} is now $newStatus');
  }

  void _updateRole(Map<String, String> staff, String newRole) {
    setState(() {
      staff['role'] = newRole;
    });
    _showSnack('${staff['name']} is now $newRole');
  }

  Future<void> _confirmDelete(Map<String, String> staff) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF232323),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.white10),
        ),
        title: const Text(
          'Delete staff member?',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to remove ${staff['name']}? '
          'This action cannot be undone.',
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete',
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        allStaff.remove(staff);
      });
      _showSnack('${staff['name']} was deleted');
    }
  }

  Future<void> _showAddStaffDialog() async {
    final newStaff = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const _AddStaffDialog(
        roleOptions: _roleOptions,
        statusOptions: _statusOptions,
      ),
    );

    if (newStaff != null && mounted) {
      setState(() {
        selectedFilter = 'All'; // make sure the new person is visible
        allStaff.add(newStaff);
      });
      _showSnack('${newStaff['name']} was added');
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message,
              style: const TextStyle(color: Colors.white, fontSize: 12)),
          backgroundColor: const Color(0xFF2B2B2B),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      body: Row(
        children: [
          // Sidebar Widget with 'Staff Management' active
          const SidebarWidget(currentRoute: 'Staff Management'),

          // Main Screen Content
          Expanded(
            child: Column(
              children: [
                const HeaderWidget(),

                // Scrollable Body Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'STAFF MANAGEMENT',
                          style: TextStyle(
                            color: Color(0xFF00FF66),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Analytics / Overview Cards Row
                        LayoutBuilder(
                          builder: (context, constraints) {
                            double cardWidth = (constraints.maxWidth - 36) / 4;
                            return Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _buildMetricCard(
                                    'Total staff',
                                    '14',
                                    '2 added this month',
                                    const Color(0xFF00FF66),
                                    cardWidth),
                                _buildMetricCard(
                                    'Active Today',
                                    '9',
                                    'On Shift now',
                                    const Color(0xFF00FF66),
                                    cardWidth),
                                _buildMetricCard(
                                    'On leave',
                                    '2',
                                    'Returning next week',
                                    Colors.redAccent,
                                    cardWidth),
                                _buildMetricCard('Admins', '3', 'Full Access',
                                    const Color(0xFF00FF66), cardWidth),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        // Filters & Action Bar Row
                        Row(
                          children: [
                            Wrap(
                              spacing: 8,
                              children: [
                                _buildFilterChip('All'),
                                _buildFilterChip('Front Desk'),
                                _buildFilterChip('Trainers'),
                                _buildFilterChip('Admins'),
                              ],
                            ),
                            const Spacer(),
                            _buildAddStaffButton(),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Main Staff Table Box
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF232323),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Table Headers
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width:
                                            44), // Alignment spacing for circle avatar
                                    Expanded(
                                      flex: 3,
                                      child: Text('STAFF',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text('ROLE',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text('SHIFT',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text('STATUS',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text('LAST LOGIN',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    SizedBox(
                                        width:
                                            80), // Reserve width for action buttons
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),

                              // List of Staff Items
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredStaff.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  return _buildStaffRow(filteredStaff[index]);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Filter Chip Widget
  Widget _buildFilterChip(String label) {
    bool isSelected = selectedFilter == label;
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: GestureDetector(
            onTap: () {
              this.setState(() {
                selectedFilter = label;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF383838)
                    : (isHovered
                        ? const Color(0xFF333333)
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF00FF66)
                      : (isHovered ? Colors.white38 : Colors.white24),
                  width: isSelected ? 1.2 : 1.0,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFF00FF66)
                      : (isHovered ? Colors.white : Colors.white70),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Add Staff Neon Action Button
  Widget _buildAddStaffButton() {
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: InkWell(
            onTap: _showAddStaffDialog,
            borderRadius: BorderRadius.circular(6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isHovered
                    ? const Color(0xFF00E65C)
                    : const Color(0xFF1E3A29),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFF00FF66),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    '+ Add Staff',
                    style: TextStyle(
                      color: isHovered ? Colors.black : const Color(0xFF00FF66),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Edit (pencil) menu: Active / Inactive / Off Duty / Delete
  Widget _buildEditMenu(Map<String, String> staff) {
    final String current = staff['status'] ?? '';

    return PopupMenuButton<String>(
      tooltip: 'Edit status',
      icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.grey),
      splashRadius: 18,
      color: const Color(0xFF2B2B2B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.white12),
      ),
      onSelected: (value) {
        if (value == 'Delete') {
          _confirmDelete(staff);
        } else if (value != current) {
          _updateStatus(staff, value);
        }
      },
      itemBuilder: (context) => [
        for (final option in _statusOptions)
          PopupMenuItem<String>(
            value: option,
            height: 36,
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: _statusColor(option),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  option,
                  style: TextStyle(
                    color: option == current ? Colors.white : Colors.white70,
                    fontSize: 12,
                    fontWeight:
                        option == current ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (option == current) ...[
                  const SizedBox(width: 10),
                  const Icon(Icons.check, size: 14, color: Color(0xFF00FF66)),
                ],
              ],
            ),
          ),
        const PopupMenuDivider(height: 1),
        const PopupMenuItem<String>(
          value: 'Delete',
          height: 36,
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
              SizedBox(width: 8),
              Text(
                'Delete',
                style: TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Drawer (menu) button: Front Desk / Trainers / Admins
  Widget _buildRoleMenu(Map<String, String> staff) {
    final String current = staff['role'] ?? '';

    return PopupMenuButton<String>(
      tooltip: 'Change role',
      icon: const Icon(Icons.menu, size: 18, color: Colors.grey),
      splashRadius: 18,
      color: const Color(0xFF2B2B2B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.white12),
      ),
      onSelected: (value) {
        if (value != current) _updateRole(staff, value);
      },
      itemBuilder: (context) => [
        for (final option in _roleOptions)
          PopupMenuItem<String>(
            value: option,
            height: 36,
            child: Row(
              children: [
                Text(
                  option,
                  style: TextStyle(
                    color: option == current ? Colors.white : Colors.white70,
                    fontSize: 12,
                    fontWeight:
                        option == current ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (option == current) ...[
                  const SizedBox(width: 10),
                  const Icon(Icons.check, size: 14, color: Color(0xFF00FF66)),
                ],
              ],
            ),
          ),
      ],
    );
  }

  // Row Card Item for Staff Members
  Widget _buildStaffRow(Map<String, String> staff) {
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color:
                  isHovered ? const Color(0xFF333333) : const Color(0xFF2B2B2B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isHovered
                    ? const Color(0xFF00FF66).withValues(alpha: 0.5)
                    : Colors.white12,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF444444),
                  child: Text(
                    staff['initials']!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Text(
                    staff['name']!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    staff['role']!,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    staff['shift']!,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _buildStatusTag(staff['status']!),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    staff['lastLogin']!,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
                Row(
                  children: [
                    // Edit menu: Active / Inactive / Off Duty / Delete
                    _buildEditMenu(staff),
                    // Drawer menu: Front Desk / Trainers / Admins
                    _buildRoleMenu(staff),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Status Tag Badge
  Widget _buildStatusTag(String status) {
    final Color color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            status.toUpperCase(),
            style: TextStyle(
                color: color, fontSize: 9, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Metric Card Builder
  Widget _buildMetricCard(String title, String value, String subtext,
      Color subtextColor, double width) {
    return Container(
      width: width < 180 ? 180 : width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF232323),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtext,
            style: TextStyle(color: subtextColor, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Add Staff dialog
// -----------------------------------------------------------------------------
class _AddStaffDialog extends StatefulWidget {
  final List<String> roleOptions;
  final List<String> statusOptions;

  const _AddStaffDialog({
    required this.roleOptions,
    required this.statusOptions,
  });

  @override
  State<_AddStaffDialog> createState() => _AddStaffDialogState();
}

class _AddStaffDialogState extends State<_AddStaffDialog> {
  final TextEditingController _nameController = TextEditingController();
  late String _role = widget.roleOptions.first;
  late String _status = widget.statusOptions.first;
  TimeOfDay _shift = const TimeOfDay(hour: 6, minute: 0);
  String? _nameError;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // "6:00 AM" style, same as the existing rows
  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  // First letters of the first two words, e.g. "Fabs Dela Cruz" -> "FD"
  String _initialsFor(String name) {
    final parts =
        name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final p = parts.first;
      return (p.length >= 2 ? p.substring(0, 2) : p).toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Future<void> _pickShift() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _shift,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF00FF66),
            onPrimary: Colors.black,
            surface: Color(0xFF232323),
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _shift = picked);
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Please enter a name');
      return;
    }
    Navigator.of(context).pop(<String, String>{
      'initials': _initialsFor(name),
      'name': name,
      'role': _role,
      'shift': _formatTime(_shift),
      'status': _status,
      'lastLogin': 'Never',
    });
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color),
      );

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
      floatingLabelStyle:
          const TextStyle(color: Color(0xFF00FF66), fontSize: 12),
      errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 11),
      filled: true,
      fillColor: const Color(0xFF2B2B2B),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: _border(Colors.white24),
      enabledBorder: _border(Colors.white24),
      focusedBorder: _border(const Color(0xFF00FF66)),
      errorBorder: _border(Colors.redAccent),
      focusedErrorBorder: _border(Colors.redAccent),
    );
  }

  Widget _dropdown({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String> onChanged,
  }) {
    return InputDecorator(
      decoration: _decoration(label),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          isDense: true,
          dropdownColor: const Color(0xFF2B2B2B),
          iconEnabledColor: Colors.grey,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          items: [
            for (final o in options)
              DropdownMenuItem<String>(value: o, child: Text(o)),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF232323),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.white10),
      ),
      title: const Text(
        'Add Staff',
        style: TextStyle(
            color: Color(0xFF00FF66),
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2),
      ),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                cursorColor: const Color(0xFF00FF66),
                decoration:
                    _decoration('Full name').copyWith(errorText: _nameError),
                onChanged: (_) {
                  if (_nameError != null) setState(() => _nameError = null);
                },
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 14),
              _dropdown(
                label: 'Role',
                value: _role,
                options: widget.roleOptions,
                onChanged: (v) => setState(() => _role = v),
              ),
              const SizedBox(height: 14),
              InkWell(
                onTap: _pickShift,
                borderRadius: BorderRadius.circular(8),
                child: InputDecorator(
                  decoration: _decoration('Shift start').copyWith(
                    suffixIcon: const Icon(Icons.access_time,
                        size: 16, color: Colors.grey),
                  ),
                  child: Text(
                    _formatTime(_shift),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _dropdown(
                label: 'Status',
                value: _status,
                options: widget.statusOptions,
                onChanged: (v) => setState(() => _status = v),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E3A29),
            foregroundColor: const Color(0xFF00FF66),
            elevation: 0,
            side: const BorderSide(color: Color(0xFF00FF66)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: const Text('+ Add Staff',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
