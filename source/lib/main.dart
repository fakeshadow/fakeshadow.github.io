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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  LocalStorageRepo repo;
  SystemBloc systemBloc;
  PSVLocalTrophyBloc trophyBloc;

  @override
  void initState() {
    repo = LocalStorageRepo.init();
    systemBloc = SystemBloc(repo);
    trophyBloc = PSVLocalTrophyBloc(repo);
    super.initState();
  }

  @override
  void dispose() {
    repo.storage.dispose();
    systemBloc.close();
    trophyBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => systemBloc),
          BlocProvider(create: (context) => trophyBloc)
        ],
        child: BlocBuilder(
          bloc: systemBloc,
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
