// To parse this JSON data, do
//
//     final notificationsResponse = notificationsResponseFromJson(jsonString);

import 'dart:convert';

NotificationsResponse notificationsResponseFromJson(String str) =>
    NotificationsResponse.fromJson(json.decode(str));

String notificationsResponseToJson(NotificationsResponse data) {
  final dyn = data.toJson();
  dyn.removeWhere((key, value) => value == null || value.toString().isEmpty);
  return json.encode(dyn);
}

class NotificationsResponse {
  List<ListResult> listResult;
  bool isSuccess;
  int affectedRecords;
  String endUserMessage;
  List<dynamic> validationErrors;
  String exception;

  NotificationsResponse({
    this.listResult,
    this.isSuccess,
    this.affectedRecords,
    this.endUserMessage,
    this.validationErrors,
    this.exception,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) =>
      NotificationsResponse(
        listResult: List<ListResult>.from(
            json["listResult"].map((x) => ListResult.fromJson(x))),
        isSuccess: json["isSuccess"],
        affectedRecords: json["affectedRecords"],
        endUserMessage: json["endUserMessage"],
        validationErrors:
            List<dynamic>.from(json["validationErrors"].map((x) => x)),
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
  int entityId;
  String entityName;
  int entityTypeId;
  String entityType;
  String createdByUserName;
  int id;
  String userId;
  int requestId;
  dynamic isAccepted;
  bool isRead;
  int notificationTypeId;
  String responsedUnits;
  String comments;
  String text;
  String createdBy;
  String updatedBy;
  DateTime createdDate;
  DateTime updatedDate;

  ListResult({
    this.entityId,
    this.entityName,
    this.entityTypeId,
    this.entityType,
    this.createdByUserName,
    this.id,
    this.userId,
    this.requestId,
    this.isAccepted,
    this.isRead,
    this.notificationTypeId,
    this.responsedUnits,
    this.comments,
    this.text,
    this.createdBy,
    this.updatedBy,
    this.createdDate,
    this.updatedDate,
  });

  factory ListResult.fromJson(Map<String, dynamic> json) => ListResult(
        entityId: json["entityId"],
        entityName: json["entityName"],
        entityTypeId: json["entityTypeId"],
        entityType: json["entityType"],
        createdByUserName: json["createdByUserName"],
        id: json["id"],
        userId: json["userId"],
        requestId: json["requestId"],
        isAccepted: json["isAccepted"],
        isRead: json["isRead"],
        notificationTypeId: json["notificationTypeId"],
        responsedUnits:
            json["responsedUnits"] == null ? null : json["responsedUnits"],
        comments: json["comments"] == null ? null : json["comments"],
        text: json["text"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        createdDate: DateTime.parse(json["createdDate"]),
        updatedDate: DateTime.parse(json["updatedDate"]),
      );

  Map<String, dynamic> toJson() => {
        "entityId": entityId,
        "entityName": entityName,
        "entityTypeId": entityTypeId,
        "entityType": entityType,
        "createdByUserName": createdByUserName,
        "id": id,
        "userId": userId,
        "requestId": requestId,
        "isAccepted": isAccepted,
        "isRead": isRead,
        "notificationTypeId": notificationTypeId,
        "responsedUnits": responsedUnits == null ? null : responsedUnits,
        "comments": comments == null ? null : comments,
        "text": text,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "createdDate": createdDate.toIso8601String(),
        "updatedDate": updatedDate.toIso8601String(),
      };
}
