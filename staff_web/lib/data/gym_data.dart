import 'package:flutter/foundation.dart';

class GymData extends ChangeNotifier {
  GymData._();

  static final GymData instance = GymData._();

  // ============================================================
  // MEMBERS
  // ============================================================

  final List<Map<String, String>> members = [
    {
      'name': 'John Cruz',
      'type': 'Regular',
      'contact': '09123456789',
      'status': 'Active',
    },
    {
      'name': 'Joshua',
      'type': 'Regular',
      'contact': '09234567890',
      'status': 'Active',
    },
    {
      'name': 'Adrian',
      'type': 'Student',
      'contact': '09345678901',
      'status': 'Active',
    },
    {
      'name': 'Dwight',
      'type': 'Regular',
      'contact': '09456789012',
      'status': 'Active',
    },
    {
      'name': 'Emman',
      'type': 'Regular',
      'contact': '09567890123',
      'status': 'Active',
    },
  ];

  // ============================================================
  // TODAY'S LOGS
  // ============================================================

  final List<Map<String, String>> logs = [
    {
      'name': 'John Cruz',
      'action': 'Check In',
      'method': 'QR Code',
      'time': '6:00 AM',
    },
    {
      'name': 'Joshua',
      'action': 'Check Out',
      'method': 'QR Code',
      'time': '8:30 AM',
    },
    {
      'name': 'Adrian',
      'action': 'Check In',
      'method': 'Manual',
      'time': '7:15 AM',
    },
    {
      'name': 'Dwight',
      'action': 'Check In',
      'method': 'QR Code',
      'time': '8:00 AM',
    },
    {
      'name': 'Emman',
      'action': 'Check Out',
      'method': 'Manual',
      'time': '9:00 AM',
    },
  ];

  // ============================================================
  // MEMBERS COUNT
  // ============================================================

  int get totalMembers {
    return members.length;
  }

  int get activeMembers {
    return members
        .where((member) => member['status'] == 'Active')
        .length;
  }

  // ============================================================
  // TODAY'S CHECK-INS
  // ============================================================

  int get todayCheckIns {
    return logs
        .where((log) => log['action'] == 'Check In')
        .length;
  }

  // ============================================================
  // TODAY'S CHECK-OUTS
  // ============================================================

  int get todayCheckOuts {
    return logs
        .where((log) => log['action'] == 'Check Out')
        .length;
  }

  // ============================================================
  // ADD MEMBER
  // ============================================================

  void addMember({
    required String name,
    required String type,
    required String contact,
  }) {
    members.add({
      'name': name,
      'type': type,
      'contact': contact,
      'status': 'Active',
    });

    notifyListeners();
  }

  // ============================================================
  // EDIT MEMBER
  // ============================================================

  void editMember({
    required Map<String, String> member,
    required String name,
    required String type,
    required String contact,
  }) {
    member['name'] = name;
    member['type'] = type;
    member['contact'] = contact;

    notifyListeners();
  }

  // ============================================================
  // DELETE MEMBER
  // ============================================================

  void deleteMember(Map<String, String> member) {
    members.remove(member);

    notifyListeners();
  }

  // ============================================================
  // ADD CHECK-IN
  // ============================================================

  void checkIn({
    required String name,
    required String method,
  }) {
    logs.insert(
      0,
      {
        'name': name,
        'action': 'Check In',
        'method': method,
        'time': _currentTime(),
      },
    );

    notifyListeners();
  }

  // ============================================================
  // ADD CHECK-OUT
  // ============================================================

  void checkOut({
    required String name,
    required String method,
  }) {
    logs.insert(
      0,
      {
        'name': name,
        'action': 'Check Out',
        'method': method,
        'time': _currentTime(),
      },
    );

    notifyListeners();
  }

  // ============================================================
  // MANUAL TIME
  // ============================================================

  void manualTime({
    required String name,
    required String action,
  }) {
    logs.insert(
      0,
      {
        'name': name,
        'action': action,
        'method': 'Manual',
        'time': _currentTime(),
      },
    );

    notifyListeners();
  }

  // ============================================================
  // CURRENT TIME
  // ============================================================

  String _currentTime() {
    final now = DateTime.now();

    int hour = now.hour;
    final minute = now.minute;

    final period = hour >= 12 ? 'PM' : 'AM';

    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour -= 12;
    }

    return '$hour:${minute.toString().padLeft(2, '0')} $period';
  }
}