import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_logindemo/ui/models/bloodgroup_model.dart';
import 'package:flutter_logindemo/ui/models/refreshtoken_model.dart';
import 'package:flutter_logindemo/ui/models/states_model.dart';
import 'package:flutter_logindemo/ui/profile_screen/profile_screen_new.dart';
import 'package:flutter_logindemo/utils/localdata.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart';

import '../api_config.dart';

class ProfileData {
  LocalData pref = new LocalData();
  Future<List<BloodGrop>> getbloodgroups() async {
    List<BloodGrop> bloodGroups = new List<BloodGrop>();
    var apiurl = baseUrl + getbloodgroupsUrl;
    print('API CALL :' + apiurl);
    Response res = await get(apiurl);

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      var items = parsedMAP['listResult'] as List;
      for (int i = 0; i < items.length; i++) {
        print(items[i]['name']);
        bloodGroups.add(new BloodGrop(
            name: items[i]['name'], typeCdDmtId: items[i]['typeCdDmtId']));
      }

      return bloodGroups;
    } else {
      return null;
    }
  }

  Future<List<AddressItemModel>> getCountries() async {
    List<AddressItemModel> statelist = new List<AddressItemModel>();
    Response res = await get(baseUrl + getCountryComponentUrl);
    print('Get States BY Country API-------------'+ res.toString());
    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      var items = parsedMAP['listResult'] as List;
      print("---->>> StatesByCountryComponent  -> " + items.toString());
     
      if (items.length > 0) {
        for (int i = 0; i < items.length; i++) {
          print(items[i]['name']);
          statelist.add(
              new AddressItemModel(id: items[i]['id'], name: items[i]['name']));
        }
      }
      else{
        statelist.clear();
      }
      return statelist;
    } else {
      return null;
    }
  }

  Future<List<AddressItemModel>> getstates(int countryID) async {
    List<AddressItemModel> statelist = new List<AddressItemModel>();
    Response res = await get(
        baseUrl + getStatesByCountryComponentUrl + countryID.toString());

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      var items = parsedMAP['listResult'] as List;
      print("---->>> StatesByCountryComponent  -> " + items.toString());

      if (items.length > 0) {
        for (int i = 0; i < items.length; i++) {
          print(items[i]['name']);
          statelist.add(
              new AddressItemModel(id: items[i]['id'], name: items[i]['name']));
        }
      }      
      return statelist;
    } else {
       statelist.clear();
       return statelist=null;
    }
  }

  Future<List<AddressItemModel>> getDistsbystateid(int stateid) async {
    List<AddressItemModel> distslist = new List<AddressItemModel>();
    Response res = await get(
        baseUrl + getDistrictsByStateComponentUrl + stateid.toString());

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      var items = parsedMAP['listResult'] as List;
      print("districts response -- >>  " + items.toString());
      for (int i = 0; i < items.length; i++) {
        print(" -- >>  " + items[i]['name']);
        distslist.add(
            new AddressItemModel(id: items[i]['id'], name: items[i]['name']));
      }
      return distslist;
    } else {
      return null;
    }
  }

  Future<List<AddressItemModel>> getMandalsbyDistid(int distid) async {
    List<AddressItemModel> mandalslist = new List<AddressItemModel>();

    var url =
        baseUrl + getMandalsByDistrictComponentUrl  + distid.toString();
    print('API :' + url);
    Response res = await get(url);

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      var items = parsedMAP['listResult'] as List;
      for (int i = 0; i < items.length; i++) {
        print(items[i]['name']);
        mandalslist.add(
            new AddressItemModel(id: items[i]['id'], name: items[i]['name']));
      }
      return mandalslist;
    } else {
      return null;
    }
  }

  Future<List<AddressItemModel>> getvillaagebyMandalid(int mandalis) async {
    List<AddressItemModel> villagelist = new List<AddressItemModel>();

    var url =
        baseUrl + getVillagesByMandalComponentUrl  + mandalis.toString();
    print('API :' + url);
    Response res = await get(url);

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      var items = parsedMAP['listResult'] as List;
      for (int i = 0; i < items.length; i++) {
        print(items[i]['name']);
        villagelist.add(
            new AddressItemModel(id: items[i]['id'], name: items[i]['name']));
      }
      return villagelist;
    } else {
      return null;
    }
  }

  Future<int> postUserData(
    String _userid,
    String _token,
    int _id,
    String _fullname,
    String _mobilenumber,
    String _email,
    String _dob,
    BloodGrop bloodGrop,
    int _height,
    int _feet,
    int _inch,
    int _weight,
    bool isDiabetic,
    bool isAlcohalic,
    bool diseased,
    bool hivPositive,
    bool isAnyMajorSurgeries,
    // int _villageid,
    // String _addre1,
    // String _addre2,
    // String _contact1,
    // String _name1,
    // String _relation1,
    // String _contact2,
    // String _name2,
    // String _relation2
  ) async {
    final uri = baseUrl + updateProfileComponentUrl;
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': _token
    };

    var updateprofileEntity = {
      "id": _id,
      "userId": _userid,
      "firstName": null,
      "midddleName": null,
      "lastName": null,
      "mobileNumber": _mobilenumber,
      "email": _email,
      "fullName": _fullname,
      "addressId": 27,
      "genderTypeId": null,
      "dob": _dob,
      "bloodGroupTypeId": bloodGrop.typeCdDmtId,
      "height": 10,
      "feet":_feet,
      "inch":_inch,
      "weight": 55,
      "isDiabetic": isDiabetic,
      "isAlcohalic": isAlcohalic,
      "diseased": diseased,
      "hivPositive": hivPositive,
      "isAnyMajorSurgeries": isAnyMajorSurgeries,
      "emergencyContactId": null,
      "emergencyOptContactId": null,
      "address": null,
      "emergencyContact": null,
      "emergencyOptContact": null,
      "entity": {
        "listResult": [],
        "isSuccess": true,
        "affectedRecords": 0,
        "endUserMessage": "Get  Entity Details Successfull",
        "validationErrors": [],
        "exception": null
      },
      "createdBy": null,
      "updatedBy": null,
      "updatedDate": "2020-01-23T09:27:13.438996",
      "createdDate": "2020-01-23T09:27:13.438996"
    };
    // };

    String jsonBody = json.encode(updateprofileEntity);
    final encoding = Encoding.getByName('utf-8');
    print('---------------------------------------------------------');
    print('Post user profile API Request :  ' + jsonBody);
    print('---------------------------------------------------------');
    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    int statusCode = response.statusCode;

    String responseBody = response.body;
    print('---------------------------------------------------------');
    print('User profile Resoponce :' + responseBody);
    print('---------------------------------------------------------');
    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);
    }
    return statusCode;
  }

  Future<Map<String, dynamic>> getProfileinfo(
      String _userid, String _token) async {
    Map<String, dynamic> userresponce = new Map();
    String getProfileAPI = baseUrl + getProfileComponentUrl + _userid ;
    Response res = await get(getProfileAPI,
        headers: {'authorization': _token});
    print(' _token :::: --->> ' + _token);

    print(' get profile API :::: --->> ' + getProfileAPI);

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      userresponce = json.decode(responseBody);
      print('::: _getprofile :::: Success : 200');
      print('::: _getprofile :::: ' + userresponce.toString());

      return userresponce;
    } else if (statusCode == 401) {
      print('::: _getprofile :::: error : 401');
      userresponce = {'statusCode': 401};
      //getRefreshToken(refreshToken);

      return null;
    } else {
      print('::: _getprofile :::: error :' + statusCode.toString());
      userresponce = {'statusCode': statusCode};
      return null;
    }
  }

  Future<RefreshTokenModel> getRefreshToken(String refreshToken) async {
    RefreshTokenModel _refreshTokenResponce = RefreshTokenModel();

    final uri = baseUrl + refreshtokenCoponentURL;
    print('getRefreshToken' + uri);

    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "refreshToken": refreshToken,
      "clientId": "saveblood_spa",
      "clientSecret": null,
      "scope": "saveblood_api offline_access"
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    print('getRefreshToken Request body -->>  ' + jsonBody);

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    print("getRefreshToken  Responce:" + responseBody);
    if (statusCode == 200) {
      _refreshTokenResponce =
          RefreshTokenModel.fromJson(json.decode(responseBody));

      if (_refreshTokenResponce.result.accessToken != null) {
        pref.addStringToSF(
            LocalData.accessToken, _refreshTokenResponce.result.accessToken);
        pref.addStringToSF(
            LocalData.refreshtoken, _refreshTokenResponce.result.refreshToken);
      }
    } else {
      _refreshTokenResponce = new RefreshTokenModel();
    }

    return _refreshTokenResponce;
  }

  Future<int> postUserData2(String _token, PostUserInfoModel userInfo) async {
    final uri = baseUrl + updateProfileComponentUrl;
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': _token
    };

    String jsonBody = json.encode(userInfo.toJson());
    final encoding = Encoding.getByName('utf-8');
    print('---------------------------------------------------------');
    print('Post user profile API Request :  ' + jsonBody);
    print('---------------------------------------------------------');
    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    int statusCode = response.statusCode;

    String responseBody = response.body;
    print('---------------------------------------------------------');
    print('User profile Resoponce :' + responseBody);
    print('---------------------------------------------------------');
    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);
      bool code = parsedMAP['isSuccess'];
      if (code) {
        statusCode = 200;
      } else {
        statusCode = 400;
      }
    } else if (statusCode == 401) {
      statusCode = 401;
    }
    return statusCode;
  }
}
