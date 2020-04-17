import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:psv_trophy_editor/generated/l10n.dart';
import 'package:psv_trophy_editor/repo/local_storage.dart';

abstract class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object> get props => [];
}

class LoadLocale extends LocaleEvent {
  const LoadLocale();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'GetLocalLocale';
}

class SetLocale extends LocaleEvent {
  final String locale;

  const SetLocale({this.locale});

  @override
  List<Object> get props => [locale];

  @override
  String toString() => 'SetLocale { locale: $locale }';
}

abstract class LocaleState extends Equatable {
  const LocaleState();

  @override
  List<Object> get props => [];
}

class HaveLocale extends LocaleState {
  final String localString;

  const HaveLocale({this.localString});

  @override
  List<Object> get props => [this.localString];
}

class ChangedLocale extends LocaleState {}

class NoLocale extends LocaleState {}

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  final LocalStorageRepo localStorageRepo;

  LocaleBloc(this.localStorageRepo);

  @override
  LocaleState get initialState => NoLocale();

  @override
  Stream<LocaleState> mapEventToState(LocaleEvent event) async* {
    if (event is LoadLocale) {
      try {
        final localString = await this.localStorageRepo.getLocalLocale();
        await S.load(Locale(localString));
        yield HaveLocale(localString: localString);
      } catch (_) {
        yield NoLocale();
      }
    }

    if (event is SetLocale) {
      this.localStorageRepo.setLocale(event.locale);
      yield HaveLocale(localString: event.locale);
    }
  }
}
