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

  PSNTime now() {
    final now = DateTime.now().toUtc().toString();
    final time = _toDateTimeSec(now);
    return PSNTime(timeString: _dateTimeWithoutSubSecs(time) + "000000");
  }

  BigInt microsSinceBaseTime() {
    final timeSecs = _toDateTimeSec(this.timeString);
    final timeSubSec = _toMicro(this.timeString);

    final microsOff = BigInt.from(microsSinceBaseToUnixEpoch + timeSecs.microsecondsSinceEpoch);
    final micros = BigInt.from(timeSubSec);

    return microsOff + micros;
  }

  // parse timestamp string into PSNTime string.
  static PSNTime parse(String timeStamp) {
    // Use int will lose some precision so we parse hex to big int then string and finally int(Suck ass math lib).
    final big = BigInt.parse(timeStamp, radix: 16).toString();

    // DateTime.add will lose huge precision so we split our big int string from the last six digital(microseconds) and manually add it to the DateTime result.(What the fuck)
    final len = big.length;
    final splitIndex = len - SubSecLen > 1 ? len - SubSecLen : 1;
    final bigSecs = big.substring(0, splitIndex);
    var bigMicros = big.substring(splitIndex, big.length);

    bigMicros = _adjustMicrosString(bigMicros, false);

    final psnTime = DateTime.utc(1, 1, 1, 0, 0, 0, 0, 0)
        .add(Duration(seconds: int.parse(bigSecs)))
        .toString();

    return PSNTime(
        timeString:
            psnTime.substring(0, psnTime.length - SubStringLen) + bigMicros);
  }

  // psnTime2 in psv_local_trophy_bloc is generate by using PSNTime(psnTime1).toPsnTime2(jitter);
  PSNTime toPsnTime2(int jitter) {
    var tempDateTime = _toDateTimeSec(this.timeString);

    var newMicros = _toMicro(this.timeString) - jitter;

    if (newMicros < 0) {
      tempDateTime = tempDateTime.subtract(Duration(seconds: 1));
      newMicros = SecInMicroSecs + newMicros;
    }

    final time2String = _dateTimeWithoutSubSecs(tempDateTime) + _adjustMicrosString(newMicros.toString(), true);

    return PSNTime(timeString: time2String);
  }

  int compareToInMicroSecs(PSNTime otherPSNTime) {
    final selfString = this == null ? BaseTimeString : this.timeString;
    final otherString =
        otherPSNTime == null ? BaseTimeString : otherPSNTime.timeString;

    final time1Secs = _toDateTimeSec(selfString);
    final time2Secs = _toDateTimeSec(otherString);

    final microSecs1 =
        microsSinceBaseToUnixEpoch + time1Secs.microsecondsSinceEpoch;
    final microSecs2 =
        microsSinceBaseToUnixEpoch + time2Secs.microsecondsSinceEpoch;

    final time1Micros = _toMicro(selfString);
    final time2Micros = _toMicro(otherString);

    final micro1 = microSecs1 + time1Micros;
    final micro2 = microSecs2 + time2Micros;

    return micro1 - micro2;
  }

  PSNTime adjustTimeString() {
    final date = _toDateTimeSec(this.timeString);
    final micro = _toMicroString(this.timeString);

    return PSNTime(timeString: _dateTimeWithoutSubSecs(date) + micro);
  }

  bool validatePSNTime(String timeString) {
    try {
      final _date = _toDateTimeSec(timeString);
      final _time = _toMicroString(timeString);
      if (_date == null || _time == null) {
        return false;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  // parse a timeString with sec precision DateTime
  DateTime _toDateTimeSec(String timeString) {
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

  int _toMicro(String timeString) {
    final time1 = _toMicroString(timeString);
    return int.parse(time1);
  }

  String _toMicroString(String timeString) {
    final time = timeString.split(".");
    var time1 = time[1];
    if (time1.contains("Z")) {
      time1 = time1.substring(0, time.indexOf("Z"));
    }
    if (time1.contains("z")) {
      time1 = time1.substring(0, time.indexOf("z"));
    }

    if (time1.length > 6) {
      throw ("MicroSecond is not in range");
    }

    return _adjustMicrosString(time1, false);

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
        timeString: _dateTimeWithoutSubSecs(newDate) +
            _adjustMicrosString(randMicros.toString(), true));
  }

  // adjust the time string format if we don't have enough zeros.
  static _adjustMicrosString(String string, bool isReverse) {
    final adjustTimes = SubSecLen - string.length;
    for (var i = 0; i < adjustTimes; i++) {
      isReverse ? string = "0" + string : string = string + "0";
    }
    return string;
  }

  static _dateTimeWithoutSubSecs(DateTime datetime) {
    final timeList = datetime.toString().split(".");
    return timeList[0] + '.';
  }
}
