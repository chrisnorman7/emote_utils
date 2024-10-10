/// Provides the [SuffixResult] class.
import 'typedefs.dart';

/// Returned by suffix functions.
///
/// When you write your own suffixes, this type is what you will have to return.
///
/// It is simple to use, and can be created with the string in first person,
/// and the string in second person.
class SuffixResult {
  /// Give the first and second person strings.
  ///
  /// ```
  /// socials.addSuffix(
  ///   <String>['name', 'n'], (Player p) => SuffixResult('you', p.name));
  /// ```
  const SuffixResult(this.firstPerson, this.secondPerson);

  /// The string which should be sent to the object which initiated the social
  /// string.
  final String firstPerson;

  /// The string which should be sent to all observers who didn't initiate the
  /// social string.
  final String secondPerson;

  /// Apply [filter] to [firstPerson] and [secondPerson] and return the result.
  ///
  /// This is used by `SocialsFactory.getStrings` to change the case of the
  /// output.
  ///
  /// You can also use filters in your social strings, by placing a vertical bar
  /// (|) between your social formatter, and the name of the filter.
  ///
  /// For example:
  ///
  /// ```
  /// %1homepage|url
  /// ```
  SuffixResult applyFilter(final FilterType filter) =>
      SuffixResult(filter(firstPerson), filter(secondPerson));
}
