import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class DataRepository {
  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  // Save profile data
  Future<void> saveData(String firstName, String lastName, String phone, String email) async {
    await _prefs.setString('firstName', firstName);
    await _prefs.setString('lastName', lastName);
    await _prefs.setString('phone', phone);
    await _prefs.setString('email', email);
  }

  // Load profile data
  Future<Map<String, String>> loadData() async {
    return {
      'firstName': await _prefs.getString('firstName') ?? '',
      'lastName': await _prefs.getString('lastName') ?? '',
      'phone': await _prefs.getString('phone') ?? '',
      'email': await _prefs.getString('email') ?? '',
    };
  }

  // Save login data
  Future<void> saveLoginData(String loginName, String password) async {
    await _prefs.setString('loginName', loginName);
    await _prefs.setString('password', password);
  }

  // Load login data
  Future<Map<String, String>> loadLoginData() async {
    return {
      'loginName': await _prefs.getString('loginName') ?? '',
      'password': await _prefs.getString('password') ?? '',
    };
  }

  // Clear login data
  Future<void> clearLoginData() async {
    await _prefs.clear();
  }
}
