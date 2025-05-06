library diff;

import 'package:collection/collection.dart';
part 'diff_array.dart';
part 'diff_map.dart';
part 'default_equals.dart';

/// This file defines the core diff library, including the Diff abstract class and its concrete implementations.
/// It provides a unified interface for representing and applying changes (diffs) between collections such as lists and maps.

/// The base class for all diff operations.
///
/// Subclasses represent specific types of changes: Update, Addition, Deletion, and Movement.
abstract class Diff {
  const Diff();

  /// Computes the list of diffs required to transform [left] into [right].
  ///
  /// Supports List and Map types. Throws [UnimplementedError] for unsupported types.
  static List<Diff> between(dynamic left, dynamic right) {
    if ((left is List && (right is List || right == null)) ||
        (right is List && (left is List || left == null))) {
      return (left ?? []).diffTo(right ?? []);
    } else if ((left is Map && (right is Map || right == null)) ||
        (right is Map && (left is Map || left == null))) {
      return (left ?? {}).diffTo(right ?? {});
    }
    throw UnimplementedError();
  }

  /// Creates a [Diff] instance from a JSON map.
  factory Diff.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'update':
        return Update.fromJson(json);
      case 'addition':
        return Addition.fromJson(json);
      case 'deletion':
        return Deletion.fromJson(json);
      case 'movement':
        return Movement.fromJson(json);
      default:
        throw UnimplementedError();
    }
  }

  /// Converts this [Diff] instance to a JSON map.
  Map<String, dynamic> toJson() {
    if (this is Update) {
      return (this as Update).toJson();
    } else if (this is Addition) {
      return (this as Addition).toJson();
    } else if (this is Deletion) {
      return (this as Deletion).toJson();
    } else if (this is Movement) {
      return (this as Movement).toJson();
    }
    throw UnimplementedError();
  }
}

/// Represents an update operation in a diff.
class Update extends Diff {
  final dynamic key;
  final dynamic newValue;

  const Update(this.key, this.newValue);

  /// Creates an [Update] from a JSON map.
  factory Update.fromJson(Map<String, dynamic> json) =>
      Update(json['key'], json['newValue']);

  @override
  Map<String, dynamic> toJson() =>
      {'type': 'update', 'key': key, 'newValue': newValue};

  @override
  String toString() {
    return "Update($key, $newValue)";
  }
}

/// Represents a movement operation in a diff (for lists).
class Movement extends Diff {
  final dynamic oldKey;
  final dynamic newKey;

  const Movement(this.oldKey, this.newKey);

  /// Creates a [Movement] from a JSON map.
  factory Movement.fromJson(Map<String, dynamic> json) =>
      Movement(json['oldKey'], json['newKey']);

  @override
  Map<String, dynamic> toJson() =>
      {'type': 'movement', 'oldKey': oldKey, 'newKey': newKey};

  @override
  String toString() {
    return "Movement($oldKey, $newKey)";
  }
}

/// Represents an addition operation in a diff.
class Addition extends Diff {
  final dynamic key;
  final dynamic value;

  const Addition(this.key, this.value);

  /// Creates an [Addition] from a JSON map.
  factory Addition.fromJson(Map<String, dynamic> json) =>
      Addition(json['key'], json['value']);

  @override
  Map<String, dynamic> toJson() =>
      {'type': 'addition', 'key': key, 'value': value};

  @override
  String toString() {
    return "Addition($key, $value)";
  }
}

/// Represents a deletion operation in a diff.
class Deletion extends Diff {
  final dynamic key;

  const Deletion(this.key);

  /// Creates a [Deletion] from a JSON map.
  factory Deletion.fromJson(Map<String, dynamic> json) => Deletion(json['key']);

  @override
  Map<String, dynamic> toJson() => {'type': 'deletion', 'key': key};

  @override
  String toString() {
    return "Deletion($key)";
  }
}
