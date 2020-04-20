import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:psv_trophy_editor/generated/l10n.dart';
import 'package:psv_trophy_editor/bloc/psv_local_trophy.dart';

import 'package:psv_trophy_editor/widget/common.dart';

class RandomRangeAlertDialog extends StatefulWidget {
  @override
  _RandomRangeAlertDialogState createState() => _RandomRangeAlertDialogState();
}

class _RandomRangeAlertDialogState extends State<RandomRangeAlertDialog> {
  DateTime base, end;

  // ignore: close_sinks
  PSVLocalTrophyBloc bloc;
  bool editedEnd;

  @override
  void initState() {
    bloc = BlocProvider.of<PSVLocalTrophyBloc>(context);
    final state = bloc.state as PSVLocalTrophyLoaded;

    base = state.baseTime;
    end = state.endTime ?? DateTime.now().toUtc();
    editedEnd = false;

    super.initState();
  }

  void _pickDateTime(BuildContext context, bool isBase) async {
    final dateTime = await DateTimePicker(context: context).pick();
    if (dateTime != null) {
      if (isBase) {
        setState(() {
          base = dateTime.isBefore(end)
              ? dateTime
              : end.subtract(Duration(hours: 24));
        });
      } else {
        setState(() {
          editedEnd = true;
          end =
              dateTime.isAfter(base) ? dateTime : base.add(Duration(hours: 24));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).randomDateTimeRangeToolTip,
          style: TextStyle(fontSize: 15)),
      elevation: 10,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(S.of(context).randomDateTimeRangeTimeZoneAlert,
              style: TextStyle(fontSize: 15, color: Colors.red)),
          InkWell(
            radius: 5.0,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: Text(S.of(context).randomDateTimeRangeBegin),
                  ),
                  Container(width: 10),
                  Text(base.toString()),
                ],
              ),
            ),
            onTap: () => {_pickDateTime(context, true)},
          ),
          InkWell(
            radius: 5.0,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: Text(S.of(context).randomDateTimeRangeEnd),
                  ),
                  Container(width: 10),
                  Text(end == null
                      ? S.of(context).pageEditorRandomPSNTimeEndDefault
                      : end.toString()),
                ],
              ),
            ),
            onTap: () => _pickDateTime(context, false),
          )
        ],
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
              bloc.add(
                  SetBaseEndDateTime(base: base, end: editedEnd ? end : null));
              Navigator.of(context).pop();
            })
      ],
    );
  }
}
