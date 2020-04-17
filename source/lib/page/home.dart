// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psv_trophy_editor/bloc/locale.dart';

import 'package:psv_trophy_editor/generated/l10n.dart';

import 'package:psv_trophy_editor/bloc/psv_local_trophy.dart';
import 'package:psv_trophy_editor/util/psv_data.dart';
import 'package:psv_trophy_editor/widget/locale_alert_dialog.dart';

class HomePage extends StatelessWidget {
  startWebFilePicker(BuildContext context) async {
    final PSVLocalTrophyBloc bloc =
        BlocProvider.of<PSVLocalTrophyBloc>(context);

    bloc.add(Reset());

    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      if (uploadInput.files.length != 2) {
        return;
      }
      final file1 = uploadInput.files[0];
      final file2 = uploadInput.files[1];

      if (file1.name == "TROP.SFM" && file2.name == "TRPTRANS.DAT") {
        _handleFile(file1, file2, bloc, context);
      } else if (file2.name == "TROP.SFM" && file1.name == "TRPTRANS.DAT") {
        _handleFile(file2, file1, bloc, context);
      } else {
        return print("something went wrong");
      }
    });
  }

  void _handleFile(html.File sfm, html.File trans, PSVLocalTrophyBloc bloc,
      BuildContext context) {
    final reader = new html.FileReader();
    reader.readAsText(sfm);
    reader.onLoadEnd.listen((e) {
      final PSVFileParser parser =
          PSVFileParser.parseSFM(reader.result.toString());

      final reader2 = new html.FileReader();
      reader2.readAsArrayBuffer(trans);
      reader2.onLoadEnd.listen((e) {
        final PSVFileParser parser2 = parser.parseTRANS(reader2.result);

        bloc.add(SetTrophy(
            title: parser2.title,
            havePlat: parser2.havePlat,
            orgSetCount: parser2.orgSetCount,
            jitter: parser2.jitter,
            trpTrans: parser2.trpTrans,
            trophies: parser2.trophies));

        Navigator.of(context).pushNamed("editor");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final localeBloc = BlocProvider.of<LocaleBloc>(context);

    return BlocBuilder(
      bloc: localeBloc,
      builder: (context, state) {
        if (state is NoLocale) {
          localeBloc.add(LoadLocale());
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
            body: Center(
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
                FlatButton(
                  color: Colors.blue,
                  onPressed: () => startWebFilePicker(context),
                  child: Text(
                    S.of(context).pageHomeSelectFiles,
                    style: TextStyle(fontSize: 30.0, color: Colors.white),
                  ),
                ),
              ],
            )));
      },
    );
  }
}
