import 'dart:convert';
import 'package:convert/convert.dart';

import 'package:psv_trophy_editor/bloc/psv_local_trophy.dart';
import 'package:psv_trophy_editor/model/psv_local.dart';
import 'package:psv_trophy_editor/util/psn_time.dart';

class PSVFileParser {
  final String npCommId, title, trpTrans;
  final int orgSetCount, jitter;
  final bool havePlat;
  final List<PSVLocalTrophy> trophies;

  PSVFileParser(
      {this.npCommId,
      this.title,
      this.orgSetCount,
      this.havePlat,
      this.trophies,
      this.trpTrans,
      this.jitter});

  // all offsets are applied to hex string. So it's the actual hex offset * 2
  static const int npCommIdOff = 736;

  static const int lockOff = 1774;
  static const String locked = "00";
  static const String unlocked = "02";

  static const int trpIdOff = 1830;
  static const int rarityOff = 1838;

  static const int syncedOff = 1844;

  // ToDo: investigate the accurate synced string code
  static const String synced = "40";
  static const String unSynced = "20";

  static const int timeStamp1Off = 1856;
  static const int timeStamp2Off = 1872;
  static const String baseTimeStamp = "0000000000000000";
  static const int timeStampLen = 16;

  // one trophy takes 176 bytes.
  static const int trpGap = 352;

  static fromBlocState(PSVLocalTrophyLoaded state) {
    return PSVFileParser(
      title: state.title,
      orgSetCount: state.orgSetCount,
      havePlat: state.havePlat,
      trophies: state.trophies,
      trpTrans: state.trpTrans,
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
        trophies: trophies);
  }

  PSVFileParser parseTRANS(List<int> bytebuffer) {
    final trpTrans = hex.encode(bytebuffer);

    // np comm id(trophy set id) is 12 bytes long and since we use string to represent the hex data so it needs to multiply by 2.
    final _npCommId = ascii
        .decode(hex.decode(trpTrans.substring(npCommIdOff, npCommIdOff + 24)));

    if (this.npCommId != _npCommId) {
      // ToDo: throw error here;
      return PSVFileParser();
    }

    final List<int> jitters = [];

    for (var i = 0; i < 255; i++) {
      // trophy id is 2 bytes.
      final _idOff = trpIdOff + trpGap * i;
      final trpId = trpTrans.substring(_idOff, _idOff + 2);
      /*
            trophy rarity is 1 byte.
            TRPTRANS.DAT  Rarity  TROP.SFM
            04            bronze  B
            03            silver  S
            02            gold    G
            01            plat    P
          */
      final _rarityOff = rarityOff + trpGap * i;
      final rarity = trpTrans.substring(_rarityOff, _rarityOff + 2);

      /*
            Timestamp is generated from the total time eclipsed starting from Year1-January-1st-Zero Hour Utc and any give time.
            The precision is in microsecond and the format is Hex.
            There are two timestamp for one trophy. One is the time from internal clock and the other is the user clock.
            The two timestamps have a near fixed time gap when you keep two clocks up to date. The time gap may vary on different or even the same machine.
            Some of my personal recorded time gap:
              . timestamp_latter - timestamp_first = 2764 microsecond (2.764ms)
      */
      final _timeStamp1Off = timeStamp1Off + trpGap * i;
      final _timeStamp2Off = timeStamp2Off + trpGap * i;
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
        jitter: jitter);
  }

  List<int> modifyTrans() {
    var transNew = this.trpTrans;

    final length = this.trophies.length;
    for (var i = 0; i < length; i++) {
      transNew = _clearTrophy(transNew, this.trophies[i].id, length);
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
        transNew = _writeTrophy(transNew, trophy, transIndex);
        transIndex += 1;
      }
    }

    return hex.decode(transNew);
  }

  String _clearTrophy(String trpTrans, int trophyId, int length) {
    for (var index = 0; index < length; index++) {
      final _trpIdOff = trpIdOff + trpGap * index;
      final _rarityOff = rarityOff + trpGap * index;
      final _timeStamp1Off = timeStamp1Off + trpGap * index;
      final _timeStamp2Off = timeStamp2Off + trpGap * index;
      final _syncOff = syncedOff + trpGap * index;

      final trpId = trpTrans.substring(_trpIdOff, _trpIdOff + 2);
      final _trpId = int.parse(trpId, radix: 16);

      if (trophyId == _trpId) {
        // clear lock state;
        trpTrans = trpTrans.replaceRange(
            lockOff + trpGap * index, lockOff + trpGap * index + 2, locked);

        // clear trophy id;
        trpTrans = trpTrans.replaceRange(_trpIdOff, _trpIdOff + 2, "00");

        // clear rarity ;
        trpTrans = trpTrans.replaceRange(_rarityOff, _rarityOff + 2, "00");

        // clear sync state;
        trpTrans = trpTrans.replaceRange(_syncOff, _syncOff + 2, "00");

        // clear timestamp;
        trpTrans = trpTrans.replaceRange(
            _timeStamp1Off, _timeStamp1Off + timeStampLen, "0000000000000000");
        trpTrans = trpTrans.replaceRange(
            _timeStamp2Off, _timeStamp2Off + timeStampLen, "0000000000000000");
      }
    }

    return trpTrans;
  }

  String _writeTrophy(String trpTrans, PSVLocalTrophy trophy, int index) {
    final _trpIdOff = trpIdOff + trpGap * index;
    final _rarityOff = rarityOff + trpGap * index;
    final _timeStamp1Off = timeStamp1Off + trpGap * index;
    final _timeStamp2Off = timeStamp2Off + trpGap * index;
    final _syncOff = syncedOff + trpGap * index;

    // write lock state;
    trpTrans = trpTrans.replaceRange(
        lockOff + trpGap * index, lockOff + trpGap * index + 2, unlocked);

    // write trophy id in hex;
    var _id = trophy.id.toRadixString(16);
    _id = _id.length < 2 ? "0" + _id : _id;
    trpTrans = trpTrans.replaceRange(_trpIdOff, _trpIdOff + 2, _id);

    // write trophy id in hex;
    final _rarity = _mapRarity(trophy.rarity);
    trpTrans = trpTrans.replaceRange(_rarityOff, _rarityOff + 2, _rarity);

    // write sync state in hex;
    trpTrans = trpTrans.replaceRange(_syncOff, _syncOff + 2, unSynced);

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
        return "04";
        break;
      case ("G"):
        return "04";
        break;
      case ("P"):
        return "04";
        break;
      default:
        return "04";
    }
  }
}
