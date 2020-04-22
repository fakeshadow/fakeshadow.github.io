import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:psv_trophy_editor/bloc/psv_local_trophy.dart';
import 'package:psv_trophy_editor/generated/l10n.dart';
import 'package:psv_trophy_editor/model/psv_local.dart';
import 'package:psv_trophy_editor/util/psn_time.dart';
import 'package:psv_trophy_editor/widget/common.dart';

class TrophyListView extends StatelessWidget {
  final double padding;

  TrophyListView({this.padding});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scrollbar(
      child: Padding(
        padding: EdgeInsets.only(left: padding, right: padding, top: 10),
        child: BlocBuilder<PSVLocalTrophyBloc, PSVLocalTrophyState>(
          bloc: BlocProvider.of<PSVLocalTrophyBloc>(context),
          builder: (context, state) {
            if (state is PSVLocalTrophyLoaded) {
              if (state.searchedTrophies.length > 0) {
                return TrophyListBuilder(
                  state: state,
                  trophies: state.searchedTrophies,
                  width: width,
                );
              } else {
                return TrophyListBuilder(
                  state: state,
                  trophies: state.trophies,
                  width: width,
                );
              }
            } else {
              return Container(child: CircularProgressIndicator(), height: 50);
            }
          },
        ),
      ),
    );
  }
}

class TrophyListBuilder extends StatefulWidget {
  final PSVLocalTrophyLoaded state;
  final double width;
  final List<PSVLocalTrophy> trophies;

  TrophyListBuilder({this.state, this.trophies, this.width});

  @override
  _TrophyListBuilderState createState() => _TrophyListBuilderState();
}

class _TrophyListBuilderState extends State<TrophyListBuilder> {
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
          return Colors.blueGrey[200];
        }
        break;
      case "G":
        {
          return Colors.yellowAccent;
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

  String _trophyTime(
      PSVLocalTrophy trophy, BuildContext context, double width) {
    final time1 = trophy.psnTime1 == null
        ? S.of(context).unobtained
        : trophy.psnTime1.timeString;
    final time2 = trophy.psnTime2 == null ? "" : trophy.psnTime2.timeString;

    // adjust time format for mobile.
    var time;
    if (width > 500) {
      time = "$time1\n$time2";
    } else {
      final time1m = time1.split(".").toList()[0];
      final time2m = time2.split(".").toList()[0];
      time = "$time1m\n$time2m";
    }
    return time;
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
    BlocProvider.of<PSVLocalTrophyBloc>(context).add(ModifyTrophy(trophies: [
      PSVLocalTrophy(
          id: trophy.id,
          name: trophy.name,
          detail: trophy.detail,
          rarity: trophy.rarity,
          psnTime1: null,
          psnTime2: null)
    ]));
    _controller.text = null;
    Navigator.of(context).pop();
  }

  void _finishEdit(
      BuildContext context, PSVLocalTrophy trophy, PSVLocalTrophyLoaded state) {
    final PSNTime psnTime1 =
        PSNTime(timeString: _controller.text).adjustTimeString();

    BlocProvider.of<PSVLocalTrophyBloc>(context).add(ModifyTrophy(trophies: [
      PSVLocalTrophy(
          id: trophy.id,
          name: trophy.name,
          detail: trophy.detail,
          rarity: trophy.rarity,
          psnTime1: psnTime1,
          psnTime2: psnTime1.toPsnTime2(state.jitter))
    ]));
    _controller.text = null;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.trophies.length,
      itemBuilder: (BuildContext context, int index) {
        final trophy = widget.trophies[index];
        final textColor = _mapColor(trophy.rarity);
        final time = _trophyTime(trophy, context, widget.width);
        final flag = trophy.flagged ?? false;
        return Container(
          color: flag ? Colors.red[100] : Colors.transparent,
          child: InkWell(
            onTap: () {
              if (!(trophy.id == 0 && widget.state.havePlat == true)) {
                if (trophy.psnTime1 != null) {
                  _controller.text = trophy.psnTime1.timeString;
                } else {
                  _controller.text = PSNTime.BaseTimeString;
                }
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Text(trophy.name,
                              style: TextStyle(fontSize: 20, color: textColor)),
                          elevation: 10,
                          content: TextFormField(
                            controller: _controller,
                            autovalidate: true,
                            validator: (value) {
                              if (PSNTime().validatePSNTime(value)) {
                                return "";
                              } else {
                                return S.of(context).psnTimeWrongFormatAlert;
                              }
                            },
                          ),
                          actions: <Widget>[
                            trophy.psnTime1 != null
                                ? FlatButton(
                                    color: Colors.red,
                                    child: Text(
                                        S.of(context).pageEditorModifyLock),
                                    onPressed: () => _lockTrophy(
                                        context, trophy, widget.state),
                                  )
                                : Container(),
                            FlatButton(
                              color: Colors.blue,
                              child: Text(S.of(context).pageEditorModifyPick),
                              onPressed: () => _pickDateTime(),
                            ),
                            FlatButton(
                              color: Colors.blue,
                              child: Text(S.of(context).pageEditorModifyRandom),
                              onPressed: () => _rand(widget.state),
                            ),
                            FlatButton(
                              child: Text(S.of(context).pageEditorModifyFinish),
                              color: Colors.blue,
                              onLongPress: null,
                              onPressed: () {
                                if (isValid) {
                                  _finishEdit(context, trophy, widget.state);
                                }
                              },
                            )
                          ],
                        ));
              }
            },
            hoverColor: Colors.blue[200],
            child: widget.width > 500
                ? ListTile(
                    leading: Text(_mapRarity(trophy.rarity, context),
                        style: TextStyle(color: textColor)),
                    title:
                        Text(trophy.name, style: TextStyle(color: textColor)),
                    subtitle:
                        Text(trophy.detail, style: TextStyle(color: textColor)),
                    trailing: Text(time, style: TextStyle(color: textColor)),
                    isThreeLine: true,
                    contentPadding: EdgeInsets.only(top: 1, bottom: 1))
                : ListTile(
                    title:
                        Text(trophy.name, style: TextStyle(color: textColor)),
                    trailing: Text(time, style: TextStyle(color: textColor)),
                  ),
          ),
        );
      },
    );
  }
}
