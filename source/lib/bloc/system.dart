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
}

class SetSystem extends SystemEvent {
  final String locale, title;
  final bool showScriptManual, showStaticManual;

  const SetSystem(
      {this.locale, this.title, this.showScriptManual, this.showStaticManual});

  @override
  List<Object> get props => [locale, title, showScriptManual, showStaticManual];
}

abstract class SystemState extends Equatable {
  const SystemState();

  @override
  List<Object> get props => [];
}

class HaveSystem extends SystemState {
  final String locale, title;
  final bool showScriptManual, showStaticManual;

  const HaveSystem({
    this.locale,
    this.title,
    this.showScriptManual,
    this.showStaticManual,
  });

  @override
  List<Object> get props => [locale, title, showScriptManual, showStaticManual];

  @override
  String toString() =>
      'HaveSystem { locale: $locale, title: $title, showScriptManual: $showScriptManual, showStaticAnalyzeManual: $showStaticManual }';
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
      String locale;
      bool showScriptManual, showStaticManual;

      try {
        locale = await this.localStorageRepo.getLocalLocale();
      } catch (_) {}
      try {
        showScriptManual =
            await this.localStorageRepo.getLocalShowScriptManual();
      } catch (_) {}
      try {
        showStaticManual =
            await this.localStorageRepo.getLocalShowStaticManual();
      } catch (_) {}

      if (locale != null) {
        await S.load(Locale(locale));
      }

      yield HaveSystem(
        locale: locale,
        title: S.of(event.buildContext).titleDefault,
        showScriptManual: showScriptManual ?? true,
        showStaticManual: showStaticManual ?? true,
      );
    }

    if (event is SetSystem) {
      if (event.locale != null) {
        this.localStorageRepo.setLocale(event.locale);
      }
      if (event.showScriptManual != null) {
        this.localStorageRepo.setShowScriptManual(event.showScriptManual);
      }
      if (event.showStaticManual != null) {
        this.localStorageRepo.setShowStaticManual(event.showStaticManual);
      }
      if (state is HaveSystem) {
        final s = (state as HaveSystem);
        yield HaveSystem(
            locale: event.locale ?? s.locale,
            title: event.title ?? s.title,
            showScriptManual: event.showScriptManual ?? s.showScriptManual,
            showStaticManual: event.showStaticManual ?? s.showStaticManual);
      } else {
        yield HaveSystem(
            locale: event.locale,
            title: event.title,
            showScriptManual: event.showScriptManual);
      }
    }
  }
}
