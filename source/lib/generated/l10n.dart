// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

class S {
  S();
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final String name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return S();
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  String get sourceCode {
    return Intl.message(
      'Source code',
      name: 'sourceCode',
      desc: '',
      args: [],
    );
  }

  String get discordGroup {
    return Intl.message(
      'Discord group',
      name: 'discordGroup',
      desc: '',
      args: [],
    );
  }

  String get titleDefault {
    return Intl.message(
      'PSV Trophy Editor',
      name: 'titleDefault',
      desc: '',
      args: [],
    );
  }

  String get titleHead {
    return Intl.message(
      'Current Editting: ',
      name: 'titleHead',
      desc: '',
      args: [],
    );
  }

  String get jitterUnit {
    return Intl.message(
      'Unit microseconds',
      name: 'jitterUnit',
      desc: '',
      args: [],
    );
  }

  String get bronze {
    return Intl.message(
      'Bronze',
      name: 'bronze',
      desc: '',
      args: [],
    );
  }

  String get silver {
    return Intl.message(
      'Silver',
      name: 'silver',
      desc: '',
      args: [],
    );
  }

  String get gold {
    return Intl.message(
      'Gold',
      name: 'gold',
      desc: '',
      args: [],
    );
  }

  String get platinum {
    return Intl.message(
      'Platinum',
      name: 'platinum',
      desc: '',
      args: [],
    );
  }

  String get orderByPSN {
    return Intl.message(
      'Order by PSN',
      name: 'orderByPSN',
      desc: '',
      args: [],
    );
  }

  String get orderByTime {
    return Intl.message(
      'Order by Time',
      name: 'orderByTime',
      desc: '',
      args: [],
    );
  }

  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  String get unobtained {
    return Intl.message(
      'Unobtained',
      name: 'unobtained',
      desc: '',
      args: [],
    );
  }

  String get searchTrophyHint {
    return Intl.message(
      'Input trophy name',
      name: 'searchTrophyHint',
      desc: '',
      args: [],
    );
  }

  String get jitterRangeToolTip {
    return Intl.message(
      'Change the jitter for generate trophy timestamps',
      name: 'jitterRangeToolTip',
      desc: '',
      args: [],
    );
  }

  String get randomDateTimeRangeToolTip {
    return Intl.message(
      'Change the range of random DateTime(Only for random trophy time generation)',
      name: 'randomDateTimeRangeToolTip',
      desc: '',
      args: [],
    );
  }

  String get randomDateTimeRangeTimeZoneAlert {
    return Intl.message(
      '*.DateTime from picker in your local timezone will be converted and displayed as UTC time.',
      name: 'randomDateTimeRangeTimeZoneAlert',
      desc: '',
      args: [],
    );
  }

  String get randomDateTimeRangeBegin {
    return Intl.message(
      'Begin',
      name: 'randomDateTimeRangeBegin',
      desc: '',
      args: [],
    );
  }

  String get randomDateTimeRangeEnd {
    return Intl.message(
      'End',
      name: 'randomDateTimeRangeEnd',
      desc: '',
      args: [],
    );
  }

  String get advancedPopupMenuToolTip {
    return Intl.message(
      'Advanced Features',
      name: 'advancedPopupMenuToolTip',
      desc: '',
      args: [],
    );
  }

  String get scriptUnlockMenuButton {
    return Intl.message(
      'Script Unlock',
      name: 'scriptUnlockMenuButton',
      desc: '',
      args: [],
    );
  }

  String get staticAnalyzeMenuButton {
    return Intl.message(
      'Static Analyze',
      name: 'staticAnalyzeMenuButton',
      desc: '',
      args: [],
    );
  }

  String get dynamicAnalyzeMenuButton {
    return Intl.message(
      'Dynamic Analyze',
      name: 'dynamicAnalyzeMenuButton',
      desc: '',
      args: [],
    );
  }

