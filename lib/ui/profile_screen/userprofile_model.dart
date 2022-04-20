// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';

UserInfo userInfoFromJson(String str) => UserInfo.fromJson(json.decode(str));

String userInfoToJson(UserInfo data) => json.encode(data.toJson());

class UserInfo {
    int id;
    String userId;
    dynamic firstName;
    dynamic midddleName;
    dynamic lastName;
    String mobileNumber;
    String email;
    String fullName;
    int addressId;
    int genderTypeId;
    DateTime dob;
    int bloodGroupTypeId;
    double height;
    String feet;
  String inch;
    double weight;
    bool isDiabetic;
    bool isAlcohalic;
    bool diseased;
    bool hivPositive;
    bool isAnyMajorSurgeries;
    int emergencyContactId;
    int emergencyOptContactId;
    Address address;
    EmergencyContact emergencyContact;
    EmergencyContact emergencyOptContact;
    Entity entity;
    dynamic createdBy;
    String updatedBy;
    DateTime updatedDate;
    DateTime createdDate;

    UserInfo({
        this.id,
        this.userId,
        this.firstName,
        this.midddleName,
        this.lastName,
        this.mobileNumber,
        this.email,
        this.fullName,
        this.addressId,
        this.genderTypeId,
        this.dob,
        this.bloodGroupTypeId,
        this.height,
        this.feet,
    this.inch,
        this.weight,
        this.isDiabetic,
        this.isAlcohalic,
        this.diseased,
        this.hivPositive,
        this.isAnyMajorSurgeries,
        this.emergencyContactId,
        this.emergencyOptContactId,
        this.address,
        this.emergencyContact,
        this.emergencyOptContact,
        this.entity,
        this.createdBy,
        this.updatedBy,
        this.updatedDate,
        this.createdDate,
    });

    factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["id"],
        userId: json["userId"],
        firstName: json["firstName"],
        midddleName: json["midddleName"],
        lastName: json["lastName"],
        mobileNumber: json["mobileNumber"],
        email: json["email"],
        fullName: json["fullName"],
        addressId: json["addressId"],
        genderTypeId: json["genderTypeId"],
        dob:json["dob"] == null ? null : DateTime.parse(json["dob"] ),
        bloodGroupTypeId: json["bloodGroupTypeId"],
        height: json["height"] == null ? json["height"] :json["height"].toDouble(),
        weight: json["weight"] == null ? json["weight"] : json["weight"].toDouble(),
        feet: json["feet"] == null ? json["feet"] :json["feet"],
        inch: json["inch"] == null ? json["inch"] :json["inch"],
        isDiabetic: json["isDiabetic"],
        isAlcohalic: json["isAlcohalic"],
        diseased: json["diseased"],
        hivPositive: json["hivPositive"],
        isAnyMajorSurgeries: json["isAnyMajorSurgeries"],
        emergencyContactId: json["emergencyContactId"],
        emergencyOptContactId: json["emergencyOptContactId"],
        address:json["address"]== null? null : Address.fromJson(json["address"]),
        emergencyContact:json["emergencyContact"] == null ? null : EmergencyContact.fromJson(json["emergencyContact"]),
        emergencyOptContact:json["emergencyOptContact"] == null ? null: EmergencyContact.fromJson(json["emergencyOptContact"]),
        entity:json["entity"] == null ? null: Entity.fromJson(json["entity"]),
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        updatedDate: DateTime.parse(json["updatedDate"]),
        createdDate: DateTime.parse(json["createdDate"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "firstName": firstName,
        "midddleName": midddleName,
        "lastName": lastName,
        "mobileNumber": mobileNumber,
        "email": email,
        "fullName": fullName,
        "addressId": addressId,
        "genderTypeId": genderTypeId,
        "dob": dob.toIso8601String(),
        "bloodGroupTypeId": bloodGroupTypeId,
        "height": height,
        "feet" : feet,
        "inch" : inch,
        "weight": weight,
        "isDiabetic": isDiabetic,
        "isAlcohalic": isAlcohalic,
        "diseased": diseased,
        "hivPositive": hivPositive,
        "isAnyMajorSurgeries": isAnyMajorSurgeries,
        "emergencyContactId": emergencyContactId,
        "emergencyOptContactId": emergencyOptContactId,
        "address": address.toJson(),
        "emergencyContact": emergencyContact.toJson(),
        "emergencyOptContact": emergencyOptContact.toJson(),
        "entity": entity.toJson(),
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "updatedDate": updatedDate.toIso8601String(),
        "createdDate": createdDate.toIso8601String(),
    };
}

class Address {
 
