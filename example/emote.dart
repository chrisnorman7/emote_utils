/// An example showing how emotes are possible.
library emote;

import 'package:emote_utils/emote_utils.dart';

/// The error thrown by [Player.matchPlayer].
class MatchError extends Error {
  MatchError(this.name);

  String name;
}

/// A bear bones player object.
class Player {
  Player(this.name) {
    players[name.toLowerCase()] = this;
  }

  /// The name of the player.
  String name;

  Player matchPlayer(String name) {
    final nameLowerCase = name.toLowerCase();
    final player = players[nameLowerCase];
    if (player == null) {
      throw MatchError(name);
    }
    return player;
  }

  void emote(SocialsFactory<Player> factory, String emoteString) {
    final EmoteContext<Player> emoteContext =
        factory.convertEmoteString(emoteString, this, matchPlayer);
    factory.getStrings(emoteContext.socialString, emoteContext.perspectives)
      ..dispatch(
          players.values.toList(),
          // ignore: avoid_print
          (Player p, String message) => print('${p.name} sees: $message'));
  }
}

Map<String, Player> players = <String, Player>{};

void main() {
  final SocialsFactory<Player> f = SocialsFactory<Player>.sensible()
    ..addSuffix(
        <String>['name', 'n'], (Player p) => SuffixResult('you', p.name));
  final Player bill = Player('Bill');
  final Player ben = Player('Ben');
  final Player jane = Player('Jane');
  bill
    ..emote(f, '%1n begin%s fighting [ben].')
    ..emote(f, '%1N punch%es [ben].');
  ben.emote(f, '%1N return%s the punch.');
  jane.emote(f, '%1N consider%1s joining, but %are reluctant to hurt anyone.');
}
