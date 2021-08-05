/// Provides the [SocialsFactory] class.
import 'emote_context.dart';
import 'errors.dart';
import 'social_context.dart';
import 'suffix_result.dart';
import 'typedefs.dart';

/// The main factory for storing suffixes and filters, as well as converting
/// social strings to perspective aware strings which can be sent to objects of
/// type T.
class SocialsFactory<T> {
  /// Default constructor.
  SocialsFactory(
      {this.defaultSuffix = 'n',
      this.defaultIndex = '1',
      RegExp? suffixRegExp,
      RegExp? objectRegExp,
      RegExp? wordRegExp,
      RegExp? upperCaseRegExp})
      : this.suffixRegExp =
            suffixRegExp ?? RegExp('%([0-9]*)([a-zA-Z]*)([|]([a-zA-Z]+))?'),
        this.objectRegExp = objectRegExp ??= RegExp(r'\[([^\]]+)\]'),
        this.wordRegExp = wordRegExp ?? RegExp(r'\S+\s*'),
        this.upperCaseRegExp = upperCaseRegExp ?? RegExp('[A-Z]');

  /// Create a factory with a couple of useful suffixes.
  factory SocialsFactory.sensible(
      {String defaultSuffix = 'n', String defaultIndex = '1'}) {
    final factory = SocialsFactory<T>(
        defaultSuffix: defaultSuffix, defaultIndex: defaultIndex)
      ..addSuffix(<String>['s'], (T thing) => SuffixResult('', 's'))
      ..addSuffix(<String>['e', 'es'], (T thing) => SuffixResult('', 'es'))
      ..addSuffix(<String>['y', 'ies'], (T thing) => SuffixResult('y', 'ies'))
      ..addSuffix(<String>['are', 'is'], (T thing) => SuffixResult('are', 'is'))
      ..addSuffix(
          <String>['have', 'has'], (T thing) => SuffixResult('have', 'has'));
    return factory;
  }

  /// The default suffix.
  final String defaultSuffix;

  /// The default index.
  ///
  /// In cases where a formatter such as `%n`, or even just `%` is used, this
  /// value will be used to fill out the index.
  ///
  /// Indices start at 1.
  final String defaultIndex;

  /// The regular expression for matching suffixes.
  final RegExp suffixRegExp;

  /// The regular expression for matching object names in emote strings.
  final RegExp objectRegExp;

  /// The regexp to split strings into words.
  ///
  /// Used by [toTitleCase].
  final RegExp wordRegExp;

  /// The regular expression for upper case characters.
  final RegExp upperCaseRegExp;

  /// All suffixes which have been loaded with [addSuffix].
  final Map<String, SuffixResult Function(T)> suffixes = {};

  /// All filters which have been loaded with [addFilter].
  final Map<String, FilterType> filters = {};

  /// Returns true if [value] starts with an upper case letter.
  ///
  /// To modify the behaviour of this function, either override this function,
  /// or set [upperCaseRegExp] to something else.
  bool startsAsUpperCase(String value) => value.startsWith(upperCaseRegExp);

  /// Returns a string with the first letter of each word capitalised.
  String toTitleCase(String s) {
    final words = [
      for (final word in s.split(' '))
        word.length == 1
            ? word[0].toUpperCase()
            : '${word[0].toUpperCase()}${word.substring(1)}'
    ];
    return words.join(' ');
  }

