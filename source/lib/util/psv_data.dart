import 'dart:convert';
import 'package:convert/convert.dart';

import 'package:psv_trophy_editor/bloc/psv_local_trophy.dart';
import 'package:psv_trophy_editor/model/psv_local.dart';
import 'package:psv_trophy_editor/util/psn_time.dart';

class PSVFileParser {
  final String npCommId, title, trpTrans, trpTitle;
  final int orgSetCount, jitter;
  final bool havePlat;
  final List<PSVLocalTrophy> trophies;

  PSVFileParser({
    this.npCommId,
    this.title,
    this.orgSetCount,
    this.havePlat,
    this.trophies,
    this.trpTrans,
    this.trpTitle,
    this.jitter,
  });

  static const String baseTimeStamp = "0000000000000000";
  static const int timeStampLen = 16;

  // all offsets are applied to hex string. So it's the actual hex offset * 2
  static const int npCommIdOffTrans = 736;

  static const int lockOffTrans = 1774;
  static const String lockedTrans = "00";
  static const String unlockedTrans = "02";

  static const int syncOffTrans = 1782;
  static const String unSyncedTrans = "00";
  static const String syncedTrans = "01";

  static const int trpIdOffTrans = 1830;
  static const int rarityOffTrans = 1838;

  static const int lockOff2Trans = 1844;
  static const String locked2Trans = "00";
  static const String unlocked2Trans = "20";

  static const int timeStamp1OffTrans = 1856;
  static const int timeStamp2OffTrains = 1872;

  // one trophy in TRPTRANS takes 176 bytes.
  static const int trpGapTrans = 352;

  // marker of where we start to edit TRPTITLE.DAT.
  static const String trpTitleMarker = "00000800000000500000000000000000";

  // all offset in TRPTITLE.DAT are relative to the marker offset.
  static const int trpIdOffTitle = 36;

  // percentage offset is before the marker offset.
  static const int percentageOffTitle = -576;

  // percentage offset 2 is before the marker offset.
  static const int percentage2OffTitle = -800;

  static const int lockOffTitle = 46;
  static const String lockedTitle = "00";
  static const String unlockedTitle = "01";

  static const int syncedOffTitle = 52;
  static const String syncNoStateTitle = "00";
  static const String unSyncedTitle = "20";

  static const int timeStamp1OffTitle = 64;
  static const int timeStamp2OffTitle = 80;

  // one trophy in TRPTITLE takes 96 bytes.
  static const int trpGapTitle = 192;

  static fromBlocState(PSVLocalTrophyLoaded state) {
    return PSVFileParser(
      title: state.title,
      orgSetCount: state.orgSetCount,
      havePlat: state.havePlat,
      trophies: state.trophies,
      trpTrans: state.trpTrans,
      trpTitle: state.trpTitle,
      jitter: state.jitter,
    );
  }

  static parseSFM(String sfmString) {
    final List<PSVLocalTrophy> trophies = [];

    final npCommId = sfmString.substring(
        sfmString.indexOf("<npcommid>") + 10, sfmString.indexOf("</npcommid>"));

    final title = sfmString.substring(sfmString.indexOf("<title-name>") + 12,
        sfmString.indexOf("</title-name>"));

    final lastIndex = sfmString.lastIndexOf("<trophy id=");
    // We assume one list contain at most 999 trophies(Exclude platinum trophy which trophy id is 0)
    final trophyCount =
        int.parse(sfmString.substring(lastIndex + 12, lastIndex + 15));

    var orgSetCount = 0;
    var havePlat = false;
    for (var i = 0; i <= trophyCount; i++) {
      final index = i < 10
          ? 'trophy id="00$i"'
          : i < 100 ? 'trophy id="0$i"' : 'trophy id="$i"';

      sfmString = sfmString.substring(sfmString.indexOf(index));

      final rarity = sfmString.substring(
          sfmString.indexOf("ttype=") + 7, sfmString.indexOf("ttype=") + 8);

      // we mark the trophy set if it has platinum
      if (i == 0 && rarity == "P") {
        havePlat = true;
      }

      final name = sfmString.substring(
          sfmString.indexOf("<name>") + 6, sfmString.indexOf("</name>"));
      final detail = sfmString.substring(
          sfmString.indexOf("<detail>") + 8, sfmString.indexOf("</detail>"));

      // we count all the trophies have pid=000 as they all belong to the base game
      // this is not necessary to do if havePlat == false but we do it anyway as performance is not crucial for some simple file editor.
      final pId = sfmString.substring(
          sfmString.indexOf("pid=") + 5, sfmString.indexOf("pid=") + 8);
      if (pId == "000") {
        orgSetCount += 1;
      }

      trophies.add(PSVLocalTrophy(
          id: i,
          name: name,
          detail: detail,
          rarity: rarity,
          psnTime1: null,
          psnTime2: null));
    }

    return PSVFileParser(
      npCommId: npCommId,
      title: title,
      orgSetCount: orgSetCount,
      havePlat: havePlat,
      trophies: trophies,
    );
  }

