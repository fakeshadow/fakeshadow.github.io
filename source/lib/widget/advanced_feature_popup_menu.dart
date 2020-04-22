import 'dart:convert';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:psv_trophy_editor/bloc/psv_local_trophy.dart';
import 'package:psv_trophy_editor/bloc/system.dart';
import 'package:psv_trophy_editor/generated/l10n.dart';
import 'package:psv_trophy_editor/model/psv_local.dart';

enum PopupMenu { ScriptUnlock, StaticAnalyze, DynamicAnalyze }

class AdvancedFeaturePopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: Icon(Icons.more_vert),
        tooltip: S.of(context).advancedPopupMenuToolTip,
        elevation: 10.0,
        offset: Offset(20, 40),
        onSelected: (PopupMenu menu) {
          switch (menu) {
            case PopupMenu.ScriptUnlock:
              {
                showDialog(
                    context: context, builder: (_) => ScriptAlertDialog());
              }
              break;
            case PopupMenu.StaticAnalyze:
              {
                showDialog(
                    context: context, builder: (_) => StaticAnalyzeDialog());
              }
              break;
            case PopupMenu.DynamicAnalyze:
              {}
              break;
          }
        },
        itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                  value: PopupMenu.ScriptUnlock,
                  child: Text(S.of(context).scriptUnlockMenuButton)),
              PopupMenuItem(
                  value: PopupMenu.StaticAnalyze,
                  child: Text(S.of(context).staticAnalyzeMenuButton)),
              PopupMenuItem(
                  value: PopupMenu.DynamicAnalyze,
                  child: Text(S.of(context).dynamicAnalyzeMenuButton))
            ]);
  }
}

class ScriptAlertDialog extends StatelessWidget {
  _handleScript(BuildContext context) async {
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final script = uploadInput.files[0];
      final filename = script.name.split(".");

      if (filename[1] != "json") {
        return;
      }

      final reader = new html.FileReader();
      reader.readAsText(script);
      reader.onLoadEnd.listen((e) {
        try {
          final script = TrophySetScript.fromJson(json.decode(reader.result));
          if (script.havePlat == true) {
            final haveId0 =
                script.trophies.where((trp) => trp.id == 0).toList();
            if (haveId0.length > 0) {
              throw "Script can't contian platinum trophy";
            }
          }

          BlocProvider.of<PSVLocalTrophyBloc>(context).add(ScriptModifyTrophy(script: script));
        } catch (e) {
          // ToDo: give script error alert;
          print(e);
        }

        Navigator.of(context).pop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).scriptUnlockMenuButton),
      scrollable: true,
      content: BlocBuilder(
        bloc: BlocProvider.of<SystemBloc>(context),
        builder: (context, state) {
          return Column(
            children: [
              (state as HaveSystem).showScriptManual
                  ? Container(
                      color: Colors.grey[400],
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 5,
                          right: 5,
                          top: 2,
                          bottom: 2,
                        ),
                        child: Text('${S.of(context).scriptManualTitle}\n'
                            '${S.of(context).scriptManualExample}\n'
                            '{\n'
                            '   // ${S.of(context).scriptUnlockManualHavePlat}\n'
                            '   "havePlat": true,\n'
                            '   "trophies": [\n'
                            '     {\n'
                            '       // ${S.of(context).scriptUnlockManualId}\n'
                            '       "id": 1,\n'
                            '       "time": "2008-07-03 01:01:01"\n'
                            '     },\n'
                            '     {\n'
                            '       "id": 2,\n'
                            '       "time": "2008-07-03 01:01:02"\n'
                            '     },\n'
                            '     {\n'
                            '       "id": 3,\n'
                            '       // ${S.of(context).scriptUnlockManualRandom}\n'
                            '       "time": "random"\n'
                            '     }\n'
                            '   ],\n'
                            '   // ${S.of(context).scriptUnlockManualRandomBaseEnd}\n'
                            '   "randomTimeBase": "2008-07-03 01:01:02",\n'
                            '   "randomTimeEnd": "2008-07-03 01:01:02",\n'
                            '   // ${S.of(context).scriptUnlockManualJitter}\n'
                            '   "jitter": 3000\n'
                            '}'),
                      ),
                    )
                  : Container(),
              FlatButton(
                color: Colors.transparent,
                child: Text(
                  (state as HaveSystem).showScriptManual
                      ? S.of(context).manualHide
                      : S.of(context).manualShow,
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  if ((state as HaveSystem).showScriptManual) {
                    BlocProvider.of<SystemBloc>(context)
                        .add(SetSystem(showScriptManual: false));
                  } else {
                    BlocProvider.of<SystemBloc>(context)
                        .add(SetSystem(showScriptManual: true));
                  }
                },
              ),
              Container(height: 1),
              FlatButton(
                color: Colors.blue,
                child: Text(
                  S.of(context).scriptSelect,
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => _handleScript(context),
              )
            ],
          );
        },
      ),
    );
  }
}

