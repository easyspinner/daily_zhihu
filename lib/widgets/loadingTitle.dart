import 'package:flutter/material.dart';

class CompoundTitle extends StatefulWidget {
  Widget _title;
  CompoundTextState _state;
  CompoundTitle( this._title);
  void showLoading(bool show){
    this._state.setState((){
      _state._showIndicator = show;
    });
  }


  @override
  State<StatefulWidget> createState() {
    CompoundTextState state = CompoundTextState();
    this. _state = state;
    return state;

  }
}

class CompoundTextState extends State<CompoundTitle> {

  bool _showIndicator = false;

  Widget _buildLoading(){
    return new Container(
      height: 18.0,
      width: 18.0,
      color: Colors.transparent,
      child: new CircularProgressIndicator(
        strokeWidth: 1.0,
        valueColor: new AlwaysStoppedAnimation(Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisSize: MainAxisSize.min ,
      children: <Widget>[
        _showIndicator? _buildLoading(): new Container(),
        new Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: widget._title,
        )
      ],
    );
  }
}
