# diff

A Dart library for calculating and applying diffs (changes) between lists and maps. It provides a unified interface to generate minimal change sets (additions, deletions, updates, movements) and apply them to transform collections efficiently.

## Features
- Compute minimal diffs between two lists or maps
- Apply diffs (patch) to lists or maps
- Supports additions, deletions, updates, and movements
- Simple API and extensible design

## Installation
Add this to your `pubspec.yaml`:

```yaml
dependencies:
  diff: ^1.0.0
```

Then run:
```sh
dart pub get
```

## Usage

### Diff and Patch Lists
```dart
import 'package:diff/diff.dart';

void main() {
  final left = [1, 2, 3];
  final right = [2, 3, 4];

  // Calculate the diff
  final diffs = left.diffTo(right);
  print(diffs); // [Deletion(0), Addition(2, 4)]

  // Apply the diff
  final patched = left.applyDiffs(diffs);
  print(patched); // [2, 3, 4]
}
```

### Diff and Patch Maps
```dart
import 'package:diff/diff.dart';

void main() {
  final left = {'a': 1, 'b': 2};
  final right = {'a': 1, 'b': 3, 'c': 4};

  // Calculate the diff
  final diffs = left.diffTo(right);
  print(diffs); // [Update(b, 3), Addition(c, 4)]

  // Apply the diff
  final patched = left.applyDiffs(diffs);
  print(patched); // {a: 1, b: 3, c: 4}
}
```

## License
MIT