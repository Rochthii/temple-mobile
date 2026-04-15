import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Temple Context Keys
  static const String _keyTenantId = 'selected_tenant_id';
  static const String _keyTenantName = 'selected_tenant_name';
  static const String _keyContextMode = 'context_mode';

  // Setters
  static Future<bool> setTenantId(String? value) async {
    if (value == null) return _prefs.remove(_keyTenantId);
    return _prefs.setString(_keyTenantId, value);
  }

  static Future<bool> setTenantName(String? value) async {
    if (value == null) return _prefs.remove(_keyTenantName);
    return _prefs.setString(_keyTenantName, value);
  }

  static Future<bool> setContextMode(String value) async {
    return _prefs.setString(_keyContextMode, value);
  }

  // Getters
  static String? get tenantId => _prefs.getString(_keyTenantId);
  static String? get tenantName => _prefs.getString(_keyTenantName);
  static String? get contextMode => _prefs.getString(_keyContextMode);

  static Future<void> clearAll() async {
    await _prefs.clear();
  }
}
