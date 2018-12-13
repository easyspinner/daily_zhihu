import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:daily_zhihu/widgets/topBanner.dart';
import 'package:daily_zhihu/commons/Constant.dart';
import 'package:daily_zhihu/models/hotNews.dart';
import 'package:daily_zhihu/repository/HotNewsRepository.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  ScrollController _scrollController;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey();
  String _title = Constant.todayHot;
  List<News> _newsData = new List();
  List<TopNews> _topNewsData = new List();
  DateTime _curDateTime;
  HotNewsRepository hotNewsRepository;




  Future<Null> _onRefresh() {
    final Completer<Null> completer = new Completer<Null>();

    _curDateTime = new DateTime.now();
    
    hotNewsRepository.loadNews().then((data){
      print("data: "+ data.data.topNews.elementAt(1).image);
    });
    completer.complete(null);

    return completer.future;
  }

  @override
  void initState() {
    super.initState();
    hotNewsRepository = new HotNewsRepository();
  }














  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,

      drawer: new Drawer(
        child: new Container(
          color: Colors.blue,
        ),
      ),
      body: new RefreshIndicator(
        key: _refreshIndicatorKey,

        child: _buildBody(),
        onRefresh: _onRefresh,


      ),
    );
  }

  Widget _buildBody() {
    var customScroll = new CustomScrollView(
      physics: new AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      slivers: <Widget>[
        new SliverAppBar(
          title: new Text("$_title", style: new TextStyle(fontSize: 16.0),),
          pinned: true,
          expandedHeight: 180.0,
          centerTitle: true,
          flexibleSpace:
          new FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: new TopBanner(),
          ),
        ),
        SliverList(

          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            return  _buildItem(context, index);
          }, childCount: 20),

        ),
      ],
    );

    return customScroll;
  }



  Widget _buildItem(BuildContext context, int index) {
    Widget widget;

    widget = new Container(


      padding: EdgeInsets.all(12.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(
            'This is $index item',
            style: new TextStyle(fontSize: 18.0),
            textAlign: TextAlign.start,
          ),
          new Image.asset(
            'images/appbar_def_bg.jpeg',
            fit: BoxFit.fill,
            height: 75.0,
            width: 75.0,
          )
        ],
      ),
      decoration: new BoxDecoration(
        border: Border(bottom: BorderSide(width: 0.5, color: Colors.black26)),
      ),
    );
    return widget;
  }
}
