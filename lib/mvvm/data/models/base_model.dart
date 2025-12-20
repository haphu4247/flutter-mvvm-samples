import 'package:equatable/equatable.dart';

/// Base class for all data models in the application.
///
/// Provides a common interface for JSON serialization and deserialization.
/// All model classes should extend this base class and implement the required methods.
///
/// Example usage:
/// ```dart
/// class MyModel extends BaseModel {
///   final String? name;
///   final int? id;
///
///   MyModel({this.name, this.id});
///
///   factory MyModel.fromJson(Map<String, dynamic> json) {
///     return MyModel(
///       name: BaseModel.parseString(json['name']),
///       id: BaseModel.parseInt(json['id']),
///     );
///   }
///
///   @override
///   Map<String, dynamic> toJson() {
///     return {
///       'name': name,
///       'id': id,
///     };
///   }
/// }
/// ```
abstract class BaseModel extends Equatable {
  const BaseModel();

  /// Converts the model instance to a JSON map.
  ///
  /// Subclasses must implement this method to serialize their specific fields.
  Map<String, dynamic> toJson();

  @override
  List<Object> get props => toJson().entries.toList();

  /// Helper method to safely parse an integer from JSON.
  /// Returns null if the value is null or cannot be converted.
  static int? parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// Helper method to safely parse a double from JSON.
  /// Returns null if the value is null or cannot be converted.
  static double? parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Helper method to safely parse a boolean from JSON.
  /// Returns null if the value is null or cannot be converted.
  static bool? parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    if (value is num) return value != 0;
    return null;
  }

  /// Helper method to safely parse a string from JSON.
  /// Returns null if the value is null or cannot be converted.
  static String? parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  /// Helper method to safely parse a DateTime from JSON.
  /// Supports both ISO 8601 strings and Unix timestamps (seconds or milliseconds).
  /// Returns null if the value is null or cannot be converted.
  static DateTime? parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    if (value is num) {
      // Try as milliseconds first, then seconds
      final timestamp = value.toInt();
      if (timestamp > 1000000000000) {
        // Likely milliseconds
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else {
        // Likely seconds
        return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      }
    }
    return null;
  }

  /// Helper method to parse a list from JSON.
  /// Returns an empty list if the value is null or not a list.
  static List<T> parseList<T>(dynamic value, T Function(dynamic) parser) {
    if (value == null) return [];
    if (value is! List) return [];
    return value.map((item) => parser(item)).toList();
  }

  /// Helper method to parse a nested model from JSON.
  /// Returns null if the value is null or not a map.
  static T? parseModel<T extends BaseModel>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value == null) return null;
    if (value is! Map<String, dynamic>) return null;
    return fromJson(value);
  }
}