  PSVFileParser parseTrpTitle(List<int> bytebuffer) {
    return PSVFileParser(
      title: this.title,
      orgSetCount: this.orgSetCount,
      havePlat: this.havePlat,
      trophies: this.trophies,
      trpTrans: this.trpTrans,
      trpTitle: hex.encode(bytebuffer),
      jitter: this.jitter,
    );
  }

  PSVFileParser parseTRANS(List<int> bytebuffer) {
    final trpTrans = hex.encode(bytebuffer);

    // np comm id(trophy set id) is 12 bytes long and since we use string to represent the hex data so it needs to multiply by 2.
    final _npCommId = ascii.decode(hex
        .decode(trpTrans.substring(npCommIdOffTrans, npCommIdOffTrans + 24)));

    if (this.npCommId != _npCommId) {
      // ToDo: throw error here;
      return PSVFileParser();
    }

    final List<int> jitters = [];

    for (var i = 0; i < 255; i++) {
      // trophy id is 2 bytes.
      final _idOff = trpIdOffTrans + trpGapTrans * i;
      final trpId = trpTrans.substring(_idOff, _idOff + 2);
      /*
            trophy rarity is 1 byte.
            TRPTRANS.DAT  Rarity  TROP.SFM
            04            bronze  B
            03            silver  S
            02            gold    G
            01            plat    P
          */
      final _rarityOff = rarityOffTrans + trpGapTrans * i;
      final rarity = trpTrans.substring(_rarityOff, _rarityOff + 2);

      /*
            Timestamp is generated from the total time eclipsed starting from Year1-January-1st-Zero Hour Utc and any give time.
            The precision is in microsecond and the format is Hex.
            There are two timestamp for one trophy. One is the time from internal clock and the other is the user clock.
            The two timestamps have a near fixed time gap when you keep two clocks up to date. The time gap may vary on different or even the same machine.
            Some of my personal recorded time gap:
              . timestamp_latter - timestamp_first = 2764 microsecond (2.764ms)
      */
      final _timeStamp1Off = timeStamp1OffTrans + trpGapTrans * i;
      final _timeStamp2Off = timeStamp2OffTrains + trpGapTrans * i;
      final timeStamp1 =
          trpTrans.substring(_timeStamp1Off, _timeStamp1Off + timeStampLen);
      final timeStamp2 =
          trpTrans.substring(_timeStamp2Off, _timeStamp2Off + timeStampLen);

      final psnTime1 = PSNTime.parse(timeStamp1);
      final psnTime2 = PSNTime.parse(timeStamp2);

      jitters.add(psnTime1.compareToInMicroSecs(psnTime2));

      if (trpId == "00" && rarity == "00") {
        break;
      } else {
        final id = int.parse(trpId, radix: 16);
        final trophy = this.trophies[id];

        this.trophies.replaceRange(id, id + 1, [
          PSVLocalTrophy(
            id: trophy.id,
            name: trophy.name,
            detail: trophy.detail,
            rarity: trophy.rarity,
            psnTime1: psnTime1,
            psnTime2: psnTime2,
            flagged: false,
          )
        ]);
      }
    }

    // ToDo: more logic on the jitter logic as it can be floating in microseconds. Right now we just use the first one from the array.
    var jitter;
    try {
      jitter = jitters.elementAt(0);
    } catch (_) {
      jitter = 0;
    }

    return PSVFileParser(
      title: this.title,
      orgSetCount: this.orgSetCount,
      havePlat: this.havePlat,
      trophies: this.trophies,
      trpTrans: trpTrans,
      jitter: jitter,
    );
  }

