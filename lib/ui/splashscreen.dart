import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logindemo/localization/app_translations_delegate.dart';
import 'package:flutter_logindemo/localization/application.dart';
import 'package:flutter_logindemo/ui/constants.dart';
import '../utils/localdata.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_logindemo/localization/app_translations.dart';
import 'package:flutter_logindemo/localization/application.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

LocalData pref = new LocalData();
String langid='';

class SplashScreen extends StatefulWidget {
  static const rootname = 'SplashScreen';
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AppTranslationsDelegate _newLocaleDelegate;

  
  var _visible = true;
  //bool isLogin = LocalData.getBoolValuesSF(LocalData.isLogin);
  LocalData localData = new LocalData();
  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
   
    var data = await localData.getBoolValuesSF(LocalData.isLogin);
    var islangSelected =
        await localData.getBoolValuesSF(LocalData.ISLANGSELECTED);
    var profileupdated =
        await localData.getBoolValuesSF(LocalData.isProfileUpdated);

    print('is User Login :' + data.toString());
    print('is User profile Updated :' + profileupdated.toString());

    if (data == true) {
      if (profileupdated != true) {
        Navigator.of(context)
            .pushReplacementNamed(Constants.PROFILE_SCREEN_NEW);
      } else {
        Navigator.of(context).pushReplacementNamed(Constants.HOME_SCREEN);
      }
    } else {
      if (islangSelected == true) {
        localData.addBoolToSF(LocalData.isProfileUpdated, false);
        Navigator.of(context).pushReplacementNamed(Constants.SIGN_IN);
      } else {
        localData.addBoolToSF(LocalData.isProfileUpdated, false);
        Navigator.of(context)
            .pushReplacementNamed(Constants.LANGUAGE_SELECTION_SCREEN);
      }
    }

    // if (data != null || data == true ) {
    //    if(profileupdated != null  || profileupdated== true)
    //    {

    //   Navigator.of(context).pushReplacementNamed(Constants.HOME_SCREEN);
    //    }else{

    //   Navigator.of(context).pushReplacementNamed(Constants.PROFILE_SCREEN_NEW);
    //    }

    // } else {

    //   Navigator.of(context).pushReplacementNamed(Constants.SIGN_IN);
    // }
  }

  @override
  void initState() {
    super.initState();
    pref = LocalData();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation = new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();

    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;

       
    pref.getStringValueSF(LocalData.lANG).then((val) {
      setState(() {
        print('-----Splash scren analysis --------- selected lang id :' + val);
        langid = val;
      });
    });

                 localizationsDelegates: [
                    _newLocaleDelegate,
                    //provides localised strings
                    GlobalMaterialLocalizations.delegate,
                    //provides RTL support
                    GlobalWidgetsLocalizations.delegate,
                  ];

                  supportedLocales: [
                     Locale('en', ""),
                     // Locale(langid, ""),
                     //Locale("hi", ""),
                  ];

                  if (langid == ''){

                    onLocaleChange(Locale('en'));
                    print('-----Splash scren Loading app with --------- English Language');

                  }
                  else{

                    onLocaleChange(Locale(langid));
                    print('-----Splash scren Loading app with ---------' + langid);

                  }
                  

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  //child:new Image.asset('assets/images/app_logo.png',height: 25.0,fit: BoxFit.scaleDown,))

                  child: new Text('http://saveblood.org/',
                      style: TextStyle(color: Colors.redAccent))),
            ],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/images/app_logo.png',
                width: animation.value * 250,
                height: animation.value * 250,
              ),
            ],
          ),
        ],
      ),
    );

    
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      AppTranslations.load(locale);
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }
}
