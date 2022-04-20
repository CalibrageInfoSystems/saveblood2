import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_logindemo/localization/app_translations.dart';
import 'package:flutter_logindemo/ui/widgets/GradientText.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../api_config.dart';
import 'BloodInventoryModel.dart';
import 'Eventsinfomodel.dart';

ProgressDialog progressDialog;
String _datamsg = "";

class EventsInfoScreen extends StatefulWidget {
  final Map<String, dynamic> blodbanks;
  EventsInfoScreen(this.blodbanks);

  @override
  _EventsInfoScreenState createState() => _EventsInfoScreenState();
}

class _EventsInfoScreenState extends State<EventsInfoScreen> {
  static DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  static DateFormat timeFormat = DateFormat('HH:mm a');

  Eventsinfomodel eventsdata;
  BloodInventoryModel bloodInventoryData;

  // var endDate = dateFormat.format(eventsdata.listResult[index].fromDate);

  @override
  void initState() {
    super.initState();
    eventsdata = null;
    bloodInventoryData = null;

    progressDialog =
        new ProgressDialog(context, type: ProgressDialogType.Normal);

    // progressDialog.style(
    //   message: 'Please wait...',
    //   borderRadius: 10.0,
    //   backgroundColor: Colors.black54,
    //   progressWidget: CircularProgressIndicator(),
    //   elevation: 10.0,
    //   insetAnimCurve: Curves.easeInCubic,
    //   progressTextStyle: TextStyle(
    //       color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w400),
    //   messageTextStyle: TextStyle(
    //       color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w600),
    // );
    getbloodInventorybyid(widget.blodbanks["entityId"]);
  }

