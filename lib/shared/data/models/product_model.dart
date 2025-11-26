import 'package:flutter_mvvm_samples/mvvm/data/models/base_model.dart';

class PostModel extends BaseModel {
  final String? id;
  final String? title;
  final String? body;

  const PostModel({
    required this.id,
    required this.title,
    required this.body,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: BaseModel.parseString(json['id']),
      title: BaseModel.parseString(json['title']) ?? '',
      body: BaseModel.parseString(json['body']) ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
    };
  }
}
