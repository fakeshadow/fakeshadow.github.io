import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psv_trophy_editor/bloc/locale.dart';

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
              BlocProvider.of<LocaleBloc>(context).add(SetLocale(locale: "en"));
              Navigator.of(context).pop();
            },
          ),
          Spacer(),
          InkWell(
            child: Text(S.of(context).pageLocaleCN),
            onTap: () async {
              await S.load(Locale("zh"));
              BlocProvider.of<LocaleBloc>(context).add(SetLocale(locale: "zh"));
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
