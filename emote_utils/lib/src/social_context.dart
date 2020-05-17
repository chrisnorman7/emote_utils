/// Provides the [SocialContext] class.
library social_context;

import 'emote_utils_base.dart';

/// The result of calling [SocialsFactory.getStrings].
class SocialContext<T> {
  SocialContext(this.targetedStrings, this.defaultString);

  /// Contains strings to be sent to specific targets.
  final Map<T, String> targetedStrings;

  /// The string to be sent to any observer that isn't in [targetedStrings].
  final String defaultString;

  /// Given a list of observers, call [func](observer, string).
  ///
  /// If the given observer is a key in [targetedStrings], the passed string will be the associated value.
  ///
  /// If not, the passed string will be [defaultString].
  ///
  /// The [func] argument should pass the given string to the given observer.
  void dispatch(List<T> observers, void Function(T, String) func) {
    for (final T observer in observers) {
      String value = defaultString;
      if (targetedStrings.containsKey(observer)) {
        value = targetedStrings[observer];
      }
      func(observer, value);
    }
  }
}
