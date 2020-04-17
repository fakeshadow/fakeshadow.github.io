import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:psv_trophy_editor/bloc/psv_local_trophy.dart';
import 'package:psv_trophy_editor/generated/l10n.dart';
import 'package:psv_trophy_editor/util/psv_data.dart';


class FinishAlertDialog extends StatelessWidget {
  void _saveFile(BuildContext context) {
    // ignore: close_sinks
    final _bloc = BlocProvider.of<PSVLocalTrophyBloc>(context);

    final state = _bloc.state as PSVLocalTrophyLoaded;
    final trans = PSVFileParser.fromBlocState(state).modifyTrans();

    final content = base64Encode(trans);
    final _anchor = html.AnchorElement(
        href: "data:application/octet-stream;charset=utf-16le;base64,$content")
      ..setAttribute("download", "TRPTRANS_MOD.DAT")
      ..click();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).pageEditorFinishAlertTitle,
          style: TextStyle(fontSize: 20)),
      elevation: 10,
      content: Text(
        S.of(context).pageEditorFinishAlertDetail,
        style: TextStyle(color: Colors.red),
      ),
      actions: <Widget>[
        FlatButton(
          color: Colors.red,
          child: Text(S.of(context).pageEditorFinishAlertBack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
            child: Text(S.of(context).pageEditorFinishAlertFinish),
            color: Colors.blue,
            onPressed: () {
              _saveFile(context);
              Navigator.of(context).popUntil(ModalRoute.withName('/'));
            })
      ],
    );
  }
}