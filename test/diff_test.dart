import 'dart:math';
import 'package:collection/collection.dart';
import 'package:diff/diff.dart';
import 'package:test/test.dart';

dynamic generateRandomJSON({int depth = 2}) {
  final random = Random();
  if (depth <= 0) {
    final primitives = [
      () => random.nextInt(2000) - 1000,
      () => random.nextDouble() * 2000 - 1000,
      () => random.nextBool(),
      () => random.nextDouble().toString(),
      () => null
    ];
    return primitives[random.nextInt(primitives.length)]();
  }
  final type = random.nextInt(6);
  switch (type) {
    case 0:
      return random.nextInt(2000) - 1000;
    case 1:
      return random.nextDouble() * 2000 - 1000;
    case 2:
      return random.nextBool();
    case 3:
      return random.nextDouble().toString();
    case 4:
      final count = random.nextInt(5);
      return List.generate(count, (_) => generateRandomJSON(depth: depth - 1));
    case 5:
      final count = random.nextInt(5);
      final map = <String, dynamic>{};
      for (var i = 0; i < count; i++) {
        map[random.nextDouble().toString()] = generateRandomJSON(depth: depth - 1);
      }
      return map;
    default:
      return null;
  }
}

void main() {
  test('random JSON array diff/patch', () {
    for (var i = 0; i < 1000; i++) {
      final left = List.generate(Random().nextInt(5), (_) => generateRandomJSON(depth: 2));
      final right = List.generate(Random().nextInt(5), (_) => generateRandomJSON(depth: 2));
      final diffs = left.diffTo(right, equals: DeepCollectionEquality().equals);
      final patched = left.applyDiffs(diffs);
      print('Array left: $left\nArray right: $right\nDiffs: $diffs\n');
      assert(DeepCollectionEquality().equals(patched, right));
    }
  });

  test('random JSON map diff/patch', () {
    for (var i = 0; i < 1000; i++) {
      final left = <String, dynamic>{};
      final right = <String, dynamic>{};
      for (var j = 0; j < Random().nextInt(5); j++) {
        left[Random().nextDouble().toString()] = generateRandomJSON(depth: 2);
      }
      for (var j = 0; j < Random().nextInt(5); j++) {
        right[Random().nextDouble().toString()] = generateRandomJSON(depth: 2);
      }
      final diffs = left.diffTo(right, equals: DeepCollectionEquality().equals);
      final patched = left.applyDiffs(diffs);
      print('Map left: $left\nMap right: $right\nDiffs: $diffs\n');
      assert(DeepCollectionEquality().equals(patched, right));
    }
  });
} 