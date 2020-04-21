// trophy model
import 'package:equatable/equatable.dart';
import 'package:psv_trophy_editor/util/psn_time.dart';

class PSVLocalTrophy extends Equatable {
  final int id;
  final String name, detail, rarity;
  final PSNTime psnTime1, psnTime2;

  PSVLocalTrophy(
      {this.id,
      this.name,
      this.detail,
      this.rarity,
      this.psnTime1,
      this.psnTime2});

  @override
  List<Object> get props => [id, name, detail, rarity, psnTime1, psnTime2];
}

// model for individual trophy script
class ScriptTrophy {
  final int id;
  final String time;

  const ScriptTrophy({this.id, this.time});
}

// model for the whole script and method to parse it from json.
class Script {
  final bool havePlat;
  final int jitter;
  final String randomTimeBase, randomTimeEnd;
  final List<ScriptTrophy> trophies;

  Script({
    this.havePlat,
    this.jitter,
    this.randomTimeBase,
    this.randomTimeEnd,
    this.trophies,
  });

  factory Script.fromJson(Map<String, dynamic> json) {
    final int len = json["trophies"]?.length;

    final List<ScriptTrophy> trophies = [];

    if (len > 0) {
      for (var i = 0; i < len; i++) {
        trophies.add(ScriptTrophy(
          id: json["trophies"][i]["id"] as int,
          time: json["trophies"][i]["time"].toString(),
        ));
      }
    }

    return Script(
        havePlat: json["havePlat"] as bool,
        jitter: json["jitter"] as int,
        randomTimeBase: json["randomTimeBase"]?.toString(),
        randomTimeEnd: json["randomTimeEnd"]?.toString(),
        trophies: trophies);
  }
}
