import 'package:flutter/cupertino.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:psv_trophy_editor/model/psv_local.dart';
import 'package:psv_trophy_editor/repo/local_storage.dart';
import 'package:psv_trophy_editor/util/psn_time.dart';

// events for bloc
abstract class PSVLocalTrophyEvent extends Equatable {
  const PSVLocalTrophyEvent();

  @override
  List<Object> get props => [];
}

class Reset extends PSVLocalTrophyEvent {}

class OrderByPSN extends PSVLocalTrophyEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'OrderByPSN';
}

class OrderByTime extends PSVLocalTrophyEvent {
  final bool isLaterFront;

  OrderByTime({this.isLaterFront});

  @override
  List<Object> get props => [isLaterFront];

  @override
  String toString() => 'OrderByTime : { isLaterFront: $isLaterFront }';
}

class SetTrophy extends PSVLocalTrophyEvent {
  final int orgSetCount, jitter;
  final bool havePlat;
  final String title, trpTrans, trpTitle;
  final List<PSVLocalTrophy> trophies;

  const SetTrophy({
    @required this.title,
    this.havePlat,
    this.orgSetCount,
    this.jitter, // jitter is the time gap between two timestamps of one trophy.
    this.trpTrans,
    this.trpTitle,
    this.trophies,
  });

  @override
  List<Object> get props =>
      [title, havePlat, orgSetCount, jitter, trpTrans, trpTitle, trophies];

  @override
  String toString() => 'SetTrophy { title: $title }';
}

class ModifyTrophy extends PSVLocalTrophyEvent {
  final List<PSVLocalTrophy> trophies;

  const ModifyTrophy({@required this.trophies});

  @override
  List<Object> get props => [trophies];

  @override
  String toString() => 'ModifyTrophy { trophies: $trophies }';
}

class ScriptModifyTrophy extends PSVLocalTrophyEvent {
  final TrophySetScript script;

  const ScriptModifyTrophy({@required this.script});

  @override
  List<Object> get props => [script];

  @override
  String toString() => 'ScriptModifyTrophy { script: $script }';
}

class StaticAnalyzeTrophy extends PSVLocalTrophyEvent {
  final StaticAnalyzeScript script;

  const StaticAnalyzeTrophy({@required this.script});

  @override
  List<Object> get props => [script];

  @override
  String toString() => 'StaticAnalyzeTrophy { script: $script }';
}

class SetBaseEndDateTime extends PSVLocalTrophyEvent {
  final DateTime base, end;

  const SetBaseEndDateTime({this.base, this.end});

  @override
  List<Object> get props => [base, end];

  @override
  String toString() => 'SetBaseEndDateTime { base: $base, end: $end }';
}

class SetJitter extends PSVLocalTrophyEvent {
  final int jitter;

  const SetJitter({this.jitter});

  @override
  List<Object> get props => [jitter];

  @override
  String toString() => 'SetJitter { jitter: $jitter }';
}

class SetSearchedTrophy extends PSVLocalTrophyEvent {
  final List<PSVLocalTrophy> searchedTrophies;

  const SetSearchedTrophy({this.searchedTrophies});

  @override
  List<Object> get props => [searchedTrophies];

  @override
  String toString() =>
      'SetSearchResult { searchedTrophies: $searchedTrophies }';
}

// states for Bloc
abstract class PSVLocalTrophyState extends Equatable {
  const PSVLocalTrophyState();

  @override
  List<Object> get props => [];
}

class PSVLocalTrophyUninitialized extends PSVLocalTrophyState {}

class PSVLocalTrophyLoaded extends PSVLocalTrophyState {
  final int orgSetCount,
      jitter,
      currentOrder; // currentOrder : 0 == ByPSN; 1 == ByTime
  final bool havePlat;
  final String title, trpTrans, trpTitle;
  final List<PSVLocalTrophy> trophies;
  final List<PSVLocalTrophy> searchedTrophies;
  final DateTime baseTime, endTime;

