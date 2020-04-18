import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psv_trophy_editor/bloc/system.dart';

import 'package:psv_trophy_editor/generated/l10n.dart';

import 'package:psv_trophy_editor/bloc/psv_local_trophy.dart';
import 'package:psv_trophy_editor/page/editor.dart';
import 'package:psv_trophy_editor/page/home.dart';
import 'package:psv_trophy_editor/repo/local_storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final repo = LocalStorageRepo.init();

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final titleBolc = SystemBloc(repo);
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => titleBolc),
          BlocProvider(create: (context) => PSVLocalTrophyBloc(repo))
        ],
        child: BlocBuilder(
          bloc: titleBolc,
          builder: (context, state) {
            return MaterialApp(
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              title: state is HaveSystem ? state.title : "PSV Trophy Editor",
              routes: {
                'editor': (context) => EditorPage(),
                '/': (context) => HomePage(),
              },
              initialRoute: '/',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  brightness: Brightness.light,
                  primarySwatch: Colors.blue,
                  accentColor: Colors.deepPurple),
            );
          },
        ));
  }
}
