// To parse this JSON data, do
//
//     final postUserInfoModel = postUserInfoModelFromJson(jsonString);

import 'dart:convert';

PostUserInfoModel postUserInfoModelFromJson(String str) => PostUserInfoModel.fromJson(json.decode(str));

String postUserInfoModelToJson(PostUserInfoModel data) => json.encode(data.toJson());

class PostUserInfoModel {
    int id;
    String userId;
    String fullName;
    dynamic firstName;
    dynamic lastName;
    String mobileNumber;
    String email;
    int addressId;
    int genderTypeId;
    DateTime dob;
    int bloodGroupTypeId;
    int height;
    int weight;
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
    String createdBy;
    String updatedBy;
    DateTime updatedDate;
    DateTime createdDate;

    PostUserInfoModel({
        this.id,
        this.userId,
        this.fullName,
        this.firstName,
        this.lastName,
        this.mobileNumber,
        this.email,
        this.addressId,
        this.genderTypeId,
        this.dob,
        this.bloodGroupTypeId,
        this.height,
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
        this.createdBy,
        this.updatedBy,
        this.updatedDate,
        this.createdDate,
    });

    factory PostUserInfoModel.fromJson(Map<String, dynamic> json) => PostUserInfoModel(
        id: json["id"],
        userId: json["userId"],
        fullName: json["fullName"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        mobileNumber: json["mobileNumber"],
        email: json["email"],
        addressId: json["addressId"],
        genderTypeId: json["genderTypeId"],
        dob: DateTime.parse(json["dob"]),
        bloodGroupTypeId: json["bloodGroupTypeId"],
        height: json["height"],
        weight: json["weight"],
        isDiabetic: json["isDiabetic"],
        isAlcohalic: json["isAlcohalic"],
        diseased: json["diseased"],
        hivPositive: json["hivPositive"],
        isAnyMajorSurgeries: json["isAnyMajorSurgeries"],
        emergencyContactId: json["emergencyContactId"],
        emergencyOptContactId: json["emergencyOptContactId"],
        address: Address.fromJson(json["address"]),
        emergencyContact: EmergencyContact.fromJson(json["emergencyContact"]),
        emergencyOptContact: EmergencyContact.fromJson(json["emergencyOptContact"]),
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        updatedDate: DateTime.parse(json["updatedDate"]),
        createdDate: DateTime.parse(json["createdDate"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "fullName": fullName,
        "firstName": firstName,
        "lastName": lastName,
        "mobileNumber": mobileNumber,
        "email": email,
        "addressId": addressId,
        "genderTypeId": genderTypeId,
        "dob": dob.toIso8601String(),
        "bloodGroupTypeId": bloodGroupTypeId,
        "height": height,
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
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "updatedDate": updatedDate.toIso8601String(),
        "createdDate": createdDate.toIso8601String(),
    };

    
}

class Address {
    int addressId;
    String address1;
    String address2;
    String landmark;
    int countryId;
    int villageId;
    String createdBy;
    String updatedBy;
    DateTime updatedDate;
    DateTime createdDate;

    Address({
        this.addressId,
        this.address1,
        this.address2,
        this.landmark,
        this.countryId,
        this.villageId,
        this.createdBy,
        this.updatedBy,
        this.updatedDate,
        this.createdDate,
    });

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        addressId: json["addressId"],
        address1: json["address1"],
        address2: json["address2"],
        landmark: json["landmark"],
        countryId: json["countryId"],
        villageId: json["villageId"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        updatedDate: DateTime.parse(json["updatedDate"]),
        createdDate: DateTime.parse(json["createdDate"]),
    );

    Map<String, dynamic> toJson() => {
        "addressId": addressId,
        "address1": address1,
        "address2": address2,
        "landmark": landmark,
        "countryId": countryId,
        "villageId": villageId,
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