  List<int> modifyTitle() {
    String trpTitle = this.trpTitle;

    final int marker = this.trpTitle.indexOf(trpTitleMarker);
    int percentage = 0;

    for (final trophy in this.trophies) {
      if (trophy.psnTime1 == null && trophy.psnTime2 == null) {
        trpTitle = _clearTrophyTitle(trpTitle, trophy.id, marker);
      } else {
        trpTitle = _writeTrophyTitle(trpTitle, trophy, marker);
        percentage += _bitShiftInInt(trophy.id);
      }
    }

    trpTitle = _writePercentage(trpTitle, percentage, marker);

    return hex.decode(trpTitle);
  }

  String _writePercentage(String trpTitle, int percent, int marker) {
    String string = percent.toRadixString(16);
    for (int i = string.length; i < 10; i++) {
      string = "0" + string;
    }

    String stringNew = "";
    for (int i = string.length - 2; i >= 0; i = i - 2) {
      stringNew = stringNew + string.substring(i, i + 2);
    }

    final int _percentOff = marker + percentageOffTitle;
    final int _percent2Off = marker + percentage2OffTitle;

    trpTitle =
        trpTitle.replaceRange(_percent2Off, _percent2Off + 10, stringNew);
    trpTitle = trpTitle.replaceRange(_percentOff, _percentOff + 10, stringNew);

    return trpTitle;
  }

  int _bitShiftInInt(int trophyId) {
    return 1 << trophyId;
  }

  String _clearTrophyTitle(String trpTitle, int trophyId, int marker) {
    final gap = trophyId * trpGapTitle;
    final _lockOff = marker + gap + lockOffTitle;
    final _syncOff = marker + gap + syncedOffTitle;
    final _timeStamp1Off = marker + gap + timeStamp1OffTitle;
    final _timeStamp2Off = marker + gap + timeStamp2OffTitle;

    // clear lock state;
    trpTitle = trpTitle.replaceRange(_lockOff, _lockOff + 2, lockedTitle);

    // clear sync state;
    trpTitle = trpTitle.replaceRange(_syncOff, _syncOff + 2, syncNoStateTitle);

    // clear timestamp;
    trpTitle = trpTitle.replaceRange(
        _timeStamp1Off, _timeStamp1Off + timeStampLen, baseTimeStamp);
    trpTitle = trpTitle.replaceRange(
        _timeStamp2Off, _timeStamp2Off + timeStampLen, baseTimeStamp);

    return trpTitle;
  }

  String _writeTrophyTitle(String trpTitle, PSVLocalTrophy trophy, int marker) {
    final gap = trophy.id * trpGapTitle;
    final _lockOff = marker + gap + lockOffTitle;
    final _syncOff = marker + gap + syncedOffTitle;
    final _timeStamp1Off = marker + gap + timeStamp1OffTitle;
    final _timeStamp2Off = marker + gap + timeStamp2OffTitle;

    // write lock state;
    trpTitle = trpTitle.replaceRange(_lockOff, _lockOff + 2, unlockedTitle);

    // write sync state in hex;
    trpTitle = trpTitle.replaceRange(_syncOff, _syncOff + 2, unSyncedTitle);

    // write timestamp in hex;
    var _timeStamp1 = trophy.psnTime1.microsSinceBaseTime().toRadixString(16);
    var _timeStamp2 = trophy.psnTime2.microsSinceBaseTime().toRadixString(16);

    while (_timeStamp1.length < timeStampLen) {
      _timeStamp1 = "0" + _timeStamp1;
    }
    while (_timeStamp2.length < timeStampLen) {
      _timeStamp2 = "0" + _timeStamp2;
    }

    trpTitle = trpTitle.replaceRange(
        _timeStamp1Off, _timeStamp1Off + timeStampLen, _timeStamp1);
    trpTitle = trpTitle.replaceRange(
        _timeStamp2Off, _timeStamp2Off + timeStampLen, _timeStamp2);

    return trpTitle;
  }

  List<int> modifyTrans() {
    var transNew = this.trpTrans;

    final length = this.trophies.length;
    for (var i = 0; i < length; i++) {
      transNew = _clearTrophyTrans(transNew, this.trophies[i].id, length);
    }

    // sort trophies from early to late order.
    this.trophies.sort((trp1, trp2) {
      final time1 =
          trp1.psnTime1 == null ? PSNTime.baseString() : trp1.psnTime1;
      final time2 =
          trp2.psnTime1 == null ? PSNTime.baseString() : trp2.psnTime1;
      return time1.compareToInMicroSecs(time2);
    });

    var transIndex = 0;
    for (var i = 0; i < length; i++) {
      final trophy = this.trophies[i];
      if (trophy.psnTime1 != null) {
        transNew = _writeTrophyTrans(transNew, trophy, transIndex);
        transIndex += 1;
      }
    }

    return hex.decode(transNew);
  }

