/// Provides the [SuffixResult] class.
library suffix_result;

import 'constants.dart';

/// The result of running a suffix.
class SuffixResult {
  SuffixResult(this.firstPerson, this.secondPerson);

  /// The string which should be sent to the object which initiated the social string.
  String firstPerson;

  /// The string which should be sent to all observers who didn't initiate the social string.
  String secondPerson;

  /// Apply a filter to [firstPerson] and [secondPerson].
  void applyFilter(FilterType filter) {
    firstPerson = filter(firstPerson);
    secondPerson = filter(secondPerson);
  }
}
