// To parse this JSON data, do
//
//     final cityinfoModel = cityinfoModelFromJson(jsonString);

import 'dart:convert';

CityinfoModel cityinfoModelFromJson(String str) => CityinfoModel.fromJson(json.decode(str));

String cityinfoModelToJson(CityinfoModel data) => json.encode(data.toJson());

class CityinfoModel {
    List<ListResult> listResult;
    bool isSuccess;
    int affectedRecords;
    String endUserMessage;
    List<dynamic> validationErrors;
    dynamic exception;

    CityinfoModel({
        this.listResult,
        this.isSuccess,
        this.affectedRecords,
        this.endUserMessage,
        this.validationErrors,
        this.exception,
    });

    factory CityinfoModel.fromJson(Map<String, dynamic> json) => CityinfoModel(
        listResult: List<ListResult>.from(json["listResult"].map((x) => ListResult.fromJson(x))),
        isSuccess: json["isSuccess"],
        affectedRecords: json["affectedRecords"],
        endUserMessage: json["endUserMessage"],
        validationErrors: List<dynamic>.from(json["validationErrors"].map((x) => x)),
        exception: json["exception"],
    );

    Map<String, dynamic> toJson() => {
        "listResult": List<dynamic>.from(listResult.map((x) => x.toJson())),
        "isSuccess": isSuccess,
        "affectedRecords": affectedRecords,
        "endUserMessage": endUserMessage,
        "validationErrors": List<dynamic>.from(validationErrors.map((x) => x)),
        "exception": exception,
    };
}

class ListResult {
    String description;
    String id;
    String placeId;
    String reference;
    List<String> types;

    ListResult({
        this.description,
        this.id,
        this.placeId,
        this.reference,
        this.types,
    });

    factory ListResult.fromJson(Map<String, dynamic> json) => ListResult(
        description: json["description"],
        id: json["id"],
        placeId: json["place_id"],
        reference: json["reference"],
        types: List<String>.from(json["types"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "description": description,
        "id": id,
        "place_id": placeId,
        "reference": reference,
        "types": List<dynamic>.from(types.map((x) => x)),
    };
}
