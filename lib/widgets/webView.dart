import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';


class WebView extends StatefulWidget{
  final String title;

  final String url;

  WebView(this.title, this.url);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new WebViewState();
  }

}


class WebViewState extends State<WebView>{
  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      url: "http://www.baidu.com",
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      withZoom: true,
      withLocalStorage: true,
      withJavascript: true,
    );
  }

}