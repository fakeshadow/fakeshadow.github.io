import 'package:http/http.dart' as http;

import 'package:psv_trophy_editor/model/psv_local.dart';

class EditorService {
  static const serverUrl = "https://trophyeditor.com";

  static dynamicAnalyze({List<PSVLocalTrophy> trophies}) async {
      final json = trophies.map((trophy) => null).toList();
      final res = await http.post(serverUrl, body: json);
  }
}

class Advice {
  final List<ConflictAdvice> conflict;
  final List<ProximityAdvice> proximity;

  const Advice({this.conflict,this.proximity});
}

class ProximityAdvice {
  final int trophyId;
  final int proximityTrophyId;

  const ProximityAdvice({this.trophyId,this.proximityTrophyId});
}

class ConflictAdvice {
  final String probability;
  final int trophyId;
  final List<int> trophiesConflictBefore;
  final List<int> trophiesConflictAfter;

  const ConflictAdvice({this.probability,this.trophyId, this.trophiesConflictBefore,this.trophiesConflictAfter});
}