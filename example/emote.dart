/// An example showing how emotes are possible.
library;

import 'package:emote_utils/emote_utils.dart';

/// The error thrown by [Player.matchPlayer].
class MatchError implements Exception {
  /// Create an instance.
  const MatchError(this.name);

  /// The name that was used to get a failed match.
  final String name;
}

/// A bear bones player object.
class Player {
  /// Create an instance.
  const Player(this.name);

  /// The name of the player.
  final String name;

  /// Match a player by [name].
  static Player matchPlayer(final String name) {
    final nameLowerCase = name.toLowerCase();
    final player = players[nameLowerCase];
    if (player == null) {
      throw MatchError(name);
    }
    return player;
  }

  /// Perform an emote.
  void emote(final SocialsFactory<Player> factory, final String emoteString) {
    final emoteContext = factory.convertEmoteString(
      emoteString,
      this,
      matchPlayer,
    );
    factory
        .getStrings(emoteContext.socialString, emoteContext.perspectives)
        .dispatch(
          players.values.toList(),
          // ignore: avoid_print
          (final p, final message) => print('${p.name} sees: $message'),
        );
  }
}

Map<String, Player> players = <String, Player>{};

void main() {
  final f = SocialsFactory<Player>.sensible()
    ..addSuffix(
      <String>['name', 'n'],
      (final p) => SuffixResult('you', p.name),
    );
  const bill = Player('Bill');
  players[bill.name.toLowerCase()] = bill;
  const ben = Player('Ben');
  players[ben.name.toLowerCase()] = ben;
  const jane = Player('Jane');
  players[jane.name.toLowerCase()] = jane;
  bill
    ..emote(f, '%1n begin%s fighting [ben].')
    ..emote(f, '%1N punch%es [ben].');
  ben.emote(f, '%1N return%s the punch.');
  jane.emote(f, '%1N consider%1s joining, but %are reluctant to hurt anyone.');
}
