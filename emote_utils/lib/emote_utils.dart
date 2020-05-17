/// Help with emotes in any form of text-based games.
///
/// This library lets you create a [SocialsFactory], in order to convert so-called "social strings" to perspective-aware strings which can be sent to players in response to an action in the game.
///
/// This could be something as simple as "Foo" logging into the server.
///
/// The player named Foo should see something like: You have connected.
///
/// Everyone else should see: Foo has connected.
///
/// This is achieved with the string:
///
/// `%1N %1has connected.`
///
/// In this instance, there is only one object: Foo, who is referred to in the string as %1.
///
/// Social formatters begin with the % sign. You could change this behaviour by using a different value for [SocialsFactory.suffixRegExp].
///
/// After the % (per cent) sign, there should be a number. This is the number of the object in a list of "perspectives". This number starts at 1, to make it more human readable. So %1 is the first object, %2 the second, and so on.
///
/// If no index is supplied, then the contents of [SocialsFactory.defaultIndex] is used. By default, this is "1".
///
/// If a number which is outside the range of the supplied list of objects is used, [NoSuchIndexError] is thrown.
///
/// After the number, there should be a word, consisting of 1 or more letters, which is the name (or alias) of a "suffix".
///
/// If no suffix is supplied, then the contents of [SocialsFactory.defaultSuffix] is used. By default, this is the unused suffix "n".
///
/// If there is no suffix by the given name, [NoSuchSuffixError] is thrown.
///
/// With all this in mind, the string above could be more simply written as:
///
/// `% %has connected.`
///
/// Notice that the single % (per cent) sign in our example would expand to `%1n`, and `%has` would expand to `%1has`.
///
/// In reality, you probably wouldn't want to use the single per cent sign at the start of a string, as using a lower case suffix leaves the case of the suffix results unchanged. In this example, the player Foo would now see "you have connected."
///
/// As an aside, using an upper case suffix name puts the result of the suffix into title case. The behaviour of this can be changed by overriding [SocialsFactory.toTitleCase].
///
/// The last thing to note about social strings is filters.
///
/// Filters can be added with [SocialsFactory.addFilter]. They are functions which take and return a single String.
///
/// Filters aren't used much internally, mainly because I'm only interested in using this package for games, but you could easily do some interesting things with them.
///
/// ```
/// socials.addFilter(<String>['url'], (String value) => 'https://www.$value.com');
/// ```
///
/// To begin with a factory that has some sensible suffixes already in place, use the [SocialsFactory.sensible] constructor.
library emote_utils;

export 'src/constants.dart';
export 'src/emote_utils_base.dart';
export 'src/errors.dart';
export 'src/social_context.dart';
export 'src/suffix_result.dart';
