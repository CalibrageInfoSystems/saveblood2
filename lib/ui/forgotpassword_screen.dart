import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_logindemo/localization/app_translations.dart';
import 'package:flutter_logindemo/utils/validator.dart';
import 'package:http/http.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'api_config.dart';
import 'constants.dart';
import 'widgets/custom_shape.dart';
import 'widgets/customappbar.dart';
import 'widgets/responsive_ui.dart';
import 'widgets/textformfield.dart';

class ForGotpasswordScreen extends StatefulWidget {
  @override
  _ForGotpasswordScreenState createState() => _ForGotpasswordScreenState();
}

class _ForGotpasswordScreenState extends State<ForGotpasswordScreen> {
  BuildContext ctx;

  double _height;

  double _width;

  double _pixelRatio;

  bool _large;

  bool _medium;

  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> _key = GlobalKey();

  TextEditingController emailControler = new TextEditingController();

  ProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    ctx = context;
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
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Scaffold(
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Opacity(opacity: 0.88, child: CustomAppBar()),
              clipShape(),
              form(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget form(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 15.0),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            welcomeTextRow(),
            signInTextRow(),
            SizedBox(height: _height / 40.0),
            emailTextFormField(),
            SizedBox(height: _height / 40.0),
            button(context),
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
              height: _large
                  ? _height / 8
                  : (_medium ? _height / 7 : _height / 6.5),
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
                  : (_medium ? _height / 11 : _height / 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: _height / 5.5,
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

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
      child: Row(
        children: <Widget>[
          Text(
            AppTranslations.of(ctx).text("key_forgot_password"),
            //"Forgot Password",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20.0),
      child: Row(
        children: <Widget>[
          Text(
            AppTranslations.of(ctx).text("key_recovery_email"),
            //"Please enter Email or Username ",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: _large ? 18 : (_medium ? 16 : 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      textEditingController: emailControler,
      keyboardType: TextInputType.emailAddress,
      icon: Icons.email,
      hint: //"Email (or) Username",
          AppTranslations.of(ctx).text("key_recovery_email"),
    );
  }

  Widget button(BuildContext context) {
    return Material(
      child: RaisedButton(
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        onPressed: () async {
          if (emailControler.text.isEmpty) {
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
              AppTranslations.of(ctx).text("key_recovery_email"),
              //'Please Enter Username (OR) Email'
            )));
          } else {
            await Validator.isNetAvailable().then((isnet) {
              if (!isnet) {
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                  AppTranslations.of(ctx)
                      .text("key_error_msg_no_internet_connection"),
                  //'Please Check Your Network connection'
                )));
              } else {
                makePostRequest(context);
              }
            });
          }
        },
        textColor: Colors.white,
        padding: EdgeInsets.all(0.0),
        child: Container(
          alignment: Alignment.center,
          //        height: _height / 20,
          width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            gradient: LinearGradient(
              colors: <Color>[Colors.orange[200], Colors.pinkAccent],
            ),
          ),
          padding: const EdgeInsets.all(12.0),
          child: Text(
            AppTranslations.of(context).text("key_Submit"),
            style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
        ),
      ),
    );
  }

  Future makePostRequest(BuildContext context) async {
    progressDialog.show();

    final uri = baseUrl + recoverPasswordComponentUrl;
    print('API :' + uri);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {'usernameOrEmail': emailControler.text};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    print('Request :' + jsonBody);
    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    progressDialog.hide();

    print('Responce -->> :' + responseBody);
    if (statusCode == 200) {
      // Map<String, dynamic> parsedMAP = json.decode(responseBody);

      passwordController.text = "";
      _showDialog(AppTranslations.of(ctx).text("key_Please_Check_Your_Email"));
      // Scaffold.of(context).showSnackBar(
      //     SnackBar(content: Text(AppTranslations.of(ctx).text("key_Please_Check_Your_Email"),
      //       //'Please Check Your Email'
      //       )));

    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
        AppTranslations.of(ctx).text("key_Invalid"),
        //'Invalid User'
      )));
    }
    progressDialog.hide();

    // user defined function
  }

  void _showDialog(String msg) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Save Blood"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(Constants.SIGN_IN);
              },
            ),
          ],
        );
      },
    );
  }
}