  String get pageHomeAppBarTitle {
    return Intl.message(
      'Vita Trophy Editor',
      name: 'pageHomeAppBarTitle',
      desc: '',
      args: [],
    );
  }

  String get pageHomeUsage {
    return Intl.message(
      'Usage: ',
      name: 'pageHomeUsage',
      desc: '',
      args: [],
    );
  }

  String get pageHomeUsageDetail {
    return Intl.message(
      'This is a tool for people who want to fine tone their trophies and not an easy unlock all solution.\nCode is not in perfect shape by any means so please use with caution. Always backup your original TRPTRANS.DAT beforehand\n',
      name: 'pageHomeUsageDetail',
      desc: '',
      args: [],
    );
  }

  String get pageHomeFiles {
    return Intl.message(
      '*.Files needed: ',
      name: 'pageHomeFiles',
      desc: '',
      args: [],
    );
  }

  String get pageHomeFilesDetail {
    return Intl.message(
      'ur0:/user/xx/trophy/conf/NPWRXXXXX_00/TROP.SFM\nur0:/user/xx/trophy/data/NPWRXXXXX_00/TRPTRANS.DAT\nTransfer them to your PC/Phone using vitashell or other file manager homebrew\n',
      name: 'pageHomeFilesDetail',
      desc: '',
      args: [],
    );
  }

  String get pageHomeAlert {
    return Intl.message(
      '*.TRPTRANS.DAT must be in the decrypted form before transfer:',
      name: 'pageHomeAlert',
      desc: '',
      args: [],
    );
  }

  String get pageHomeAlertDetail {
    return Intl.message(
      '1. Navigate to ur0:/user/xx/trophy/data/ folder using vitashell.\n2. Select NPWRXXXXX_00 folder and press triangle button, then choose Open decrypted and confirm\n3. Transfer decrypted TRPTRANS.DAT inside the folder\n',
      name: 'pageHomeAlertDetail',
      desc: '',
      args: [],
    );
  }

  String get pageHomeSelectFiles {
    return Intl.message(
      'Select files',
      name: 'pageHomeSelectFiles',
      desc: '',
      args: [],
    );
  }

  String get pageLocaleTitle {
    return Intl.message(
      'Choose Language',
      name: 'pageLocaleTitle',
      desc: '',
      args: [],
    );
  }

  String get pageLocaleEN {
    return Intl.message(
      'English',
      name: 'pageLocaleEN',
      desc: '',
      args: [],
    );
  }

  String get pageLocaleCN {
    return Intl.message(
      '简体中文',
      name: 'pageLocaleCN',
      desc: '',
      args: [],
    );
  }

  String get pageEditorModifyLock {
    return Intl.message(
      'Lock',
      name: 'pageEditorModifyLock',
      desc: '',
      args: [],
    );
  }

  String get pageEditorModifyPick {
    return Intl.message(
      'Pick',
      name: 'pageEditorModifyPick',
      desc: '',
      args: [],
    );
  }

  String get pageEditorModifyRandom {
    return Intl.message(
      'Random',
      name: 'pageEditorModifyRandom',
      desc: '',
      args: [],
    );
  }

  String get pageEditorModifyFinish {
    return Intl.message(
      'Finish',
      name: 'pageEditorModifyFinish',
      desc: '',
      args: [],
    );
  }

  String get pageEditorFinishAlertTitle {
    return Intl.message(
      'Successfully Saved',
      name: 'pageEditorFinishAlertTitle',
      desc: '',
      args: [],
    );
  }

  String get pageEditorFinishAlertDetail {
    return Intl.message(
      'All changes have been saved. Press Finish button to download TRPTRANS_MOD.DAT\n*.Rename TRPTRANS_MOD.DAT to TRPTRANS.DAT, transfer back to Vita and overwrite the original one(Be sure to decrypt the original file before overwrite)',
      name: 'pageEditorFinishAlertDetail',
      desc: '',
      args: [],
    );
  }

  String get pageEditorFinishAlertBack {
    return Intl.message(
      'Go Back to Editor',
      name: 'pageEditorFinishAlertBack',
      desc: '',
      args: [],
    );
  }

