import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilityProvider with ChangeNotifier {
  double _textScaleFactor = 1.0;
  bool _highContrast = false;
  bool _calmMode = false;

  double get textScaleFactor => _textScaleFactor;
  bool get isHighContrast => _highContrast;
  bool get isCalmMode => _calmMode;

  AccessibilityProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _textScaleFactor = prefs.getDouble('textScaleFactor') ?? 1.0;
    _highContrast = prefs.getBool('highContrast') ?? false;
    _calmMode = prefs.getBool('calmMode') ?? false;
    notifyListeners();
  }

  Future<void> setTextScaleFactor(double value) async {
    _textScaleFactor = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('textScaleFactor', value);
    notifyListeners();
  }

  Future<void> setHighContrast(bool value) async {
    _highContrast = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('highContrast', value);
    notifyListeners();
  }

  Future<void> setCalmMode(bool value) async {
    _calmMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('calmMode', value);
    notifyListeners();
  }
}
