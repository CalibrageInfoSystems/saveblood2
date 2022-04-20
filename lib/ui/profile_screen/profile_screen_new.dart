import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_logindemo/localization/app_translations.dart';
import 'package:flutter_logindemo/ui/models/bloodgroup_model.dart';
import 'package:flutter_logindemo/ui/models/states_model.dart';
import 'package:flutter_logindemo/ui/notification_screen.dart';
import 'package:flutter_logindemo/utils/validator.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../utils/localdata.dart';
import '../constants.dart';
import 'api_data_methods.dart';
import 'userprofile_model.dart';

ProgressDialog progressDialog;

// List<int>heightFeets =[];
class ProfileScreenNew extends StatefulWidget {
  @override
  _ProfileScreenNewState createState() => _ProfileScreenNewState();
}

class _ProfileScreenNewState extends State<ProfileScreenNew> {
  PostUserInfoModel model;
  var selectedHeight3;
  var selectedHeight4;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKeyBasicDetails = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyAddress = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyContact1 = GlobalKey<FormState>();
  UserInfo userinfo;
  bool _autoValidateBasicDetails = false;
  static DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
  // ------------------- FocusNode -------------------------
  final focusMobile = FocusNode();
  final focusEmail = FocusNode();
  final focusnodeDropdown = FocusNode();
  final focusHeight = FocusNode();
  final focusHeight2 = FocusNode();
  final focusWeight = FocusNode();
  final focusAddress1 = FocusNode();
  final focusAddress2 = FocusNode();
  final focusnodeBloodGroup = FocusNode();
  final focusDropDownCountries = FocusNode();
  final focusDropDownStates = FocusNode();
  final focusDropDownDists = FocusNode();
  final focusDropDownMandals = FocusNode();
  final focusDropDownVillage = FocusNode();
  final focusContact1 = FocusNode();
  final focusContactName1 = FocusNode();
  final focusContactRelation = FocusNode();

  final fullnamecontroller = TextEditingController;
//-------------------- Controlser ---------------------------
  var _currencies = ["Male", "Female"];
  var heightFeets = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  var heightInches = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  List<double> heightss = [
    0.01,
    0.02,
    0.03,
    0.04,
    0.05,
    0.06,
    0.07,
    0.08,
    0.09,
    0.10,
    0.11,
    0.12
  ];
  ProfileData profileapi;
  LocalData localData = new LocalData();

  List<BloodGrop> _bloodGroups = new List<BloodGrop>();
  BloodGrop blooddropdownValue;
  List<AddressItemModel> _countrysList = new List<AddressItemModel>();
  AddressItemModel selectedCountry;
  List<AddressItemModel> _statesList = new List<AddressItemModel>();
  AddressItemModel selectedState;
  List<AddressItemModel> _distsList = new List<AddressItemModel>();
  AddressItemModel selecteddist;
  List<AddressItemModel> _mandalsList = new List<AddressItemModel>();
  AddressItemModel selectemandal;
  List<AddressItemModel> _villagesList = new List<AddressItemModel>();
  AddressItemModel selectevillage;
  String _username,
      _mobileNumber,
      _email,
      selectedSalutation,
      _address1,
      _address2,
      _hint,
      _contact1,
      _contactname1,
      _relation1,
      _contact2,
      _contactname2,
      _relation2;
  int _userIDFROMAPI, selectedHeight1, selectedHeight2;
  String _uSERID, _token;
  double finalHeight = 0;
  String fullname, mobilenumber, email;
  bool goforLogin = false;
  int selectedCountryID = 0;
  LocalData pref;
  Map<String, dynamic> profileresponce;
  TextEditingController fullnamecontoler = new TextEditingController();
  TextEditingController mobilenumbercontoler = new TextEditingController();
  TextEditingController emailcontoler = new TextEditingController();

  TextEditingController dobcontoler = new TextEditingController();
  TextEditingController heightcontoler = new TextEditingController();
  TextEditingController height2contoler = new TextEditingController();
  TextEditingController weghtcontoler = new TextEditingController();
  TextEditingController address1contoler = new TextEditingController();
  TextEditingController address2contoler = new TextEditingController();

  TextEditingController contact1Controller = new TextEditingController();
  TextEditingController name1Controller = new TextEditingController();
  TextEditingController relation1Controller = new TextEditingController();

  TextEditingController contact2Controller = new TextEditingController();
  TextEditingController name2Controller = new TextEditingController();
  TextEditingController relation2Controller = new TextEditingController();

  var _isDeceased = false;
  var _isDiabetic = false;
  var _isAlcoholic = false;
  var _ishivpositive = false;
  var _isMajorSurgery = false;

  ProgressDialog pr;

