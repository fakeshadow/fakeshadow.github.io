import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:psv_trophy_editor/bloc/system.dart';
import 'package:psv_trophy_editor/generated/l10n.dart';
import 'package:psv_trophy_editor/widget/advanced_feature_popup_menu.dart';
import 'package:psv_trophy_editor/widget/finish_edit_alert_dialog.dart';
import 'package:psv_trophy_editor/widget/more_action_row.dart';
import 'package:psv_trophy_editor/widget/trophy_list_view.dart';

class EditorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = width / 2 - 300 > 10 ? width / 2 - 300 : 10;

    // ToDo: figure a way to generate items in MoreActionButton widget
    final List<String> orders = [];
    orders.add(S.of(context).orderByPSN);
    orders.add(S.of(context).orderByTime);

    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<SystemBloc>(context)
            .add(SetSystem(title: S.of(context).titleDefault));
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              AdvancedFeaturePopup()
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Padding(
            padding:
                EdgeInsets.only(right: padding - 100 > 0 ? padding - 100 : 0),
            child: FloatingActionButton(
              tooltip: S.of(context).saveChanges,
              backgroundColor: Colors.transparent,
              isExtended: true,
              child: Icon(Icons.save, color: Colors.blue),
              mini: padding > 10 ? true : false,
              onPressed: () => showDialog(
                context: context,
                builder: (_) => FinishAlertDialog(),
                barrierDismissible: false,
              ),
            ),
          ),
          body: Column(
            children: <Widget>[
              MoreActionRow(padding: padding, orders: orders),
              Expanded(
                child: TrophyListView(padding: padding),
              ),
            ],
          )),
    );
  }
}
