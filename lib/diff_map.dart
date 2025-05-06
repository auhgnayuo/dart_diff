part of diff;

// This file defines an extension on Map to compute and apply diffs between maps.
// It provides methods to calculate the minimal set of changes (additions, deletions, updates)
// required to transform one map into another, as well as to apply such changes.

/// Extension on Map to provide diffing and patching capabilities.
extension DiffMap<K, V> on Map<K, V> {
  /// Computes the list of diffs required to transform this map into [other].
  ///
  /// The [equals] function is used to compare values for equality.
  List<Diff> diffTo(Map<K, V> other,
      {bool Function(V, V) equals = _defaultEquals}) {
    final diffs = <Diff>[];
    final allKeys = <K>{...keys, ...other.keys};
    for (final key in allKeys) {
      if (containsKey(key) && !other.containsKey(key)) {
        diffs.add(Deletion(key));
      } else if (!containsKey(key) && other.containsKey(key)) {
        diffs.add(Addition(key, other[key]));
      } else if (containsKey(key) &&
          other.containsKey(key) &&
          !equals(this[key] as V, other[key] as V)) {
        diffs.add(Update(key, other[key]));
      }
    }
    return diffs;
  }

  /// Computes the list of diffs required to transform [other] into this map.
  ///
  /// The [equals] function is used to compare values for equality.
  List<Diff> diffFrom(Map<K, V> other,
      {bool Function(V, V) equals = _defaultEquals}) {
    return other.diffTo(this, equals: equals);
  }

  /// Applies a list of [diffs] to this map and returns the resulting map.
  Map<K, V> applyDiffs(List<Diff> diffs) {
    final result = Map<K, V>.from(this);
    for (final diff in diffs) {
      if (diff is Addition) {
        result[diff.key] = diff.value;
      } else if (diff is Deletion) {
        result.remove(diff.key);
      } else if (diff is Update) {
        result[diff.key] = diff.newValue;
      }
    }
    return result;
  }
}