  DateTime _date = new DateTime.now();
  DateTime _userdob;
  String formattedDate = '';
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());
    if (picked != null && picked != _date) {
      DateFormat dateFormat = new DateFormat('yyyy-MM-dd');
      formattedDate = dateFormat.format(picked);
      new DateFormat();
      print('Date selected: ${_date.toString()}');
      setState(() {
        DateFormat dateFormat = new DateFormat('MM/dd/yyyy');
        dobcontoler.text = dateFormat.format(picked);
        _userdob = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    userinfo = new UserInfo();

    pref = new LocalData();
    profileapi = new ProfileData();
    blooddropdownValue = null;
    selectedSalutation = _currencies[0];
    _hint = 'select blood group';
    // _hint = AppTranslations.of(context).text("key_select_blood_group");

    profileapi.getbloodgroups().then((bloodgropslist) {
      // progressDialog.show();
      _bloodGroups = bloodgropslist;

      profileapi.getCountries().then((countriesList) {
        setState(() {
          _countrysList = countriesList;
          progressDialog.hide();
          getUserdata1().then((onValue) {
            print('Data comming from api mahesh');
          });
        });
      });
    });
    selectedState = null;
    //mobilenumbercontoler.text = '7032214460';
    pref.getStringValueSF(LocalData.MOBILENUMBER).then((number) {
      mobilenumbercontoler.text = number;
      print('mobile number -->> ' + number);
    });

    progressDialog = new ProgressDialog(ctx, type: ProgressDialogType.Normal);

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

  Future getUserdata1() async {
    await pref.getStringValueSF(LocalData.USER_ID).then((userid) async {
      print('user id :' + userid);
      _uSERID = userid;
      await pref
          .getStringValueSF(LocalData.accessToken)
          .then((accessTOken) async {
        _token = accessTOken;
        print('Token :' + accessTOken);
        //progressDialog.show();
        await profileapi.getProfileinfo(userid, accessTOken).then((profile) {
          if (null != profile) {
            saveProfileData(profile);
          } else {
            pref
                .getStringValueSF(LocalData.refreshtoken)
                .then((refreshtoken) async {
              if (null != refreshtoken) {
                await profileapi
                    .getRefreshToken(refreshtoken)
                    .then((refreshTOken) async {
                  if (null != refreshTOken) {
                  } else {
                    await profileapi
                        .getProfileinfo(userid, accessTOken)
                        .then((profile) {
                      if (null != profile) {
                        saveProfileData(profile);
                      }
                    });
                  }
                });
              } else {
                pref.addBoolToSF(LocalData.isLogin, false);
                Navigator.of(context).pushReplacementNamed(Constants.SIGN_IN);
                print(
                    "****************************** user need to logout **************************");
              }
            });
          }
        });
      });
    });
  }

  void saveProfileData(Map<String, dynamic> profile) {
    setState(() {
      //progressDialog.dismiss();
      userinfo = UserInfo.fromJson(profile);
      fullnamecontoler.text = userinfo.fullName;
      mobilenumbercontoler.text = userinfo.mobileNumber;
      emailcontoler.text = userinfo.email;

      if (userinfo.dob != null) {
        var format = DateFormat.yMd();
        var dateString = format.format(userinfo.dob);
        _date = userinfo.dob;
        _userdob = userinfo.dob;
        dobcontoler.text = dateString;
      }

      if (userinfo.genderTypeId == 1) {
        selectedSalutation = 'Male';
      } else if (userinfo.genderTypeId == 2) {
        selectedSalutation = 'Female';
      }

      for (int i = 0; i < _bloodGroups.length; i++) {
        if (_bloodGroups[i].typeCdDmtId == userinfo.bloodGroupTypeId) {
          blooddropdownValue = _bloodGroups[i];
          print("Selected Blood Group :" +
              blooddropdownValue.typeCdDmtId.toString());
          LocalData.setBloodGroupID(_bloodGroups[i].typeCdDmtId);
        }
      }
      userinfo.isDiabetic =
          userinfo.isDiabetic == null ? false : userinfo.isDiabetic;
      _isDiabetic = userinfo.isDiabetic;
      userinfo.isAlcohalic =
          userinfo.isAlcohalic == null ? false : userinfo.isAlcohalic;
      _isAlcoholic = userinfo.isAlcohalic;
      userinfo.diseased = userinfo.diseased == null ? false : userinfo.diseased;
      _isDeceased = userinfo.diseased;
      userinfo.hivPositive =
          userinfo.hivPositive == null ? false : userinfo.hivPositive;
      _ishivpositive = userinfo.hivPositive;
      userinfo.isAnyMajorSurgeries = userinfo.isAnyMajorSurgeries == null
          ? false
          : userinfo.isAnyMajorSurgeries;
      _isMajorSurgery = userinfo.isAnyMajorSurgeries;

      // if (userinfo.height != null) {
      //   heightcontoler.text = userinfo.height.toString();
      // }
      if (userinfo.height != null) {
        print('---------------HEIGHTTTT' + userinfo.feet);
        selectedHeight3 = int.parse(userinfo.feet);
      }

      if (userinfo.inch != null) {
        print('---------------INCHHHHHHH' + userinfo.inch);
        selectedHeight4 = int.parse(userinfo.inch);
      }

      if (userinfo.weight != null) {
        weghtcontoler.text = userinfo.weight.toString();
      }

      //dateFormat.format(userinfo.dob);
      // selectedSalutation = userinfo.genderTypeId;
      // blooddropdownValue = userinfo.bloodGroupTypeId;
      // heightcontoler = userinfo.height;
      if (userinfo.address != null) {
        address1contoler.text = userinfo.address.address1;
        address2contoler.text = userinfo.address.address2;
      }

      if (userinfo.emergencyContactId != null) {
        contact1Controller.text = userinfo.emergencyContact.contactNumber;
        name1Controller.text = userinfo.emergencyContact.name;
        relation1Controller.text = userinfo.emergencyContact.relationship;
      }

      if (userinfo.emergencyOptContactId != null) {
        contact2Controller.text = userinfo.emergencyOptContact.contactNumber;
        name2Controller.text = userinfo.emergencyOptContact.name;
        relation2Controller.text = userinfo.emergencyOptContact.relationship;
      }

      // selectedState = _statesList
      //     .firstWhere((item) => item.id == userinfo.address.stateId);
      if (userinfo.address != null) {
        selectedCountry = _countrysList
            .firstWhere((country) => country.id == userinfo.address.countryId);

        if (selectedCountry != null) {
          profileapi.getstates(selectedCountry.id).then((stateslist) {
            setState(() {
              _statesList = stateslist;
              selectedState = _statesList
                  .firstWhere((state) => state.id == userinfo.address.stateId);
              profileapi.getDistsbystateid(selectedState.id).then((dist) {
                _distsList = dist;
                selecteddist = _distsList.firstWhere(
                    (state) => state.id == userinfo.address.districtId);
                profileapi.getMandalsbyDistid(selecteddist.id).then((mandal) {
                  _mandalsList = mandal;
                  selectemandal = _mandalsList.firstWhere(
                      (mandal) => mandal.id == userinfo.address.mandalId);

                  profileapi
                      .getvillaagebyMandalid(selectemandal.id)
                      .then((villages) {
                    _villagesList = villages;
                    selectevillage = _villagesList.firstWhere(
                        (village) => village.id == userinfo.address.villageId);
                  });
                });
              });
            });
          });
        }
      }
      //  name1Controller.text = userinfo.
    });
  }

  BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    if (goforLogin) {
      localData.addBoolToSF(LocalData.isLogin, false);
      Navigator.of(context).pushNamed(Constants.SIGN_IN);
    }
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    pr.style(
      // message: 'Please wait...',
      message: AppTranslations.of(context).text("key_Pleasewait"),
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
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        // title: Text('Profile'),
        title: Text(AppTranslations.of(context).text('key_profile')),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.orange[200], Colors.pinkAccent])),
        ),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.exit_to_app),
        //     onPressed: () {
        //       localData.addBoolToSF(LocalData.isLogin, false);
        //       Navigator.of(context).pushNamed(Constants.SIGN_IN);
        //     },
        //   )
        // ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            _userBasicDetailsForm(),
            Divider(),
            _addressForm(),
            Divider(),
            _contactForm(),
            Divider(),
            _contactForm2(),
            Divider(),
            RaisedButton(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              onPressed: () {
                final form = _formKeyBasicDetails.currentState;
                final formaddress = _formKeyAddress.currentState;
                final formContact = _formKeyContact1.currentState;
                if (form.validate() &&
                    formaddress.validate() &&
                    formContact.validate()) {
                  form.save();
                  if (dobcontoler.text == null) {
                    scaffoldKey.currentState.showSnackBar(new SnackBar(
                      // content: new Text('Please select Date of Birth'),
                      content: new Text(AppTranslations.of(context)
                          .text("key_enter_date_birth")),
                    ));
                  } else if (blooddropdownValue == null) {
                    scaffoldKey.currentState.showSnackBar(new SnackBar(
                      // content: new Text('Please Select Blood Group'),
                      content: new Text(AppTranslations.of(context)
                          .text("key_Please_Select_Blood_Group")),
                    ));
                  } else if (selectedCountry == null) {
                    scaffoldKey.currentState.showSnackBar(new SnackBar(
                      // content: new Text('Please Select State'),
                      content: new Text(AppTranslations.of(context)
                          .text("key_Please_Select_Country")),
                    ));
                  } else if (selectedState == null) {
                    scaffoldKey.currentState.showSnackBar(new SnackBar(
                      // content: new Text('Please Select State'),
                      content: new Text(AppTranslations.of(context)
                          .text("key_Please_Select_State")),
                    ));
                  } else if (selecteddist == null) {
                    scaffoldKey.currentState.showSnackBar(new SnackBar(
                      // content: new Text('Please Select District'),
                      content: new Text(AppTranslations.of(context)
                          .text("key_Please_Select_District")),
                    ));
                  } else if (selectemandal == null) {
                    scaffoldKey.currentState.showSnackBar(new SnackBar(
                      // content: new Text('Please Select Mandal'),
                      content: new Text(AppTranslations.of(context)
                          .text("key_Please_Select_Mandal")),
                    ));
                  } else if (selectevillage == null) {
                    scaffoldKey.currentState.showSnackBar(new SnackBar(
                      // content: new Text('Please Select Village'),
                      content: new Text(AppTranslations.of(context)
                          .text("key_Please_Select_Village")),
                    ));
                  } else if (selectedHeight3 == null || selectedHeight3 == 0) {
                    scaffoldKey.currentState.showSnackBar(new SnackBar(
                      // content: new Text('Please Select Village'),
                      content: new Text(AppTranslations.of(context)
                          .text("key_Please_Select_Height")),
                    ));
                  } else if (selectedHeight4 == null) {
                    scaffoldKey.currentState.showSnackBar(new SnackBar(
                      // content: new Text('Please Select Village'),
                      content: new Text(AppTranslations.of(context)
                          .text("key_Please_Select_Height")),
                    ));
                  } else {
                    setState(() {
                      //   pr.show();

                      PostUserInfoModel model = new PostUserInfoModel();
                      model.id = userinfo.id;
                      model.userId = userinfo.userId;
                      model.fullName = fullnamecontoler.text;
                      model.firstName = userinfo.firstName;
                      model.lastName = userinfo.lastName;
                      model.mobileNumber = mobilenumbercontoler.text;
                      model.email = emailcontoler.text;

                      model.addressId =
                          userinfo.addressId == null ? 0 : userinfo.addressId;
                      if (selectedSalutation == _currencies[0]) {
                        model.genderTypeId = 1;
                      } else {
                        model.genderTypeId = 2;
                      }
                      model.dob = _userdob;
                      model.bloodGroupTypeId = blooddropdownValue.typeCdDmtId;
                      model.height = selectedHeight4 == 0
                          ? finalHeight = selectedHeight3.toDouble() + 0.0
                          : selectedHeight3.toDouble() +
                              heightss[selectedHeight4 - 1];
                      model.weight = double.parse(weghtcontoler.text);
                      model.isDiabetic = userinfo.isDiabetic;
                      model.isAlcohalic = userinfo.isAlcohalic;
                      model.diseased = userinfo.diseased;
                      model.hivPositive = userinfo.hivPositive;
                      model.isAnyMajorSurgeries = userinfo.isAnyMajorSurgeries;
                      model.emergencyContactId = userinfo.emergencyContactId;
                      model.emergencyOptContactId =
                          userinfo.emergencyOptContactId;
                      model.address = new Address(
                          addressId: userinfo.addressId == null
                              ? 0
                              : userinfo.addressId,
                          address1: address1contoler.text,
                          address2: address2contoler.text,
                          landmark: '',
                          countryId: selectedCountry.id,
                          villageId: selectevillage.id,
                          createdBy: userinfo.userId,
                          stateId: selectedState.id,
                          updatedBy: userinfo.userId,
                          createdDate: DateTime.now(),
                          updatedDate: DateTime.now());

                      model.emergencyContact = new EmergencyContact(
                          contactId: userinfo.emergencyContactId == null
                              ? 0
                              : userinfo.emergencyContactId,
                          name: name1Controller.text,
                          contactNumber: contact1Controller.text,
                          relationship: relation1Controller.text,
                          createdBy: userinfo.userId,
                          updatedBy: userinfo.userId,
                          createdDate: DateTime.now(),
                          updatedDate: DateTime.now());

                      model.emergencyOptContact = new EmergencyContact(
                          contactId: userinfo.emergencyOptContactId == null
                              ? 0
                              : userinfo.emergencyOptContactId,
                          name: name2Controller.text,
                          contactNumber: contact2Controller.text,
                          relationship: relation2Controller.text,
                          createdBy: userinfo.userId,
                          updatedBy: userinfo.userId,
                          createdDate: DateTime.now(),
                          updatedDate: DateTime.now());
                      model.createdBy = userinfo.createdBy;
                      model.updatedBy = userinfo.userId;
                      model.createdDate = userinfo.createdDate;
                      model.updatedDate = DateTime.now();
                      localData.setCountryCode(selectedCountry.id);
                      profileapi.postUserData2(_token, model).then((val) {
                        pr.hide();
                        if (val == 200) {
                          if (val != null) {
                            print('Data Posted Success fully ');
                            localData.addBoolToSF(
                                LocalData.isProfileUpdated, true);
                            Navigator.of(context)
                                .pushReplacementNamed(Constants.HOME_SCREEN);
                          } else {
                            scaffoldKey.currentState.showSnackBar(new SnackBar(
                                content:
                                    new Text('Unable to Complete Request')));
                          }
                        } else if (val == 401) {
                          pref
                              .getStringValueSF(LocalData.refreshtoken)
                              .then((_refreshtoken) {
                            if (null != _refreshtoken) {
                              profileapi
                                  .getRefreshToken(_refreshtoken)
                                  .then((_tokendetails) {
                                if (null != _tokendetails) {
                                  profileapi
                                      .postUserData2(_token, model)
                                      .then((profile) {
                                    if (profile == 200) {
                                      if (profile != null) {
                                        print('Data Posted Success fully ');
                                        localData.addBoolToSF(
                                            LocalData.isProfileUpdated, true);
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                Constants.HOME_SCREEN);
                                      } else {
                                        scaffoldKey.currentState.showSnackBar(
                                            new SnackBar(
                                                content: new Text(
                                                    'Unable to Complete Request')));
                                      }
                                    } else if (profile == 401) {
                                      pref.addBoolToSF(
                                          LocalData.isLogin, false);
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              Constants.SIGN_IN);
                                      print(
                                          "****************************** user need to logout **************************");
                                    }
                                  });
                                }
                              });
                            }
                          });
                        } else {
                          print(' Got error');
                        }
                      });
                      //   print('Profile Updated :' + statuscode.toString());
                      //   if (statuscode == 200) {
                      //     localData.addBoolToSF(
                      //         LocalData.isProfileUpdated, true);
                      //     Navigator.of(context)
                      //         .pushReplacementNamed(Constants.HOME_SCREEN);
                      //   }
                      // });
                    });
                  }
                }
              },
              textColor: Colors.white,
              padding: EdgeInsets.all(0.0),
              child: Container(
                alignment: Alignment.center,
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  gradient: LinearGradient(
                    colors: <Color>[Colors.orange[200], Colors.pinkAccent],
                  ),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Text(AppTranslations.of(context).text("key_Update"),
                    style: TextStyle(fontSize: 15)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _userBasicDetailsForm() {
    return Form(
      key: _formKeyBasicDetails,
      autovalidate: _autoValidateBasicDetails,
      child: Column(
        children: <Widget>[
          TextFormField(
            readOnly: true,
            controller: fullnamecontoler,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            decoration: InputDecoration(
                labelText: AppTranslations.of(context).text('key_full_name'),
                border: border),
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(focusMobile);
            },
            validator: (value) => Validator.validateemptyString(context, value),
            onSaved: (val) => _username = val,
          ),
          Divider(),
          TextFormField(
            readOnly: false,
            controller: mobilenumbercontoler,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            maxLength: 15,
            focusNode: focusMobile,
            decoration: InputDecoration(
                labelText:
                    AppTranslations.of(context).text('key_mobile_number'),
                border: border),
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(focusEmail);
            },
            validator: (value) => Validator.validateMobile(context, value),
            onSaved: (val) => _mobileNumber = val,
          ),
          Divider(),
          TextFormField(
            readOnly: true,
            controller: emailcontoler,
            keyboardType: TextInputType.emailAddress,
            focusNode: focusEmail,
            textInputAction: TextInputAction.next,
            // maxLength: 40,
            autofocus: true,
            decoration: InputDecoration(
              // labelText: "Email *",
              labelText: AppTranslations.of(context).text("key_email"),
              border: border,
            ),
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(focusnodeDropdown);
            },
            validator: (value) => Validator.validateEmail(context, value),
            onSaved: (val) => _email = val,
          ),
          Divider(),
          TextFormField(
            controller: dobcontoler,
            keyboardType: TextInputType.datetime,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.characters,
            autofocus: true,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _selectDate(context);
            },
            decoration: InputDecoration(
                labelText: AppTranslations.of(context).text("key_date_birth"),
                border: border),
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(focusMobile);
            },
            validator: (value) => Validator.validateemptyString(context, value),
            onSaved: (val) => _username = val,
          ),
          Divider(),
          _genderdropdown(),
          Divider(),
          _bloodgroupdropdown(),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: <Widget>[
          //     Expanded(
          //       child: _genderdropdown(),
          //     ),
          //     Text(' '),
          //     Expanded(
          //       child: _bloodgroupdropdown(),
          //     )
          //   ],
          // ),
          _disesinfo(),
        ],
      ),
    );
  }

  Widget _bloodgroupdropdown() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            // labelText: "Blood Group *",
            labelText: AppTranslations.of(context).text("key_blood_group"),
            border: border,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<BloodGrop>(
              hint: Text(
                  AppTranslations.of(context).text("key_select_blood_group")),
              // hint: Text(AppTranslations.of(context).text("")),
              focusNode: focusnodeBloodGroup,
              value: blooddropdownValue,
              isDense: true,
              onChanged: (BloodGrop newValue) {
                setState(() {
                  blooddropdownValue = newValue;
                  FocusScope.of(context).requestFocus(focusAddress1);
                });
              },
              items: _bloodGroups.map((BloodGrop value) {
                return DropdownMenuItem<BloodGrop>(
                  value: value,
                  child: Container(
                    child: Text(value.name),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _genderdropdown() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            // labelText: "Gender *",
            labelText: AppTranslations.of(context).text("key_gender"),
            border: border,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              // hint: Text('Please Select '),
              hint: Text(AppTranslations.of(context).text("select_gender")),
              focusNode: focusnodeDropdown,
              value: selectedSalutation,
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  selectedSalutation = newValue;
                  FocusScope.of(context).requestFocus(focusAddress1);
                });
              },
              items: _currencies.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _addressForm() {
    return Form(
      key: _formKeyAddress,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                blurRadius: 5.0,
              ),
            ]),
        child: ExpansionTile(
          // title: Text('Address *'),
          title: Text(AppTranslations.of(context).text("key_address")),
          children: <Widget>[
            Material(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 5.0),
                    TextFormField(
                      controller: address1contoler,
                      keyboardType: TextInputType.text,
                      focusNode: focusAddress1,
                      // initialValue: _address1,
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      decoration: InputDecoration(
                        // labelText: "Address 1 *",
                        labelText:
                            AppTranslations.of(context).text("key_address1"),
                        border: border,
                      ),
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focusAddress2);
                      },
                      validator: (value) =>
                          Validator.validateemptyString(context, value),
                      onSaved: (val) => _address1 = val,
                    ),
                    Divider(),
                    TextFormField(
                      controller: address2contoler,
                      // initialValue: _address2,
                      keyboardType: TextInputType.text,
                      focusNode: focusAddress2,
                      textInputAction: TextInputAction.done,
                      autofocus: true,
                      decoration: InputDecoration(
                        // labelText: "Address 2 (Optional)",
                        labelText:
                            AppTranslations.of(context).text("key_address2"),
                        border: border,
                      ),
                      onFieldSubmitted: (v) {
                        FocusScope.of(context)
                            .requestFocus(focusDropDownStates);
                      },
                      onSaved: (val) => _address2 = val,
                    ),
                    Divider(),
                    _countryropdown(),
                    Divider(),
                    Row(
                      children: <Widget>[
                        Expanded(
                          // flex: 3,
                          child: _statesropdown(),
                        ),
                        Text(' '),
                        Expanded(
                          // flex: 3,
                          child: _distsropdown(),
                        ),
                      ],
                    ),
                    Divider(),
                    Column(
                      children: <Widget>[
                        _mandaldropdown(),
                        Divider(),
                        _villagedopdown(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _disesinfo() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: CheckboxListTile(
                value: _isDeceased,
                onChanged: (bool newValue) {
                  setState(() {
                    _isDeceased = newValue;
                    print('is_Diseased cheked -->>');
                    print(_isDeceased);
                    userinfo.diseased = _isDeceased;
                  });
                },
                // title: Text('Is Deceased'),
                title:
                    Text(AppTranslations.of(context).text("key_is_diseased")),
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                value: _isDiabetic,

                onChanged: (bool newValue) {
                  setState(() {
                    _isDiabetic = newValue;
                    userinfo.isDiabetic = _isDiabetic;
                    print('is_diabetic cheked -->>');
                    print(_isDiabetic);
                  });
                },
                // title: Text('Is Diabetic'),
                title:
                    Text(AppTranslations.of(context).text("key_is_diabetic")),
              ),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: CheckboxListTile(
                value: _isAlcoholic,
                onChanged: (bool newValue) {
                  setState(() {
                    _isAlcoholic = newValue;
                    userinfo.isAlcohalic = _isAlcoholic;
                    print('is_alcoholic cheked -->>');
                    print(_isAlcoholic);
                  });
                },
                // title: Text('Is Alcoholic'),
                title:
                    Text(AppTranslations.of(context).text("key_is_alcoholic")),
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                value: _ishivpositive,
                onChanged: (bool newValue) {
                  setState(() {
                    _ishivpositive = newValue;
                    userinfo.hivPositive = _ishivpositive;
                    print('is_positive cheked -->>');
                    print(_ishivpositive);
                  });
                },
                // title: Text('HIV Positive'),
                title:
                    Text(AppTranslations.of(context).text("key_hiv_positive")),
              ),
            )
          ],
        ),
        CheckboxListTile(
          value: _isMajorSurgery,
          onChanged: (bool newValue) {
            setState(() {
              _isMajorSurgery = newValue;
              userinfo.isAnyMajorSurgeries = _isMajorSurgery;
              print('is_any_major_Surgery cheked -->>');
              print(_isMajorSurgery);
            });
          },
          // title: Text('Is Any Major Surgeries in last 1 year'),

          title:
              Text(AppTranslations.of(context).text("key_any_major_Surgery")),
        ),
        Row(
          children: <Widget>[
            // Expanded(
            // child: TextFormField(
            //   controller: heightcontoler,
            //   keyboardType: TextInputType.number,
            //   focusNode: focusHeight,
            //   textInputAction: TextInputAction.next,
            //   // maxLength: 3,
            //   autofocus: true,
            //   decoration: InputDecoration(
            //       // labelText: "Height ", height2contoler
            //       labelText: AppTranslations.of(context).text("key_height"),
            //       border: border,
            //       suffixText: 'ft'),

            //   onFieldSubmitted: (v) {
            //     FocusScope.of(context).requestFocus(focusHeight2);
            //   },
            //   validator: (value) =>
            //       Validator.validateemptyString(context, value),
            //   onSaved: (val) => _email = val,
            // ),
            Expanded(
              child: FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: AppTranslations.of(context).text("key_height"),
                      border: border,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        hint: Text("Feet"),
                        focusNode: focusHeight,
                        value: selectedHeight3,
                        isDense: true,
                        items: heightFeets.map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        onChanged: (int changedValue) {
                          setState(() {
                            selectedHeight3 = changedValue;
                            FocusScope.of(context).requestFocus(focusHeight2);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            //       ),
            Text(' '),
            Expanded(
              // //   // child: TextFormField(
              // //   //   controller: height2contoler,
              // //   //   keyboardType: TextInputType.number,
              // //   //   focusNode: focusHeight2,
              // //   //   textInputAction: TextInputAction.next,
              // //   //   // maxLength: 3,
              // //   //   autofocus: true,
              // //   //   decoration: InputDecoration(
              // //   //       // labelText: "Height ",
              // //   //       labelText: AppTranslations.of(context).text("key_height"),
              // //   //       border: border,
              // //   //       suffixText: 'in'),
              // //   //   onFieldSubmitted: (v) {
              // //   //     FocusScope.of(context).requestFocus(focusWeight);
              // //   //   },
              // //   //   validator: (value) =>
              // //   //       Validator.validateemptyString(context, value),
              // //   //   onSaved: (val) => _email = val,
              // //   // ),
              child: FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: AppTranslations.of(context).text("key_height"),
                      border: border,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        hint: Text("Inch"),
                        focusNode: focusHeight2,
                        value: selectedHeight4,
                        isDense: true,
                        items: heightInches.map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        onChanged: (int newValue) {
                          setState(() {
                            selectedHeight4 = newValue;
                            print("--- >>+++++++++++++++++FEET " +
                                heightss[selectedHeight4].toString());
                            selectedHeight4 == 0
                                ? finalHeight = selectedHeight3.toDouble() + 0.0
                                : finalHeight = selectedHeight3.toDouble() +
                                    heightss[selectedHeight4 - 1];
                            //  selectedHeight1 = selectedHeight1
                            FocusScope.of(context).requestFocus(focusWeight);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            Text(' '),
            Expanded(
              child: TextFormField(
                controller: weghtcontoler,
                keyboardType: TextInputType.number,
                focusNode: focusWeight,
                textInputAction: TextInputAction.next,
                // maxLength: 3,
                autofocus: true,
                decoration: InputDecoration(
                    // labelText: "Weight ",
                    labelText: AppTranslations.of(context).text("key_weight"),
                    border: border,
                    suffixText: 'kgs'),

                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focusnodeDropdown);
                },
                validator: (value) =>
                    Validator.validateemptyString(context, value),
                onSaved: (val) => _email = val,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _countryropdown() {
    return FormField<String>(
      builder: (FormFieldState<String> country) {
        return InputDecorator(
          decoration: InputDecoration(
            // labelText: "State *",
            labelText: AppTranslations.of(context).text("key_country"),
            border: border,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<AddressItemModel>(
              // hint: Text('Please Select State'),
              hint: Text(
                AppTranslations.of(context).text("key_Please_Select_Country"),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              focusNode: focusDropDownCountries,
              value: selectedCountry,
              style: TextStyle(fontSize: 13, color: Colors.black),
              isDense: true,
              onChanged: (AddressItemModel newValue) {
                selectedState = null;
                selecteddist = null;
                selectemandal = null;
                selectevillage = null;

                setState(() {
                  selectedCountry = newValue;
                  _statesList.clear();
                  _distsList.clear();
                  _mandalsList.clear();
                  _villagesList.clear();
                  FocusScope.of(context).requestFocus(focusDropDownStates);
                });
                profileapi.getstates(newValue.id).then((stateslist) {
                  setState(() {
                    // _statesList.clear();
                    _statesList = stateslist;
                    progressDialog.hide();

                    print('-------------  Calling USER API infi');
                    // getUserdata();
                  });
                });
              },
              items: _countrysList.map((AddressItemModel value) {
                return DropdownMenuItem<AddressItemModel>(
                  value: value,
                  child: Container(
                    child: Text(
                      value.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _statesropdown() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            // labelText: "State *",
            labelText: AppTranslations.of(context).text("key_state"),
            border: border,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<AddressItemModel>(
              // hint: Text('Please Select State'),
              hint: Text(
                AppTranslations.of(context).text("key_Please_Select_State"),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              focusNode: focusDropDownStates,
              value: selectedState != null ? selectedState : null,
              style: TextStyle(fontSize: 13, color: Colors.black),
              isDense: true,
              onChanged: (AddressItemModel newValue) {
                selecteddist = null;
                selectemandal = null;
                selectevillage = null;
                setState(() {
                  selectedState = newValue;
                  FocusScope.of(context).requestFocus(focusDropDownDists);
                });
                profileapi.getDistsbystateid(newValue.id).then((dist) {
                  setState(() {
                    _distsList = dist;
                  });
                });
              },
              items: _statesList.map((AddressItemModel value) {
                return DropdownMenuItem<AddressItemModel>(
                  value: value,
                  child: Container(
                    child: Text(
                      value.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _distsropdown() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            // labelText: "District *",
            labelText: AppTranslations.of(context).text("key_district"),
            labelStyle: TextStyle(fontSize: 12),
            border: border,
          ),
          child: DropdownButton<AddressItemModel>(
            style: TextStyle(fontSize: 13, color: Colors.black),
            // hint: Text('Please Select '),
            hint: Text(
              AppTranslations.of(context).text("key_Please_Select_District"),
              style: TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            focusNode: focusDropDownDists,
            value: selecteddist != null ? selecteddist : null,
            isDense: true,
            onChanged: (AddressItemModel newValue) {
              selectemandal = null;
              selectevillage = null;
              setState(() {
                selecteddist = newValue;
                FocusScope.of(context).requestFocus(focusDropDownMandals);
              });
              profileapi.getMandalsbyDistid(selecteddist.id).then((mandals) {
                setState(() {
                  _mandalsList = mandals;
                });
              });
            },
            items: _distsList.map((AddressItemModel value) {
              return DropdownMenuItem<AddressItemModel>(
                value: value,
                child: Text(
                  value.name,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _mandaldropdown() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            // labelText: "Mandal *",
            labelText: AppTranslations.of(context).text("key_mandal"),
            border: border,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<AddressItemModel>(
              // hint: Text('Please Select '),
              hint: Text(
                  AppTranslations.of(context).text("key_Please_Select_Mandal")),
              focusNode: focusDropDownMandals,
              value: selectemandal,
              isDense: true,
              onChanged: (AddressItemModel newValue) {
                selectevillage = null;
                setState(() {
                  selectemandal = newValue;
                  FocusScope.of(context).requestFocus(focusDropDownVillage);
                });

                profileapi.getvillaagebyMandalid(newValue.id).then((villages) {
                  setState(() {
                    _villagesList = villages;
                  });
                });
              },
              items: _mandalsList.map((AddressItemModel value) {
                return DropdownMenuItem<AddressItemModel>(
                  value: value,
                  child: Container(
                    child: Text(value.name),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _villagedopdown() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            // labelText: "Village *",
            labelText: AppTranslations.of(context).text("key_village"),
            border: border,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<AddressItemModel>(
              // hint: Text('Please Select '),
              hint: Text(AppTranslations.of(context)
                  .text("key_Please_Select_Village")),
              focusNode: focusDropDownVillage,
              value: selectevillage,
              isDense: true,
              onChanged: (AddressItemModel newValue) {
                setState(() {
                  selectevillage = newValue;
                  FocusScope.of(context).requestFocus(focusContact1);
                });
              },
              items: _villagesList.map((AddressItemModel value) {
                return DropdownMenuItem<AddressItemModel>(
                  value: value,
                  child: Container(
                    child: Text(value.name),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _contactForm() {
    return Form(
        key: _formKeyContact1,
        autovalidate: _autoValidateBasicDetails,
        child: Column(children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    blurRadius: 5.0,
                  ),
                ]),
            child: ExpansionTile(
              initiallyExpanded: true,

              // title: Text('Emergency Contact 1 *'),
              title: Text(
                  AppTranslations.of(context).text("key_enter_contact_name1")),
              children: <Widget>[
                Material(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 5.0),
                        TextFormField(
                          controller: contact1Controller,
                          initialValue: _contact1,
                          focusNode: focusContact1,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          maxLength: 15,
                          autofocus: true,
                          decoration: InputDecoration(
                              // labelText: "Contact Number ",
                              labelText: AppTranslations.of(context)
                                  .text("key_contact_number"),
                              border: border),
                          onFieldSubmitted: (v) {
                            FocusScope.of(context)
                                .requestFocus(focusContactName1);
                          },
                          validator: (value) =>
                              Validator.validateMobile(context, value),
                          onSaved: (val) => _contact1 = val,
                        ),
                        SizedBox(height: 5.0),
                        TextFormField(
                          controller: name1Controller,
                          initialValue: _contactname2,
                          focusNode: focusContactName1,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          maxLength: 40,
                          autofocus: true,
                          decoration: InputDecoration(
                              // labelText: "Name ",
                              labelText: AppTranslations.of(context)
                                  .text("key_enter_contact_name"),
                              border: border),
                          onFieldSubmitted: (v) {
                            FocusScope.of(context)
                                .requestFocus(focusContactRelation);
                          },
                          validator: (value) =>
                              Validator.validateName(context, value),
                          onSaved: (val) => _contactname1 = val,
                        ),
                        SizedBox(height: 5.0),
                        TextFormField(
                          controller: relation1Controller,
                          initialValue: _relation1,
                          focusNode: focusContactRelation,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          maxLength: 15,
                          autofocus: true,
                          decoration: InputDecoration(
                              // labelText: "Relation ",
                              labelText: AppTranslations.of(context)
                                  .text("key_relation1"),
                              border: border),
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focusMobile);
                          },
                          validator: (value) =>
                              Validator.validateName(context, value),
                          onSaved: (val) => _relation1 = val,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ]));
  }

  Widget _contactForm2() {
    return Form(
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    blurRadius: 5.0,
                  ),
                ]),
            child: ExpansionTile(
              // title: Text('Emergency Contact 2 (Optional)'),
              title: Text(
                  AppTranslations.of(context).text("key_enter_contact_name2")),
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 5.0),
                      TextFormField(
                        controller: contact2Controller,
                        initialValue: _contact2,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        maxLength: 15,
                        autofocus: true,
                        decoration: InputDecoration(
                            // labelText: "Contact Number",
                            labelText: AppTranslations.of(context)
                                .text("key_contact_number2"),
                            border: border),
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focusMobile);
                        },
                        validator: (value) =>
                            Validator.validateMobile(context, value),
                        onSaved: (val) => _contact2 = val,
                      ),
                      SizedBox(height: 5.0),
                      TextFormField(
                        controller: name2Controller,
                        initialValue: _contactname2,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        maxLength: 40,
                        autofocus: true,
                        decoration: InputDecoration(
                            // labelText: "Name ",
                            labelText: AppTranslations.of(context)
                                .text("key_Emergency_contact_name"),
                            border: border),
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focusMobile);
                        },
                        validator: (value) =>
                            Validator.validateMobile(context, value),
                        onSaved: (val) => _contactname2 = val,
                      ),
                      SizedBox(height: 5.0),
                      TextFormField(
                        controller: relation2Controller,
                        initialValue: _relation2,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        maxLength: 15,
                        autofocus: true,
                        decoration: InputDecoration(
                            // labelText: "Relation ",
                            labelText: AppTranslations.of(context)
                                .text("key_relation2"),
                            border: border),
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focusMobile);
                        },
                        validator: (value) =>
                            Validator.validateMobile(context, value),
                        onSaved: (val) => _relation2 = val,
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }

  var border = OutlineInputBorder(
    borderRadius: new BorderRadius.circular(10.0),
    borderSide: new BorderSide(),
  );
}
// class Address {
//     int addressId;
//     String address1;
//     String address2;
//     String landmark;
//     int countryId;
//     int villageId;
//     String createdBy;
//     String updatedBy;
//     DateTime updatedDate;
//     DateTime createdDate;

//     Address({
//         this.addressId,
//         this.address1,
//         this.address2,
//         this.landmark,
//         this.countryId,
//         this.villageId,
//         this.createdBy,
//         this.updatedBy,
//         this.updatedDate,
//         this.createdDate,
//     });

//     factory Address.fromJson(Map<String, dynamic> json) => Address(
//         addressId: json["addressId"],
//         address1: json["address1"],
//         address2: json["address2"],
//         landmark: json["landmark"],
//         countryId: json["countryId"],
//         villageId: json["villageId"],
//         createdBy: json["createdBy"],
//         updatedBy: json["updatedBy"],
//         updatedDate: DateTime.parse(json["updatedDate"]),
//         createdDate: DateTime.parse(json["createdDate"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "addressId": addressId,
//         "address1": address1,
//         "address2": address2,
//         "landmark": landmark,
//         "countryId": countryId,
//         "villageId": villageId,
//         "createdBy": createdBy,
//         "updatedBy": updatedBy,
//         "updatedDate": updatedDate.toIso8601String(),
//         "createdDate": createdDate.toIso8601String(),
//     };
// }

PostUserInfoModel postUserInfoModelFromJson(String str) =>
    PostUserInfoModel.fromJson(json.decode(str));

String postUserInfoModelToJson(PostUserInfoModel data) =>
    json.encode(data.toJson());

class PostUserInfoModel {
  int id;
  String userId;
  String fullName;
  dynamic firstName;
  dynamic lastName;
  String mobileNumber;
  String email;
  int addressId;
  int genderTypeId;
  DateTime dob;
  int bloodGroupTypeId;
  double height;
  double weight;
  bool isDiabetic;
  bool isAlcohalic;
  bool diseased;
  bool hivPositive;
  bool isAnyMajorSurgeries;
  int emergencyContactId;
  int emergencyOptContactId;
  Address address;
  EmergencyContact emergencyContact;
  EmergencyContact emergencyOptContact;
  String createdBy;
  String updatedBy;
  DateTime updatedDate;
  DateTime createdDate;

  PostUserInfoModel({
    this.id,
    this.userId,
    this.fullName,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.email,
    this.addressId,
    this.genderTypeId,
    this.dob,
    this.bloodGroupTypeId,
    this.height,
    this.weight,
    this.isDiabetic,
    this.isAlcohalic,
    this.diseased,
    this.hivPositive,
    this.isAnyMajorSurgeries,
    this.emergencyContactId,
    this.emergencyOptContactId,
    this.address,
    this.emergencyContact,
    this.emergencyOptContact,
    this.createdBy,
    this.updatedBy,
    this.updatedDate,
    this.createdDate,
  });

  factory PostUserInfoModel.fromJson(Map<String, dynamic> json) =>
      PostUserInfoModel(
        id: json["id"],
        userId: json["userId"],
        fullName: json["fullName"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        mobileNumber: json["mobileNumber"],
        email: json["email"],
        addressId: json["addressId"],
        genderTypeId: json["genderTypeId"],
        dob: DateTime.parse(json["dob"]),
        bloodGroupTypeId: json["bloodGroupTypeId"],
        height: json["height"],
        weight: json["weight"],
        isDiabetic: json["isDiabetic"],
        isAlcohalic: json["isAlcohalic"],
        diseased: json["diseased"],
        hivPositive: json["hivPositive"],
        isAnyMajorSurgeries: json["isAnyMajorSurgeries"],
        emergencyContactId: json["emergencyContactId"],
        emergencyOptContactId: json["emergencyOptContactId"],
        address: Address.fromJson(json["address"]),
        emergencyContact: EmergencyContact.fromJson(json["emergencyContact"]),
        emergencyOptContact:
            EmergencyContact.fromJson(json["emergencyOptContact"]),
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        updatedDate: DateTime.parse(json["updatedDate"]),
        createdDate: DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "fullName": fullName,
        "firstName": firstName,
        "lastName": lastName,
        "mobileNumber": mobileNumber,
        "email": email,
        "addressId": addressId,
        "genderTypeId": genderTypeId,
        "dob": dob.toIso8601String(),
        "bloodGroupTypeId": bloodGroupTypeId,
        "height": height,
        "weight": weight,
        "isDiabetic": isDiabetic,
        "isAlcohalic": isAlcohalic,
        "diseased": diseased,
        "hivPositive": hivPositive,
        "isAnyMajorSurgeries": isAnyMajorSurgeries,
        "emergencyContactId": emergencyContactId,
        "emergencyOptContactId": emergencyOptContactId,
        "address": address.toJson(),
        "emergencyContact": emergencyContact.toJson(),
        "emergencyOptContact": emergencyOptContact.toJson(),
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "updatedDate": updatedDate.toIso8601String(),
        "createdDate": createdDate.toIso8601String(),
      };
}

class Address {
  int addressId;
  String address1;
  String address2;
  String landmark;
  int countryId;
  int stateId;
  int villageId;
  String createdBy;
  String updatedBy;
  DateTime updatedDate;
  DateTime createdDate;

  Address({
    this.addressId,
    this.address1,
    this.address2,
    this.landmark,
    this.countryId,
    this.stateId,
    this.villageId,
    this.createdBy,
    this.updatedBy,
    this.updatedDate,
    this.createdDate,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        addressId: json["addressId"],
        address1: json["address1"],
        address2: json["address2"],
        landmark: json["landmark"],
        countryId: json["countryId"],
        stateId: json["stateId"],
        villageId: json["villageId"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        updatedDate: DateTime.parse(json["updatedDate"]),
        createdDate: DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toJson() => {
        "addressId": addressId,
        "address1": address1,
        "address2": address2,
        "landmark": landmark,
        "countryId": countryId,
        "stateId": stateId,
        "villageId": villageId,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "updatedDate": updatedDate.toIso8601String(),
        "createdDate": createdDate.toIso8601String(),
      };
}

class EmergencyContact {
  int contactId;
  String name;
  String contactNumber;
  String relationship;
  String createdBy;
  String updatedBy;
  DateTime updatedDate;
  DateTime createdDate;

  EmergencyContact({
    this.contactId,
    this.name,
    this.contactNumber,
    this.relationship,
    this.createdBy,
    this.updatedBy,
    this.updatedDate,
    this.createdDate,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) =>
      EmergencyContact(
        contactId: json["contactId"],
        name: json["name"],
        contactNumber: json["contactNumber"],
        relationship: json["relationship"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        updatedDate: DateTime.parse(json["updatedDate"]),
        createdDate: DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toJson() => {
        "contactId": contactId,
        "name": name,
        "contactNumber": contactNumber,
        "relationship": relationship,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "updatedDate": updatedDate.toIso8601String(),
        "createdDate": createdDate.toIso8601String(),
      };
}
