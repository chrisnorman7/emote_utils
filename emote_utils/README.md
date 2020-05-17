A library for working with emote strings in text-based games, such as MOO.

## Usage

A simple usage example:

```dart
import 'package:emote_utils/emote_utils.dart';

/// Create a pretend player class.
class Player {
  /// Create it with a name.
  Player(this.name);

  /// The name of the player.
  String name;
}

void main() {
  // Create some players:
  final Player bill = Player('Bill');
  final Player ben = Player('Ben');
  final Player jane = Player('Jane');
  // Create a socials factory, bound to the Player type.
  //
  // The SocialsFactory.sensible constructor gives you some reasonable defaults (at least for english), ensuring that word endings like "y", "es", and "s" work as expected.
  final SocialsFactory<Player> f = SocialsFactory<Player>.sensible();
  // Add a suffix, to give us player names.
  f.addSuffix(<String>['n'], (Player p) => SuffixResult('you', p.name));
  // Generate some strings.
  final SocialContext<Player> ctx = f.getStrings('%1N punch%1es %2n.', <Player>[jane, bill]);
  // We could go through and send them all out by hand, but we can do better:
  ctx.dispatch(
    <Player>[bill, ben, jane],
    (Player p, String s) => print('${p.name} sees: $s')
  );
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker](https://github.com/chrisnorman7/emote_utils).
