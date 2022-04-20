// To parse this JSON data, do
//
//     final eventsinfomodel = eventsinfomodelFromJson(jsonString);

import 'dart:convert';

Eventsinfomodel eventsinfomodelFromJson(String str) => Eventsinfomodel.fromJson(json.decode(str));

String eventsinfomodelToJson(Eventsinfomodel data) => json.encode(data.toJson());

class Eventsinfomodel {
    List<ListResult> listResult;
    bool isSuccess;
    int affectedRecords;
    String endUserMessage;
    List<dynamic> validationErrors;
    dynamic exception;

    Eventsinfomodel({
        this.listResult,
        this.isSuccess,
        this.affectedRecords,
        this.endUserMessage,
        this.validationErrors,
        this.exception,
    });

    factory Eventsinfomodel.fromJson(Map<String, dynamic> json) => Eventsinfomodel(
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
    String address1;
    String address2;
    String landmark;
    int countryId;
    String countryName;
    int stateId;
    String stateName;
    int districtId;
    String districtName;
    int mandalId;
    String mandalName;
    int villageId;
    String villageName;
    String fullAddress;
    String bloodBankName;
    int id;
    String name;
    int entityId;
    int addressId;
    DateTime fromDate;
    DateTime toDate;
    String fromTime;
    String toTime;
    String comments;
    String createdBy;
    DateTime createdDate;
    String updatedBy;
    DateTime updatedDate;
    dynamic stockEventId;

    ListResult({
        this.address1,
        this.address2,
        this.landmark,
        this.countryId,
        this.countryName,
        this.stateId,
        this.stateName,
        this.districtId,
        this.districtName,
        this.mandalId,
        this.mandalName,
        this.villageId,
        this.villageName,
        this.fullAddress,
        this.bloodBankName,
        this.id,
        this.name,
        this.entityId,
        this.addressId,
        this.fromDate,
        this.toDate,
        this.fromTime,
        this.toTime,
        this.comments,
        this.createdBy,
        this.createdDate,
        this.updatedBy,
        this.updatedDate,
        this.stockEventId,
    });

    factory ListResult.fromJson(Map<String, dynamic> json) => ListResult(
        address1: json["address1"],
        address2: json["address2"],
        landmark: json["landmark"],
        countryId: json["countryId"],
        countryName: json["countryName"],
        stateId: json["stateId"],
        stateName: json["stateName"],
        districtId: json["districtId"],
        districtName: json["districtName"],
        mandalId: json["mandalId"],
        mandalName: json["mandalName"],
        villageId: json["villageId"],
        villageName: json["villageName"],
        fullAddress : json["fullAddress"],
        bloodBankName: json["bloodBankName"],
        id: json["id"],
        name: json["name"],
        entityId: json["entityId"],
        addressId: json["addressId"],
        fromDate: DateTime.parse(json["fromDate"]),
        toDate: DateTime.parse(json["toDate"]),
        fromTime: json["fromTime"],
        toTime: json["toTime"],
        comments: json["comments"],
        createdBy: json["createdBy"],
        createdDate: DateTime.parse(json["createdDate"]),
        updatedBy: json["updatedBy"],
        updatedDate: DateTime.parse(json["updatedDate"]),
        stockEventId: json["stock_EventId"],
    );

    Map<String, dynamic> toJson() => {
        "address1": address1,
        "address2": address2,
        "landmark": landmark,
        "countryId": countryId,
        "countryName": countryName,
        "stateId": stateId,
        "stateName": stateName,
        "districtId": districtId,
        "districtName": districtName,
        "mandalId": mandalId,
        "mandalName": mandalName,
        "villageId": villageId,
        "villageName": villageName,
        "fullAddress" : fullAddress,
        "bloodBankName": bloodBankName,
        "id": id,
        "name": name,
        "entityId": entityId,
        "addressId": addressId,
        "fromDate": fromDate.toIso8601String(),
        "toDate": toDate.toIso8601String(),
        "fromTime": fromTime,
        "toTime": toTime,
        "comments": comments,
        "createdBy": createdBy,
        "createdDate": createdDate.toIso8601String(),
        "updatedBy": updatedBy,
        "updatedDate": updatedDate.toIso8601String(),
        "stock_EventId": stockEventId,
    };
}
