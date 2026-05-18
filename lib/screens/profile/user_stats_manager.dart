import 'package:shared_preferences/shared_preferences.dart';


class UserStatsManager {
  static final UserStatsManager _instance = UserStatsManager._internal();
  factory UserStatsManager() => _instance;
  UserStatsManager._internal();


  static const String _keyTotalOrders = 'user_total_orders';
  static const String _keyTotalPoints = 'user_total_points';
  static const String _keyTotalVouchers = 'user_total_vouchers';


  Future<int> getTotalOrders() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTotalOrders) ?? 0;
  }


  Future<int> getTotalPoints() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTotalPoints) ?? 0;
  }


  Future<int> getTotalVouchers() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTotalVouchers) ?? 0;
  }


  Future<void> addCompletedOrder() async {
    final prefs = await SharedPreferences.getInstance();


    int currentOrders = prefs.getInt(_keyTotalOrders) ?? 0;
    await prefs.setInt(_keyTotalOrders, currentOrders + 1);


    int currentPoints = prefs.getInt(_keyTotalPoints) ?? 0;
    await prefs.setInt(_keyTotalPoints, currentPoints + 5);
  }


  Future<void> addPoints(int points) async {
    final prefs = await SharedPreferences.getInstance();
    int currentPoints = prefs.getInt(_keyTotalPoints) ?? 0;
    await prefs.setInt(_keyTotalPoints, currentPoints + points);
  }


  Future<bool> deductPoints(int points) async {
    final prefs = await SharedPreferences.getInstance();
    int currentPoints = prefs.getInt(_keyTotalPoints) ?? 0;

    if (currentPoints >= points) {
      await prefs.setInt(_keyTotalPoints, currentPoints - points);
      return true;
    }
    return false;
  }

  Future<void> addVoucher() async {
    final prefs = await SharedPreferences.getInstance();
    int currentVouchers = prefs.getInt(_keyTotalVouchers) ?? 0;
    await prefs.setInt(_keyTotalVouchers, currentVouchers + 1);
  }


  Future<bool> useVoucher() async {
    final prefs = await SharedPreferences.getInstance();
    int currentVouchers = prefs.getInt(_keyTotalVouchers) ?? 0;

    if (currentVouchers > 0) {
      await prefs.setInt(_keyTotalVouchers, currentVouchers - 1);
      return true;
    }
    return false;
  }


  Future<void> resetAllStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyTotalOrders);
    await prefs.remove(_keyTotalPoints);
    await prefs.remove(_keyTotalVouchers);
  }


  Future<void> initializeNewUser({
    int orders = 0,
    int points = 0,
    int vouchers = 0,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTotalOrders, orders);
    await prefs.setInt(_keyTotalPoints, points);
    await prefs.setInt(_keyTotalVouchers, vouchers);
  }
}