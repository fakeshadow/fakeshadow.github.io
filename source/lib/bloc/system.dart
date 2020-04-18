import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:psv_trophy_editor/generated/l10n.dart';
import 'package:psv_trophy_editor/repo/local_storage.dart';

abstract class SystemEvent extends Equatable {
  const SystemEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class LoadSystem extends SystemEvent {
  BuildContext buildContext;

  LoadSystem({this.buildContext});

  @override
  List<Object> get props => [buildContext];

  @override
  String toString() => 'LoadSystem';
}

class SetSystem extends SystemEvent {
  final String locale, title;

  const SetSystem({this.locale, this.title});

  @override
  List<Object> get props => [locale, title];

  @override
  String toString() => 'SetSystem { locale: $locale, title: $title }';
}

abstract class SystemState extends Equatable {
  const SystemState();

  @override
  List<Object> get props => [];
}

class HaveSystem extends SystemState {
  final String locale, title;

  const HaveSystem({this.locale, this.title});

  @override
  List<Object> get props => [locale, title];
}

class NoSystem extends SystemState {}

class SystemBloc extends Bloc<SystemEvent, SystemState> {
  final LocalStorageRepo localStorageRepo;

  SystemBloc(this.localStorageRepo);

  @override
  SystemState get initialState => NoSystem();

  @override
  Stream<SystemState> mapEventToState(SystemEvent event) async* {
    if (event is LoadSystem) {
      try {
        final locale = await this.localStorageRepo.getLocalLocale();
        await S.load(Locale(locale));
        yield HaveSystem(
            locale: locale, title: S.of(event.buildContext).titleDefault);
      } catch (_) {
        yield NoSystem();
      }
    }

    if (event is SetSystem) {
      if (event.locale != null) {
        this.localStorageRepo.setLocale(event.locale);
      }
      if (state is HaveSystem) {
        yield HaveSystem(
            locale: event.locale ?? (state as HaveSystem).locale,
            title: event.title ?? (state as HaveSystem).title);
      } else {
        yield HaveSystem(locale: event.locale, title: event.title);
      }
    }
  }
}
