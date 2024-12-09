import 'dart:convert';

class UserModel {
  String? uid;
  String? name;
  String? imageUrl = "";
  String? email;
  String? phone;
  String? userType;
  bool? isBlocked;

  UserModel({
    this.name,
    this.uid,
    this.email,
    this.imageUrl,
    this.phone,
    this.isBlocked = false,
    this.userType = "user",
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'uid': uid,
      'email': email,
      'phone': phone,
      'imageUrl': imageUrl,
      'userType': userType,
      "isBlocked": isBlocked,
    };
  }

  static UserModel initialUser = UserModel(
    email: "",
    name: "",
    phone: "",
    imageUrl: "",
    uid: "",
    userType: "user",
    isBlocked: false,
  );

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String?,
      uid: map['uid'] as String?,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      imageUrl: map['imageUrl'] as String?,
      userType: map['userType'] as String?,
      isBlocked: map['isBlocked'] as bool?,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
