import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:psv_trophy_editor/bloc/psv_local_trophy.dart';
import 'package:psv_trophy_editor/generated/l10n.dart';
import 'package:psv_trophy_editor/widget/jitter_alert_dialog.dart';

import 'package:psv_trophy_editor/widget/random_range_alert_dialog.dart';

class MoreActionRow extends StatefulWidget {
  final double padding;
  final List<String> orders;

  MoreActionRow({this.padding, this.orders});

  @override
  _MoreActionRowState createState() => _MoreActionRowState();
}

class _MoreActionRowState extends State<MoreActionRow> {
  PSVLocalTrophyBloc bloc;

  String dropdownValue;
  bool showClearButton;

  TextEditingController _controller;

  @override
  void initState() {
    bloc = BlocProvider.of<PSVLocalTrophyBloc>(context);
    dropdownValue = widget.orders[0];
    _controller = TextEditingController();
    _controller.text = "";
    _controller.addListener(_searchListen);
    showClearButton = false;
    super.initState();
  }

  void _searchListen() {
    List<PSVLocalTrophy> trophies;

    if (_controller.text == "") {
      setState(() {
        showClearButton = false;
      });
      trophies = [];
    } else {
      setState(() {
        showClearButton = true;
      });

      final text = _controller.text.trimLeft();

      if (text.length > 0) {
        trophies = (bloc.state as PSVLocalTrophyLoaded)
            .trophies
            .where((trp) => trp.name.startsWith(text))
            .toList();
      } else {
        trophies = [];
      }
    }

    bloc.add(SetSearchedTrophy(searchedTrophies: trophies));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearSearch() {
    setState(() {
      _controller.text = "";
      showClearButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem> items = [
      DropdownMenuItem(
        child: Text("test"),
      ),
      DropdownMenuItem(
        child: Text("test"),
      ),
      DropdownMenuItem(
        child: Text("test"),
      ),
    ];

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
              width: 100,
            ),
            Expanded(
              child: Container(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      hintText: "Input trophy name",
                      border: InputBorder.none,
                      suffixIcon: showClearButton
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () => _clearSearch())
                          : Container(
                              height: 1,
                              width: 1,
                            ),
                      prefixIcon: Icon(Icons.search)),
                ),
              ),
            ),
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
