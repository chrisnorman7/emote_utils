/// An example showing how emotes are possible.
library emote;

import 'package:emote_utils/emote_utils.dart';

/// The error thrown by [Player.match].
class MatchError extends Error {
  MatchError(this.name);

  String name;
}

/// A bear bones player object.
class Player {
  Player(this.name){
    players[name.toLowerCase()] = this;
  }

  /// The name of the player.
  String name;

  Player matchPlayer(String name) {
    final String nameLowerCase = name.toLowerCase();
    if (players.containsKey(nameLowerCase)) {
      return players[nameLowerCase];
    }
    throw MatchError(name);
  }

  void emote(SocialsFactory<Player> factory, String emoteString) {
    final EmoteContext<Player> emoteContext = factory.convertEmoteString(emoteString, this, matchPlayer);
    final SocialContext<Player> socialsContext = factory.getStrings(emoteContext.socialString, emoteContext.perspectives);
    socialsContext.dispatch(players.values.toList(), (Player p, String message) => print('${p.name} sees: $message'));
  }
}

Map<String, Player> players = <String, Player>{};

void main() {
  final SocialsFactory<Player> f = SocialsFactory<Player>.sensible();
  f.addSuffix(<String>['name', 'n'], (Player p) => SuffixResult('you', p.name));
  final Player bill = Player('Bill');
  final Player ben = Player('Ben');
  final Player jane = Player('Jane');
  bill.emote(f, '%1n begin%s fighting [ben].');
  bill.emote(f, '%1N punch%es [ben].');
  ben.emote(f, '%1N return%s the punch.');
  jane.emote(f, '%1N consider%1s joining, but %are reluctant to hurt anyone.');
}
