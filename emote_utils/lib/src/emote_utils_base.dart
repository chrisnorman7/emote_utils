/// Provides the main classes for the library.
///
/// [SocialsFactory]
library emote_utils_base;

import 'constants.dart';
import 'errors.dart';
import 'social_context.dart';
import 'suffix_result.dart';

/// The main factory for storing suffixes and filters, as well as converting social strings to perspective aware strings which can be sent to objects of type T.
class SocialsFactory<T> {
  /// Default constructor.
  SocialsFactory();

  /// Create a factory with a couple of useful suffixes.
  SocialsFactory.sensible() {
    addSuffix(<String>['s'], (T thing) => SuffixResult('', 's'));
    addSuffix(<String>['es'], (T thing) => SuffixResult('', 'es'));
    addSuffix(<String>['y', 'ies'], (T thing) => SuffixResult('y', 'ies'));
    addSuffix(<String>['are', 'is'], (T thing) => SuffixResult('are', 'is'));
    addSuffix(<String>['have', 'has'], (T thing) => SuffixResult('have', 'has'));
  }

  /// The default suffix.
  String defaultSuffix = 'n';

  /// The default index.
  ///
  /// In cases where a formatter such as `%n`, or even just `%` is used, this value will be used to fill out the index.
  ///
  /// Indices start at 1.
  String defaultIndex = '1';

  /// The regular expression for matching suffixes.
  RegExp suffixRegExp = defaultSuffixRegExp;

  /// The regular expression for matching object names in emote strings.
  RegExp objectRegExp = defaultObjectRegExp;

  /// The regexp to split strings into words.
  ///
  /// Used by [toTitleCase].
  final RegExp wordRegExp = RegExp(r'\S+\s*');

  /// The regular expression for upper case characters.
  RegExp upperCaseRegExp = RegExp('[A-Z]');

  /// All suffixes which have been loaded with [addSuffix].
  Map<String, SuffixResult Function(T)> suffixes = <String, SuffixResult Function(T)>{};

  /// All filters which have been loaded with [addFilter].
  Map<String, FilterType> filters = <String, FilterType>{};

  /// Returns true if [value] starts with an upper case letter.
  ///
  /// To modify the behaviour of this function, either override this function, or set [upperCaseRegExp] to something else.
  bool startsAsUpperCase(String value) {
    return value.startsWith(upperCaseRegExp);
  }

  /// Returns a string with the first letter of each word capitalised.
  String toTitleCase(String s) {
    return s.replaceAllMapped(wordRegExp, (Match m) {
      final String word = m.group(0);
      return word[0].toUpperCase() + word.substring(1);
    });
  }

  /// Add a suffix.
  ///
  /// Suffixes must have at least 1 name, although you can specify as many as you like.
  ///
  /// Because suffix names in social strings can be either case to change the case of the resulting string, it is important that suffix names are lower case, since that is how they will be looked up.
  ///
  /// ```
  /// socials.addSuffix(<String>['name', 'n'], (Player p) => SuffixResult('you', player.name));
  /// ```
  void addSuffix(List<String> names, SuffixResult Function(T) func) {
    for (final String name in names) {
      if (suffixes.containsKey(name)) {
        throw DuplicateNameError(name);
      }
      suffixes[name] = func;
    }
  }

  /// Add a filter.
  /// ```
  /// socials.addFilter(<String>['upper', 'uppercase', 'touppercase'], (String value) => value.toUpperCase());
  /// ```
  void addFilter(List<String> names, String Function(String) func) {
    for (final String name in names) {
      if (filters.containsKey(name)) {
        throw DuplicateNameError(name);
      }
      filters[name] = func;
    }
  }

  /// Converts a string such as
  /// ```
  /// %1N smile%1s at %2 with %1his eyes sparkling in the light of %3.
  /// ```
  ///
  /// Returns an object which can be used to send the right string to the right observer.
  ///
  /// If no number is provided after a % (per cent) sign, defaultIndex is used.
  ///
  /// If no suffix name is provided, defaultSuffix is assumed.
  ///
  /// Assuming the defaults haven't been changed, this means `%` will be expanded to `51n`.
  ///
  /// Make the suffix names upper case to have the strings rendered with their first letter capitalised.
  SocialContext<T> getStrings(String socialString, List<T> perspectives) {
    final Map<T, String> targetedStrings = <T, String>{};
    for (final T perspective in perspectives) {
      targetedStrings[perspective] = socialString;
    }
    final String defaultString = socialString.replaceAllMapped(suffixRegExp, (Match m) {
      String indexString = m.group(1);
      if (indexString.isEmpty) {
        indexString = defaultIndex;
      }
      final int index = int.tryParse(indexString);
      if (index > perspectives.length || index < 1) {
        throw NoSuchIndexError(index, perspectives.length);
      }
      final T perspective = perspectives[index - 1];
      String suffixName = m.group(2);
      if (suffixName.isEmpty) {
        suffixName = defaultSuffix;
      }
      final SuffixResult Function(T) suffix = suffixes[suffixName.toLowerCase()];
      if (suffix == null) {
        throw NoSuchSuffixError(suffixName.toLowerCase());
      }
      final SuffixResult result = suffix(perspective);
      String filterName = m.group(3);
      if (filterName != null) {
        filterName = filterName.substring(1);
        final FilterType filter = filters[filterName];
        if (filter == null) {
          throw NoSuchFilterError(filterName);
        }
        result.applyFilter(filter);
      }
      if (startsAsUpperCase(suffixName)) {
        result.applyFilter(toTitleCase);
      }
      for (final T p in perspectives) {
        String value;
        if (p == perspective) {
          value = result.firstPerson;
        } else {
          value = result.secondPerson;
        }
        targetedStrings[p] = targetedStrings[p].replaceFirst(m.group(0), value);
      }
      return result.secondPerson;
    });
    return SocialContext<T>(targetedStrings, defaultString);
  }
}