    int stateId;
    int districtId;
    int mandalId;
    int addressId;
    String address1;
    String address2;
    String landmark;
    int villageId;
    int countryId;
    String createdBy;
    String updatedBy;
    DateTime updatedDate;
    DateTime createdDate;

    Address({
        this.stateId,
        this.districtId,
        this.mandalId,
        this.addressId,
        this.address1,
        this.address2,
        this.landmark,
        this.villageId,
        this.countryId,
        this.createdBy,
        this.updatedBy,
        this.updatedDate,
        this.createdDate,
    });

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        stateId: json["stateId"],
        districtId: json["districtId"],
        mandalId: json["mandalId"],
        addressId: json["addressId"],
        address1: json["address1"],
        address2: json["address2"],
        landmark: json["landmark"],
        villageId: json["villageId"],
        countryId: json["countryId"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        updatedDate: DateTime.parse(json["updatedDate"]),
        createdDate: DateTime.parse(json["createdDate"]),
    );

    Map<String, dynamic> toJson() => {
        "stateId": stateId,
        "districtId": districtId,
        "mandalId": mandalId,
        "addressId": addressId,
        "address1": address1,
        "address2": address2,
        "landmark": landmark,
        "villageId": villageId,
        "countryId": countryId,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "updatedDate": updatedDate.toIso8601String(),
        "createdDate": createdDate.toIso8601String(),
    };
}

class EmergencyContact {
    int contactId;
    String name;
    String contactNumber;
    String relationship;
    String createdBy;
    String updatedBy;
    DateTime updatedDate;
    DateTime createdDate;

    EmergencyContact({
        this.contactId,
        this.name,
        this.contactNumber,
        this.relationship,
        this.createdBy,
        this.updatedBy,
        this.updatedDate,
        this.createdDate,
    });

    factory EmergencyContact.fromJson(Map<String, dynamic> json) => EmergencyContact(
        contactId: json["contactId"],
        name: json["name"],
        contactNumber: json["contactNumber"],
        relationship: json["relationship"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        updatedDate: DateTime.parse(json["updatedDate"]),
        createdDate: DateTime.parse(json["createdDate"]),
    );

    Map<String, dynamic> toJson() => {
        "contactId": contactId,
        "name": name,
        "contactNumber": contactNumber,
        "relationship": relationship,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "updatedDate": updatedDate.toIso8601String(),
        "createdDate": createdDate.toIso8601String(),
    };
}

class Entity {
    List<dynamic> listResult;
    bool isSuccess;
    int affectedRecords;
    String endUserMessage;
    List<dynamic> validationErrors;
    dynamic exception;

    Entity({
        this.listResult,
        this.isSuccess,
        this.affectedRecords,
        this.endUserMessage,
        this.validationErrors,
        this.exception,
    });

    factory Entity.fromJson(Map<String, dynamic> json) => Entity(
        listResult: List<dynamic>.from(json["listResult"].map((x) => x)),
        isSuccess: json["isSuccess"],
        affectedRecords: json["affectedRecords"],
        endUserMessage: json["endUserMessage"],
        validationErrors: List<dynamic>.from(json["validationErrors"].map((x) => x)),
        exception: json["exception"],
    );

    Map<String, dynamic> toJson() => {
        "listResult": List<dynamic>.from(listResult.map((x) => x)),
        "isSuccess": isSuccess,
        "affectedRecords": affectedRecords,
        "endUserMessage": endUserMessage,
        "validationErrors": List<dynamic>.from(validationErrors.map((x) => x)),
        "exception": exception,
    };
}
