/// The base class for all errors used by the package.
class EmoteUtilsError implements Exception {
  /// Allow constant constructors.
  const EmoteUtilsError({required this.message});

  /// The message to show.
  final String message;
}

/// Thrown when attempting to add a suffix with a name which has already been
/// used.
class DuplicateNameError extends EmoteUtilsError {
  /// Create an instance.
  DuplicateNameError({
    required this.name,
  }) : super(message: 'There is already a suffix named $name.');

  /// The duplicate name.
  final String name;
}

/// Thrown when an invalid index is used.
class NoSuchIndexError extends EmoteUtilsError {
  /// Create an instance.
  NoSuchIndexError({
    required this.index,
    required this.maxIndex,
  }) : super(
          message: 'Nothing found at position $index. The last position is '
              '$maxIndex.',
        );

  /// The invalid index.
  final int index;

  /// The maximum possible index.
  final int maxIndex;
}

/// Thrown when attempting to use a suffix that does not exist.
class NoSuchSuffixError extends EmoteUtilsError {
  /// Create an instance.
  NoSuchSuffixError({required this.name})
      : super(message: 'There is no suffix named "$name".');

  /// The name of the non existant suffix.
  final String name;
}

/// Thrown when attempting to use a filter that does not exist.
class NoSuchFilter extends EmoteUtilsError {
  /// Create an instance.
  NoSuchFilter({required this.name})
      : super(message: 'There is no filter named "$name".');

  /// The name of the non existant filter.
  final String name;
}
