/// Provides [Error] classes.
library errors;

/// Thrown when attempting to add a suffix with a name which has already been used.
class DuplicateNameError extends Error {
  DuplicateNameError(this.name);

  /// The name of the duplicate name.
  final String name;

  @override
  String toString() => 'The name $name has already been used.';
}

/// Thrown when an invalid index is used.
class NoSuchIndexError extends Error {
  NoSuchIndexError(this.index, this.length);

  /// The index that was used.
  final int index;

  /// The number of possible indices (starting at 1).
  final int length;

  @override
  String toString() => 'Nothing found at position $index. The last position is $length.';
}

/// Thrown when attempting to use a suffix that does not exist.
class NoSuchSuffixError extends Error {
  NoSuchSuffixError(this.name);

  /// The name of the non existant suffix.
  final String name;

  @override
  String toString() => 'There is no suffix named "$name".';
}

/// Thrown when attempting to use a filter that does not exist.
class NoSuchFilterError{
  NoSuchFilterError(this.name);

  /// The name of the non existant filter.
  final String name;

  @override
  String toString() => 'There is no filter named "$name".';
}
