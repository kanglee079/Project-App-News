import 'dart:convert';

class UserModel {
  String? id;
  String? displayName;
  String? email;
  String? photoUrl;
  DateTime? dateTime;
  String? gender;
  String? phoneNumber;
  String? address;

  UserModel({
    this.id,
    this.displayName,
    this.email,
    this.photoUrl,
    this.dateTime,
    this.gender,
    this.phoneNumber,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl ??
          "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png",
      'dateTime': dateTime?.millisecondsSinceEpoch,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      displayName: map['displayName'],
      email: map['email'],
      photoUrl: map['photoUrl'],
      dateTime: map['dateTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateTime'])
          : null,
      gender: map['gender'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
