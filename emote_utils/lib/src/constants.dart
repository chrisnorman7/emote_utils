/// This file contains constants for use with emote_utils.
///
/// * [SuffixType]
/// * [FilterType]
/// * [defaultObjectRegExp]
/// * [defaultSuffixRegExp]
library constants;

/// The type of all filters.
typedef FilterType = String Function(String);

/// The regular expression used for matching suffixes in social strings.
final RegExp defaultSuffixRegExp = RegExp(r'%([0-9]*)([a-zA-Z]*)([|]([a-zA-Z]+))?');

/// The regular expression used for matching objects in emote strings.
final RegExp defaultObjectRegExp = RegExp(r'\[([^\]]+)\]');
