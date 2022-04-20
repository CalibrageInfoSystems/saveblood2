import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_logindemo/localization/app_translations.dart';
import 'package:flutter_logindemo/ui/constants.dart';
import 'package:flutter_logindemo/utils/localdata.dart';
import 'package:flutter_logindemo/utils/validator.dart';

import 'package:http/http.dart';
import '../ui/widgets/custom_shape.dart';
import '../ui/widgets/responsive_ui.dart';
import '../ui/widgets/textformfield.dart';

import 'package:progress_dialog/progress_dialog.dart';
import '../ui/api_config.dart';
import 'widgets/customappbar.dart';

//by narmada
import 'package:flutter/services.dart';

ProgressDialog pr;
LocalData localData;

class SignupScreenNew extends StatelessWidget {
  static const rootname = 'SignInPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  GlobalKey<FormState> _key = GlobalKey();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController confirmPassWordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //textController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    localData = new LocalData();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    pr.style(
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
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Opacity(opacity: 0.88, child: CustomAppBar()),
            clipShape(),
            form(),
            // acceptTermsTextRow(),
            SizedBox(
              height: _height / 35,
            ),
            signupButton(),
            signUpTextRow(),

            //signInTextRow(),
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
//        Positioned(
//          top: _height/8,
//          left: _width/1.75,
//          child: Container(
//            alignment: Alignment.center,
//            height: _height/23,
//            padding: EdgeInsets.all(5),
//            decoration: BoxDecoration(
//              shape: BoxShape.circle,
//              color:  Colors.orange[100],
//            ),
//            child: GestureDetector(
//                onTap: (){
//                  print('Adding photo');
//                },
//                child: Icon(Icons.add_a_photo, size: _large? 22: (_medium? 15: 13),)),
//          ),
//        ),
      ],
    );
  }

  Widget infoTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            //"Or create using social media",
            AppTranslations.of(context).text("key_social_media"),
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child: Form(
        child: Column(
          children: <Widget>[
            registrationField(),
            SizedBox(height: _height / 60.0),
            firstNameTextFormField(),
            SizedBox(height: _height / 60.0),
            lastNameTextFormField(),
            SizedBox(height: _height / 60.0),
            phoneTextFormField(),
            SizedBox(height: _height / 60.0),
            emailTextFormField(),
            SizedBox(height: _height / 60.0),
            passwordTextFormField(),
            SizedBox(height: _height / 60.0),
            confirmpasswordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget registrationField() {
    return Container(
      margin: EdgeInsets.only(left: 5),
      child: Row(
        children: <Widget>[
          Text(
            AppTranslations.of(context).text("key_Registration"),
            //"Registration",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget firstNameTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: firstNameController,
      icon: Icons.person,
      hint: AppTranslations.of(context).text("key_full_name"),
      //"Full Name *",
    );
  }

  Widget lastNameTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: userNameController,
      icon: Icons.person,
      hint: AppTranslations.of(context).text("key_Username"),
      //"Username *",
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      onTap: () {
        print('--->> Email ontap');
      },

      keyboardType: TextInputType.emailAddress,
      textEditingController: emailController,

      icon: Icons.email,
      hint: AppTranslations.of(context).text("key_email"),
      //"Email *",
    );
  }

  Widget phoneTextFormField() {
    return CustomTextField(
      maxLength: 15,
      keyboardType:
          TextInputType.numberWithOptions(signed: true, decimal: false),
      textEditingController: contactNumberController,
      icon: Icons.phone,
      hint: AppTranslations.of(context).text("key_mobile_number"),

      //"Mobile number *",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      obscureText: true,
      textEditingController: passWordController,
      icon: Icons.lock,
      hint: AppTranslations.of(context).text("key_password"),
      // "Password *",
    );
  }

  Widget confirmpasswordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: confirmPassWordController,
      obscureText: true,
      icon: Icons.lock,
      hint: AppTranslations.of(context).text("key_confirm_pwd"),
      //"Confirm password *",
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              activeColor: Colors.orange[200],
              value: checkBoxValue,
              onChanged: (bool newValue) {
                setState(() {
                  checkBoxValue = newValue;
                });
              }),
          Text(
            AppTranslations.of(context).text("key_terms_conditions"),
            //"I accept all terms and conditions",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget signupButton() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () async {
        bool isNetworkavailable = await Validator.isNetAvailable();
        if (isNetworkavailable) {
          if (validateData()) {
            print('--- analysis ----- signup validation completed ');
            makeSignupPostRequest();
          }
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
            AppTranslations.of(context)
                .text("key_error_msg_no_internet_connection"),
            //'Please Check Your Internet Connection'
          )));
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
          AppTranslations.of(context).text("key_sign_up"),
          //'SIGN UP',
          style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
        ),
      ),
    );
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 120.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            AppTranslations.of(context).text("key_Alredy_Account"),
            //"Already have an account!",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(Constants.SIGN_IN);
              print("Routing to Sign up screen");
            },
            child: Text(
              AppTranslations.of(context).text("Key_sign_in"),
              // "Sign in",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.orange[200],
                  fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  bool validateData() {
    if (Validator.validatefirstnameLength(
            context, firstNameController.value.text) !=
        null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(Validator.validatefirstnameLength(
              context, firstNameController.value.text))));
      return false;
    } else if (Validator.validateusernameLength(
            context, userNameController.value.text) !=
        null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(Validator.validateusernameLength(
              context, userNameController.value.text))));
      return false;
    } else if (Validator.validateMobile(
            context, contactNumberController.value.text) !=
        null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(Validator.validateMobile(
              context, contactNumberController.value.text))));
      return false;
    } else if (Validator.validateEmail(context, emailController.value.text) !=
        null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
              Validator.validateEmail(context, emailController.value.text))));
      return false;
    } else if (Validator.validatePasswordLength(
            context, passWordController.value.text) !=
        null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(Validator.validatePasswordLength(
              context, passWordController.value.text))));
      return false;
    } else if (Validator.validateconfirmPasswordLength(
            context, confirmPassWordController.value.text) !=
        null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(Validator.validateconfirmPasswordLength(
              context, confirmPassWordController.value.text))));

      return false;
    } else if (passWordController.value.text !=
        confirmPassWordController.value.text) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
        AppTranslations.of(context)
            .text("key_Password_And_Confirm_Password_Must_Match"),
        //'Password And Confirm Password Must Match'
      )));
      return false;
    } else {
      return true;
    }
  }

  Future<Void> makeSignupPostRequest() async {
    pr.show();

    final uri = baseUrl + signUpComponentUrl;
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      'newPassword': passWordController.value.text,
      'id': null,
      'userName': userNameController.value.text,
      'fullName': userNameController.value.text,
      'email': emailController.value.text,
      'phoneNumber': contactNumberController.value.text,
      'configuration': null,
      'isEnabled': true
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    print('Request body -->> :' + jsonBody);

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    Map<String, dynamic> parsedMAP = json.decode(responseBody);

    var _list = parsedMAP.values.toList();
    print('RES :' + responseBody);

    print('List -->>  :' + _list.toString());

    if (parsedMAP['statusCode'] == 200) {
      print('status code 200');
      pr.hide();
      bool isLockedOut = parsedMAP['isLockedOut'];
      _showDialog(AppTranslations.of(context)
          .text("key_Please_confirm_your_registerd_email_to_login"));

      print('Login Responce value:' + isLockedOut.toString());
    } else {
      pr.hide();
      print('status code not 200');
      List result = parsedMAP['result'];

      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(result[0].toString())));
    }
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
              child: new Text("Ok"),
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
