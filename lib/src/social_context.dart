/// Provides the [SocialContext] class.
library social_context;

import 'socials_factory.dart';

/// Returned by [SocialsFactory.getStrings].
class SocialContext<T> {
  /// Create a context.
  SocialContext(this.targetedStrings, this.defaultString);

  /// Contains strings to be sent to specific targets.
  final Map<T, String> targetedStrings;

  /// The string to be sent to any observer that isn't in [targetedStrings].
  final String defaultString;

  /// Given a list of observers, call [func](observer, string).
  ///
  /// If the given observer is a key in [targetedStrings], the passed string
  /// will be the associated value.
  ///
  /// If not, the passed string will be [defaultString].
  ///
  /// The [func] argument should pass the given string to the given observer.
  void dispatch(List<T> observers, void Function(T, String) func) {
    for (final T observer in observers) {
      final String value = targetedStrings[observer] ?? defaultString;
      func(observer, value);
    }
  }
}
