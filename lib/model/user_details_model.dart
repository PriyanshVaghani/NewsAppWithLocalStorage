import 'package:json_annotation/json_annotation.dart';
part 'user_details_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: "Id")
  int? id;

  @JsonKey(name: "UserName")
  String userName;

  @JsonKey(name: "MobileNumber")
  String mobileNumber;

  @JsonKey(name: "Email")
  String email;

  @JsonKey(name: "ProfileImage")
  String profileImage;

  UserModel({
    required this.userName,
    required this.mobileNumber,
    required this.email,
    this.profileImage = "",
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

// this command for generate g.dart file
//  flutter packages pub run build_runner build
//
// this command for generate g.dart file and auto update file
//  flutter packages pub run build_runner watch

// if there is config
// flutter packages pub run build_runner build --delete-conflicting-outputs
