/// Provides the [EmoteContext] class.
import 'socials_factory.dart';

/// Returned by [SocialsFactory.convertEmoteString].
class EmoteContext<T> {
  /// Create a context whose members can be used by [SocialsFactory.getStrings].
  EmoteContext(this.socialString, this.perspectives);

  /// a social string, such as `%1N smile%1s at %2n.`
  final String socialString;

  /// A list of perspectives involved in the string.
  final List<T> perspectives;
}
