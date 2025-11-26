import 'package:flutter_mvvm_samples/mvvm/data/models/base_model.dart';

class LoginResponse extends BaseModel {
  const LoginResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.image,
    required this.accessToken,
    required this.refreshToken,
  });

  final int? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? image;
  final String? accessToken;
  final String? refreshToken;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: BaseModel.parseInt(json['id']),
      username: BaseModel.parseString(json['username']),
      email: BaseModel.parseString(json['email']),
      firstName: BaseModel.parseString(json['firstName']),
      lastName: BaseModel.parseString(json['lastName']),
      gender: BaseModel.parseString(json['gender']),
      image: BaseModel.parseString(json['image']),
      accessToken: BaseModel.parseString(json['accessToken']),
      refreshToken: BaseModel.parseString(json['refreshToken']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'image': image,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
