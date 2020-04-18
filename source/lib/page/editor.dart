import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:psv_trophy_editor/bloc/psv_local_trophy.dart';
import 'package:psv_trophy_editor/bloc/system.dart';
import 'package:psv_trophy_editor/generated/l10n.dart';
import 'package:psv_trophy_editor/util/psn_time.dart';

import 'package:psv_trophy_editor/widget/finish_edit_alert_dialog.dart';
import 'package:psv_trophy_editor/widget/more_action_row.dart';
import 'package:psv_trophy_editor/widget/common.dart';

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
              MoreActionRow(padding: padding, orders: orders),
              Expanded(
                child: TrophyList(padding: padding),
              ),
            ],
          )),
    );
  }
}

class TrophyList extends StatefulWidget {
  final double padding;

  TrophyList({this.padding});

  @override
  _TrophyListState createState() => _TrophyListState();
}

class _TrophyListState extends State<TrophyList> {
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

  void _rand(PSVLocalTrophyLoaded state) {
    setState(() {
      _controller.text =
          PSNTime.randomPSNTimeFromRange(state.baseTime, state.endTime)
              .timeString;
    });
  }

  void _pickDateTime() async {
    final dateTime = await DateTimePicker(context: context).pick();
    if (dateTime != null) {
      setState(() {
        _controller.text = PSNTime.randomPSNTimeSubMin(dateTime).timeString;
      });
    }

    print(dateTime);
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

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Padding(
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
                                        return S
                                            .of(context)
                                            .psnTimeWrongFormatAlert;
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
                                      onPressed: () => _pickDateTime(),
                                    ),
                                    FlatButton(
                                      color: Colors.blue,
                                      child: Text(
                                          S.of(context).pageEditorModifyRandom),
                                      onPressed: () => _rand(state),
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
              return Container(child: CircularProgressIndicator(),height: 50);
            }
          },
        ),
      ),
    );
  }
}
