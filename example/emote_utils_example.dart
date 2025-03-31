import 'package:emote_utils/emote_utils.dart';

/// Create a pretend player class.
class Player {
  /// Create it with a name.
  const Player(this.name);

  /// The name of the player.
  final String name;
}

void main() {
  // Create some players:
  const bill = Player('Bill');
  const ben = Player('Ben');
  const jane = Player('Jane');
  // Create a socials factory, bound to the Player type.
  //
  // The SocialsFactory.sensible constructor gives you some reasonable defaults
  // (at least in english), ensuring that word endings like "y", "es", and "s"
  //work as expected.
  final f = SocialsFactory<Player>.sensible()
    // Add a suffix, to give us player names.
    ..addSuffix(<String>['n'], (final p) => SuffixResult('you', p.name));
  // Generate some strings.
  f.getStrings('%1N punch%1es %2n.', [jane, bill])
      // We could go through and send them all out by hand, but we can do
      // better:
      .dispatch(
    [bill, ben, jane],
    // ignore: avoid_print
    (final p, final s) => print('${p.name} sees: $s'),
  );
}
