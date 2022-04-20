// To parse this JSON data, do
//
//     final bloodInventoryModel = bloodInventoryModelFromJson(jsonString);

import 'dart:convert';

BloodInventoryModel bloodInventoryModelFromJson(String str) => BloodInventoryModel.fromJson(json.decode(str));

String bloodInventoryModelToJson(BloodInventoryModel data) => json.encode(data.toJson());

class BloodInventoryModel {
    List<ListResult> listResult;
    bool isSuccess;
    int affectedRecords;
    String endUserMessage;
    List<dynamic> validationErrors;
    dynamic exception;

    BloodInventoryModel({
        this.listResult,
        this.isSuccess,
        this.affectedRecords,
        this.endUserMessage,
        this.validationErrors,
        this.exception,
    });

    factory BloodInventoryModel.fromJson(Map<String, dynamic> json) => BloodInventoryModel(
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
    int oPositive;
    int oNegitive;
    int aPositive;
    int aNegitive;
    int bPositive;
    int bNegitive;
    int abPositive;
    int abNegitive;
    int bloodComponentTypeId;
    String bloodComponentTypeName;

    ListResult({
        this.oPositive,
        this.oNegitive,
        this.aPositive,
        this.aNegitive,
        this.bPositive,
        this.bNegitive,
        this.abPositive,
        this.abNegitive,
        this.bloodComponentTypeId,
        this.bloodComponentTypeName,
    });

    factory ListResult.fromJson(Map<String, dynamic> json) => ListResult(
        oPositive: json["oPositive"],
        oNegitive: json["oNegitive"],
        aPositive: json["aPositive"],
        aNegitive: json["aNegitive"],
        bPositive: json["bPositive"],
        bNegitive: json["bNegitive"],
        abPositive: json["abPositive"],
        abNegitive: json["abNegitive"],
        bloodComponentTypeId: json["bloodComponentTypeId"],
        bloodComponentTypeName: json["bloodComponentTypeName"],
    );

    Map<String, dynamic> toJson() => {
        "oPositive": oPositive,
        "oNegitive": oNegitive,
        "aPositive": aPositive,
        "aNegitive": aNegitive,
        "bPositive": bPositive,
        "bNegitive": bNegitive,
        "abPositive": abPositive,
        "abNegitive": abNegitive,
        "bloodComponentTypeId": bloodComponentTypeId,
        "bloodComponentTypeName": bloodComponentTypeName,
    };
}
