import 'dart:convert';
import 'dart:math';

import 'package:flutter_logindemo/ui/home/city_info_model.dart';
import 'package:flutter_logindemo/ui/home/city_model.dart';
import 'package:http/http.dart';

import '../api_config.dart';
import 'city_latlong.dart';

class BackendService {
  static Future<List> getSuggestions(String query) async {
    await Future.delayed(Duration(seconds: 1));

    return List.generate(3, (index) {
      return {'name': query + index.toString(), 'price': Random().nextInt(100)};
    });
  }
}

class CitiesService {
  static final List<String> cities = [
    'Beirut',
    'Damascus',
    'San Fransisco',
    'Rome',
    'Los Angeles',
    'Madrid',
    'Bali',
    'Barcelona',
    'Paris',
    'Bucharest',
    'New York City',
    'Philadelphia',
    'Sydney',
  ];

  static Future<List<CityModel>> getSuggestions(String query) async {
    List<CityModel> citysmodel = [];

    print("query -> " + query);

    if (query != null) {
      Response res = await get(
        baseUrl + getGeolocationsGeoPlaces + query,
      );

      print("query -> " + baseUrl + getGeolocationsGeoPlaces + query);

      int statusCode = res.statusCode;
      String responseBody = res.body;
      print("responseBody -> " + responseBody);

      print("statusCode -> " + statusCode.toString());

      if (statusCode == 200) {
        var responce = json.decode(responseBody);
        CityinfoModel userinfo = CityinfoModel.fromJson(responce);
        if (userinfo != null &&
            userinfo.listResult != null &&
            userinfo.listResult.length > 0) {
          for (int i = 0; i < userinfo.listResult.length; i++) {
            citysmodel.add(new CityModel(userinfo.listResult[i].description,
                userinfo.listResult[i].placeId));
          }
        }
        print('::: getLocationsInfo :::: Success : 200');
        return citysmodel;
      } else {
        print('::: getLocationsInfo :::: Success : 100');
        return citysmodel;
      }
    } else {
      print('::: getLocationsInfo :::: Success : 300');
      return citysmodel;
    }
  }

  static Future<Citylatlong> getlatlongfromplaceid(String placeid) async {
    Response res = await get(
      baseUrl + getGeolocationslatlong + placeid,
    );

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      var responce = json.decode(responseBody);
      Citylatlong cityinfo = Citylatlong.fromJson(responce);

      print('::: getLocationsInfo :::: Success : 200');

      return cityinfo;
    } else {
      return null;
    }
  }
}