  /// Add a suffix.
  ///
  /// Suffixes must have at least 1 name, although you can specify as many as
  /// you like.
  ///
  /// Because suffix names in social strings can be either case to change the
  /// case of the resulting string, it is important that suffix names are lower
  /// case, since that is how they will be looked up.
  ///
  /// ```
  /// socials.addSuffix(
  ///   <String>['name', 'n'], (Player p) => SuffixResult('you', player.name));
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
  /// socials.addFilter(
  ///   <String>['upper', 'uppercase', 'touppercase'], (String value) =>
  ///     value.toUpperCase());
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
  /// Returns an object which can be used to send the right string to the right
  /// observer.
  ///
  /// If no number is provided after a % (per cent) sign, defaultIndex is used.
  ///
  /// If no suffix name is provided, defaultSuffix is assumed.
  ///
  /// Assuming the defaults haven't been changed, this means `%` will be
  /// expanded to `51n`.
  ///
  /// Make the suffix names upper case to have the strings rendered with their
  /// first letter capitalised.
  SocialContext<T> getStrings(String socialString, List<T> perspectives) {
    final Map<T, String> targetedStrings = <T, String>{
      for (final perspective in perspectives) perspective: socialString
    };
    final String defaultString =
        socialString.replaceAllMapped(suffixRegExp, (Match m) {
      final fullString = m.group(0);
      if (fullString == null) {
        throw Exception('RegExp group(0) returned null.');
      }
      var indexString = m.group(1);
      if (indexString == null || indexString.isEmpty) {
        indexString = defaultIndex;
      }
      final int index = int.parse(indexString);
      if (index > perspectives.length || index < 1) {
        throw NoSuchIndexError(index, perspectives.length);
      }
      final T perspective = perspectives[index - 1];
      var suffixName = m.group(2);
      if (suffixName == null || suffixName.isEmpty) {
        suffixName = defaultSuffix;
      }
      final suffix = suffixes[suffixName.toLowerCase()];
      if (suffix == null) {
        throw NoSuchSuffixError(suffixName.toLowerCase());
      }
      final SuffixResult result = suffix(perspective);
      var filterName = m.group(3);
      if (filterName != null) {
        filterName = filterName.substring(1);
        final filter = filters[filterName];
        if (filter == null) {
          throw NoSuchFilter(filterName);
        }
        result.applyFilter(filter);
      }
      if (startsAsUpperCase(suffixName)) {
        result.applyFilter(toTitleCase);
      }
      for (final entry in targetedStrings.entries) {
        final p = entry.key;
        final currentValue = targetedStrings[p];
        if (currentValue == null) {
          throw Exception('Somehow `currentValue` is null.');
        }
        final String value;
        if (p == perspective) {
          value = result.firstPerson;
        } else {
          value = result.secondPerson;
        }
        targetedStrings[p] = currentValue.replaceFirst(fullString, value);
      }
      return result.secondPerson;
    });
    return SocialContext<T>(targetedStrings, defaultString);
  }

  /// Used to convert emote strings entered by players to social strings.
  ///
  /// Using [objectRegExp], convert a string such as `%1N smile%1s at [bob].`,
  /// to the social string `%1N smile%1s at %2.`, as well as creating a list of
  /// T instances, where [actor] is the first, and any other matches follow.
  ///
  /// In the case of the example above, assuming Mary used the emote, the
  /// perspectives list would be `[mary, bob]`.
  ///
  /// Every time a match string is found (according to the [objectRegExp]
  /// regular expression), it is passed through [matchFunc], which should
  /// return a T instance.
  ///
  /// If the match fails for any reason, throw some kind of error which you can
  /// catch in your code.
  ///
  /// ```
  /// try {
  ///   final ctx = socialsFactory.convertEmoteString(
  ///     emoteString, player, (String name) {
  ///       final Player match = player.match(name);
  ///       if (match == null) throw 'You see no $name here.';
  ///       return match;
  ///     });
  ///   socialsFactory.getStrings(
  ///   ctx.socialString, ctx.perspectives).dispatch(...);
  /// }
  /// catch(e) {
  ///   player.message(e);
  /// }
  /// ```
  EmoteContext<T> convertEmoteString(
      String emoteString, T actor, T Function(String) matchFunc) {
    final List<T> perspectives = <T>[actor];
    final String socialString =
        emoteString.replaceAllMapped(objectRegExp, (Match m) {
      final objectName = m.group(1);
      if (objectName == null) {
        throw Exception('Object name is null.');
      }
      final perspective = matchFunc(objectName);
      int index;
      if (perspectives.contains(perspective)) {
        index = perspectives.indexOf(perspective);
      } else {
        perspectives.add(perspective);
        index = perspectives.length;
      }
      return '%$index';
    });
    return EmoteContext<T>(socialString, perspectives);
  }
}
