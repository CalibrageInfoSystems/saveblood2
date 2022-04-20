// To parse this JSON data, do
//
//     final citylatlong = citylatlongFromJson(jsonString);

import 'dart:convert';

Citylatlong citylatlongFromJson(String str) => Citylatlong.fromJson(json.decode(str));

String citylatlongToJson(Citylatlong data) => json.encode(data.toJson());

class Citylatlong {
    Result result;
    bool isSuccess;
    int affectedRecords;
    String endUserMessage;
    List<dynamic> validationErrors;
    dynamic exception;

    Citylatlong({
        this.result,
        this.isSuccess,
        this.affectedRecords,
        this.endUserMessage,
        this.validationErrors,
        this.exception,
    });

    factory Citylatlong.fromJson(Map<String, dynamic> json) => Citylatlong(
        result: Result.fromJson(json["result"]),
        isSuccess: json["isSuccess"],
        affectedRecords: json["affectedRecords"],
        endUserMessage: json["endUserMessage"],
        validationErrors: List<dynamic>.from(json["validationErrors"].map((x) => x)),
        exception: json["exception"],
    );

    Map<String, dynamic> toJson() => {
        "result": result.toJson(),
        "isSuccess": isSuccess,
        "affectedRecords": affectedRecords,
        "endUserMessage": endUserMessage,
        "validationErrors": List<dynamic>.from(validationErrors.map((x) => x)),
        "exception": exception,
    };
}

class Result {
    String formattedAddress;
    Geometry geometry;

    Result({
        this.formattedAddress,
        this.geometry,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        formattedAddress: json["formatted_address"],
        geometry: Geometry.fromJson(json["geometry"]),
    );

    Map<String, dynamic> toJson() => {
        "formatted_address": formattedAddress,
        "geometry": geometry.toJson(),
    };
}

class Geometry {
    Location location;

    Geometry({
        this.location,
    });

    factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: Location.fromJson(json["location"]),
    );

    Map<String, dynamic> toJson() => {
        "location": location.toJson(),
    };
}

class Location {
    double lat;
    double lng;

    Location({
        this.lat,
        this.lng,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
    };
}
