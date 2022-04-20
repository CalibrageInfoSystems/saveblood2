import 'package:flutter/material.dart';
import 'package:flutter_logindemo/localization/app_translations.dart';
import 'package:flutter_logindemo/localization/app_translations_delegate.dart';
import 'package:flutter_logindemo/localization/application.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../utils/localdata.dart';
import 'constants.dart';
import 'dart:async';

Timer _timer;
ProgressDialog progressDialog;

class LanguageSelectonScreen extends StatelessWidget {
  static const rootname = "LanguageSelectonScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LanguageSelectonScreens(),
    );
  }
}

class LanguageSelectonScreens extends StatefulWidget {
  @override
  _LanguageSelectorPageState createState() => _LanguageSelectorPageState();
}

class _LanguageSelectorPageState extends State<LanguageSelectonScreens> {
  LocalData pref;
  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
    languagesList[2]: languageCodesList[2],
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pref = LocalData();
    pref.addBoolToSF(LocalData.ISLANGSELECTED, false);

    progressDialog =
        new ProgressDialog(context, type: ProgressDialogType.Normal);

    progressDialog.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.black54,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInCubic,
      progressTextStyle: TextStyle(
          color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w600),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(bottom: 5),
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              englishButton(),
              SizedBox(height: 10),
              teluguButton(),
              SizedBox(height: 10),
              hindiButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget englishButton() {
    return RaisedButton(
        elevation: 2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        onPressed: () async {
          setState(() {
            onLocaleChange(Locale(languagesMap["English"]));
            print(
                '------Language screen analysis --------- selected language is -->> English');
            //pref.addStringToSF(LocalData.lANG, 'en');
          });
        },
        textColor: Colors.white,
        padding: EdgeInsets.all(0.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            gradient: LinearGradient(
              colors: <Color>[Colors.orange[200], Colors.pinkAccent],
            ),
          ),
          padding: const EdgeInsets.all(12.0),
          child: Text(
            AppTranslations.of(context).text("key_English"),
          ),
        ));
  }

  Widget teluguButton() {
    return RaisedButton(
        elevation: 2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        onPressed: () async {
          setState(() {
            onLocaleChange(Locale(languagesMap["Telugu"]));
            print(
                '------Language screenh screen analysis --------- selected language is -->> Telugu');
            //pref.addStringToSF(LocalData.lANG, 'tu');
          });
        },
        textColor: Colors.white,
        padding: EdgeInsets.all(0.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            gradient: LinearGradient(
              colors: <Color>[Colors.orange[200], Colors.pinkAccent],
            ),
          ),
          padding: const EdgeInsets.all(12.0),
          child: Text(
            AppTranslations.of(context).text("key_Telugu"),
          ),
        ));
  }

  Widget hindiButton() {
    return RaisedButton(
        elevation: 2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        onPressed: () async {
          setState(() {
            onLocaleChange(Locale(languagesMap["Hindi"]));
            print(
                '------Language screen analysis --------- selected language is -->> Hindi');
            //pref.addStringToSF(LocalData.lANG, 'hi');
          });
        },
        textColor: Colors.white,
        padding: EdgeInsets.all(0.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            gradient: LinearGradient(
              colors: <Color>[Colors.orange[200], Colors.pinkAccent],
            ),
          ),
          padding: const EdgeInsets.all(12.0),
          child: Text(
            AppTranslations.of(context).text("key_Hindi"),
          ),
        ));
  }

  void onLocaleChange(Locale locale) async {
    setState(() {
      savelangchanges(locale);
    });
  }

  void savelangchanges(Locale locale) {
    print('Language selected :' + locale.languageCode);
    pref.addStringToSF(LocalData.lANG, locale.languageCode);
    // pref.addBoolToSF(LocalData.ISLANGSELECTED, true);
    AppTranslations.load(locale);
    progressDialog.show();
    Future.delayed(const Duration(seconds: 3)).then((newscreen) {
      progressDialog.hide();
      Navigator.of(context).pushReplacementNamed(Constants.SIGN_IN);
    });
  }
}
