import 'dart:math';

import 'package:collection/collection.dart';
import 'package:diff/diff.dart';
import 'package:test/test.dart';

void main() {
  test('list', () {

    int length = 1000;
    final lefts = List.generate(length, (index) => generateRandomArray(base: 4));
    final rights = List.generate(length, (index) => generateRandomArray(base: 4));

    for (int i = 0; i < length; i++) {
      final left = lefts[i];
      final right = rights[i];
      final stopwatch = Stopwatch()..start();
      final d = left.diffTo(right);
      stopwatch.stop();
      final t = stopwatch.elapsedMilliseconds;
      final newRight = left.applyDiffs(d);
      assert(const DeepCollectionEquality().equals(newRight, right));
      print("list l: $left\tr: $right\td: $d\t t: $t");
    }
  });

  test('map', () {
    int length = 1000;
    final lefts = List.generate(length, (index) => generateRandomArray(base: 4));
    final rights = List.generate(length, (index) => generateRandomArray(base: 4));

    for (int i = 0; i < length; i++) {
      final left = lefts[i].asMap();
      final right = rights[i].asMap();
      final stopwatch = Stopwatch()..start();
      final d = left.diffTo(right);
      stopwatch.stop();
      final t = stopwatch.elapsedMilliseconds;
      final newRight = left.applyDiffs(d);
      assert(const DeepCollectionEquality().equals(newRight, right));
      print("map l: $left\tr: $right\td: $d\t t: $t");
    }
  });
}

List<int> generateRandomArray({int base = 100}) {
  final random = Random();
  final length = random.nextInt(base);
  return List.generate(length, (index) => random.nextInt(base));
}
