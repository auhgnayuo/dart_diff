part of diff;

// This file defines an extension on List to compute and apply diffs between lists.
// It provides methods to calculate the minimal set of changes (additions, deletions, movements)
// required to transform one list into another, as well as to apply such changes.

/// Extension on List to provide diffing and patching capabilities.
extension DiffArray<T> on List<T> {
  /// Computes the list of diffs required to transform this list into [other].
  ///
  /// The [equals] function is used to compare elements for equality.
  List<Diff> diffTo(List<T> other,
      {bool Function(T, T) equals = _defaultEquals}) {
    final List<Diff> diffs = [];
    final tmpLeft = List<T>.from(this);
    for (var j = 0; j < other.length; j++) {
      int? ii;
      for (var i = j; i < tmpLeft.length; i++) {
        if (equals(other[j], tmpLeft[i])) {
          ii = i;
          break;
        }
      }
      if (ii == null) {
        tmpLeft.insert(j, other[j]);
        diffs.add(Addition(j, other[j]));
      } else {
        if (ii == j) {
          continue;
        }
        tmpLeft.insert(j, tmpLeft.removeAt(ii));
        diffs.add(Movement(ii, j));
      }
    }
    for (var j = tmpLeft.length - 1; j >= other.length; j--) {
      diffs.add(Deletion(j));
    }
    return diffs;
  }

  /// Computes the list of diffs required to transform [other] into this list.
  ///
  /// The [equals] function is used to compare elements for equality.
  List<Diff> diffFrom(List<T> other,
      {bool Function(T, T) equals = _defaultEquals}) {
    return other.diffTo(this, equals: equals);
  }

  /// Applies a list of [diffs] to this list and returns the resulting list.
  List<T> applyDiffs(List<Diff> diffs) {
    final right = List<T>.from(this);
    for (var diff in diffs) {
      if (diff is Addition) {
        right.insert(diff.key, diff.value);
      } else if (diff is Deletion) {
        right.removeAt(diff.key);
      } else if (diff is Movement) {
        right.insert(diff.newKey, right.removeAt(diff.oldKey));
      }
    }
    return right;
  }
}
