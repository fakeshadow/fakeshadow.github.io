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
  final String title, trpTrans;
  final List<PSVLocalTrophy> trophies;

  const SetTrophy(
      {@required this.title,
      this.havePlat,
      this.orgSetCount,
      this.jitter, // jitter is the time gap between two timestamps of one trophy.
      this.trpTrans,
      this.trophies});

  @override
  List<Object> get props =>
      [title, havePlat, orgSetCount, jitter, trpTrans, trophies];

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
  final Script script;

  const ScriptModifyTrophy({@required this.script});

  @override
  List<Object> get props => [script];

  @override
  String toString() => 'ScriptModifyTrophy { script: $script }';
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
  final String title, trpTrans;
  final List<PSVLocalTrophy> trophies;
  final List<PSVLocalTrophy> searchedTrophies;
  final DateTime baseTime, endTime;

  const PSVLocalTrophyLoaded(
      {this.currentOrder,
      this.title,
      this.havePlat,
      this.orgSetCount,
      this.jitter,
      this.trpTrans,
      this.trophies,
      this.searchedTrophies,
      this.baseTime,
      this.endTime});

  @override
  List<Object> get props => [
        currentOrder,
        title,
        havePlat,
        orgSetCount,
        jitter,
        trpTrans,
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
//      'trpTrans: $trpTrans, '
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
            psnTime2: trophy[0].psnTime2);
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
                psnTime2: null);
          } else {
            // ToDo: add jitter here as there should be some gap in timestamp between the last trophy timestamp and the plat timestamp
            trophies[i] = PSVLocalTrophy(
                id: trp.id,
                name: trp.name,
                detail: trp.detail,
                rarity: trp.rarity,
                psnTime1: timeLast1,
                psnTime2: timeLast2);
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
            psnTime2: trophy[0].psnTime2);
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
  Stream<PSVLocalTrophyLoaded> _scriptModifyTrophy(Script script) async* {
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
