// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:psv_trophy_editor/bloc/system.dart';
import 'package:psv_trophy_editor/generated/l10n.dart';
import 'package:psv_trophy_editor/widget/locale_alert_dialog.dart';
import 'package:psv_trophy_editor/widget/upload_file_button.dart'
    if (dart.library.io) 'package:psv_trophy_editor/widget/upload_file_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<SystemBloc>(context),
      builder: (context, state) {
        if (state is NoSystem) {
          BlocProvider.of<SystemBloc>(context)
              .add(LoadSystem(buildContext: context));
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).pageHomeAppBarTitle),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.language),
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => LocaleAlertDialog(),
                  barrierDismissible: true,
                ),
              )
            ],
          ),
          body: HomePageBody(),
          bottomNavigationBar: Container(
            color: Colors.blue[200],
            height: 40,
            child: Row(
              children: [
                Spacer(),
                FlatButton.icon(
                  icon: Icon(FlutterIcons.github_ant),
                  label: Text(S.of(context).sourceCode),
                  onPressed: () => html.window.location.href =
                      "https://github.com/fakeshadow/fakeshadow.github.io/tree/master/source",
                ),
                FlatButton.icon(
                  icon: Icon(FlutterIcons.discord_faw5d),
                  label: Text(S.of(context).discordGroup),
                  onPressed: () =>
                      html.window.location.href = "https://discord.gg/KEwvvup",
                ),
                Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              S.of(context).pageHomeUsage,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.left,
            ),
            Text(
              S.of(context).pageHomeUsageDetail,
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.left,
            ),
            Text(
              S.of(context).pageHomeFiles,
              style: TextStyle(fontSize: 16, color: Colors.redAccent),
              textAlign: TextAlign.left,
            ),
            Text(
              S.of(context).pageHomeFilesDetail,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
            Text(
              S.of(context).pageHomeAlert,
              style: TextStyle(fontSize: 16, color: Colors.redAccent),
              textAlign: TextAlign.left,
            ),
            Text(
              S.of(context).pageHomeAlertDetail,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        UploadFileButton(),
      ],
    ));
  }
}
