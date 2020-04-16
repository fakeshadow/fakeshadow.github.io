import 'dart:math';

import 'package:flutter/material.dart';

class PSNTime {
  final String timeString;

  // we use BaseTimeString as base time and set up a const micros between the base and unix epoch time.
  static const microsSinceBaseToUnixEpoch = 62135596800000000;
  static const BaseTimeString = "0001-01-01 01:01:01.000000";
  static const SecInMicroSecs = 1000000;

  // total length of time string
  static const TimeStringLength = 26;

  // length of time string in seconds precision
  static const SubSecLen = 6;
  static const SubStringLen = 4;

  PSNTime({this.timeString});

  static PSNTime base() {
    return PSNTime(timeString: BaseTimeString);
  }

  BigInt microsSinceBaseTime() {
    final timeSecs = _stringToDateTimeSec(this.timeString);
    final timeSubSecs = _stringToMicroSecs(this.timeString);

    final micros = microsSinceBaseToUnixEpoch + timeSecs.microsecondsSinceEpoch;

    // suck ass dart math will lose precision on microseconds adding. so we convert it to string and back to bigint
    var stringSecs = micros.toString();

    final len = stringSecs.length;
    if (len > 6) {
      stringSecs = stringSecs.substring(0, len - 6);
    }

    return BigInt.parse(
        stringSecs + _adjustSubSecsString(timeSubSecs.toString()));
  }

  // parse timestamp string into PSNTime string.
  static PSNTime parse(String timeStamp) {
    // Use int will lose some precision so we parse hex to big int then string and finally int(Suck ass math lib).
    final big = BigInt.parse(timeStamp, radix: 16).toString();

    // DateTime.add will lose huge precision so we split our big int string from the last six digital(microseconds) and manually add it to the DateTime result.(What the fuck)
    final len = big.length;
    final splitIndex = len - SubSecLen > 1 ? len - SubSecLen : 1;
    final bigSecs = big.substring(0, splitIndex);
    var bigSubSecs = big.substring(splitIndex, big.length);

    bigSubSecs = _adjustSubSecsString(bigSubSecs);

    final psnTime = DateTime.utc(1, 1, 1, 0, 0, 0, 0, 0)
        .add(Duration(seconds: int.parse(bigSecs)))
        .toString();

    return PSNTime(
        timeString:
            psnTime.substring(0, psnTime.length - SubStringLen) + bigSubSecs);
  }

  // psnTime2 in psv_local_trophy_bloc is generate by using PSNTime(psnTime1).toPsnTime2(jitter);
  PSNTime toPsnTime2(int jitter) {
    var tempDateTime = _stringToDateTimeSec(this.timeString);

    final adjust = _stringToMicroSecs(this.timeString) - jitter;
    var adjustString;

    if (adjust < 0) {
      tempDateTime = tempDateTime.subtract(Duration(seconds: 1));
      adjustString = (SecInMicroSecs + adjust).toString();
    } else {
      adjustString = _adjustSubSecsString(adjust.toString());
    }

    final time2String = tempDateTime.toString().substring(0, 20) + adjustString;

    return PSNTime(timeString: time2String);
  }

  int compareToInMicroSecs(PSNTime otherPSNTime) {
    final selfString = this == null ? BaseTimeString : this.timeString;
    final otherString =
        otherPSNTime == null ? BaseTimeString : otherPSNTime.timeString;

    final time1Secs = _stringToDateTimeSec(selfString);
    final time2Secs = _stringToDateTimeSec(otherString);

    final microSecs1 =
        microsSinceBaseToUnixEpoch + time1Secs.microsecondsSinceEpoch;
    final microSecs2 =
        microsSinceBaseToUnixEpoch + time2Secs.microsecondsSinceEpoch;

    final time1SubSecs = _stringToMicroSecs(this.timeString);
    final time2SubSecs = _stringToMicroSecs(otherString);

    var string1Secs = microSecs1.toString();
    final len1 = string1Secs.length;
    if (len1 > 6) {
      string1Secs = string1Secs.substring(0, len1 - 6);
    }

    var string2Secs = microSecs2.toString();
    final len2 = string2Secs.length;
    if (len2 > 6) {
      string2Secs = string2Secs.substring(0, len2 - 6);
    }

    final micro1 = BigInt.parse(
        string1Secs + _adjustSubSecsString(time1SubSecs.toString()));
    final micro2 = BigInt.parse(
        string2Secs + _adjustSubSecsString(time2SubSecs.toString()));

    return int.parse((micro1 - micro2).toString());
  }

