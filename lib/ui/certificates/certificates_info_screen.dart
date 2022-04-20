

import 'package:flutter/material.dart';
import 'package:flutter_logindemo/localization/app_translations.dart';
import 'package:flutter_logindemo/ui/certificates/certificatefullview.dart';
import 'package:flutter_logindemo/ui/widgets/app_drawer.dart';
import 'package:flutter_logindemo/utils/localdata.dart';
import 'package:intl/intl.dart';
import 'certificatess_data.dart';


class CertificatesScreen extends StatefulWidget {
  CertificatesScreen({Key key}) : super(key: key);

  @override
  _CertificatesScreenState createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  var iamCertificatesScreen = 'No Data Available';
  static DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");

  static DateTime date2 = DateTime.now();

  CertificatesData certificatesData = new CertificatesData();
  List<CertificateModel> dummyPersonList = new List<CertificateModel>();
  LocalData pref;
  @override
  void initState() {
    super.initState();
    pref = new LocalData();
    dummyPersonList = null;
    pref.getStringValueSF(LocalData.USER_ID).then((userid) {
      certificatesData.getCertificates(userid).then((items) {
        setState(() {
          dummyPersonList = items;
          // iamCertificatesScreen ='No Data Available';
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: appbarwidget,
      appBar: AppBar(
        centerTitle: true,
    title: Text(
      //'Certificates'
      AppTranslations.of(context).text("key_Donor_Certificates"),
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
      body:dummyPersonList == null || dummyPersonList.isEmpty  || dummyPersonList.length < 0
      ?Center(child: Text(AppTranslations.of(context).text("key_No_Data_Available")),) :  Container(
        padding: EdgeInsets.all(1),
      child: dummyPersonList == null || dummyPersonList.isEmpty
          ? Center(
              child: Text(AppTranslations.of(context).text("key_No_Data_Available")),
            )
          : Container(
              padding: EdgeInsets.all(1),
              child: ListView.builder(
                  itemCount: dummyPersonList == null || dummyPersonList.isEmpty
                      ? 0
                      : dummyPersonList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var dummyPersonList2 = dummyPersonList;
                    return new Card(
                      elevation: 8.0,
                      margin: new EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              gradient: (index % 2 == 0)
                                  ? LinearGradient(
                                      colors: [
                                        Colors.grey[400],
                                        Colors.white70
                                      ],
                                    )
                                  : LinearGradient(
                                      colors: [
                                        Colors.grey[200],
                                        Colors.white70
                                      ],
                                    )),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                  isThreeLine: true,
                                  onTap: () {
                                    // Navigator.of(context).pushNamed(Constants.CERTIFCATES_IMAGEVIEW);
                                    if (dummyPersonList[index].certificateURL !=
                                        null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ImageFullscreen(
                                              dummyPersonList[index]
                                                  .certificateURL),
                                          // Pass the arguments as part of the RouteSettings. The
                                          // DetailScreen reads the arguments from these settings.
                                          settings: RouteSettings(
                                            arguments: dummyPersonList[index]
                                                .certificateURL,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 10.0),
                                  title: Text(
                                    dummyPersonList[index].hospatalName,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                  subtitle: Column(
                                    children: <Widget>[
                                      Divider(),
                                      Text(
                                          'Address :\n' +
                                              dummyPersonList[index]
                                                  .hospatalAddress,
                                          style:
                                              TextStyle(color: Colors.black54)),
                                    ],
                                  ),
                                  trailing: Column(
                                    children: <Widget>[
                                      Icon(Icons.calendar_today,
                                          color: Colors.black54),
                                      Text(date2
                                                  .difference(dateFormat.parse(
                                                      dummyPersonList[index]
                                                          .dateofDonation))
                                                  .inDays <
                                              1
                                          ? 'Today'
                                          : date2
                                                  .difference(dateFormat.parse(
                                                      dummyPersonList2[index]
                                                          .dateofDonation))
                                                  .inDays
                                                  .toString() +
                                              ' Days(s)'),
                                    ],
                                  )
                                  // trailing: Icon(Icons.keyboard_arrow_right,
                                  //     color: Colors.white, size: 30.0)
                                  ),
                            ],
                          )),
                    );
                  }),
            ),
    ));
  }

}
