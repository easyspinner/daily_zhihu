import 'package:flutter/material.dart';
import 'package:daily_zhihu/pages/home.dart';
import 'dart:async';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  Future _future;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = new Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushAndRemoveUntil( new MaterialPageRoute( builder: (BuildContext context) => new HomePage() ), (Route route)=> route == null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.blue,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            '知乎日报',
            style: new TextStyle(
                color: Colors.white,
                fontSize: 32.0,
                fontWeight: FontWeight.bold),
          ),
          new Container(
            height: 12.0,
          ),
          new Text(
            '发现新世界',
            style: new TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
