import '../Constants/exports.dart';

class SharedPrefs {
  static final c = Get.put(MyController());
  static Future<void> loginSave(
      {required String email, required String password}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('email', email);
    preferences.setString('pass', password);
  }

  static Future<bool> autoLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('email') && 
        preferences.getString('email') != null && 
        preferences.getString('email')!.isNotEmpty) {
      String mail = preferences.getString('email')!;
      String password = preferences.getString('pass')!;
      c.authEmail.value = mail;
      c.authPass.value = password;
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    
    // First clear all shared preferences
    await preferences.clear();
    
    // Explicitly remove guest mode setting
    await preferences.setBool('is_guest_mode', false);
    
    // Reset essential controller values
    c.selectedIndex.value = 0;
    c.isSubscribed.value = false;
    c.isEmailVerified.value = false;
    c.isPhoneVerified.value = false;
    c.isGuestMode.value = false;
    
    // Reset any additional controller values that might be persisted
    c.authEmail.value = '';
    c.authPass.value = '';
    
    // Navigate to login screen
    Get.offAll(() => LoginScreen(), transition: Transition.leftToRightWithFade);
  }

  //get user data from shared preferences
  static Future<void> getUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    c.isSubscribed.value = preferences.getBool('is_subscribed') ?? false;
    c.isEmailVerified.value = preferences.getBool('is_email_verified') ?? false;
    c.isPhoneVerified.value = preferences.getBool('is_phone_verified') ?? false;
    
    // Load user ID into controller
    final userId = preferences.getInt('user_id');
    if (userId != null && userId > 0) {
      MyController.id = userId;
      print("Loaded user ID from preferences: $userId");
    } else {
      print("No valid user ID found in preferences. Current MyController.id: ${MyController.id}");
    }
  }

  static Future<void> saveFcmToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('fcm_token', token);
  }

  static Future<String?> getFcmToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('fcm_token');
  }
}