  const PSVLocalTrophyLoaded({
    this.currentOrder,
    this.title,
    this.havePlat,
    this.orgSetCount,
    this.jitter,
    this.trpTrans,
    this.trpTitle,
    this.trophies,
    this.searchedTrophies,
    this.baseTime,
    this.endTime,
  });

  @override
  List<Object> get props => [
        currentOrder,
        title,
        havePlat,
        orgSetCount,
        jitter,
        trpTrans,
        trpTitle,
        trophies,
        searchedTrophies,
        baseTime,
        endTime
      ];

  PSVLocalTrophyLoaded copyWith({
    int currentOrder,
    String title,
    bool havePlat,
    int orgSetCount,
    int jitter,
    String trpTrans,
    String trpTitle,
    List<PSVLocalTrophy> trophies,
    List<PSVLocalTrophy> searchedTrophies,
    DateTime baseTime,
    DateTime endTime,
  }) {
    return PSVLocalTrophyLoaded(
      currentOrder: currentOrder ?? this.currentOrder,
      title: title ?? this.title,
      havePlat: havePlat ?? this.havePlat,
      orgSetCount: orgSetCount ?? this.orgSetCount,
      jitter: jitter ?? this.jitter,
      trpTrans: trpTrans ?? this.trpTrans,
      trpTitle: trpTitle ?? this.trpTitle,
      trophies: trophies ?? this.trophies,
      searchedTrophies: searchedTrophies ?? this.searchedTrophies,
      baseTime: baseTime ?? this.baseTime,
      endTime: endTime ?? this.endTime,
    );
  }

  @override
  String toString() => 'PSVLocalTrophyLoaded { '
      'currentOrder: $currentOrder ,'
      'title: $title, '
      'havePlat: $havePlat, '
      'orgSetCount: $orgSetCount, '
      'trophies: $trophies, '
      'baseTime: $baseTime, '
      'endTime: $endTime '
      '}';
}

