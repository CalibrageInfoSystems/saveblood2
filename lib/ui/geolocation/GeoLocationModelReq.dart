class GeoLocationModelReq {
  int id;
  String userId;
  double latitude;
  double longitude;
  String address;
  String postalCode;
  String createdBy;
  String updatedBy;
  String updatedDate;
  String createdDate;

  GeoLocationModelReq(
      {this.id,
        this.userId,
        this.latitude,
        this.longitude,
        this.address,
        this.postalCode,
        this.createdBy,
        this.updatedBy,
        this.updatedDate,
        this.createdDate});

  GeoLocationModelReq.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    postalCode = json['postalCode'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['postalCode'] = this.postalCode;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    data['createdDate'] = this.createdDate;
    return data;
  }
}