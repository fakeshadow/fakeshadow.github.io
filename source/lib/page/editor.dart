import 'dart:convert';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:psv_trophy_editor/bloc/psv_local_trophy.dart';
import 'package:psv_trophy_editor/generated/l10n.dart';
import 'package:psv_trophy_editor/util/psn_time.dart';
import 'package:psv_trophy_editor/util/psv_data.dart';

class EditorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = width / 2 - 300 > 10 ? width / 2 - 300 : 10;

    // ToDo: figure a way to generate items in MoreActionButton widget
    final List<String> orders = [];
    orders.add(S.of(context).orderByPSN);
    orders.add(S.of(context).orderByTime);

    return Scaffold(
        appBar: AppBar(),
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
            MoreActionButton(padding: padding, orders: orders),
            Expanded(
              child: TrophyList(padding: padding),
            ),
          ],
        ));
  }
}

class TrophyList extends StatefulWidget {
  final double padding;

  TrophyList({this.padding});

  @override
  _TrophyListState createState() => _TrophyListState();
}

class _TrophyListState extends State<TrophyList> {
  DateTime randBegin, randEnd;
  TextEditingController _controller;
  bool isValid;

  @override
  void initState() {
    isValid = true;
    _controller = TextEditingController();
    _controller.addListener(_listenInput);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _listenInput() {
    isValid = PSNTime().validatePSNTime(_controller.text);
  }

  String _mapRarity(String rarity, BuildContext context) {
    switch (rarity) {
      case "B":
        {
          return S.of(context).bronze;
        }
        break;
      case "S":
        {
          return S.of(context).silver;
        }
        break;
      case "G":
        {
          return S.of(context).gold;
        }
        break;
      case "P":
        {
          return S.of(context).platinum;
        }
        break;
      default:
        {
          return "";
        }
        break;
    }
  }

  Color _mapColor(String rarity) {
    switch (rarity) {
      case "B":
        {
          return Colors.brown;
        }
        break;
      case "S":
        {
          return Colors.blueGrey;
        }
        break;
      case "G":
        {
          return Colors.amberAccent;
        }
        break;
      case "P":
        {
          return Colors.blue;
        }
        break;
      default:
        {
          return Colors.black;
        }
        break;
    }
  }

  void _rand() {
    setState(() {
      final rand = PSNTime.randomPSNTime(randBegin, randEnd).timeString;
      _controller.text = rand;
    });
  }

  void _lockTrophy(
      BuildContext context, PSVLocalTrophy trophy, PSVLocalTrophyLoaded state) {
    BlocProvider.of<PSVLocalTrophyBloc>(context).add(ModifyTrophy(
        trophy: PSVLocalTrophy(
            id: trophy.id,
            name: trophy.name,
            detail: trophy.detail,
            rarity: trophy.rarity,
            psnTime1: null,
            psnTime2: null)));
    _controller.text = null;
    Navigator.of(context).pop();
  }

  void _finishEdit(
      BuildContext context, PSVLocalTrophy trophy, PSVLocalTrophyLoaded state) {
    final PSNTime psnTime1 =
        PSNTime(timeString: _controller.text).adjustTimeString();
    BlocProvider.of<PSVLocalTrophyBloc>(context).add(ModifyTrophy(
        trophy: PSVLocalTrophy(
            id: trophy.id,
            name: trophy.name,
            detail: trophy.detail,
            rarity: trophy.rarity,
            psnTime1: psnTime1,
            psnTime2: psnTime1.toPsnTime2(state.jitter))));
    _controller.text = null;
    Navigator.of(context).pop();
  }

  Future<DateTime> _pickDate(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
  }

  Future<TimeOfDay> _pickTime(BuildContext context) {
    return showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: widget.padding, right: widget.padding, top: 10),
      child: BlocBuilder<PSVLocalTrophyBloc, PSVLocalTrophyState>(
        bloc: BlocProvider.of<PSVLocalTrophyBloc>(context),
        builder: (context, state) {
          if (state is PSVLocalTrophyLoaded) {
            return ListView.builder(
              itemCount: state.trophies.length,
              itemBuilder: (BuildContext context, int index) {
                final trophy = state.trophies[index];
                final textColor = _mapColor(trophy.rarity);
                final time1 = trophy.psnTime1 == null
                    ? S.of(context).unobtained
                    : trophy.psnTime1.timeString;
                final time2 =
                    trophy.psnTime2 == null ? "" : trophy.psnTime2.timeString;
                final time = "$time1  \n$time2";
                return InkWell(
                  onTap: () {
                    if (!(trophy.id == 0 && state.havePlat == true)) {
                      if (trophy.psnTime1 != null) {
                        _controller.text = trophy.psnTime1.timeString;
                      } else {
                        _controller.text = PSNTime.BaseTimeString;
                      }
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text(trophy.name,
                                    style: TextStyle(
                                        fontSize: 20, color: textColor)),
                                elevation: 10,
                                content: TextFormField(
                                  controller: _controller,
                                  autovalidate: true,
                                  validator: (value) {
                                    if (PSNTime().validatePSNTime(value)) {
                                      return "";
                                    } else {
                                      return "Wrong Format";
                                    }
                                  },
                                ),
                                actions: <Widget>[
                                  trophy.psnTime1 != null
                                      ? FlatButton(
                                          color: Colors.red,
                                          child: Text(S
                                              .of(context)
                                              .pageEditorModifyLock),
                                          onPressed: () => _lockTrophy(
                                              context, trophy, state),
                                        )
                                      : Container(),
                                  FlatButton(
                                    color: Colors.blue,
                                    child: Text(
                                        S.of(context).pageEditorModifyPick),
                                    onPressed: () async {
                                      final date = await _pickDate(context);

                                      final time = await _pickTime(context);
                                      print(date);
                                      print(time);
                                    },
                                  ),
                                  FlatButton(
                                    color: Colors.blue,
                                    child: Text(
                                        S.of(context).pageEditorModifyRandom),
                                    onPressed: () => _rand(),
                                  ),
                                  FlatButton(
                                    child: Text(
                                        S.of(context).pageEditorModifyFinish),
                                    color: Colors.blue,
                                    onLongPress: null,
                                    onPressed: () {
                                      if (isValid) {
                                        _finishEdit(context, trophy, state);
                                      }
                                    },
                                  )
                                ],
                              ));
                    }
                  },
                  hoverColor: Colors.blue,
                  child: ListTile(
                      leading: Text(_mapRarity(trophy.rarity, context),
                          style: TextStyle(color: textColor)),
                      title:
                          Text(trophy.name, style: TextStyle(color: textColor)),
                      subtitle: Text(trophy.detail,
                          style: TextStyle(color: textColor)),
                      trailing: Text(time, style: TextStyle(color: textColor)),
                      isThreeLine: true,
                      contentPadding: EdgeInsets.only(top: 1, bottom: 1)),
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class MoreActionButton extends StatefulWidget {
  final double padding;
  final List<String> orders;

  MoreActionButton({this.padding, this.orders});

  @override
  _MoreActionButtonState createState() => _MoreActionButtonState();
}

class _MoreActionButtonState extends State<MoreActionButton> {
  String dropdownValue;

  @override
  void initState() {
    dropdownValue = widget.orders[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            )
          ],
        ));
  }
}

class ChangeDateTimeRange extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

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
