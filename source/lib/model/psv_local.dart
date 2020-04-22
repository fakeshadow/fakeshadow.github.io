// trophy model
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:psv_trophy_editor/util/psn_time.dart';

class PSVLocalTrophy extends Equatable {
  final int id;
  final String name, detail, rarity;
  final PSNTime psnTime1, psnTime2;
  final bool flagged;

  PSVLocalTrophy({
    this.id,
    this.name,
    this.detail,
    this.rarity,
    this.psnTime1,
    this.psnTime2,
    this.flagged,
  });

  PSVLocalTrophy copyWith({
    int id,
    String name,
    String detail,
    String rarity,
    PSNTime psnTime1,
    PSNTime psnTime2,
    bool flagged,
  }) {
    return PSVLocalTrophy(
      id: id ?? this.id,
      name: name ?? this.name,
      detail: detail ?? this.detail,
      rarity: rarity ?? this.rarity,
      psnTime1: psnTime1 ?? this.psnTime1,
      psnTime2: psnTime2 ?? this.psnTime2,
      flagged: flagged ?? this.flagged,
    );
  }

  @override
  List<Object> get props =>
      [id, name, detail, rarity, psnTime1, psnTime2, flagged];
}

// model for individual trophy script
class TrophyScript {
  final int id;
  final String time;

  const TrophyScript({this.id, this.time});
}

// model for the whole script and method to parse it from json.
class TrophySetScript {
  final bool havePlat;
  final int jitter;
  final String randomTimeBase, randomTimeEnd;
  final List<TrophyScript> trophies;

  TrophySetScript({
    this.havePlat,
    this.jitter,
    this.randomTimeBase,
    this.randomTimeEnd,
    this.trophies,
  });

  factory TrophySetScript.fromJson(Map<String, dynamic> json) {
    final int len = json["trophies"]?.length;

    final List<TrophyScript> trophies = [];

    if (len > 0) {
      for (var i = 0; i < len; i++) {
        trophies.add(TrophyScript(
          id: json["trophies"][i]["id"] as int,
          time: json["trophies"][i]["time"].toString(),
        ));
      }
    }

    return TrophySetScript(
        havePlat: json["havePlat"] as bool,
        jitter: json["jitter"] as int,
        randomTimeBase: json["randomTimeBase"]?.toString(),
        randomTimeEnd: json["randomTimeEnd"]?.toString(),
        trophies: trophies);
  }
}

// script for ranged time script
class StaticAnalyzeRangeScript {
  final String begin, end;
  final List<int> affectTrophies;

  const StaticAnalyzeRangeScript({this.begin, this.end, this.affectTrophies});
}

// script for ranged time script
class StaticAnalyzeRepeatScript {
  final int weekDay, hour, minute, second, duration;
  final List<int> affectTrophies;

  const StaticAnalyzeRepeatScript({
    this.weekDay,
    this.hour,
    this.minute,
    this.second,
    this.duration,
    this.affectTrophies,
  });
}

// script for the whole static analyze.
class StaticAnalyzeScript {
  final List<StaticAnalyzeRangeScript> ranges;
  final List<StaticAnalyzeRepeatScript> repeats;

  StaticAnalyzeScript({this.ranges, this.repeats});

  factory StaticAnalyzeScript.fromJson(Map<String, dynamic> json) {
    final int len1 = json["ranges"]?.length;
    final int len2 = json["repeats"]?.length;

    final List<StaticAnalyzeRangeScript> ranges = [];
    final List<StaticAnalyzeRepeatScript> repeats = [];

    if (len1 > 0) {
      for (var i = 0; i < len1; i++) {
        ranges.add(StaticAnalyzeRangeScript(
          begin: json["ranges"][i]["begin"].toString(),
          end: json["ranges"][i]["end"].toString(),
          affectTrophies: json["ranges"][i]['trophies'] != null
              ? _parseAffectTrophies(json["ranges"][i]['trophies'])
              : [],
        ));
      }
    }

    if (len2 > 0) {
      for (var i = 0; i < len2; i++) {
        repeats.add(StaticAnalyzeRepeatScript(
          weekDay: json["repeats"][i]["weekDay"] as int,
          hour: json["repeats"][i]["hour"] as int,
          minute: json["repeats"][i]["minute"] as int,
          second: json["repeats"][i]["second"] as int,
          duration: json["repeats"][i]["duration"] as int,
          affectTrophies: json["repeats"][i]['trophies'] != null
              ? _parseAffectTrophies(json["repeats"][i]['trophies'])
              : [],
        ));
      }
    }

    return StaticAnalyzeScript(ranges: ranges, repeats: repeats);
  }

  static List<int> _parseAffectTrophies(List<dynamic> trophies) {
    final List<int> affectTrophies = [];
    final int len = trophies?.length;

    if (len > 0) {
      for (var i = 0; i < len; i++) {
        affectTrophies.add(trophies[i] as int);
      }
    }
    return affectTrophies;
  }
}
