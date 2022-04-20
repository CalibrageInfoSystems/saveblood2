import 'dart:convert';

import 'package:flutter_logindemo/ui/models/bloodgroup_model.dart';
import 'package:http/http.dart';

import '../api_config.dart';

class CertificatesData
{
  var dummyPersonList = new List<CertificateModel>.generate(20, (i) {
    return CertificateModel(
      bloodGroup: 'John Doe',
      dateofDonation: '2020-02-07T01:58:22.222272+05:30',
      units: '2',
      hospatalName: 'Calibrage',
      hospatalAddress: 'Plot No : 132/A, II Floor, Road No : 06, Western Hills, Opp JNTU, Kukatpally, Hyderabad - 72, Telangana 500072',
      certificateURL: 'https://picsum.photos/id/237/200/300'

    );
  });
 
Future<List<CertificateModel>> getCertificates(String userid) async {
    
    List<CertificateModel> certificates=new List<CertificateModel>();
    Response res = await get(baseUrl + getCertificatesofDonar+userid);

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      var items = parsedMAP['listResult'] as List;
      
      for (int i = 0; i < items.length; i++) {
        print('------------------------------------');
        print(items[i]['entityName']);
         print(items[i]['bloodGroupName']);
          print(items[i]['dateOfCollection']);
           print(items[i]['entityAddress']);
            print(items[i]['certificateImage']);
           


        certificates.add(   new CertificateModel(
        bloodGroup: items[i]['bloodGroupName'],
        dateofDonation: items[i]['dateOfCollection'],
        units: items[i]['entityName'].toString(),
        hospatalName:items[i]['entityName'],
        hospatalAddress:items[i]['entityAddress'],
        certificateURL: items[i]['certificateImage']));
      }
    return dummyPersonList =certificates;
       
    } else {
      return null;
    }
  }
}

class CertificateModel
{

  final String bloodGroup;
  final String dateofDonation;
  final String units;
  final String hospatalName;
  final String hospatalAddress;
  final String certificateURL;

  CertificateModel({
    this.bloodGroup,
    this.dateofDonation,
    this.units,
    this.hospatalName,
    this.hospatalAddress,
    this.certificateURL});
}