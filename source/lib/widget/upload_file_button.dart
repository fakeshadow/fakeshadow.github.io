// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:psv_trophy_editor/bloc/psv_local_trophy.dart';
import 'package:psv_trophy_editor/bloc/system.dart';
import 'package:psv_trophy_editor/generated/l10n.dart';
import 'package:psv_trophy_editor/util/psv_data.dart';

class UploadFileButton extends StatelessWidget {
  startWebFilePicker(BuildContext context) async {
    final PSVLocalTrophyBloc bloc =
        BlocProvider.of<PSVLocalTrophyBloc>(context);

    bloc.add(Reset());

    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      if (uploadInput.files.length != 3) {
        return;
      }
      final file1 = uploadInput.files[0];
      final file2 = uploadInput.files[1];
      final file3 = uploadInput.files[2];

      final files = [file1, file2, file3];
      final names = [file1.name, file2.name, file3.name];

      if (names.contains("TROP.SFM") &&
          names.contains("TRPTRANS.DAT") &&
          names.contains("TRPTITLE.DAT")) {
        _handleFile(
            files[names.indexOf("TROP.SFM")],
            files[names.indexOf("TRPTRANS.DAT")],
            files[names.indexOf("TRPTITLE.DAT")],
            bloc,
            context);
      } else {
        // ToDo: give error to user.
        return print("something went wrong");
      }
    });
  }

  void _handleFile(
    html.File sfm,
    html.File trans,
    html.File trpTitle,
    PSVLocalTrophyBloc bloc,
    BuildContext context,
  ) {
    final reader = new html.FileReader();
    reader.readAsText(sfm);
    reader.onLoadEnd.listen((e) {
      PSVFileParser parser = PSVFileParser.parseSFM(reader.result.toString());

      final reader2 = new html.FileReader();
      reader2.readAsArrayBuffer(trans);
      reader2.onLoadEnd.listen((e) {
        parser = parser.parseTRANS(reader2.result);

        final reader3 = new html.FileReader();
        reader3.readAsArrayBuffer(trpTitle);
        reader3.onLoadEnd.listen((e) {
          parser = parser.parseTrpTitle(reader3.result);

          bloc.add(SetTrophy(
            title: parser.title,
            havePlat: parser.havePlat,
            orgSetCount: parser.orgSetCount,
            jitter: parser.jitter,
            trpTrans: parser.trpTrans,
            trpTitle: parser.trpTitle,
            trophies: parser.trophies,
          ));

          final title = S.of(context).titleHead + parser.title;

          BlocProvider.of<SystemBloc>(context).add(SetSystem(title: title));
          Navigator.of(context).pushNamed("editor");
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.blue,
      onPressed: () => startWebFilePicker(context),
      child: Text(
        S.of(context).pageHomeSelectFiles,
        style: TextStyle(fontSize: 30.0, color: Colors.white),
      ),
    );
  }
}
