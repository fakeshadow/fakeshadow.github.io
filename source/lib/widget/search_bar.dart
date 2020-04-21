import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:psv_trophy_editor/bloc/psv_local_trophy.dart';
import 'package:psv_trophy_editor/generated/l10n.dart';
import 'package:psv_trophy_editor/model/psv_local.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  PSVLocalTrophyBloc bloc;
  bool showClearButton;
  TextEditingController _controller;

  @override
  void initState() {
    bloc = BlocProvider.of<PSVLocalTrophyBloc>(context);
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
    return Container(
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
              hintText: S.of(context).searchTrophyHint,
              border: InputBorder.none,
              suffixIcon: showClearButton
                  ? IconButton(
                      icon: Icon(Icons.clear), onPressed: () => _clearSearch())
                  : Container(
                      height: 1,
                      width: 1,
                    ),
              prefixIcon: Icon(Icons.search)),
        ),
    );
  }
}