  String get pageEditorFinishAlertFinish {
    return Intl.message(
      'Finish',
      name: 'pageEditorFinishAlertFinish',
      desc: '',
      args: [],
    );
  }

  String get pageEditorRandomPSNTimeEndDefault {
    return Intl.message(
      'Unset. Current System Time will be used.',
      name: 'pageEditorRandomPSNTimeEndDefault',
      desc: '',
      args: [],
    );
  }

  String get psnTimeWrongFormatAlert {
    return Intl.message(
      'DateTime Format Wrong',
      name: 'psnTimeWrongFormatAlert',
      desc: '',
      args: [],
    );
  }

  String get jitterWrongFormatAlert {
    return Intl.message(
      'Jitter Format Wrong',
      name: 'jitterWrongFormatAlert',
      desc: '',
      args: [],
    );
  }

  String get scriptUnlockManualHavePlat {
    return Intl.message(
      'if the trophy set have platinum trophy',
      name: 'scriptUnlockManualHavePlat',
      desc: '',
      args: [],
    );
  }

  String get scriptUnlockManualId {
    return Intl.message(
      'id is the the same order as PSN default and starts from 0.',
      name: 'scriptUnlockManualId',
      desc: '',
      args: [],
    );
  }

  String get scriptUnlockManualRandom {
    return Intl.message(
      'time will genearate randomly',
      name: 'scriptUnlockManualRandom',
      desc: '',
      args: [],
    );
  }

  String get scriptUnlockManualRandomBaseEnd {
    return Intl.message(
      'if random is used in trophies[i].time then the following two fields are needed',
      name: 'scriptUnlockManualRandomBaseEnd',
      desc: '',
      args: [],
    );
  }

  String get scriptUnlockManualJitter {
    return Intl.message(
      'jitter used for set timestamps generation. Unit in microseconds',
      name: 'scriptUnlockManualJitter',
      desc: '',
      args: [],
    );
  }

  String get staticAnalyzeRange {
    return Intl.message(
      'Ranges of time where trophy can not be obtained',
      name: 'staticAnalyzeRange',
      desc: '',
      args: [],
    );
  }

  String get staticAnalyzeAffectedTrophies {
    return Intl.message(
      'Affected trophies by this time range',
      name: 'staticAnalyzeAffectedTrophies',
      desc: '',
      args: [],
    );
  }

  String get staticAnalyzeAffectedTrophiesAll {
    return Intl.message(
      'No trophies field means this time range affect all trophies in the list',
      name: 'staticAnalyzeAffectedTrophiesAll',
      desc: '',
      args: [],
    );
  }

  String get staticAnalyzeRepeat {
    return Intl.message(
      'Repeats of time where trophy can not be obtained',
      name: 'staticAnalyzeRepeat',
      desc: '',
      args: [],
    );
  }

  String get staticAnalyzeRepeatExample {
    return Intl.message(
      'Every Tuesday from 12am the trophies can not be obtained for 3600 seconds',
      name: 'staticAnalyzeRepeatExample',
      desc: '',
      args: [],
    );
  }

  String get scriptManualTitle {
    return Intl.message(
      'Script use JSON format and file name can be [Anything].json',
      name: 'scriptManualTitle',
      desc: '',
      args: [],
    );
  }

  String get scriptManualExample {
    return Intl.message(
      'Example:',
      name: 'scriptManualExample',
      desc: '',
      args: [],
    );
  }

  String get manualHide {
    return Intl.message(
      'Hide manual',
      name: 'manualHide',
      desc: '',
      args: [],
    );
  }

  String get manualShow {
    return Intl.message(
      'Show manual',
      name: 'manualShow',
      desc: '',
      args: [],
    );
  }

  String get scriptSelect {
    return Intl.message(
      'Select script',
      name: 'scriptSelect',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'), Locale.fromSubtags(languageCode: 'zh'), Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}