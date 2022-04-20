import 'package:flutter/material.dart';
import 'package:flutter_logindemo/localization/app_translations.dart';
import 'package:flutter_logindemo/localization/application.dart';
import 'package:flutter_logindemo/ui/signin.dart';
import 'package:flutter_logindemo/ui/widgets/gradient_appbar.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../../utils/localdata.dart';

import '../constants.dart';
import 'custom_shape.dart';
import 'responsive_ui.dart';
import 'dart:io' show Platform;

ProgressDialog progressDialog;

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
    languagesList[2]: languageCodesList[2],
  };

  String label = languagesList[0];

  double _height;

  double _width;

  double _pixelRatio;

  bool _large;

  bool _medium;

  String _username, _email;
  LocalData pref = new LocalData();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pref.getStringValueSF(LocalData.loginName).then((name) {
      setState(() {
        _username = name;
      });
    });
    pref.getStringValueSF(LocalData.email).then((name) {
      setState(() {
        _email = name;
      });
    });
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
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: _height / 10.0),
                Image.asset(
                  'assets/images/app_logo.png',
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: _height / 40.0),
                Text(_username == null
                    ? 'user email not available '
                    : _username),
                Divider(),
                Text(_email == null ? 'user name not available ' : _email),
                Divider(),
              ],
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(
                AppTranslations.of(context).text("key_home"),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(Constants.HOME_SCREEN);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                AppTranslations.of(context).text("key_profile_name"),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(Constants.PROFILE_SCREEN_NEW);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text(
                AppTranslations.of(context).text("key_Notifications"),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(Constants.NOTIFICATIONS_SCREEN);
                // Navigator.of(context)
                //     .pushReplacementNamed(OrdersScreen.routeName);
                // Navigator.of(context).pushReplacement(
                //   CustomRoute(
                //     builder: (ctx) => OrdersScreen(),
                //   ),
                // );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text(
                AppTranslations.of(context).text("key_Language"),
              ),
              onTap: () {
                // Navigator.pop(context);
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (BuildContext bc) {
                      return Container(
                        child: new Wrap(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      onLocaleChange(
                                          Locale(languagesMap["English"]));
                                    });
                                  },
                                  child: Container(
                                    width: 300,
                                    child: Card(
                                        elevation: 5,
                                        child: Center(
                                            child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            'English',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ))),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      onLocaleChange(
                                          Locale(languagesMap["Telugu"]));
                                    });
                                  },
                                  child: Container(
                                    width: 300,
                                    child: Card(
                                        elevation: 5,
                                        child: Center(
                                            child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            'Telugu',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ))),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      onLocaleChange(
                                          Locale(languagesMap["Hindi"]));
                                    });
                                  },
                                  child: Container(
                                    width: 300,
                                    child: Card(
                                        elevation: 5,
                                        child: Center(
                                            child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            'Hindi',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ))),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 300,
                                    child: Card(
                                        elevation: 5,
                                        child: Center(
                                            child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.red),
                                          ),
                                        ))),
                                  ),
                                ),
                              ],
                            ),
                            // new ListTile(
                            //   //leading: new Icon(Icons.music_note),
                            //   title: new Text('English'),
                            //   onTap: () async {
                            //     // setState(() {
                            //     onLocaleChange(Locale(languagesMap["English"]));

                            //     // });
                            //   },
                            // ),
                            // new ListTile(
                            //   //leading: new Icon(Icons.videocam),
                            //   title: new Text('Telugu'),
                            //   onTap: () async {
                            //     // setState(() {
                            //     onLocaleChange(Locale(languagesMap["Telugu"]));

                            //     // });
                            //   },
                            // ),
                            // new ListTile(
                            //   // leading: new Icon(Icons.videocam),
                            //   title: new Text('Hindi'),

                            //   onTap: () async {
                            //     // setState(() {
                            //     onLocaleChange(Locale(languagesMap["Hindi"]));

                            //     // });
                            //   },
                            // ),
                            // new ListTile(
                            //   //leading: new Icon(Icons.videocam),
                            //   title: new Text(
                            //     'Cancel',
                            //     style: TextStyle(color: Colors.red),
                            //   ),
                            //   onTap: () => {Navigator.pop(context)},
                            // ),
                          ],
                        ),
                      );
                    });

                //MapsLauncher.launchCoordinates( 37.4220041, -122.0862462, 'Google Headquarters are here');
                //      setState(() {
                //    PopupMenuButton(
                //     child: Text("Show Popup Menu"),
                //     itemBuilder: (context) => [
                //           PopupMenuItem(
                //             child: englishButton(),
                //              //Text("English"),
                //           ),
                //           PopupMenuItem(
                //             child: teluguButton(),
                //             //Text("Telugu"),
                //           ),
                //           PopupMenuItem(
                //             child: hindiButton(),
                //             //Text("Hindi"),
                //           ),
                //         ],
                //   );

                // });
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.insert_drive_file),
              title: Text(
                AppTranslations.of(context).text("key_Certificates"),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(Constants.CERTIFCATES_SCREEN);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(
                AppTranslations.of(context).text("key_Logout"),
              ),
              onTap: () {
                // Navigator.of(context).pop();
                // Navigator.of(context).pushReplacementNamed(SIGN_IN);
                pref.addBoolToSF(LocalData.isLogin, false);
                Navigator.of(context).pushReplacementNamed(Constants.SIGN_IN);

                // Provider.of<Auth>(context, listen: false).logout();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.share),
              title: Text(AppTranslations.of(context).text("key_share")),
              onTap: () async {
                if (Platform.isAndroid) {
                  await FlutterShare.share(
                      title: 'Apk File Path for Android',
                      text: 'saveblood',
                      linkUrl: 'http://saveblood.org/',
                      chooserTitle: 'Please Select');
                } else if (Platform.isIOS) {
                  await FlutterShare.share(
                      title: 'ipa file for IOS',
                      text: 'saveblood',
                      linkUrl: 'http://saveblood.org/',
                      chooserTitle: 'Please Select');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              // height: _large
              //     ? _height / 8
              //     : (_medium ? _height / 7 : _height / 6.5),
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 12
                  : (_medium ? _height / 11 : _height / 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: _height / 6.5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  spreadRadius: 0.0,
                  color: Colors.black26,
                  offset: Offset(1.0, 10.0),
                  blurRadius: 20.0),
            ],
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
              onTap: () {
                print('Adding photo');
              },
              child: Image.asset(
                'assets/images/app_logo.png',
              )),
        ),
      ],
    );
  }

  Widget englishButton() {
    return RaisedButton(
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        onPressed: () async {
          //setState(() {
          //onLocaleChange(Locale(languagesMap["English"]));
          AppTranslations.load(languagesMap["English"]);

          //pref.addStringToSF(LocalData.lANG, 'en');
          //  });
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
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        onPressed: () async {
          // setState(() {
          //onLocaleChange(Locale(languagesMap["Telugu"]));
          AppTranslations.load(languagesMap["Telugu"]);
          //pref.addStringToSF(LocalData.lANG, 'tu');
          // });
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
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        onPressed: () async {
          // setState(() {
          // onLocaleChange(Locale(languagesMap["Hindi"]));
          AppTranslations.load(languagesMap["Hindi"]);
          //pref.addStringToSF(LocalData.lANG, 'hi');
          // });
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

  void onLocaleChange(Locale locale) {
    setState(() {
      //AppTranslations.load(locale);
      // for (int i = 0; i < 2; i++) {
      //   savelangchanges(locale);
      //    new Future.delayed(const Duration(seconds: 5));

      // }
      savelangchanges(locale);
      //Navigator.of(context).pushReplacementNamed(Constants.HOME_SCREEN);
    });
  }

  void savelangchanges(Locale locale) {
    print('Language selected :' + locale.languageCode);
    pref.addStringToSF(LocalData.lANG, locale.languageCode);
    // pref.addBoolToSF(LocalData.ISLANGSELECTED, true);
    AppTranslations.load(locale);

    // Navigator.pop(context);
    progressDialog.show();
    Future.delayed(const Duration(seconds: 3)).then((newscreen) {
      progressDialog.hide();
      Navigator.of(context).pushReplacementNamed(Constants.HOME_SCREEN);
    });
    // Navigator.of(context).pushReplacementNamed(Constants.HOME_SCREEN);
  }
}
