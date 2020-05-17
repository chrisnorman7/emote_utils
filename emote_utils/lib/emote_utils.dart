/// Help with emotes in any form of text-based games.
///
/// This library lets you provide a string which will be converted to a bunch of strings which can be sent to 0 or more players, in response to an action in the game.
///
/// This could be something as simple as "Foo" logging into the server:
///
/// The player named Foo should see something like: You have connected.
/// Everyone else should see: Foo has connected.
///
/// This is possible with a string like:
///
/// `%1N %1has connected.`
///
/// In this instance, there is only one object: Foo, who is referred to in the string as %1.
///
/// After the number, there should be 0 or more letters, which is the name (or alias) of a `suffix`.
///
/// If no suffix is supplied, then a default is assumed. This is most likely a suffix which returns the name of the object (or "you" if the message is destined for the object itself. As a result, the string above could be more simply written as:
///
/// `%1 %1has connected.
///
/// To shorten things further, we could omit the number, and the library would assume the number 1:
///
/// `% %has connected.`
///
/// Notice that the single % (per cent) sign in our example, would expand to `%1n`, and `%has` would expand to `%1has`.
///
/// In reality, you probably wouldn't want to use the single per cent sign at the start of a string, as case matters, and this would result in incorrect capitalisation. Depending on how you configure the library, upper and lower case names of suffixes will result in different case strings.
library emote_utils;

export 'src/constants.dart';
export 'src/emote_utils_base.dart';
export 'src/errors.dart';
export 'src/social_context.dart';
export 'src/suffix_result.dart';