  @override
  Widget build(BuildContext context) {
    var listView = ListView.builder(
        itemCount: eventsdata == null ||
                eventsdata.listResult == null ||
                eventsdata.listResult.length < 1
            ? 0
            : eventsdata.listResult.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
                padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: (index % 2 == 0)
                      ? LinearGradient(
                          colors: [Colors.grey[400], Colors.white70],
                        )
                      : LinearGradient(
                          colors: [Colors.grey[200], Colors.white70],
                        ),
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      isThreeLine: true,
                      onTap: () {},
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      title: GradientText(
                        eventsdata.listResult[index].name,
                        gradient: LinearGradient(colors: [
                          Colors.orange[500],
                          Colors.pinkAccent,
                          Colors.blue
                        ]),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            eventsdata.listResult[index].fullAddress,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          // Text('Address :\n' +
                          //     eventsdata.listResult[index]
                          //         .districtName
                          //         .toString() +
                          //     '(dist) ,' +
                          //     eventsdata.listResult[index]
                          //         .mandalName
                          //         .toString() +
                          //     '(Mandal) ,' +
                          //     eventsdata.listResult[index]
                          //         .villageName
                          //         .toString() +
                          //     '(village) ,'),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                // crossAxisAlignment:
                                //     CrossAxisAlignment.start,
                                children: <Widget>[
                                  // Text('Availability:',
                                  //   style: TextStyle(
                                  //       color: Colors.black,
                                  //       fontWeight: FontWeight.w500,
                                  //       fontSize: 18,
                                  //       decoration: TextDecoration
                                  //           .underline),
                                  // ),
                                  //SizedBox(height: 5),
                                  Row(
                                    children: <Widget>[
                                      //Icon(Icons.calendar_today,size: 17,color: Colors.black,),
                                      SizedBox(width: 3),
                                      Text('From : ',
                                          style:
                                              TextStyle(color: Colors.black)),
                                      Text(
                                          dateFormat.format(eventsdata
                                              .listResult[index].fromDate),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),

                                      SizedBox(width: 30),

                                      Icon(
                                        Icons.timer,
                                        size: 17,
                                      ),
                                      SizedBox(width: 5),

                                      Text(
                                        //timeFormat.format(eventsdata.listResult[index].fromTime),
                                        eventsdata.listResult[index].fromTime,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        ' To:  ',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      SizedBox(width: 15),
                                      Text(
                                        dateFormat.format(eventsdata
                                            .listResult[index].toDate),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 30),
                                      Icon(
                                        Icons.timer,
                                        size: 17,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        eventsdata.listResult[index].toTime,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17),
                                      )
                                    ],
                                  ),

                                  // dateFormat.format(eventsdata
                                  //             .listResult[index]
                                  //             .toDate) !=
                                  //         dateFormat.format(eventsdata
                                  //             .listResult[index]
                                  //             .fromDate)
                                  //     ? Row(
                                  //         children: <Widget>[
                                  //           Icon(
                                  //             Icons.calendar_today,
                                  //             size: 17,
                                  //           ),
                                  //           SizedBox(width: 5),
                                  //           Text(
                                  //             'To:  ',
                                  //             style: TextStyle(
                                  //                 color:
                                  //                     Colors.black),
                                  //           ),
                                  //           Text(
                                  //             dateFormat.format(
                                  //                 eventsdata
                                  //                     .listResult[
                                  //                         index]
                                  //                     .toDate),
                                  //             style: TextStyle(
                                  //                 color: Colors.black,
                                  //                 fontWeight:
                                  //                     FontWeight
                                  //                         .bold),
                                  //           )
                                  //         ],
                                  //       )
                                  //     : Container(),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          );
        });
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.blodbanks["name"]),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Colors.orange[200], Colors.pinkAccent])),
          ),
        ),
        //body: eventsdata == null || eventsdata.listResult.length < 1? Center(child: Text('No Data Available'),)
        body: Column(children: [
          bloodInventoryData == null ?? Center(child: Text("No data found"))
              ? Text('')
              : Card(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Blood Groups (Uts)',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[1].aPositive >=
                                          1
                                      ? Image.asset('assets/blood/a-pos.png',
                                          height: 45, width: 45)
                                      : Image.asset('assets/blood/a-pos-0.png',
                                          height: 45, width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[1].aPositive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[1].aNegitive >=
                                          1
                                      ? Image.asset('assets/blood/a-neg.png',
                                          height: 45, width: 45)
                                      : Image.asset('assets/blood/a-neg-0.png',
                                          height: 45, width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[1].aNegitive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[1].bPositive >=
                                          1
                                      ? Image.asset('assets/blood/b-pos.png',
                                          height: 45, width: 45)
                                      : Image.asset('assets/blood/b-pos-0.png',
                                          height: 45, width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[1].bPositive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[1].bNegitive >=
                                          1
                                      ? Image.asset('assets/blood/b-neg.png',
                                          height: 45, width: 45)
                                      : Image.asset('assets/blood/b-neg-0.png',
                                          height: 45, width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[1].bNegitive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[1].abPositive >=
                                          1
                                      ? Image.asset('assets/blood/ab-pos.png',
                                          height: 45, width: 45)
                                      : Image.asset('assets/blood/ab-pos-0.png',
                                          height: 45, width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[1].abPositive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[1].abNegitive >=
                                          1
                                      ? Image.asset('assets/blood/ab-neg.png',
                                          height: 45, width: 45)
                                      : Image.asset('assets/blood/ab-neg-0.png',
                                          height: 45, width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[1].abNegitive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[1].oPositive >=
                                          1
                                      ? Image.asset('assets/blood/o-pos.png',
                                          height: 45, width: 45)
                                      : Image.asset('assets/blood/o-pos-0.png',
                                          height: 45, width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[1].oPositive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[1].oNegitive >=
                                          1
                                      ? Image.asset('assets/blood/o-neg.png',
                                          height: 45, width: 45)
                                      : Image.asset('assets/blood/o-neg-0.png',
                                          height: 45, width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[1].oNegitive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                            ],
                          ),
                        ),
                        
                        Divider(),
                        Text('Plasma (Uts)',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[

                                  bloodInventoryData.listResult[2].aPositive >=
                                          1
                                      ? Image.asset('assets/plasma/a-pos.png',
                                          height: 45, width: 45)
                                      : Image.asset('assets/plasma/a-pos-0.png',
                                          height: 45, width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[2].aPositive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[2].aNegitive >=
                                          1
                                      ? Image.asset('assets/plasma/a-neg.png',
                                          height: 45, width: 45)
                                      : Image.asset('assets/plasma/a-neg-0.png',
                                          height: 45, width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[2].aNegitive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[2].bPositive >=
                                          1
                                      ? Image.asset('assets/plasma/b-pos.png',
                                          height: 45, width: 45)
                                      : Image.asset('assets/plasma/b-pos-0.png',
                                          height: 45, width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[2].bPositive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[2].bNegitive >=
                                          1
                                      ? Image.asset('assets/plasma/b-neg.png',
                                          height: 45, width: 45)
                                      : Image.asset('assets/plasma/b-neg-0.png',
                                          height: 45, width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[2].bNegitive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[2].abNegitive >=
                                          1
                                      ? Image.asset('assets/plasma/ab-pos.png',
                                          height: 45, width: 45)
                                      : Image.asset(
                                          'assets/plasma/ab-pos-0.png',
                                          height: 45,
                                          width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[2].abPositive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[2].abNegitive >=
                                          1
                                      ? Image.asset('assets/plasma/ab-neg.png',
                                          height: 45, width: 45)
                                      : Image.asset(
                                          'assets/plasma/ab-neg-0.png',
                                          height: 45,
                                          width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[2].abNegitive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[2].oPositive >=
                                          1
                                      ? Image.asset('assets/plasma/o-pos.png',
                                          height: 45, width: 45)
                                      : Image.asset('assets/plasma/o-pos-0.png',
                                          height: 45, width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[2].oPositive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[2].oNegitive >=
                                          1
                                      ? Image.asset('assets/plasma/o-neg.png',
                                          height: 45, width: 45)
                                      : Image.asset('assets/plasma/o-neg-0.png',
                                          height: 45, width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[2].oNegitive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                            ],
                          ),
                        ),
                        Divider(),
                        Text('Platelets (Uts)',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[0].aPositive >=
                                          1
                                      ? Image.asset(
                                          'assets/platelets/a-pos.png',
                                          height: 45,
                                          width: 45)
                                      : Image.asset('assets/platelets/a-pos-0.png',
                                          height: 45, width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[0].aPositive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[0].aNegitive >=
                                          1
                                      ? Image.asset(
                                          'assets/platelets/a-neg.png',
                                          height: 45,
                                          width: 45)
                                      : Image.asset('assets/platelets/a-neg-0.png',
                                          height: 45, width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[0].aNegitive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[0].bPositive >=
                                          1
                                      ? Image.asset(
                                          'assets/platelets/b-pos.png',
                                          height: 45,
                                          width: 45)
                                      : Image.asset('assets/platelets/b-pos-0.png',
                                          height: 45, width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[0].bPositive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[0].bNegitive >=
                                          1
                                      ? Image.asset(
                                          'assets/platelets/b-neg.png',
                                          height: 45,
                                          width: 45)
                                      : Image.asset('assets/platelets/b-neg-0.png',
                                          height: 45, width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[0].bNegitive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[0].abPositive >=
                                          1
                                      ? Image.asset(
                                          'assets/platelets/ab-pos.png',
                                          height: 45,
                                          width: 45)
                                      : Image.asset(
                                          'assets/platelets/ab-pos-0.png',
                                          height: 45,
                                          width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[0].abPositive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[0].abNegitive >=
                                          1
                                      ? Image.asset(
                                          'assets/platelets/ab-neg.png',
                                          height: 45,
                                          width: 45)
                                      : Image.asset(
                                          'assets/platelets/ab-neg-0.png',
                                          height: 45,
                                          width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[0].abNegitive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[0].oPositive >=
                                          1
                                      ? Image.asset(
                                          'assets/platelets/o-pos.png',
                                          height: 45,
                                          width: 45)
                                      : Image.asset('assets/platelets/o-pos-0.png',
                                          height: 45, width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[0].oPositive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                              Column(
                                children: <Widget>[
                                  bloodInventoryData.listResult[0].oNegitive >=
                                          1
                                      ? Image.asset(
                                          'assets/platelets/o-neg.png',
                                          height: 45,
                                          width: 45)
                                      : Image.asset('assets/platelets/o-neg-0.png',
                                          height: 45, width: 45),
                                  SizedBox(height: 2),
                                  Text(bloodInventoryData
                                      .listResult[0].oNegitive
                                      .toString()),
                                ],
                              ),
                              SizedBox(width: 2),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
          eventsdata == null ?? Center(child: Text("No data found"))
              ? Text(_datamsg)
              : Expanded(child: listView),
        ]));
  }

  Future geteventsbyid(int bloodbankid) async {
    Eventsinfomodel _eventsdata;
    var url = baseUrl + eventsbybloddbankid + bloodbankid.toString();
    print('API URL :' + url);
    Response res = await get(url);

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);
      print("RESPONCE :" + parsedMAP.toString());
      _eventsdata = Eventsinfomodel.fromJson(parsedMAP);
      if (_eventsdata.affectedRecords == null ||
          _eventsdata.affectedRecords <= 0) {
        _datamsg = AppTranslations.of(context).text("key_No_Data_Available");
      }

      setState(() {
        eventsdata = _eventsdata;
      });
    }
  }

  Future getbloodInventorybyid(int bloodbankid) async {
    BloodInventoryModel _bloodInventoryData;
    var url = baseUrl + bloodInventoryURL + bloodbankid.toString();
    print('bloodInventory API URL :' + url);
    Response res = await get(url);

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<dynamic, dynamic> parsedMAP = json.decode(responseBody);
      print("RESPONSE :" + parsedMAP.toString());
      _bloodInventoryData = BloodInventoryModel.fromJson(parsedMAP);

      if (_bloodInventoryData.listResult != null &&
          _bloodInventoryData.listResult.length > 0) {
        setState(() {
          bloodInventoryData = _bloodInventoryData;

          print(' blood groupss -- >> ' +
              bloodInventoryData.listResult.length.toString());
        });
      }

      geteventsbyid(widget.blodbanks["entityId"]);
    }
  }
}
