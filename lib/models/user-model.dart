
class UserModel {
  final String uId;
  final String username;
  final String email;
  final String? phone;
  final String userImg;
  final String userDeviceToken;
  final dynamic createdOn;
  final String city;

  UserModel({
    required this.uId,
    required this.username,
    required this.email,
     this.phone,
    required this.userImg,
    required this.userDeviceToken,
    required this.createdOn,
    required this.city,
  });

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'username': username,
      'email': email,
      'phone': phone,
      'userImg': userImg,
      'userDeviceToken': userDeviceToken,
      'createdOn': createdOn,
      'city': city,
    };
  }


  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      uId: json['uId'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      userImg: json['userImg'],
      userDeviceToken: json['userDeviceToken'],
      createdOn: json['createdOn'].toString(),
      city: json['city'],
    );
  }
}


