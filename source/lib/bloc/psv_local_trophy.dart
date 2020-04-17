import 'package:flutter/cupertino.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:psv_trophy_editor/repo/local_storage.dart';
import 'package:psv_trophy_editor/util/psn_time.dart';

// trophy model
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
  final PSVLocalTrophy trophy;

  const ModifyTrophy({@required this.trophy});

  @override
  List<Object> get props => [trophy];

  @override
  String toString() => 'ModifyTrophy { trophy: $trophy }';
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

class SetLocale extends PSVLocalTrophyEvent {
  final String locale;

  const SetLocale({this.locale});

  @override
  List<Object> get props => [locale];

  @override
  String toString() => 'SetLocale { locale: $locale }';
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
  final DateTime baseTime, endTime;

  const PSVLocalTrophyLoaded(
      {this.currentOrder,
      this.title,
      this.havePlat,
      this.orgSetCount,
      this.jitter,
      this.trpTrans,
      this.trophies,
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
        baseTime,
        endTime
      ];

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
  Stream<PSVLocalTrophyLoaded> _modifyTrophy(PSVLocalTrophy trophy) async* {
    final stateOld = state as PSVLocalTrophyLoaded;

    final List<PSVLocalTrophy> trophies = [];

    for (var i = 0; i < stateOld.trophies.length; i++) {
      final trp = stateOld.trophies[i];
      if (trp.id == trophy.id) {
        trophies.add(PSVLocalTrophy(
            id: trophy.id,
            name: trophy.name,
            detail: trophy.detail,
            rarity: trophy.rarity,
            psnTime1: trophy.psnTime1,
            psnTime2: trophy.psnTime2));
      } else {
        trophies.add(trp);
      }
    }

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

    yield PSVLocalTrophyLoaded(
        currentOrder: stateOld.currentOrder,
        title: stateOld.title,
        orgSetCount: stateOld.orgSetCount,
        havePlat: stateOld.havePlat,
        jitter: stateOld.jitter,
        trpTrans: stateOld.trpTrans,
        trophies: trophies,
        baseTime: stateOld.baseTime,
        endTime: stateOld.endTime);

    // we sort our trophies if currentOrder is ByTime
    if (stateOld.currentOrder == 1) {
      this.add(OrderByTime(isLaterFront: true));
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
          currentOrder = 1;
        }
        break;
      case Order.PSN:
        {
          stateOld.trophies.sort((trp1, trp2) {
            return trp1.id.compareTo(trp2.id);
          });
          currentOrder = 0;
        }
        break;
    }

    yield PSVLocalTrophyLoaded(
      currentOrder: currentOrder,
      title: stateOld.title,
      orgSetCount: stateOld.orgSetCount,
      havePlat: stateOld.havePlat,
      jitter: stateOld.jitter,
      trpTrans: stateOld.trpTrans,
      trophies: stateOld.trophies,
      baseTime: stateOld.baseTime,
      endTime: stateOld.endTime,
    );
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
      yield* _modifyTrophy(event.trophy);
    }

    if (event is SetJitter) {
      final _state = state as PSVLocalTrophyLoaded;

      this.localStorageRepo.setJitter(event.jitter);

      yield PSVLocalTrophyLoaded(
          currentOrder: _state.currentOrder,
          title: _state.title,
          havePlat: _state.havePlat,
          orgSetCount: _state.orgSetCount,
          jitter: event.jitter,
          trpTrans: _state.trpTrans,
          trophies: _state.trophies,
          baseTime: _state.baseTime,
          endTime: _state.endTime);
    }

    if (event is SetLocale) {
      this.localStorageRepo.setLocale(event.locale);
      yield state;
    }

    if (event is SetBaseEndDateTime) {
      final _state = state as PSVLocalTrophyLoaded;

      this.localStorageRepo.setRandomRange(base: event.base, end: event.end);

      yield PSVLocalTrophyLoaded(
          currentOrder: _state.currentOrder,
          title: _state.title,
          havePlat: _state.havePlat,
          orgSetCount: _state.orgSetCount,
          jitter: _state.jitter,
          trpTrans: _state.trpTrans,
          trophies: _state.trophies,
          baseTime: event.base ?? _state.baseTime,
          endTime: event.end ?? _state.endTime);
    }
  }
}

enum Order { PSN, Time }
