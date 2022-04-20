import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_logindemo/ui/constants.dart';
import 'package:flutter_logindemo/ui/home_screen.dart';
import 'package:flutter_logindemo/ui/languageSelectionScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_logindemo/ui/signup_screen.dart';

import './ui/signin.dart';
import './ui/notification_screen.dart';

import './ui/splashscreen.dart';
import 'ui/certificates/certificates_info_screen.dart';
import 'ui/constants.dart';
import 'ui/forgotpassword_screen.dart';
import 'ui/notification_screen.dart';

import 'ui/profile_screen/profile_screen_new.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization/app_translations_delegate.dart';
import 'localization/application.dart';
import 'ui/languageSelectionScreen.dart';
import 'utils/localdata.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final GlobalKey<NavigatorState> navigatorKey =
  //     GlobalKey<NavigatorState>(debugLabel: "navigator");

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  AppTranslationsDelegate _newLocaleDelegate;
  LocalData pref = new LocalData();
  var splash_screen = Constants.SPLASH_SCREEN;
//LocalData pref ;
  String langid = 'en';

  @override
  void initState() {
    super.initState();

    pref = LocalData();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;

    langid = 'es';

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);

    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print(' ---- on message in main ${message}');

        // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
        splash_screen = Constants.NOTIFICATIONS_SCREEN;
        displayNotification(message);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationScreen()),
        );

        // _showItemDialog(message);
      },
      onResume: (Map<String, dynamic> message) {
        print(' ---- on resume in main  $message');
        splash_screen = Constants.NOTIFICATIONS_SCREEN;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationScreen()),
        );
      },
      onLaunch: (Map<String, dynamic> message) {
        print(' ---- on launch $message');
        splash_screen = Constants.NOTIFICATIONS_SCREEN;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationScreen()),
        );
        Fluttertoast.showToast(
            msg: "Notification Clicked",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      pref.addStringToSF(LocalData.FIREBASE_TOKEN, token);
      print('----->> Device token in main --- ' + token);
    });
  }

  Future displayNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channelid', 'flutterfcm', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: 'hello',
    );

    //  Navigator.push(
    //       context,
    //       new MaterialPageRoute(builder: (context) => new NotificationScreen()),
    //     );

    // Navigator.push(navigatorKey.currentContext, MaterialPageRoute(builder: (_) => NotificationScreen()));
  }

  Future onSelectNotification(String payload) async {
    // await Navigator.push(navigatorKey.currentContext,
    //   MaterialPageRoute(builder: (context) => NotificationScreen()));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationScreen()),
    );
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    // await Fluttertoast.showToast(
    //     msg: "Notification Clicked mahesh1",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIos: 1,
    //     backgroundColor: Colors.black54,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
  }

  Future myBackgroundMessageHandler(Map<String, dynamic> message) async {
    print("_backgroundMessageHandler");
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      print("_backgroundMessageHandler data: ${data}");
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print("_backgroundMessageHandler notification: ${notification}");
      //Fimber.d("=====>myBackgroundMessageHandler $message");
    }
    return Future<void>.value();
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Fluttertoast.showToast(
                  msg: "Notification Clicked",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('-----main analysis --------- selected lang id :' + langid);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: "Login",
      theme: ThemeData(
          primarySwatch: Colors.red,
          accentColor: Colors.redAccent,
          fontFamily: 'Hind'),
      routes: <String, WidgetBuilder>{
        Constants.SPLASH_SCREEN: (BuildContext context) => SplashScreen(),
        Constants.SIGN_IN: (BuildContext context) => SignInPage(),
        Constants.PROFILE_SCREEN_NEW: (BuildContext context) =>
            ProfileScreenNew(),
        Constants.FORGOTPASSWORD: (BuildContext context) =>
            ForGotpasswordScreen(),

        // Constants.PROFILE_screen :(BuildContext context) => UserProfileView(),
        // Constants.EDIT_PROFILE : (BuildContext context) => UserProfileScreen(),
        // Constants.SIGN_UP: (BuildContext context) =>  SignUpScreen(),
        Constants.SIGN_UP: (BuildContext context) => SignupScreenNew(),
        Constants.HOME_SCREEN: (BuildContext context) => HomeScreen(),
        Constants.NOTIFICATIONS_SCREEN: (BuildContext context) =>
            NotificationScreen(),
        Constants.CERTIFCATES_SCREEN: (BuildContext context) =>
            CertificatesScreen(), //ImageFullscreen
        Constants.LANGUAGE_SELECTION_SCREEN: (BuildContext context) =>
            LanguageSelectonScreen(),
      },
      initialRoute: splash_screen,
      localizationsDelegates: [
        _newLocaleDelegate,
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ""),
        Locale("tu", ""),
        Locale("hi", "")

        //Locale("hi", ""),
      ],
    );
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }
}
