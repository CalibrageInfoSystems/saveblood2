import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static const String isLogin = 'isLogin';
  static const String isProfileUpdated = 'isprofuileUpdated';
  static const String USER_ID = 'userId';
  static const String bloodGroupID = 'bloodGroupTypeId';
  static const String accessToken = 'accessToken';
  static const String refreshtoken = 'refreshtoken';
  static const String loginName = 'loginname';
  static const String email = 'email';
  static const String lANG = 'lang';
  static const String ISLANGSELECTED = 'islangslected';
  static const String FIREBASE_TOKEN = 'firebasetoken';
  static const String MOBILENUMBER = 'mobilenumber';
  static const String countryCod= 'countryCod';

  Future<bool> getBoolValuesSF(String keyBool) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool(keyBool);
    return boolValue;
  }

  Future<void> addBoolToSF(String keyBool, bool istrue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(keyBool, istrue);

    print(':: SHARED PREF:: isLogin :: ' + prefs.getBool(isLogin).toString());
  }

  Future<void> addStringToSF(String keySting, String inputValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keySting, inputValue);
  }

  Future<String> getStringValueSF(String keyBool) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    String boolValue = prefs.getString(keyBool);
    if (boolValue == null) {
      return '';
    }

    return boolValue;
  }

  static Future<void> setBloodGroupID(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt(bloodGroupID, value);
  }

  static Future<int> getBloodGroupID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt(bloodGroupID) ?? null;
  }

 Future<void> setCountryCode(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
print('===================> Country Code Updating :'+value.toString());
    return prefs.setInt(countryCod, value);
  }

 Future<int> getCountryCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

   
    return prefs.getInt(countryCod) == null ? 0: prefs.getInt(countryCod);
  }
}
