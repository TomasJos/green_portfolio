import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _storage = const FlutterSecureStorage();

  static const String _credentialsKey = 'user_credentials';
  static const String _isLoggedInKey = 'is_logged_in';

  /// Saves user credentials securely
  Future<void> saveCredentials(String username, String email, String password) async {
    final credentials = {
      'username': username,
      'email': email,
      'password': password,
    };
    await _storage.write(key: _credentialsKey, value: jsonEncode(credentials));
    await setLoggedIn(true);
  }

  /// Retrieves stored credentials
  Future<Map<String, dynamic>?> getCredentials() async {
    final credentialsStr = await _storage.read(key: _credentialsKey);
    if (credentialsStr != null) {
      return jsonDecode(credentialsStr);
    }
    return null;
  }

  /// Checks if any credentials exist
  Future<bool> hasCredentials() async {
    return await _storage.read(key: _credentialsKey) != null;
  }

  /// Sets the logged-in state
  Future<void> setLoggedIn(bool isLoggedIn) async {
    await _storage.write(key: _isLoggedInKey, value: isLoggedIn.toString());
  }

  /// Checks if the user is currently logged in
  Future<bool> isLoggedIn() async {
    final loggedInStr = await _storage.read(key: _isLoggedInKey);
    return loggedInStr == 'true';
  }

  /// Verifies login credentials against stored ones
  Future<bool> verifyLogin(String username, String password) async {
    final credentials = await getCredentials();
    if (credentials != null) {
      if (credentials['username'] == username && credentials['password'] == password) {
        await setLoggedIn(true);
        return true;
      }
    }
    return false;
  }

  /// Clears the logged-in state (Logout)
  /// Note: We might want to keep the credentials so the user can easily log back in,
  /// or clear them completely depending on requirements.
  /// Here we just clear the logged-in state. To clear all, use `_storage.deleteAll()`.
  Future<void> logout() async {
    await setLoggedIn(false);
  }
}
