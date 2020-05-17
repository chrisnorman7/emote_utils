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

/// A pretend match function.
Player matchPlayer(String name) {
  switch(name) {
    case 'jane':
      return jane;
      break;
    case 'bill':
      return bill;
      break;
    case 'ben':
      return ben;
      break;
    default:
      throw name;
  }
}

final Player bill = Player('Bill');
final Player ben = Player('Ben');
final Player jane = Player('Jane');

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
      SocialContext<Player> ctx = socials.getStrings(s, <Player>[bill, jane]);

      expect(ctx.defaultString, 'Bill smiles at Jane.');

      expect(ctx.targetedStrings[bill], 'You smile at Jane.');

      expect(ctx.targetedStrings[jane], 'Bill smiles at you.');

      expect(
        () => socials.getStrings('%2', <Player>[jane]),
        throwsA(
          predicate<NoSuchIndexError>((NoSuchIndexError e) => e.index == 2 && e.length == 1)
        )
      );

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

  group('Tests for SocialsFactory.sensible', () {
    SocialsFactory<Player> f;
    SocialContext<Player> ctx;

    setUp(() =>f = SocialsFactory<Player>.sensible());
    final Player p = Player('Someone');
    final List<Player> pl = <Player>[p];

    test('%s', () {
      ctx = f.getStrings('smile%s', pl);
      expect(ctx.targetedStrings[p], 'smile');
      expect(ctx.defaultString, 'smiles');
    });

    test('%es', () {
      ctx = f.getStrings('punch%es', pl);
      expect (ctx.targetedStrings[p], 'punch');
      expect(ctx.defaultString, 'punches');
    });

    test('%y', () {
      ctx = f.getStrings('fl%y', pl);
      expect(ctx.targetedStrings[p], 'fly');
      expect(ctx.defaultString, 'flies');
    });

    test('%are', () {
      ctx = f.getStrings('%are', pl);
      expect(ctx.targetedStrings[p], 'are');
      expect(ctx.defaultString, 'is');
    });

    test('%have', () {
      ctx = f.getStrings('%have', pl);
      expect(ctx.targetedStrings[p], 'have');
      expect(ctx.defaultString, 'has');
    });
  });

  group('Test SocialContext.dispatch', () {
    SocialsFactory<Player> f;

    setUp(() {
      f = SocialsFactory<Player>.sensible();
      f.addSuffix(<String>['n'], (Player p) => SuffixResult('you', p.name));
    });

    test('Ensure everyone gets the right message.', () {
      final SocialContext<Player> ctx = f.getStrings('%N punch%es %2.', <Player>[jane, bill]);
      ctx.dispatch(
        <Player>[bill, ben, jane], (Player p, String message) => p.message(message)
      );
      expect(bill.messages.last, 'Jane punches you.');
      expect(jane.messages.last, 'You punch Bill.');
      expect(ben.messages.last, 'Jane punches Bill.');
    });
  });

  group('Test emote strings', () {
    SocialsFactory<Player> f;

    setUp(() => f = SocialsFactory<Player>());

    test('Convert emote strings', () {
      final EmoteContext<Player> ctx = f.convertEmoteString('%1N smile%1s at [jane].', bill, matchPlayer);
      expect(ctx.socialString, '%1N smile%1s at %2.');
      expect(ctx.perspectives, <Player>[bill, jane]);
    });

    test('Throw an error if an invalid name is used', () {
      expect(
        () => f.convertEmoteString('%1N smile%1s at [nobody].', jane, matchPlayer),
        throwsA(
          predicate<String>((String s) => s == 'nobody')
        )
      );
    });
  });
}
