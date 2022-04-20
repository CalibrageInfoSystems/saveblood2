import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_logindemo/localization/app_translations.dart';
import 'package:flutter_logindemo/ui/events/events_info_screen.dart';
import 'package:flutter_logindemo/ui/notification_screen.dart';
import 'package:flutter_logindemo/ui/profile_screen/api_data_methods.dart';
import 'package:flutter_logindemo/ui/profile_screen/userprofile_model.dart';
import 'package:flutter_logindemo/utils/localdata.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../ui/widgets/app_drawer.dart';
import 'api_config.dart';
import 'constants.dart';
import 'home/city_info_model.dart';
import 'widgets/custom_shape.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:location/location.dart' as locationPackage;
import 'home/home_screen_data.dart';

ProgressDialog progressDialog;
UserInfo userAddress;
int usercountryid = 0;
//const kGoogleApiKey = "AIzaSyB1pNgh-6U5Pm0Ggmz_UBlGwT7pKrg2dfA"; // Old
const kGoogleApiKey = "AIzaSyCxkV7tf2tbTqthQglVDWaO6T0bq0iaavo"; // New

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class HomeScreen extends StatefulWidget {
  static const rootname = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position currentPosition;
  String currentAddress;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  locationPackage.Location _locationService = new locationPackage.Location();
  TextEditingController locationControl = new TextEditingController();
  TextEditingController donateController = new TextEditingController();
  TextEditingController commentsController = new TextEditingController();
  FocusNode donateFocus = FocusNode();
  FocusNode commentsFocus = FocusNode();

  bool _permission = false;
  var _datamsg = "";
  final Distance distance = new Distance();
  var _blodbanks = [];
  Geolocator geolocator = Geolocator();
  Position userLocation;
  LocalData pref;
  ProfileData profileapi;
  double latitude;
  double longitude;

  String _saveduserID, comments, datetime;
  int _destinationID, _bgTypeID, _bgTypeId, _entityID;

  var _typeAheadController;

  DateTime _date = new DateTime.now();
  DateTime _donateDate;
  String formattedDate = '';

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        firstDate: new DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        lastDate: new DateTime(3019));
    if (picked != null && picked != _date) {
      DateFormat dateFormat = new DateFormat('yyyy-MM-dd');
      formattedDate = dateFormat.format(picked);
      new DateFormat();
      print('Date selected: ${_date.toString()}');
      setState(() {
        DateFormat dateFormat = new DateFormat('MM/dd/yyyy');
        donateController.text = dateFormat.format(picked);
        _donateDate = picked;
      });
    }
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
  }

  Future<CityinfoModel> getLocationsInfo(String query) async {
    CityinfoModel userinfo = new CityinfoModel();

    Response res = await get(
      baseUrl + getGeolocationsGeoPlaces + query,
    );

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      var responce = json.decode(responseBody);
      userinfo = CityinfoModel.fromJson(responce);
      print('::: getLocationsInfo :::: Success : 200');

      return userinfo;
    } else {
      return userinfo;
    }
  }

  fetchCurrentLocation(String _userid) async {
    await _locationService.changeSettings(
        accuracy: locationPackage.LocationAccuracy.HIGH, interval: 1000);

    locationPackage.LocationData location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print("-------------Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = (await (_locationService.requestPermission())) as bool;

        print("---------------Permission: $_permission");

        if (_permission) {
          location = await _locationService.getLocation().then((location) {
            if (location != null) {
              pref.getCountryCode().then((code) {
                makePostRequest(location.latitude, location.longitude, code);
              });
              latitude = location.latitude;
              longitude = location.longitude;
              // _getAddressFromLatLng(_userid);
            }
          });

          // print("Location: ${location.latitude}");

        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          fetchCurrentLocation(_userid);
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        //error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        //error = e.message;
      }
      location = null;
    }
  }

  _getCurrentLocation(String _userid) {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      pref.getCountryCode().then((code) {
        makePostRequest(position.latitude, position.longitude, code);
      });
      setState(() {
        // String _currentAddress;
        currentPosition = position;
        newgetAddressFromLatLng(_userid);
      });
    }).catchError((e) {
      print(e);
    });
  }

  newgetAddressFromLatLng(String _userid) async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";

        print(" currentAddress ->  " + currentAddress);

        print(currentPosition.latitude);
        print(currentPosition.longitude);
        _getAddressFromLatLng(_userid);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<Void> makePostRequest(double lat, double long, int countryid) async {
    //progressDialog.show();
    final uri = baseUrl + getlocalBloodbanksBylatlong;
    print('--------- API --- : ' + uri);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "latitude": lat,
      "longitude": long,
      "countryId": countryid
    };
    String jsonBody = json.encode(body);
    print('--------- send lat lang country code Request : --- : ' + jsonBody);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    print('--------- responseBody : --- : ' + responseBody);
    progressDialog.hide();
    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      setState(() {
        var bloodbanks = parsedMAP['listResult'] as List;
        progressDialog.hide();
        if (bloodbanks != null) {
          _blodbanks = bloodbanks;
        } else {
          _blodbanks = [];
          _datamsg = 'No nearby blood banks found';
          print('--------- responseBody : -Items size -- : ' +
              _blodbanks.length.toString());
        }
        // if (_blodbanks.length == null || _blodbanks.length == 0) {
        //   _datamsg = 'No nearby blood banks found';
        // }
        // print('--------- responseBody : -Items size -- : ' +
        //     _blodbanks.length.toString());
      });
    } else {}
  }

  Future<Void> sendFirebaseToken(String _userid, String _firebasetoken) async {
    final uri = baseUrl + updateDeviceTokenComponentUrl;
    print("---------------------------------------------------API :::::" + uri);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "userId": _userid,
      "deviseToken": _firebasetoken
    };
    String jsonBody = json.encode(body);
    print('Post FIREBASE :' + jsonBody);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    progressDialog.hide();
    print('RES  FIREBASE TOKEN :' + responseBody);
    if (statusCode == 200) {
    } else {
      progressDialog.hide();
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Firebase Token issue')));
    }
  }

  _getAddressFromLatLng(String userid) async {
    try {
      // List<Placemark> p = await geolocator.placemarkFromCoordinates(
      //     userpo.latitude, userpo.longitude);
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      Placemark place = p[0];

      print('_____________LOCATION OR AREA _________________' + place.name);

      postGeotags(userid, place);
    } catch (e) {
      print(e);
    }
  }

  Future<Void> postGeotags(String userid, Placemark place) async {
    final uri = baseUrl + updateGeoLocationComponentUrl;

    print('--------- API --- : ' + uri);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "id": 0,
      "userId": userid,
      "latitude": currentPosition.latitude,
      "longitude": currentPosition.longitude,
      "address": place.locality,
      "postalCode": place.postalCode,
      "createdBy": userid,
      "updatedBy": userid,
      "updatedDate": DateTime.now().toIso8601String(),
      "createdDate": DateTime.now().toIso8601String()
    };
    String jsonBody = json.encode(body);
    print('------------------------postGeotags Request : --- : ' + jsonBody);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    print('---------postGeotags responseBody : --- : ' + responseBody);

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      print('---------postGeotags responseBody : : ' + parsedMAP.toString());
    }
  }

  String _uSERID, _token;
  @override
  void initState() {
    super.initState();
    // userinfo= new UserInfo();

    pref = new LocalData();
    profileapi = new ProfileData();

    pref.getStringValueSF(LocalData.USER_ID).then((userid) async {
      print('user id :' + userid);
      _uSERID = userid;
      await pref
          .getStringValueSF(LocalData.accessToken)
          .then((accessTOken) async {
        _token = accessTOken;
        print('Token :' + accessTOken);
        await profileapi.getProfileinfo(userid, accessTOken).then((profile) {
          print('=================================' + profile.toString());
          userAddress = UserInfo.fromJson(profile);
          usercountryid = userAddress.address.countryId;
          print('===================COUNTRYID' + usercountryid.toString());
        });
      });
    });

    Future onSelectNotification(String payload) async {
      Navigator.of(context)
          .pushReplacementNamed(Constants.NOTIFICATIONS_SCREEN);

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

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);

    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('------------------- on message in Home ${message.toString()}');
        displayNotification(message);
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => NotificationScreen()));
        //navigateToNotificationScreen();
      },
      onResume: (Map<String, dynamic> message) async {
        print(' ------------------ on resume in home   ${message.toString()}');

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NotificationScreen()));
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('------------------- on launch in home ${message.toString()}');
        // Navigator.push(
        //   context,
        // MaterialPageRoute(
        //   builder: (context) => NotificationScreen()
        // ),
        // );
      },
    );

    pref = new LocalData();

    pref.getStringValueSF(LocalData.USER_ID).then((userid) {
      _saveduserID = userid;
      print('Save User ID:' + _saveduserID);
      // fetchCurrentLocation(userid);
      _getCurrentLocation(userid);
      progressDialog.hide();
      pref.getStringValueSF(LocalData.FIREBASE_TOKEN).then((token) {
        print('______________FIREBASE TOKEN IN HOME _______________' + token);
        sendFirebaseToken(userid, token);
      });
    });
    LocalData.getBloodGroupID().then((bgTypeid) {
      _bgTypeID = bgTypeid;
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

// Future displayNotification(Map<String, dynamic> message) async {
//     var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//         'channelid', 'flutterfcm', 'your channel description',
//         importance: Importance.Max, priority: Priority.High);
//     var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
//     var platformChannelSpecifics = new NotificationDetails(
//         androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       message['notification']['title'],
//       message['notification']['body'],
//       platformChannelSpecifics,
//       payload: 'hello',
//     );

//     //  Navigator.push(
//     //       context,
//     //       new MaterialPageRoute(builder: (context) => new NotificationScreen()),
//     //     );

//     // Navigator.push(navigatorKey.currentContext, MaterialPageRoute(builder: (_) => NotificationScreen()));
//   }

  // Future onSelectNotification(String payload) async {
  //   if (payload != null) {
  //     debugPrint('notification payload: ' + payload);
  //   }
  //   // await Fluttertoast.showToast(
  //   //     msg: "Notification Clicked",
  //   //     toastLength: Toast.LENGTH_SHORT,
  //   //     gravity: ToastGravity.BOTTOM,
  //   //     timeInSecForIos: 1,
  //   //     backgroundColor: Colors.black54,
  //   //     textColor: Colors.white,
  //   //     fontSize: 16.0);
  //   Navigator.push(
  //     context,
  //     new MaterialPageRoute(builder: (context) => new NotificationScreen()),
  //   );
  // }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    print(
        '---------- >> coming from top in home onDidRecieveLocalNotification');
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
              // await Fluttertoast.showToast(
              //     msg: "Notification Clicked",
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.BOTTOM,
              //     timeInSecForIos: 1,
              //     backgroundColor: Colors.black54,
              //     textColor: Colors.white,
              //     fontSize: 16.0);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //   Padding(
          //     padding: const EdgeInsets.only(right: 8.0),
          //     child: Center(
          //         child: GestureDetector(
          //       child: Image.asset('assets/Icons/Donateblood.png',
          //           height: 30, width: 30),
          //       onTap: () {

          //       },
          //     )),
          //   )
          // ],
          centerTitle: true,
          title: Text(
            //"Nearby Blood banks"
            AppTranslations.of(context).text("key_Near_by_Blood_Banks"),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Colors.orange[200], Colors.pinkAccent])),
          ),
        ),
        drawer: AppDrawer(),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    autofocus: false,
                    style: TextStyle(fontSize: 12),
                    controller: locationControl,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        border: OutlineInputBorder(),
                        hintText:
                            AppTranslations.of(context).text("key_city_name")),
                  ),
                  suggestionsCallback: (pattern) async {
                    return await CitiesService.getSuggestions(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      leading: Icon(Icons.location_city),
                      title: Text(suggestion.cityname),
                      // subtitle: Text('\$${suggestion['price']}'),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    // Navigator.of(context).push(MaterialPageRoute(
                    // builder: (context) => ProductPage(product: suggestion)));
                    locationControl.text = suggestion.cityname;
                    CitiesService.getlatlongfromplaceid(suggestion.placeid)
                        .then((latlong) {
                      makePostRequest(
                          latlong.result.geometry.location.lat,
                          latlong.result.geometry.location.lng,
                          userAddress.address.countryId);
                    });
                  },
                ),
              ),
              _blodbanks.isEmpty ?? Center(child: Text("No data found"))
                  ? Text(_datamsg)
                  : Expanded(child: listitems()),
            ],
          ),
        ));
  }

  var border = OutlineInputBorder(
    borderRadius: new BorderRadius.circular(10.0),
    borderSide: new BorderSide(),
  );
  Widget _createSearchView() {
    return new Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(width: 1.0)),
      child: new TextField(
        controller: locationControl,
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: new TextStyle(color: Colors.grey[300]),
        ),
        textAlign: TextAlign.center,
        onChanged: (textchangevalue) async {
          Prediction p = await PlacesAutocomplete.show(
              context: context, apiKey: kGoogleApiKey);
          displayPrediction(p);
        },
      ),
    );
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local
          .findAddressesFromQuery(p.description)
          .then((locationName) {
        progressDialog.hide();
        locationControl.text = locationName[0].addressLine;
      });
      if (lat != null) {
        makePostRequest(lat, lng, userAddress.address.countryId);
      }
      print(lat);
      print(lng);
    }
  }

  Widget header() {
    return Container(
      child: Opacity(
        opacity: 0.75,
        child: Stack(
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
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange[200], Colors.pinkAccent],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listitems() {
    return ListView.builder(
        itemCount: _blodbanks == null ? 0 : _blodbanks.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: (index % 2 == 0)
                      ? LinearGradient(
                          colors: [Colors.grey[400], Colors.white70],
                        )
                      : LinearGradient(
                          colors: [Colors.grey[200], Colors.white70],
                        )),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventsInfoScreen(_blodbanks[index]),
                      // Pass the arguments as part of the RouteSettings. The
                      // DetailScreen reads the arguments from these settings.
                      settings: RouteSettings(
                        arguments: _blodbanks[index],
                      ),
                    ),
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),

                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _blodbanks[index]["name"],
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          // int entityid = _blodbanks[index]["entityTypeId"];
                          int entityid = _blodbanks[index]["entityId"];
                          _entityID = entityid;
                          onDonateTap(entityid, _bgTypeID, comments, datetime,
                              _saveduserID);
                        },
                        child: Image.asset(
                          'assets/images/blood_donation.png',
                          height: 35,
                          width: 35,
                        ))
                  ],
                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                subtitle: Column(
                  children: <Widget>[
                    Divider(),
                    Text('Address :\n' + _blodbanks[index]["fullAddress"],
                        style: TextStyle(color: Colors.black54)),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _makePhoneCall(
                                'tel:' + _blodbanks[index]["contactNumber"]);
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.phone, color: Colors.black54),
                              Text(' : ' + _blodbanks[index]["contactNumber"],
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 12))
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            MapsLauncher.launchCoordinates(
                                _blodbanks[index]["latitude"],
                                _blodbanks[index]["longitude"],
                                _blodbanks[index]["name"]);
                          },
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                                child: Icon(Icons.map, color: Colors.grey),
                                onTap: () {
                                  MapsLauncher.launchCoordinates(
                                      _blodbanks[index]["latitude"],
                                      _blodbanks[index]["longitude"],
                                      _blodbanks[index]["name"]);
                                },
                              ),
                              Text(_blodbanks[index]["distance"]
                                      .toStringAsFixed(2) +
                                  ' KM')
                              // Text(distance
                              //         .as(
                              //             LengthUnit.Kilometer,
                              //             new LatLng(userLocation.latitude,
                              //                 userLocation.longitude),
                              //             new LatLng(
                              //                 _blodbanks[index]["latitude"],
                              //                 _blodbanks[index]["longitude"]))
                              //         .toString() +
                              //     ' Km'),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                // trailing: Icon(Icons.keyboard_arrow_right,
                //     color: Colors.white, size: 30.0)
              ),
            ),
          );
        });

    // Text(_blodbanks[index]["name"]),
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURL() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  void onDonateTap(int entityid, int _bgTypeID, String _comments,
      String datetime, String _saveduserID) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(
                  height: 25,
                  color: Colors.grey,
                ),
                Text(
                  AppTranslations.of(context)
                      .text("key_Are_you_sure_want_to_donate_blood?"),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                ),
                Divider(
                  height: 25,
                  color: Colors.grey,
                ),
              ],
            ),
            // content: SingleChildScrollView(
            //   child: Container(
            //     // width: 260.0,
            //     // height: 230.0,
            //     child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //       children: <Widget>[
            //         Container(
            //           padding: EdgeInsets.all(5),
            //           decoration: BoxDecoration(
            //               border: Border.all(color: Colors.grey),
            //               borderRadius: BorderRadius.all(Radius.circular(6))),
            //           child: TextField(
            //             controller: donateController,
            //             focusNode: donateFocus,
            //             keyboardType: TextInputType.datetime,
            //             textInputAction: TextInputAction.next,
            //             textCapitalization: TextCapitalization.characters,
            //             autofocus: false,
            //             onTap: () {
            //               FocusScope.of(context).requestFocus(FocusNode());
            //               _selectDate(context);
            //             },
            //             decoration: InputDecoration(
            //                 border: InputBorder.none,
            //                 hintText: 'Please select date'),
            //           ),
            //         ),
            //         SizedBox(height: 15),
            //         Container(
            //           height: 150,
            //           decoration: BoxDecoration(
            //             shape: BoxShape.rectangle,
            //             border: new Border.all(
            //               color: Color(0xffDEE3EA),
            //               width: 1,
            //             ),
            //           ),
            //           child: Padding(
            //             padding: const EdgeInsets.all(6.0),
            //             child: TextField(
            //               controller: commentsController,
            //               textCapitalization: TextCapitalization.sentences,
            //               focusNode: commentsFocus,
            //               decoration: InputDecoration(
            //                 hintText: ' comments here....',
            //                 hintStyle: TextStyle(
            //                   color: Colors.grey,
            //                 ),
            //                 border: InputBorder.none,
            //               ),
            //               textInputAction: TextInputAction.newline,
            //               maxLines: 8,
            //               scrollPhysics: ScrollPhysics(),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    color: Colors.red,
                    child: Text(
                      AppTranslations.of(context).text("key_cancel"),
                      // 'CANCEL',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 20),
                  RaisedButton(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text(AppTranslations.of(context).text("Key_OK"),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400)),
                    onPressed: () {
                      donateRequest(
                        _entityID,
                        _bgTypeID,
                        _saveduserID,
                      );
                      Navigator.pop(context);
                    },
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     donateRequest(
                  //       _entityID,
                  //       _bgTypeID,
                  //       _saveduserID,
                  //     );
                  //   },
                  //   child: Padding(
                  //     padding: EdgeInsets.only(right: 15),
                  //     child: Container(
                  //       padding: EdgeInsets.all(10),
                  //       width: 120,
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.all(Radius.circular(6)),
                  //           gradient: LinearGradient(
                  //               begin: Alignment.topLeft,
                  //               end: Alignment.bottomRight,
                  //               colors: [
                  //                 Colors.orange[200],
                  //                 Colors.pinkAccent
                  //               ])),
                  //       child: Center(
                  //           child: Text(
                  //         'OK',
                  //         style: TextStyle(color: Colors.white, fontSize: 15),
                  //       )),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          );
        });
  }

  Future<int> donateRequest(
      int _entityID, int _bgTypeId, String _userId) async {
    final uri = baseUrl + donateRequestComponentURL;
    print(' Donate blood url :' + uri);

    final headers = {'Content-Type': 'application/json'};

    Map<String, dynamic> body = {
      "destinationEntityId": _entityID,
      "bloodGroupTypeId": _bgTypeId,
      "userId": _userId,
      "comments": null
    };
    String jsonbody = json.encode(body);
    print('DONOR REQUEST OBJECT :' + jsonbody);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonbody,
      encoding: encoding,
    );
    int statusCode = response.statusCode;
    String responseBody = response.body;
    print('---------------------------------------------------------');
    print('Donate Response :' + responseBody);
    print('---------------------------------------------------------');

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);
      bool code = parsedMAP['isSuccess'];
      if (code) {
        statusCode = 200;

        print('Donate Alert :' +
            parsedMAP['result']["notification_RequestId"][0]["text"]);
        await Fluttertoast.showToast(
            msg: parsedMAP['result']["notification_RequestId"][0]["text"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        statusCode = 400;
      }
    } else if (statusCode == 401) {
      statusCode = 401;
    }
    return statusCode;
  }
}
