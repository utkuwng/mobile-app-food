import 'package:shared_preferences/shared_preferences.dart';

class UserService {

  static const String _keyFullName = 'user_full_name';
  static const String _keyEmail = 'user_email';
  static const String _keyPhone = 'user_phone';
  static const String _keyAddress = 'user_address';
  static const String _keyIsLoggedIn = 'user_is_logged_in';


  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();


  SharedPreferences? _prefs;


  Future<void> init() async {

    _prefs ??= await SharedPreferences.getInstance();
  }


  Future<bool> isEmailRegistered(String email) async {
    await init();
    final allKeys = _prefs!.getKeys();
    for (String key in allKeys) {
        if (key.endsWith('_email') && _prefs!.getString(key) == email) {
            return true;
        }
    }
    return false;
  }


  Future<bool> saveUserData({
    required String fullName,
    required String email,
    String? phone,
    String? address,
  }) async {
    await init();


    if (await isEmailRegistered(email)) {
      print('Email đã tồn tại: $email');
      return false;
    }

    try {

      await _prefs!.setString(_keyFullName, fullName);
      await _prefs!.setString(_keyEmail, email);

      if (phone != null) await _prefs!.setString(_keyPhone, phone);
      if (address != null) await _prefs!.setString(_keyAddress, address);

      await _prefs!.setBool(_keyIsLoggedIn, true);
      return true;
    } catch (e) {

      print('Lỗi khi lưu dữ liệu: $e');
      return false;
    }
  }


  Future<bool> updateUserData({
    String? fullName,
    String? email,
    String? phone,
    String? address,
  }) async {
    await init();
    try {

      if (fullName != null) await _prefs!.setString(_keyFullName, fullName);
      if (email != null) await _prefs!.setString(_keyEmail, email);
      if (phone != null) await _prefs!.setString(_keyPhone, phone);
      if (address != null) await _prefs!.setString(_keyAddress, address);
      return true;
    } catch (e) {
      print('Lỗi khi cập nhật dữ liệu: $e');
      return false;
    }
  }


  Future<bool> login(String email) async {
    await init();
    try {

      await _prefs!.setString(_keyEmail, email);

      await _prefs!.setBool(_keyIsLoggedIn, true);
      return true;
    } catch (e) {
      print('Lỗi khi đăng nhập: $e');
      return false;
    }
  }


  Future<bool> logout() async {
    await init();
    try {

      await _prefs!.setBool(_keyIsLoggedIn, false);
      return true;
    } catch (e) {
      print('Lỗi khi đăng xuất: $e');
      return false;
    }
  }


  Future<Map<String, String?>> getUserData() async {
    await init();

    return {
      'fullName': _prefs!.getString(_keyFullName),
      'email': _prefs!.getString(_keyEmail),
      'phone': _prefs!.getString(_keyPhone),
      'address': _prefs!.getString(_keyAddress),
    };
  }


  Future<String?> getFullName() async {
    await init();
    return _prefs!.getString(_keyFullName);
  }


  Future<String?> getEmail() async {
    await init();
    return _prefs!.getString(_keyEmail);
  }

  Future<String?> getPhone() async {
    await init();
    return _prefs!.getString(_keyPhone);
  }

  Future<String?> getAddress() async {
    await init();
    return _prefs!.getString(_keyAddress);
  }

  Future<bool> isLoggedIn() async {
    await init();
    return _prefs!.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<bool> clearAllData() async {
    await init();
    try {

      await _prefs!.clear();
      return true;
    } catch (e) {
      print('Lỗi khi xóa dữ liệu: $e');
      return false;
    }
  }
}
