part of diff;

// This file provides a default equality function for deep comparison of objects.
// It is used internally by the diff library to compare complex data structures.

/// Returns true if [a] and [b] are deeply equal using DeepCollectionEquality.
bool _defaultEquals(dynamic a, dynamic b) {
  return const DeepCollectionEquality().equals(a, b);
}
