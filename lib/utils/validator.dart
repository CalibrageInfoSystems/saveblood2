import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_logindemo/localization/app_translations.dart';


class Validator {
 
 static String validateemptyString(BuildContext ctx, String _inputvalue)
 {
   if(_inputvalue.length <1)
   {
     return AppTranslations.of(ctx).text("key_Field_cannot_be_empty");
     
   }else{
return null;
   } 

 }
 static String validateName(BuildContext ctx, String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return AppTranslations.of(ctx).text("key_Field_cannot_be_empty");
    } else if (!regExp.hasMatch(value)) {
      return AppTranslations.of(ctx).text("key_Name_must_be_a-z_and_A-Z");
    }
    return null;
  }

 static String validateMobile(BuildContext ctx, String value) {
   String pattern = r'^(?:(?:\(?(?:00|\+)([1-4]\d\d|[1-9]\d?)\)?)?[\-\.\ \\\/]?)?((?:\(?\d{1,}\)?[\-\.\ \\\/]?){0,})(?:[\-\.\ \\\/]?(?:#|ext\.?|extension|x)[\-\.\ \\\/]?(\d+))?$';
    // String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return AppTranslations.of(ctx).text("key_Mobile_number_isRequired");
    } else if (value.length < 10 || value.length > 15) {
      return AppTranslations.of(ctx).text("key_Mobile_number_must_be_10_or_15_digits");
    } 
    else if (!regExp.hasMatch(value)) {
      return AppTranslations.of(ctx).text("key_Mobile_number_Must_be_Digits");
    }
    return null;
  }

  static String validatePasswordLength(BuildContext ctx, String value) {
    if (value.length == 0) {
      return AppTranslations.of(ctx).text("key_Password_can't_be_Empty");
      
    } else if (value.length < 5) {
      return AppTranslations.of(ctx).text("key_Password_Must_be_Longer_Than_5_Characters");
    }
    return null;
  }
    static String validateconfirmPasswordLength(BuildContext ctx, String value) {
    if (value.length == 0) {
      return AppTranslations.of(ctx).text("key_Confirm_password_can't_be_Empty");
    } else if (value.length < 5) {
      return AppTranslations.of(ctx).text("key_Confirm_password_Must_be_Longer_Than_5_Characters");
    }
    return null;
  }
  static String validatefirstnameLength(BuildContext ctx, String value) {
    if (value.length == 0) {
      return AppTranslations.of(ctx).text("key_Full_Name_Can't_be_Empty");
    } else if (value.length < 3) {
      return AppTranslations.of(ctx).text("key_Full_Name_must_be_Longer_Than_3_Characters");
    }
    return null;
  }

  static String validateusernameLength(BuildContext ctx,String value) {
    if (value.length == 0) {
      //return "Username Can't be Empty";
      return AppTranslations.of(ctx).text("key_enter_username");
    } else if (value.length < 5) {
      return AppTranslations.of(ctx).text("key_Username_must_be_Longer_Than_5_Characters");
    }
    return null;
  }

  static String validateEmail(BuildContext ctx, String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return AppTranslations.of(ctx).text("key_Email_is_Required");
    } else if (!regExp.hasMatch(value)) {
      return AppTranslations.of(ctx).text("key_Invalid_Email"); 
    } else {
      return null;
    }
  }

  static Future<bool> isNetAvailable() async {
    try {
      final result = await  InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
         return true;
      }
    } on SocketException catch (_) {
       return false;
    }
  }


}
