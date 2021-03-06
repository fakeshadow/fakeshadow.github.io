// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "advancedPopupMenuToolTip" : MessageLookupByLibrary.simpleMessage("Advanced Features"),
    "bronze" : MessageLookupByLibrary.simpleMessage("Bronze"),
    "discordGroup" : MessageLookupByLibrary.simpleMessage("Discord group"),
    "dynamicAnalyzeMenuButton" : MessageLookupByLibrary.simpleMessage("Dynamic Analyze"),
    "gold" : MessageLookupByLibrary.simpleMessage("Gold"),
    "jitterRangeToolTip" : MessageLookupByLibrary.simpleMessage("Change the jitter for generate trophy timestamps"),
    "jitterUnit" : MessageLookupByLibrary.simpleMessage("Unit microseconds"),
    "jitterWrongFormatAlert" : MessageLookupByLibrary.simpleMessage("Jitter Format Wrong"),
    "manualHide" : MessageLookupByLibrary.simpleMessage("Hide manual"),
    "manualShow" : MessageLookupByLibrary.simpleMessage("Show manual"),
    "orderByPSN" : MessageLookupByLibrary.simpleMessage("Order by PSN"),
    "orderByTime" : MessageLookupByLibrary.simpleMessage("Order by Time"),
    "pageEditorFinishAlertBack" : MessageLookupByLibrary.simpleMessage("Go Back to Editor"),
    "pageEditorFinishAlertDetail" : MessageLookupByLibrary.simpleMessage("All changes have been saved. Press Finish button to download TRPTRANS_MOD.DAT and TRPTITLE_MOD.DAT\n*.Rename them to TRPTRANS.DAT and TRPTITLE.DAT ,transfer back to Vita and overwrite the original ones(Be sure to decrypt the original files before overwrite)"),
    "pageEditorFinishAlertFinish" : MessageLookupByLibrary.simpleMessage("Finish"),
    "pageEditorFinishAlertTitle" : MessageLookupByLibrary.simpleMessage("Successfully Saved"),
    "pageEditorModifyFinish" : MessageLookupByLibrary.simpleMessage("Finish"),
    "pageEditorModifyLock" : MessageLookupByLibrary.simpleMessage("Lock"),
    "pageEditorModifyPick" : MessageLookupByLibrary.simpleMessage("Pick"),
    "pageEditorModifyRandom" : MessageLookupByLibrary.simpleMessage("Random"),
    "pageEditorRandomPSNTimeEndDefault" : MessageLookupByLibrary.simpleMessage("Unset. Current System Time will be used."),
    "pageHomeAlert" : MessageLookupByLibrary.simpleMessage("*.TRPTRANS.DAT and TRPTITLE.DAT must be in the decrypted form before transfer:"),
    "pageHomeAlertDetail" : MessageLookupByLibrary.simpleMessage("1. Navigate to ur0:/user/xx/trophy/data/ folder using vitashell.\n2. Select NPWRXXXXX_00 folder and press triangle button, then choose Open decrypted and confirm\n3. Transfer decrypted TRPTRANS.DAT and TRPTITLE.DAT inside the folder\n"),
    "pageHomeAppBarTitle" : MessageLookupByLibrary.simpleMessage("Vita Trophy Editor"),
    "pageHomeFiles" : MessageLookupByLibrary.simpleMessage("*.Files needed: "),
    "pageHomeFilesDetail" : MessageLookupByLibrary.simpleMessage("ur0:/user/xx/trophy/conf/NPWRXXXXX_00/TROP.SFM\nur0:/user/xx/trophy/data/NPWRXXXXX_00/TRPTRANS.DAT\nur0:/user/xx/trophy/data/NPWRXXXXX_00/TRPTITLE.DAT\nTransfer them to your PC/Phone using vitashell or other file manager homebrew\n"),
    "pageHomeSelectFiles" : MessageLookupByLibrary.simpleMessage("Select files"),
    "pageHomeUsage" : MessageLookupByLibrary.simpleMessage("Usage: "),
    "pageHomeUsageDetail" : MessageLookupByLibrary.simpleMessage("This is a tool for people who want to fine tone their trophies and not an easy unlock all solution.\nCode is not in perfect shape by any means so please use with caution. Always backup your original TRPTRANS.DAT beforehand\n"),
    "pageLocaleCN" : MessageLookupByLibrary.simpleMessage("简体中文"),
    "pageLocaleEN" : MessageLookupByLibrary.simpleMessage("English"),
    "pageLocaleTitle" : MessageLookupByLibrary.simpleMessage("Choose Language"),
    "platinum" : MessageLookupByLibrary.simpleMessage("Platinum"),
    "psnTimeWrongFormatAlert" : MessageLookupByLibrary.simpleMessage("DateTime Format Wrong"),
    "randomDateTimeRangeBegin" : MessageLookupByLibrary.simpleMessage("Begin"),
    "randomDateTimeRangeEnd" : MessageLookupByLibrary.simpleMessage("End"),
    "randomDateTimeRangeTimeZoneAlert" : MessageLookupByLibrary.simpleMessage("*.DateTime from picker in your local timezone will be converted and displayed as UTC time."),
    "randomDateTimeRangeToolTip" : MessageLookupByLibrary.simpleMessage("Change the range of random DateTime(Only for random trophy time generation)"),
    "saveChanges" : MessageLookupByLibrary.simpleMessage("Save Changes"),
    "scriptManualExample" : MessageLookupByLibrary.simpleMessage("Example:"),
    "scriptManualTitle" : MessageLookupByLibrary.simpleMessage("Script use JSON format and file name can be [Anything].json"),
    "scriptSelect" : MessageLookupByLibrary.simpleMessage("Select script"),
    "scriptUnlockManualHavePlat" : MessageLookupByLibrary.simpleMessage("if the trophy set have platinum trophy"),
    "scriptUnlockManualId" : MessageLookupByLibrary.simpleMessage("id is the the same order as PSN default and starts from 0."),
    "scriptUnlockManualJitter" : MessageLookupByLibrary.simpleMessage("jitter used for set timestamps generation. Unit in microseconds"),
    "scriptUnlockManualRandom" : MessageLookupByLibrary.simpleMessage("time will genearate randomly"),
    "scriptUnlockManualRandomBaseEnd" : MessageLookupByLibrary.simpleMessage("if random is used in trophies[i].time then the following two fields are needed"),
    "scriptUnlockMenuButton" : MessageLookupByLibrary.simpleMessage("Script Unlock"),
    "searchTrophyHint" : MessageLookupByLibrary.simpleMessage("Input trophy name"),
    "silver" : MessageLookupByLibrary.simpleMessage("Silver"),
    "sourceCode" : MessageLookupByLibrary.simpleMessage("Source code"),
    "staticAnalyzeAffectedTrophies" : MessageLookupByLibrary.simpleMessage("Affected trophies by this time range"),
    "staticAnalyzeAffectedTrophiesAll" : MessageLookupByLibrary.simpleMessage("No trophies field means this time range affect all trophies in the list"),
    "staticAnalyzeMenuButton" : MessageLookupByLibrary.simpleMessage("Static Analyze"),
    "staticAnalyzeRange" : MessageLookupByLibrary.simpleMessage("Ranges of time where trophy can not be obtained"),
    "staticAnalyzeRepeat" : MessageLookupByLibrary.simpleMessage("Repeats of time where trophy can not be obtained"),
    "staticAnalyzeRepeatExample" : MessageLookupByLibrary.simpleMessage("Every Tuesday from 12am the trophies can not be obtained for 3600 seconds"),
    "titleDefault" : MessageLookupByLibrary.simpleMessage("PSV Trophy Editor"),
    "titleHead" : MessageLookupByLibrary.simpleMessage("Current Editting: "),
    "unobtained" : MessageLookupByLibrary.simpleMessage("Unobtained")
  };
}
