import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trophyeditor/generated/l10n.dart';

import 'package:trophyeditor/bloc/psv_local_trophy.dart';
import 'package:trophyeditor/page/editor.dart';
import 'package:trophyeditor/page/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [BlocProvider(create: (context) => PSVLocalTrophyBloc())],
        child: MaterialApp(
         localizationsDelegates: [
           S.delegate,
           GlobalMaterialLocalizations.delegate,
           GlobalWidgetsLocalizations.delegate,
           GlobalCupertinoLocalizations.delegate,
         ],
         supportedLocales: S.delegate.supportedLocales,
          title: 'PSV Trophy Editor',
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
        ));
  }
}
