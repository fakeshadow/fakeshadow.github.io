import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psv_trophy_editor/bloc/system.dart';

import 'package:psv_trophy_editor/generated/l10n.dart';

class LocaleAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(S.of(context).pageLocaleTitle, style: TextStyle(fontSize: 20)),
      elevation: 10,
      content: Row(
        children: <Widget>[
          InkWell(
            child: Text(S.of(context).pageLocaleEN),
            onTap: () async {
              await S.load(Locale("en"));
              BlocProvider.of<SystemBloc>(context).add(
                  SetSystem(locale: "en", title: S.of(context).titleDefault));
              Navigator.of(context).pop();
            },
          ),
          Spacer(),
          InkWell(
            child: Text(S.of(context).pageLocaleCN),
            onTap: () async {
              await S.load(Locale("zh"));
              BlocProvider.of<SystemBloc>(context).add(
                  SetSystem(locale: "zh", title: S.of(context).titleDefault));
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
