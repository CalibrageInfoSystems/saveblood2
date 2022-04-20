import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_logindemo/Model/NotificationResponse.dart';
import 'package:flutter_logindemo/localization/app_translations.dart';
import 'package:flutter_logindemo/ui/api_config.dart';
import 'package:flutter_logindemo/utils/localdata.dart';
import 'package:http/http.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'widgets/app_drawer.dart';

LocalData localData;
String userID;
bool _canShowButton = true;
ProgressDialog progressDialog;
var _datamsg = "";
int pageIndex = 0;
int totalCount = 0;
int notificationIndex = 0;
ScrollController _scrollController;

List<String> notificationsArray = [];
List<String> bloodBankArray = [];
List<String> useNameArray = [];
List<int> idsArray = [];
List<String> userIdArray = [];
List<int> requestIdArray = [];
List<NotificationsResponse> notificationsResponse;
// List<ListResult> listResultResponse = List();

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var listResultResponse = [];
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  bool isLoading = false;

  bool get isAccepeted => null;

  String userID;

  bool isAccepted;

  Future loadingPushNotifications() async {
    // perform fetching data delay
    //getAllNotifications();
    await new Future.delayed(new Duration(seconds: 2));

    print("load more");
    progressDialog.hide();
    // update data and loading status
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@drawable/appstore');

    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);

    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message in notifications Screen ${message}');
        //getAllNotifications();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NotificationScreen()));
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume in notifications Screen $message');
        //getAllNotifications();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NotificationScreen()));
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch in notifications Screen $message');
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
      print('firebase Token from notification:' + token);
    });
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    var response = json.decode(payload) as Map;

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NotificationScreen()));
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text('mallemmahesh'),
        content: Column(
          children: <Widget>[Text(body), Text(body)],
        ),
        actions: [
          new CupertinoAlertDialog(
            title: new Text("Dialog Title"),
            content: new Text("This is my content"),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Yes"),
              ),
              CupertinoDialogAction(
                child: Text("No"),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

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

    loadingPushNotifications();
    _canShowButton = true;
    localData = new LocalData();
    localData.getStringValueSF(LocalData.USER_ID).then((_userID) {
      userID = _userID;
      pageIndex = 0;
      totalCount = 0;
      listResultResponse = [];
      getAllNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppTranslations.of(context).text("key_Notifications"),
          //'Notifications'
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
      // body: listResultResponse == null || listResultResponse.isEmpty
      //     ? Center(
      //         child: Text(
      //           AppTranslations.of(context).text("key_No_Data_Available"),
      //           //'No Data Available ...'
      //         ),
      //       )
      //     : listItems());

      body: listResultResponse == null || listResultResponse.isEmpty ??
              Center(child: Text("No data found"))
          ? Center(child: Text(_datamsg))
          : listItems(),
    );
  }

  Future<Void> getAllNotifications() async {
    print('UserID -->> ' + userID);

    progressDialog.show();
    final uri = baseUrl + getAllNotificationsUrl;

    print(' ---- GetAllNotifications  API :' + uri);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "userId": userID,
      "pageIndex": pageIndex,
      "pageSize": 10
    };

    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    print(' Post OBJ :' + jsonBody);
    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    print(' Res Body :' + responseBody);
    progressDialog.hide();
    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      setState(() {
        progressDialog.hide();
        //listResultResponse = parsedMAP["listResult"] as List;
        var item = parsedMAP["listResult"] as List;
        if (item.length < 10) {
          print(' ---------- pagination completed');
        }
        listResultResponse.addAll(parsedMAP["listResult"]);
        totalCount = parsedMAP["affectedRecords"];
        //  if (totalCount >  listResultResponse.length) {
        //    listResultResponse.addAll(parsedMAP["listResult"]);
        //  }
        print('--->>> listResultResponse.length' +
            listResultResponse.length.toString());
        print('--->>> total count' + totalCount.toString());
        isLoading = false;
        if (listResultResponse == null ||
            listResultResponse.length == null ||
            listResultResponse.length == 0) {
          _datamsg = 'No Data Available';
        }
      });
    } else {
      // pr.dismiss();

      progressDialog.hide();
    }
  }

  Future<Void> accepetNotificationAPI(String userid, int id, int requestID,
      bool isAccepeted, int position) async {
    //print('UserID -->> ' + userID);

    progressDialog.show();
    final uri = baseUrl + doAcceptNotificationComponentUrl;
    print(' ----   ----- -- ----  API :' + uri);

    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "id": id,
      "userId": userID,
      "requestId": requestID,
      "isAccepted": isAccepeted,
      "responseUnits": 0
    };

    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    print(' Post OBJ :' + jsonBody);
    Response response = await put(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    print(' Res Body :' + responseBody);
    progressDialog.hide();
    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      var endUserMessage = parsedMAP["endUserMessage"];
      var resultArray = parsedMAP["result"];
      var isAccepted = resultArray['isAccepted'];

      print('Updating into  Index:' +
          position.toString() +
          " -- Value :" +
          resultArray.toString());

      listResultResponse[position]['isAccepted'] = isAccepted;
      print(listResultResponse[position]);
      print(parsedMAP.keys);

      setState(() {
        print('---------->>>> Notifications Reloading');
        listItems();
        //_scrollController.animateTo(position + 0.0 ,duration: new Duration(seconds: 1), curve: Curves.ease);
      });

      _showDialog(endUserMessage);

      // });
    } else {
      // pr.dismiss();

      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
        AppTranslations.of(context)
            .text("key_error_msg_no_internet_connection"),
        //'Please Check Your Internet Connection'
      )));
    }
  }

  // user defined function
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
                Navigator.of(context).pop();
                progressDialog.hide();
                //getAllNotifications();
                // setState(() {
                //   listItems();
                // });
              },
            ),
          ],
        );
      },
    );
  }

  Widget listItems() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8),
          child: SizedBox(
            height: 30,
            width: double.infinity,
            child: RaisedButton(
              color: Colors.grey[300],
              padding: EdgeInsets.all(3),
              onPressed: () {
                markAllReadNotificationsAPICall();
              },
              child: Text(
                  AppTranslations.of(context).text("key_Mark_as_All_Read"),
                  style: TextStyle(fontSize: 16)),
            ),
          ),
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!isLoading &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                pageIndex = pageIndex + 1;
                if (listResultResponse.length < totalCount) {
                  getAllNotifications();
                }
                // start loading data
                print('--->>> listResultResponse.length' +
                    listResultResponse.length.toString());
                print('--->>> total count' + totalCount.toString());
                print('--->>> called Notiification listener');
                setState(() {
                  isLoading = true;
                });
              }
            },
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              itemCount:
                  listResultResponse == null || listResultResponse.isEmpty
                      ? 0
                      : listResultResponse.length,
              itemBuilder: (context, index) {
                print('--->>> Loading Notifications');
                var acceptButton = GestureDetector(
                  onTap: () {
                    accepetNotificationAPI(
                        userID,
                        listResultResponse[index]['id'],
                        listResultResponse[index]['requestId'],
                        true,
                        index);
                  },
                  child: Container(
                    height: 30,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      gradient: LinearGradient(
                        colors: <Color>[Colors.orange[200], Colors.pinkAccent],
                      ),
                    ),
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                      child: Text(
                        AppTranslations.of(context).text("key_accept"),
                        //'Accept',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );

                var declineButton = GestureDetector(
                  onTap: () {
                    accepetNotificationAPI(
                        userID,
                        listResultResponse[index]['id'],
                        listResultResponse[index]['requestId'],
                        false,
                        index);
                  },
                  child: Container(
                    height: 30,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      gradient: LinearGradient(
                        colors: <Color>[Colors.orange[200], Colors.pinkAccent],
                      ),
                    ),
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                      child: Text(
                        AppTranslations.of(context).text("key_reject"),
                        //'Decline',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                        //style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10))
                      ),
                    ),
                  ),
                );
                return Padding(
                  padding: EdgeInsets.only(left: 6, right: 6, top: 6),
                  child: Card(
                    // color: listResultResponse[index]["isRead"]== true ? Colors.grey :Colors.blue,

                    elevation: 8,

                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                listResultResponse[index]['entityName'] == null
                                    ? "General Information"
                                    : '${listResultResponse[index]['entityName']}',
                                style: TextStyle(
                                    color: listResultResponse[index]
                                                ["isRead"] ==
                                            true
                                        ? Colors.grey
                                        : listResultResponse[index]
                                                    ["isAccepted"] ==
                                                null
                                            ? Colors.black87
                                            : Colors.grey,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600),
                              ),
                              Divider(height: 15),
                              GestureDetector(
                                onTap: () {
                                  MapsLauncher.launchCoordinates(
                                      listResultResponse[index]["latitude"],
                                      listResultResponse[index]["longitude"],
                                      listResultResponse[index]["entityName"]);
                                },
                                child: Text(
                                  listResultResponse[index]['text'],
                                  style: TextStyle(
                                      color: listResultResponse[index]
                                                  ["isRead"] ==
                                              true
                                          ? Colors.grey
                                          : listResultResponse[index]
                                                      ["isAccepted"] ==
                                                  null
                                              ? Colors.black87
                                              : Colors.grey,
                                      fontSize: 14),
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: <Widget>[],
                              ),
                              Divider(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  listResultResponse[index]
                                              ["notificationTypeId"] ==
                                          23
                                      ? (listResultResponse[index]
                                                  ["isAccepted"] ==
                                              null
                                          ? Visibility(
                                              visible: _canShowButton,
                                              child: acceptButton)
                                          : Container())
                                      : Container(),
                                  SizedBox(width: 8),
                                  listResultResponse[index]
                                              ["notificationTypeId"] ==
                                          23
                                      ? (listResultResponse[index]
                                                  ["isAccepted"] ==
                                              null
                                          ? Visibility(
                                              visible: _canShowButton,
                                              child: declineButton)
                                          : Container())
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                            height: 3,
                            width: double.infinity,
                            // child: if (listResultResponse[index]["isAccepted"] == true) {

                            // } else {
                            // },
                            color:
                                listResultResponse[index]["isAccepted"] == true
                                    ? Colors.green[200]
                                    : listResultResponse[index]["isAccepted"] ==
                                            false
                                        ? Colors.red
                                        : Colors.white

                            //color: listResultResponse[index]["isAccepted"] == true ? Colors.green[200] ?? Colors.red : Colors.white,
                            ),
                      ],
                    ),
                    // child: ListTile(

                    //   title: Text('${notificationsArray[index]}'),

                    // ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<Void> markAllReadNotificationsAPICall() async {
    var url = baseUrl + markAllReadNotificationsURl + userID;

    print('API :' + url);
    Response res = await get(url);

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => NotificationScreen()));

      print('--- markAllReadNotificationsAPI -->>>>   ' + responseBody);

      parsedMAP.toString();
    } else {
      return null;
    }
  }
}