//bloc logic
class PSVLocalTrophyBloc
    extends Bloc<PSVLocalTrophyEvent, PSVLocalTrophyState> {
  final LocalStorageRepo localStorageRepo;

  PSVLocalTrophyBloc(this.localStorageRepo);

  @override
  PSVLocalTrophyState get initialState => PSVLocalTrophyUninitialized();

  // modifyTrophy use a private stream function so that we yield an new state of PSVLocalTrophyLoaded every time.
  Stream<PSVLocalTrophyLoaded> _modifyTrophy(
      List<PSVLocalTrophy> trophiesMod) async* {
    final stateOld = state as PSVLocalTrophyLoaded;

    final trophies = stateOld.trophies.map((trp) {
      final trophy = trophiesMod.where((trpm) => trpm.id == trp.id).toList();
      if (trophy.length > 0) {
        return PSVLocalTrophy(
          id: trophy[0].id,
          name: trophy[0].name,
          detail: trophy[0].detail,
          rarity: trophy[0].rarity,
          psnTime1: trophy[0].psnTime1,
          psnTime2: trophy[0].psnTime2,
          flagged: trophy[0].flagged,
        );
      } else {
        return trp;
      }
    }).toList();

    // we loop through the trophies unlocked every time the state is updated.
    // if all trophies in base group are unlocked we unlock the plat trophy too using the latest timestamp.
    if (stateOld.havePlat == true) {
      var timeLast1 = PSNTime.baseString();
      var timeLast2 = PSNTime.baseString();

      var unlockedBaseCount = 0;
      for (var i = 0; i < trophies.length; i++) {
        final _trophy = trophies[i];

        if (_trophy.id != 0) {
          if (_trophy.psnTime1 != null && _trophy.psnTime2 != null) {
            if (_trophy.psnTime1.compareToInMicroSecs(timeLast1) > 0) {
              timeLast1 = _trophy.psnTime1;
            }
            if (_trophy.psnTime2.compareToInMicroSecs(timeLast2) > 0) {
              timeLast2 = _trophy.psnTime2;
            }

            if (_trophy.id < stateOld.orgSetCount) {
              unlockedBaseCount += 1;
            }
          }
        }
      }

      for (var i = 0; i < trophies.length; i++) {
        final trp = trophies[i];
        if (trp.id == 0) {
          if (unlockedBaseCount < stateOld.orgSetCount - 1) {
            // ToDo: add jitter here as there should be some gap in timestamp between the last trophy timestamp and the plat timestamp
            trophies[i] = PSVLocalTrophy(
                id: trp.id,
                name: trp.name,
                detail: trp.detail,
                rarity: trp.rarity,
                psnTime1: null,
                psnTime2: null,
                flagged: trp.flagged);
          } else {
            // ToDo: add jitter here as there should be some gap in timestamp between the last trophy timestamp and the plat timestamp
            trophies[i] = PSVLocalTrophy(
                id: trp.id,
                name: trp.name,
                detail: trp.detail,
                rarity: trp.rarity,
                psnTime1: timeLast1,
                psnTime2: timeLast2,
                flagged: trp.flagged);
          }
        }
      }
    }

    final searchedTrophies = stateOld.searchedTrophies.map((trp) {
      final trophy = trophiesMod.where((trpm) => trpm.id == trp.id).toList();
      if (trophy.length > 0) {
        return PSVLocalTrophy(
          id: trophy[0].id,
          name: trophy[0].name,
          detail: trophy[0].detail,
          rarity: trophy[0].rarity,
          psnTime1: trophy[0].psnTime1,
          psnTime2: trophy[0].psnTime2,
          flagged: trophy[0].flagged,
        );
      } else {
        return trp;
      }
    }).toList();

    yield (state as PSVLocalTrophyLoaded)
        .copyWith(trophies: trophies, searchedTrophies: searchedTrophies);

    // we sort our trophies if currentOrder is ByTime
    if (stateOld.currentOrder == 1) {
      this.add(OrderByTime(isLaterFront: true));
    }
  }

  // script modify trophies in batch.
  Stream<PSVLocalTrophyLoaded> _scriptModifyTrophy(
      TrophySetScript script) async* {
    final stateOld = state as PSVLocalTrophyLoaded;
    final List<PSVLocalTrophy> trophies = [];

    final int jitter = script.jitter ?? stateOld.jitter;

    DateTime base = script.randomTimeBase != null
        ? DateTime.tryParse(script.randomTimeBase)?.toUtc()
        : null;

    DateTime end = script.randomTimeEnd != null
        ? DateTime.tryParse(script.randomTimeEnd)?.toUtc()
        : null;

    for (final trophyMod in script.trophies) {
      final trophy =
          stateOld.trophies.where((trp) => trp.id == trophyMod.id).toList();
      if (trophy.length > 0) {
        final dateTime = trophyMod.time != null
            ? DateTime.tryParse(trophyMod.time)?.toUtc()
            : null;

        if (dateTime != null) {
          final PSNTime psnTime1 = PSNTime.randomPSNTimeSubSec(dateTime);

          trophies.add(PSVLocalTrophy(
              id: trophy[0].id,
              name: trophy[0].name,
              detail: trophy[0].detail,
              rarity: trophy[0].rarity,
              psnTime1: psnTime1,
              psnTime2: psnTime1.toPsnTime2(jitter)));
        } else {
          if (trophyMod.time == "random" && base != null && end != null) {
            final PSNTime psnTime1 = PSNTime.randomPSNTimeFromRange(base, end);

            trophies.add(PSVLocalTrophy(
                id: trophy[0].id,
                name: trophy[0].name,
                detail: trophy[0].detail,
                rarity: trophy[0].rarity,
                psnTime1: psnTime1,
                psnTime2: psnTime1.toPsnTime2(jitter)));
          }
        }
      }
    }

    if (trophies.length > 0) {
      this.add(ModifyTrophy(trophies: trophies));
    }
  }

  Stream<PSVLocalTrophyLoaded> _staticAnalyzeTrophy(
      StaticAnalyzeScript script) async* {
    final List<PSVLocalTrophy> trophies =
        (state as PSVLocalTrophyLoaded).trophies.map((trophy) {
      if (trophy.psnTime1 != null && trophy.psnTime2 != null) {
        for (final range in script.ranges) {
          // If affectTrophies list is not empty then we skip and do nothing if the trophy is not in the affectTrophies list.
          final affected = range.affectTrophies;
          if (!(affected.length > 0 && !affected.contains(trophy.id))) {
            final begin = DateTime.tryParse(range.begin);
            final end = DateTime.tryParse(range.end);

            if (begin != null && end != null) {
              /*
              We add 120 second on the psnTime and compare it to the begin time.
              This is to compensate any potential precision lost in DateTime parse.
              Besides you don't really want to be that close the unobtainable range anyway.
              We subtract 120 second on the psnTime and compare it to the end time for the same reason.
            */
              final isAfterBegin1 = DateTime.parse(trophy.psnTime1.timeString)
                  .add(Duration(seconds: 120))
                  .isAfter(begin);
              final isBeforeEnd1 = DateTime.parse(trophy.psnTime1.timeString)
                  .subtract(Duration(seconds: 120))
                  .isBefore(end);
              final isAfterBegin2 = DateTime.parse(trophy.psnTime2.timeString)
                  .add(Duration(seconds: 120))
                  .isAfter(begin);
              final isBeforeEnd2 = DateTime.parse(trophy.psnTime2.timeString)
                  .subtract(Duration(seconds: 120))
                  .isBefore(end);

              if ((isAfterBegin1 && isBeforeEnd1) ||
                  (isAfterBegin2 && isBeforeEnd2)) {
                return trophy.copyWith(flagged: true);
              }
            }
          }
        }

        for (final repeat in script.repeats) {
          final affected = repeat.affectTrophies;
          if (!(affected.length > 0 && !affected.contains(trophy.id))) {
            int weekDay, hour, minute, second, duration;

            if (repeat.weekDay > 0 && repeat.weekDay < 8) {
              weekDay = repeat.weekDay;
            }
            if (repeat.hour >= 0 && repeat.hour < 24) {
              hour = repeat.hour;
            }
            if (repeat.minute >= 0 && repeat.minute < 60) {
              minute = repeat.minute;
            }
            if (repeat.second >= 0 && repeat.second < 60) {
              second = repeat.second;
            }
            if (repeat.duration > 0) {
              duration = repeat.duration;
            }

            if (weekDay != null &&
                hour != null &&
                minute != null &&
                second != null &&
                duration != null) {
              final psnTime1 = DateTime.parse(trophy.psnTime1.timeString);
              final psnTime2 = DateTime.parse(trophy.psnTime2.timeString);

              // ToDo: double check this logic.
              if (psnTime1.weekday == weekDay) {
                final durBase =
                    Duration(hours: hour, minutes: minute, seconds: second);
                final durEnd = durBase + Duration(seconds: duration);

                final dur1 = Duration(
                    hours: psnTime1.hour,
                    minutes: psnTime1.minute,
                    seconds: psnTime1.second);
                /*
                We subtract or add 120 seconds Duration for the same reason as how we deal with ranges.
              */
                final isAfterBegin1 = dur1 > durBase - Duration(seconds: 120);
                final isBeforeEnd1 = dur1 < durEnd + Duration(seconds: 120);

                if (isAfterBegin1 && isBeforeEnd1) {
                  return trophy.copyWith(flagged: true);
                }
              }

              if (psnTime2.weekday == weekDay) {
                final durBase =
                    Duration(hours: hour, minutes: minute, seconds: second);
                final durEnd = durBase + Duration(seconds: duration);

                final dur2 = Duration(
                    hours: psnTime2.hour,
                    minutes: psnTime2.minute,
                    seconds: psnTime2.second);
                final isAfterBegin2 = dur2 > durBase - Duration(seconds: 120);
                final isBeforeEnd2 = dur2 < durEnd + Duration(seconds: 120);

                if (isAfterBegin2 && isBeforeEnd2) {
                  return trophy.copyWith(flagged: true);
                }
              }
            }
          }
        }
      }
      return trophy.copyWith(flagged: false);
    }).toList();

    this.add(ModifyTrophy(trophies: trophies));
  }

  Stream<PSVLocalTrophyLoaded> _sort(Order order, bool isLaterFront) async* {
    final stateOld = state as PSVLocalTrophyLoaded;

    int currentOrder;
    switch (order) {
      case Order.Time:
        {
          stateOld.trophies.sort((trp1, trp2) {
            final time1 =
                trp1.psnTime1 == null ? PSNTime.baseString() : trp1.psnTime1;
            final time2 =
                trp2.psnTime1 == null ? PSNTime.baseString() : trp2.psnTime1;

            if (isLaterFront) {
              return time2.compareToInMicroSecs(time1);
            } else {
              return time1.compareToInMicroSecs(time2);
            }
          });
          stateOld.searchedTrophies.sort((trp1, trp2) {
            final time1 =
                trp1.psnTime1 == null ? PSNTime.baseString() : trp1.psnTime1;
            final time2 =
                trp2.psnTime1 == null ? PSNTime.baseString() : trp2.psnTime1;

            if (isLaterFront) {
              return time2.compareToInMicroSecs(time1);
            } else {
              return time1.compareToInMicroSecs(time2);
            }
          });
          currentOrder = 1;
        }
        break;
      case Order.PSN:
        {
          stateOld.trophies.sort((trp1, trp2) {
            return trp1.id.compareTo(trp2.id);
          });
          stateOld.searchedTrophies.sort((trp1, trp2) {
            return trp1.id.compareTo(trp2.id);
          });
          currentOrder = 0;
        }
        break;
    }

    yield stateOld.copyWith(currentOrder: currentOrder);
  }

  @override
  Stream<PSVLocalTrophyState> mapEventToState(
      PSVLocalTrophyEvent event) async* {
    if (event is SetTrophy) {
      final localJitter = await this.localStorageRepo.getLocalJitter();
      final localBase = await this.localStorageRepo.getLocalBasePSNTime();
      final localEnd = await this.localStorageRepo.getLocalEndPSNTime();

      yield PSVLocalTrophyLoaded(
          currentOrder: 0,
          title: event.title,
          havePlat: event.havePlat,
          orgSetCount: event.orgSetCount,
          jitter: localJitter ?? event.jitter,
          trpTrans: event.trpTrans,
          trpTitle: event.trpTitle,
          trophies: event.trophies,
          searchedTrophies: [],
          baseTime: localBase ?? PSNTime.baseDateTime(),
          endTime: localEnd);
    }

    if (event is Reset) {
      yield PSVLocalTrophyUninitialized();
    }

    if (event is OrderByPSN) {
      yield* _sort(Order.PSN, true);
    }

    if (event is OrderByTime) {
      yield* _sort(Order.Time, event.isLaterFront);
    }

    if (event is ModifyTrophy) {
      yield* _modifyTrophy(event.trophies);
    }

    if (event is ScriptModifyTrophy) {
      yield* _scriptModifyTrophy(event.script);
    }

    if (event is StaticAnalyzeTrophy) {
      yield* _staticAnalyzeTrophy(event.script);
    }

    if (event is SetSearchedTrophy) {
      yield (state as PSVLocalTrophyLoaded)
          .copyWith(searchedTrophies: event.searchedTrophies);
    }

    if (event is SetJitter) {
      this.localStorageRepo.setJitter(event.jitter);
      yield (state as PSVLocalTrophyLoaded).copyWith(jitter: event.jitter);
    }

    if (event is SetBaseEndDateTime) {
      this.localStorageRepo.setRandomRange(base: event.base, end: event.end);
      yield (state as PSVLocalTrophyLoaded)
          .copyWith(baseTime: event.base, endTime: event.end);
    }
  }
}

enum Order { PSN, Time }