class StaticAnalyzeDialog extends StatelessWidget {
  _handleScript(BuildContext context) async {
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final script = uploadInput.files[0];
      final filename = script.name.split(".");

      if (filename[1] != "json") {
        return;
      }

      final reader = new html.FileReader();
      reader.readAsText(script);
      reader.onLoadEnd.listen((e) {
        try {
          final script = StaticAnalyzeScript.fromJson(json.decode(reader.result));

          BlocProvider.of<PSVLocalTrophyBloc>(context).add(StaticAnalyzeTrophy(script: script));
        } catch (e) {
          // ToDo: give script error alert;
          print(e);
        }

        Navigator.of(context).pop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).staticAnalyzeMenuButton),
      scrollable: true,
      content: BlocBuilder(
        bloc: BlocProvider.of<SystemBloc>(context),
        builder: (context, state) {
          return Column(
            children: [
              (state as HaveSystem).showStaticManual
                  ? Container(
                color: Colors.grey[400],
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 5,
                    right: 5,
                    top: 2,
                    bottom: 2,
                  ),
                  child: Text('${S.of(context).scriptManualTitle}\n'
                      '${S.of(context).scriptManualExample}\n'
                      '{\n'
                      '   // ${S.of(context).staticAnalyzeRange}\n'
                      '   "ranges": [ \n'
                      '     {\n'
                      '       "begin": "2008-07-03 01:01:01",\n'
                      '       "end": "2010-07-03 01:01:01",\n'
                      '       // ${S.of(context).staticAnalyzeAffectedTrophies}\n'
                      '       "trophies: [ 1, 2, 3 ]\n'
                      '     },\n'
                      '     {\n'
                      '       "begin": "2016-07-03 01:01:01",\n'
                      '       "end": "9999-07-03 01:01:01"\n'
                      '      // ${S.of(context).staticAnalyzeAffectedTrophiesAll}\n'
                      '     }\n'
                      '   ], \n'
                      '   // ${S.of(context).staticAnalyzeRepeat}\n'
                      '   "repeats": [\n'
                      '     // ${S.of(context).staticAnalyzeRepeatExample}\n'
                      '     {\n'
                      '       "weekDay": 2,\n'
                      '       "hour": 12,\n'
                      '       "minute": 00,\n'
                      '       "second": 00,\n'
                      '       "duration": 3600,\n'
                      '       // ${S.of(context).staticAnalyzeAffectedTrophiesAll}\n'
                      '       "trophies": [ 1, 2, 3 ]\n'
                      '     }\n'
                      '   ]\n'
                      '}'),
                ),
              )
                  : Container(),
              FlatButton(
                color: Colors.transparent,
                child: Text(
                  (state as HaveSystem).showStaticManual
                      ? S.of(context).manualHide
                      : S.of(context).manualShow,
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  if ((state as HaveSystem).showStaticManual) {
                    BlocProvider.of<SystemBloc>(context)
                        .add(SetSystem(showStaticManual: false));
                  } else {
                    BlocProvider.of<SystemBloc>(context)
                        .add(SetSystem(showStaticManual: true));
                  }
                },
              ),
              Container(height: 1),
              FlatButton(
                color: Colors.blue,
                child: Text(
                  S.of(context).scriptSelect,
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => _handleScript(context),
              )
            ],
          );
        },
      ),
    );
  }
}