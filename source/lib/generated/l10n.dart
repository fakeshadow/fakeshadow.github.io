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