  String _clearTrophyTrans(String trpTrans, int trophyId, int length) {
    for (var index = 0; index < length; index++) {
      final int gap = trpGapTrans * index;
      final _trpIdOff = trpIdOffTrans + gap;
      final _rarityOff = rarityOffTrans + gap;
      final _syncOff = syncOffTrans + gap;
      final _timeStamp1Off = timeStamp1OffTrans + gap;
      final _timeStamp2Off = timeStamp2OffTrains + gap;
      final _lock = lockOffTrans + gap;
      final _lock2 = lockOff2Trans + gap;

      final trpId = trpTrans.substring(_trpIdOff, _trpIdOff + 2);
      final _trpId = int.parse(trpId, radix: 16);

      if (trophyId == _trpId) {
        // clear trophy id;
        trpTrans = trpTrans.replaceRange(_trpIdOff, _trpIdOff + 2, "00");

        // clear rarity ;
        trpTrans = trpTrans.replaceRange(_rarityOff, _rarityOff + 2, "00");

        // clear sync state;
        trpTrans = trpTrans.replaceRange(_syncOff, _syncOff + 2, unSyncedTrans);

        // clear lock state;
        trpTrans = trpTrans.replaceRange(_lock, _lock + 2, lockedTrans);

        // clear lock 2 state;
        trpTrans = trpTrans.replaceRange(_lock2, _lock2 + 2, locked2Trans);

        // clear timestamp;
        trpTrans = trpTrans.replaceRange(
            _timeStamp1Off, _timeStamp1Off + timeStampLen, "0000000000000000");
        trpTrans = trpTrans.replaceRange(
            _timeStamp2Off, _timeStamp2Off + timeStampLen, "0000000000000000");
      }
    }

    return trpTrans;
  }

  String _writeTrophyTrans(String trpTrans, PSVLocalTrophy trophy, int index) {
    final gap = trpGapTrans * index;
    final _trpIdOff = trpIdOffTrans + gap;
    final _rarityOff = rarityOffTrans + gap;
    final _timeStamp1Off = timeStamp1OffTrans + gap;
    final _timeStamp2Off = timeStamp2OffTrains + gap;
    final _lockOff = lockOffTrans + gap;
    final _lock2Off = lockOff2Trans + gap;

    // write trophy id in hex;
    String _id = trophy.id.toRadixString(16);
    _id = _id.length < 2 ? "0" + _id : _id;
    trpTrans = trpTrans.replaceRange(_trpIdOff, _trpIdOff + 2, _id);

    // write rarity id in hex;
    final _rarity = _mapRarity(trophy.rarity);
    trpTrans = trpTrans.replaceRange(_rarityOff, _rarityOff + 2, _rarity);

    // write lock state;
    trpTrans = trpTrans.replaceRange(_lockOff, _lockOff + 2, unlockedTrans);

    // write lock2 state in hex;
    trpTrans = trpTrans.replaceRange(_lock2Off, _lock2Off + 2, unlocked2Trans);

    // write timestamp in hex;
    var _timeStamp1 = trophy.psnTime1.microsSinceBaseTime().toRadixString(16);
    var _timeStamp2 = trophy.psnTime2.microsSinceBaseTime().toRadixString(16);

    while (_timeStamp1.length < timeStampLen) {
      _timeStamp1 = "0" + _timeStamp1;
    }
    while (_timeStamp2.length < timeStampLen) {
      _timeStamp2 = "0" + _timeStamp2;
    }

    trpTrans = trpTrans.replaceRange(
        _timeStamp1Off, _timeStamp1Off + timeStampLen, _timeStamp1);
    trpTrans = trpTrans.replaceRange(
        _timeStamp2Off, _timeStamp2Off + timeStampLen, _timeStamp2);

    return trpTrans;
  }

  String _mapRarity(String rarity) {
    switch (rarity) {
      case ("B"):
        return "04";
        break;
      case ("S"):
        return "03";
        break;
      case ("G"):
        return "02";
        break;
      case ("P"):
        return "01";
        break;
      default:
        return "04";
    }
  }
}
