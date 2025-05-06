library diff;

import 'package:collection/collection.dart';
part 'diff_array.dart';
part 'diff_map.dart';
part 'default_equals.dart';

/// This file defines the core diff library, including the Diff abstract class and its concrete implementations.
/// It provides a unified interface for representing and applying changes (diffs) between collections such as lists and maps.

/// Abstract base class for all diff operations.
///
/// Subclasses represent specific types of changes: Update, Addition, Deletion, and Movement.
abstract class Diff {
  const Diff();

  /// Creates a [Diff] instance from a JSON map.
  ///
  /// @param json The JSON map containing diff information.
  /// @returns A [Diff] instance corresponding to the type.
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
        throw UnimplementedError('Unknown diff type: ${json['type']}');
    }
  }

  /// Converts this [Diff] instance to a JSON map.
  ///
  /// @returns A JSON map representing this diff operation.
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
    throw UnimplementedError('Unknown diff type: $runtimeType');
  }
}

/// Represents an update operation in a diff.
///
/// @property key The key of the value being updated.
/// @property newValue The new value to update to.
class Update extends Diff {
  final dynamic key;
  final dynamic newValue;

  /// Constructs an [Update] operation.
  ///
  /// @param key The key to update.
  /// @param newValue The new value to set.
  const Update(this.key, this.newValue);

  /// Creates an [Update] from a JSON map.
  ///
  /// @param json The JSON map containing update information.
  /// @returns An [Update] instance.
  factory Update.fromJson(Map<String, dynamic> json) =>
      Update(json['key'], json['newValue']);

  @override
  /// Converts this [Update] to a JSON map.
  Map<String, dynamic> toJson() =>
      {'type': 'update', 'key': key, 'newValue': newValue};

  @override
  String toString() {
    return "Update($key, $newValue)";
  }
}

/// Represents a movement operation in a diff (for lists).
///
/// @property oldKey The original key or index.
/// @property newKey The new key or index.
class Movement extends Diff {
  final dynamic oldKey;
  final dynamic newKey;

  /// Constructs a [Movement] operation.
  ///
  /// @param oldKey The original key or index.
  /// @param newKey The new key or index.
  const Movement(this.oldKey, this.newKey);

  /// Creates a [Movement] from a JSON map.
  ///
  /// @param json The JSON map containing movement information.
  /// @returns A [Movement] instance.
  factory Movement.fromJson(Map<String, dynamic> json) =>
      Movement(json['oldKey'], json['newKey']);

  @override
  /// Converts this [Movement] to a JSON map.
  Map<String, dynamic> toJson() =>
      {'type': 'movement', 'oldKey': oldKey, 'newKey': newKey};

  @override
  String toString() {
    return "Movement($oldKey, $newKey)";
  }
}

/// Represents an addition operation in a diff.
///
/// @property key The key where the value is added.
/// @property value The value being added.
class Addition extends Diff {
  final dynamic key;
  final dynamic value;

  /// Constructs an [Addition] operation.
  ///
  /// @param key The key where the value is added.
  /// @param value The value being added.
  const Addition(this.key, this.value);

  /// Creates an [Addition] from a JSON map.
  ///
  /// @param json The JSON map containing addition information.
  /// @returns An [Addition] instance.
  factory Addition.fromJson(Map<String, dynamic> json) =>
      Addition(json['key'], json['value']);

  @override
  /// Converts this [Addition] to a JSON map.
  Map<String, dynamic> toJson() =>
      {'type': 'addition', 'key': key, 'value': value};

  @override
  String toString() {
    return "Addition($key, $value)";
  }
}

/// Represents a deletion operation in a diff.
///
/// @property key The key of the value being deleted.
class Deletion extends Diff {
  final dynamic key;

  /// Constructs a [Deletion] operation.
  ///
  /// @param key The key of the value being deleted.
  const Deletion(this.key);

  /// Creates a [Deletion] from a JSON map.
  ///
  /// @param json The JSON map containing deletion information.
  /// @returns A [Deletion] instance.
  factory Deletion.fromJson(Map<String, dynamic> json) => Deletion(json['key']);

  @override
  /// Converts this [Deletion] to a JSON map.
  Map<String, dynamic> toJson() => {'type': 'deletion', 'key': key};

  @override
  String toString() {
    return "Deletion($key)";
  }
}
