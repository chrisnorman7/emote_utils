/// emote_util tests.
library emote_utils_test;

import 'package:emote_utils/emote_utils.dart';
import 'package:test/test.dart';

/// The "name" suffix.
SuffixResult getName(Player p) => SuffixResult('you', p.name);

/// The "s" suffix.
SuffixResult getS(Player p) => SuffixResult('', 's');

// The "url" filter.
String url(String value) => '$value.com';

/// A pretend player in a game.
class Player {
  Player(this.name);

  /// Pretend player's pretend name.
  String name;

  /// Messages.
  List<String> messages = <String>[];

  /// Send a pretend message.
  void message(String message) => messages.add(message);
}

void main() {
  group('Tests for SocialsFactory', () {
    SocialsFactory<Player> socials;

    setUp(() {
      socials = SocialsFactory<Player>();
    });

    test('default suffixes', () {
      expect(socials.suffixes.length, 0);
    });

    test('Add a suffix', () {
      // Add a name suffix.
      socials.addSuffix(<String>['name', 'n'], getName);

      expect(socials.suffixes.length, 2);

      expect(socials.suffixes['name'], getName);

      expect(socials.suffixes['n'], getName);
    });

    test('Default filters', () {
      expect(socials.filters.length, 0);
    });

    test('Add a filter', () {
      socials.addFilter(<String>['url', 'u'], url);

      expect(socials.filters.length, 2);

      expect(socials.filters['url'], url);

      expect(socials.filters['u'], url);
    });

    test('getStrings', () {
      socials.addSuffix(<String>['n'], getName);
      socials.addSuffix(<String>['s'], getS);

      const String s = '%1N smile%s at %2.';
      final Player bill = Player('Bill');
      final Player jane = Player('Jane');

      SocialContext<Player> ctx = socials.getStrings(s, <Player>[bill, jane]);

      expect(ctx.defaultString, 'Bill smiles at Jane.');

      expect(ctx.targetedStrings[bill], 'You smile at Jane.');

      expect(ctx.targetedStrings[jane], 'Bill smiles at you.');

      const String invalidName = 'fails';
      
      expect(
        () => socials.getStrings('%1$invalidName', <Player>[bill]),
        throwsA(
          predicate((NoSuchSuffixError e) => e.name == invalidName)
        )
      );

      socials.addFilter(<String>['url'], url);

      ctx = socials.getStrings('%1N|url', <Player>[bill]);

      expect(ctx.defaultString, 'Bill.com');

      expect(ctx.targetedStrings[bill], 'You.com');
      
      expect(
        () => socials.getStrings('%1N|$invalidName', <Player>[jane]),
        throwsA(
          predicate<NoSuchFilterError>((NoSuchFilterError e) => e.name == invalidName)
        )
      );
    });
  });
}
