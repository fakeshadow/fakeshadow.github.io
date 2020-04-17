import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:psv_trophy_editor/generated/l10n.dart';
import 'package:psv_trophy_editor/bloc/psv_local_trophy.dart';

class JitterRangeAlertDialog extends StatefulWidget {
  @override
  _JitterRangeAlertDialogState createState() => _JitterRangeAlertDialogState();
}

class _JitterRangeAlertDialogState extends State<JitterRangeAlertDialog> {
  TextEditingController _controller;

  // ignore: close_sinks
  PSVLocalTrophyBloc _bloc;

  @override
  void initState() {
    _controller = TextEditingController();
    _bloc = BlocProvider.of<PSVLocalTrophyBloc>(context);
    _controller.text = (_bloc.state as PSVLocalTrophyLoaded).jitter.toString();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).jitterRangeToolTip,
          style: TextStyle(fontSize: 15)),
      elevation: 10,
      content: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
            labelText: S.of(context).jitterUnit,
            labelStyle: TextStyle(color: Colors.black45)),
        autovalidate: true,
        validator: (value) {
          final jitter = int.tryParse(value);
          if (jitter == null) {
            return S.of(context).jitterWrongFormatAlert;
          } else {
            return "";
          }
        },
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
              BlocProvider.of<PSVLocalTrophyBloc>(context)
                  .add(SetJitter(jitter: int.parse(_controller.text)));
              Navigator.of(context).pop();
            })
      ],
    );
  }
}
