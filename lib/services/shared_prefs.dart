import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class SharedPrefs {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> completeOnboarding() async {
    await init();
    await _prefs!.setBool(PrefKeys.kOnboardingCompletedKey, true);
  }

  static Future<bool> isOnboardingCompleted() async {
    await init();
    return _prefs!.getBool(PrefKeys.kOnboardingCompletedKey) ?? false;
  }

  static Future<void> login(String token) async {
    await init();
    await _prefs!.setBool(PrefKeys.kIsLoggedInKey, true);
    await _prefs!.setString(PrefKeys.kUserTokenKey, token);
  }

  static Future<bool> isLoggedIn() async {
    await init();
    return _prefs!.getBool(PrefKeys.kIsLoggedInKey) ?? false;
  }
static Future<void> logout() async {
  await init();
  await _prefs!.setBool(PrefKeys.kIsLoggedInKey, false);
}


  static Future<void> saveFavorites(String data) async {
    await _prefs?.setString('favorites', data);
  }

  static Future<String?> getFavorites() async {
    return _prefs?.getString('favorites');
  }

  static Future<String?> getUserToken() async {
    await init();
    return _prefs!.getString(PrefKeys.kUserTokenKey);
  }
}
