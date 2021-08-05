/// Provides [Error] classes.

/// The base class for all errors used by the package.
class EmoteUtilsError extends Error {}

/// Thrown when attempting to add a suffix with a name which has already been
/// used.
class DuplicateNameError extends EmoteUtilsError {
  /// Create an instance.
  DuplicateNameError(this.name);

  /// The name of the duplicate name.
  final String name;

  @override
  String toString() => 'The name $name has already been used.';
}

/// Thrown when an invalid index is used.
class NoSuchIndexError extends EmoteUtilsError {
  /// Create an instance.
  NoSuchIndexError(this.index, this.length);

  /// The index that was used.
  final int index;

  /// The number of possible indices (starting at 1).
  final int length;

  @override
  String toString() =>
      'Nothing found at position $index. The last position is $length.';
}

/// Thrown when attempting to use a suffix that does not exist.
class NoSuchSuffixError extends EmoteUtilsError {
  /// Create an instance.
  NoSuchSuffixError(this.name);

  /// The name of the non existant suffix.
  final String name;

  @override
  String toString() => 'There is no suffix named "$name".';
}

/// Thrown when attempting to use a filter that does not exist.
class NoSuchFilter extends EmoteUtilsError {
  /// Create an instance.
  NoSuchFilter(this.name);

  /// The name of the non existant filter.
  final String name;

  @override
  String toString() => 'There is no filter named "$name".';
}
