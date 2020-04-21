import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:psv_trophy_editor/bloc/psv_local_trophy.dart';
import 'package:psv_trophy_editor/generated/l10n.dart';
import 'package:psv_trophy_editor/widget/jitter_alert_dialog.dart';

import 'package:psv_trophy_editor/widget/random_range_alert_dialog.dart';
import 'package:psv_trophy_editor/widget/search_bar.dart';

class MoreActionRow extends StatefulWidget {
  final double padding;
  final List<String> orders;

  MoreActionRow({this.padding, this.orders});

  @override
  _MoreActionRowState createState() => _MoreActionRowState();
}

class _MoreActionRowState extends State<MoreActionRow> {
  String dropdownValue;

  @override
  void initState() {
    dropdownValue = widget.orders[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
        padding: EdgeInsets.only(left: widget.padding, right: widget.padding),
        child: Row(
          children: <Widget>[
            DropdownButton(
              value: dropdownValue,
              icon: Icon(Icons.arrow_drop_down),
              elevation: 15,
              iconSize: 30,
              underline: Container(height: 2, color: Colors.blue),
              onChanged: (value) {
                setState(() {
                  dropdownValue = value;
                });
                if (value == widget.orders[0]) {
                  BlocProvider.of<PSVLocalTrophyBloc>(context)
                      .add(OrderByPSN());
                } else if (value == widget.orders[1]) {
                  BlocProvider.of<PSVLocalTrophyBloc>(context)
                      .add(OrderByTime(isLaterFront: true));
                }
              },
              items: widget.orders.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Container(
              width: width > 500 ? 100 : 1,
            ),
            width > 500 ? Expanded(child: SearchBar()) : Spacer(),
            IconButton(
              icon: Icon(Icons.swap_horizontal_circle),
              tooltip: S.of(context).randomDateTimeRangeToolTip,
              onPressed: () => showDialog(
                context: context,
                builder: (_) => RandomRangeAlertDialog(),
                barrierDismissible: true,
              ),
            ),
            IconButton(
              icon: Icon(Icons.timer),
              tooltip: S.of(context).jitterRangeToolTip,
              onPressed: () => showDialog(
                context: context,
                builder: (_) => JitterRangeAlertDialog(),
                barrierDismissible: true,
              ),
            )
          ],
        ));
  }
}