  PSNTime adjustTimeString() {
    final date = _stringToDateTimeSec(this.timeString).toString();
    final micro = _adjustSubSecsString(
        _stringToMicroSecs(this.timeString).toString());

    return PSNTime(timeString: date.substring(0, 20) + micro);
  }

  bool validatePSNTime(String timeString) {
    try {
      final _date = _stringToDateTimeSec(timeString);
      final _time = _stringToMicroSecs(timeString);
      if (_date == null || _time == null) {
        return false;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  // parse a timeString with sec precision DateTime
  DateTime _stringToDateTimeSec(String timeString) {
    final dateTime = timeString.split("-");
    final year = int.parse(dateTime[0]);
    final month = int.parse(dateTime[1]);

    final dateTime2 = dateTime[2].split(" ");
    final day = int.parse(dateTime2[0]);

    final time = dateTime2[1].split(":");
    final hour = int.parse(time[0]);
    final min = int.parse(time[1]);

    final time2 = time[2].split(".");
    final sec = int.parse(time2[0]);

    if (year < 1) {
      throw ("Year not in range");
    }

    if (month < 1 || month > 12) {
      throw ("Month not in range");
    }

    if (day < 1 ||
        ((month == 1 ||
                month == 3 ||
                month == 5 ||
                month == 7 ||
                month == 8 ||
                month == 10 ||
                month == 12) &&
            day > 31)) {
      throw ("Day not in range");
    }

    if (day < 1 ||
        ((month == 4 || month == 6 || month == 9 || month == 11) && day > 30)) {
      throw ("Day not in range");
    }

    if (day < 1 || (month == 2 && day > 28 && (year / 4) is int)) {
      throw ("Day not in range");
    }

    if (day < 1 || (month == 2 && day > 27 && !((year / 4) is int))) {
      throw ("Day not in range");
    }

    if (hour < 0 || hour > 23) {
      throw ("Hour not in range");
    }

    if (min < 0 || min > 59) {
      throw ("Minute not in range");
    }

    if (sec < 0 || sec > 59) {
      throw ("Second not in range");
    }

    return DateTime.utc(year, month, day, hour, min, sec);
  }

  int _stringToMicroSecs(String timeString) {
    final time = timeString.split(".");
    final time1 = time[1];
    if (time1.contains("Z")) {
      time1.substring(0, time.indexOf("Z"));
    }
    if (time1.contains("z")) {
      time1.substring(0, time.indexOf("z"));
    }
    final micros = int.parse(time1);
    if (micros < 0 || micros > 999999) {
      throw ("MicroSecond is not in range");
    }
    return micros;
  }

  static randomPSNTime(DateTime begin, DateTime end) {
    final _begin = begin != null ? begin : DateTime.utc(2008, 7, 3);
    final _end = end != null ? end : DateTime.now().toUtc();

    final newMills =
        ((_end.millisecondsSinceEpoch - _begin.millisecondsSinceEpoch) *
                Random().nextDouble())
            .round();
    final randMicros = Random().nextInt(999999);

    final newDate = _begin.add(Duration(milliseconds: newMills));

    return PSNTime(
        timeString: newDate.toString().substring(0, 20) +
            _adjustSubSecsString(randMicros.toString()));
  }

  // adjust the time string format if we don't have enough zeros.
  static _adjustSubSecsString(String string) {
    final adjustTimes = SubSecLen - string.length;
    for (var i = 0; i < adjustTimes; i++) {
      string = "0" + string ;
    }
    return string;
  }
}
