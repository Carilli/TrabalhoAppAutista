import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_role.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserRole _currentRole = UserRole.user;
  static const String _roleKey = 'user_role';

  UserRole get currentRole => _currentRole;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final roleString = prefs.getString(_roleKey);
    if (roleString != null) {
      _currentRole = UserRoleExtension.fromString(roleString);
      notifyListeners();
    }
  }

  Future<void> setRole(UserRole role) async {
    _currentRole = role;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role.value);
    notifyListeners();
  }

  bool get isAdmin => _currentRole == UserRole.admin;
  bool get isUser => _currentRole == UserRole.user;

  // Permission checks
  bool canAddRoutineItem() => isAdmin;
  bool canDeleteRoutineItem() => isAdmin;
  bool canCheckRoutineItem() => true; // Both roles can check

  bool canRegisterEmotion() => true; // Both roles can register
  bool canViewEmotions() => true; // Both roles can view

  bool canCreateJournalEntry() => true; // Both roles can create
  bool canViewJournal() => true; // Both roles can view

  bool canAddReminder() => isAdmin;
  bool canDeleteReminder() => isAdmin;
  bool canToggleReminder() => isAdmin;
  bool canViewReminders() => true; // Both roles can view
}
