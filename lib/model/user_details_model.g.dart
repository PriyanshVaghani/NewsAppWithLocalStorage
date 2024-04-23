// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userName: json['UserName'] as String,
      mobileNumber: json['MobileNumber'] as String,
      email: json['Email'] as String,
      profileImage: json['ProfileImage'] as String? ?? "",
    )..id = json['Id'] as int?;

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'Id': instance.id,
      'UserName': instance.userName,
      'MobileNumber': instance.mobileNumber,
      'Email': instance.email,
      'ProfileImage': instance.profileImage,
    };
