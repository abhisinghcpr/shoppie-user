// //
// // class UserModel {
// //   final String uId;
// //   final String username;
// //   final String email;
// //   final String? phone;
// //   final String userImg;
// //   final String userDeviceToken;
// //   final dynamic createdOn;
// //   final String city;
// //
// //   UserModel({
// //     required this.uId,
// //     required this.username,
// //     required this.email,
// //      this.phone,
// //     required this.userImg,
// //     required this.userDeviceToken,
// //     required this.createdOn,
// //     required this.city,
// //   });
// //
// //   Map<String, dynamic> toMap() {
// //     return {
// //       'uId': uId,
// //       'username': username,
// //       'email': email,
// //       'phone': phone,
// //       'userImg': userImg,
// //       'userDeviceToken': userDeviceToken,
// //       'createdOn': createdOn,
// //       'city': city,
// //     };
// //   }
// //
// //
// //   factory UserModel.fromMap(Map<String, dynamic> json) {
// //     return UserModel(
// //       uId: json['uId'],
// //       username: json['username'],
// //       email: json['email'],
// //       phone: json['phone'],
// //       userImg: json['userImg'],
// //       userDeviceToken: json['userDeviceToken'],
// //       createdOn: json['createdOn'].toString(),
// //       city: json['city'],
// //     );
// //   }
// // }
// //
// //
// // ignore_for_file: file_names
//
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class UserModel {
//   final String uId;
//   final String username;
//   final String email;
//   final String phone;
//   final String userImg;
//   final String? userDeviceToken;
//   final String? country;
//   final String? userAddress;
//   final String? street;
//   final bool isAdmin;
//   final bool isActive;
//   //final DateTime? createdOn;
//   final String? city;
//
//   UserModel({
//     required this.uId,
//     required this.username,
//     required this.email,
//     required this.phone,
//     required this.userImg,
//
//     this.userDeviceToken,
//     this.country,
//     this.userAddress,
//     this.street,
//     this.isAdmin = false,
//     this.isActive = true,
//     //this.createdOn,
//     this.city,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'uId': uId,
//       'username': username,
//       'email': email,
//       'phone': phone,
//       'userImg': userImg,
//       'userDeviceToken': userDeviceToken,
//       'country': country,
//       'userAddress': userAddress,
//       'street': street,
//       'isAdmin': isAdmin,
//       'isActive': isActive,
//       //'createdOn': createdOn != null ? Timestamp.fromDate(createdOn!) : null,
//       'city': city,
//     };
//   }
//
//   factory UserModel.fromMap(Map<String, dynamic> json) {
//     return UserModel(
//       uId: json['uId'] ?? '',
//       username: json['username'] ?? '',
//       email: json['email'] ?? '',
//       phone: json['phone'] ?? '',
//       userImg: json['userImg'] ?? '',
//       userDeviceToken: json['userDeviceToken'],
//       country: json['country'],
//       userAddress: json['userAddress'],
//       street: json['street'],
//       isAdmin: json['isAdmin'] ?? false,
//       isActive: json['isActive'] ?? true,
//       // createdOn: json['createdOn'] is Timestamp
//       //     ? (json['createdOn'] as Timestamp).toDate()
//       //     : null,
//       city: json['city'],
//     );
//   }
// }

class UserModel {
  final String uId;
  final String username;
  final String email;
  final String phone;
  final String userImg;
  final String? userDeviceToken;
  final String? country;
  final String? userAddress;
  final String? street;
  final bool isAdmin;
  final bool isActive;
  final String? city;

  UserModel({
    required this.uId,
    required this.username,
    required this.email,
    required this.phone,
    required this.userImg,
    this.userDeviceToken,
    this.country,
    this.userAddress,
    this.street,
    this.isAdmin = false,
    this.isActive = true,
    this.city,
  });

  // Convert UserModel to Map
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'username': username,
      'email': email,
      'phone': phone,
      'userImg': userImg,
      'userDeviceToken': userDeviceToken,
      'country': country,
      'userAddress': userAddress,
      'street': street,
      'isAdmin': isAdmin,
      'isActive': isActive,
      'city': city,
    };
  }

  // Create UserModel from Map
  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      uId: json['uId'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      userImg: json['userImg'] ?? '',
      userDeviceToken: json['userDeviceToken'],
      country: json['country'],
      userAddress: json['userAddress'],
      street: json['street'],
      isAdmin: json['isAdmin'] ?? false,
      isActive: json['isActive'] ?? true,
      city: json['city'],
    );
  }
}
