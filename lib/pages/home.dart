import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:daily_zhihu/widgets/topBanner.dart';
import 'package:daily_zhihu/commons/Constant.dart';
import 'package:daily_zhihu/models/hotNews.dart';
import 'package:daily_zhihu/repository/remote/NewsRepository.dart';
import 'package:daily_zhihu/utils/dateUtil.dart';

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


  void _scrollListener() {
//    _computeShowtTitle(_scrollController.offset);

    //滑到最底部刷新
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {

      String date = DateUtil.formatDateSimple(_curDateTime);
      print("currentDate: "+date);
      loadNews(date);
    }
  }

  Future<Null> _onRefresh() {
    final Completer<Null> completer = new Completer<Null>();


    loadNews(null);

    completer.complete(null);

    return completer.future;
  }





  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController()..addListener(_scrollListener);
    _curDateTime = new DateTime.now();
    loadNews(null);
  }


  void loadNews(String currentDate){
    if(hotNewsRepository == null){
      hotNewsRepository = new HotNewsRepository();
    }
    hotNewsRepository.loadNews(currentDate).then((model){

      if(currentDate==null){
        print("data: "+ model.data.topNews.elementAt(1).image);
        _newsData.clear();
        _topNewsData = model.data.topNews;
        _newsData = model.data.news;

      }else{
        _curDateTime =  _curDateTime.subtract(new Duration(days: 1));
        News date = new News();
        date.setItemType(News.itemTypeDate);

        date.setCurDate(_curDateTime);
        _newsData.add(date);
        _newsData.addAll(model.data.news);

      }





      setState(() {
      });
    });
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

        child: _newsData.length>0?_buildBody():_buildProgress(),
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
          expandedHeight: 220.0,
          centerTitle: true,
          flexibleSpace:
          new FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: new TopBanner(_topNewsData),
          ),
        ),
        SliverList(

          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            return  _buildItem(context, index);
          }, childCount: _newsData.length),

        ),
      ],
    );

    return customScroll;
  }



  Widget _buildItem(BuildContext context, int index) {
    News item = _newsData[index];
    if(item.itemType == News.itemTypeDate){
      return new Container(color: Colors.blue,padding: EdgeInsets.symmetric(vertical: 10.0), child:

          new Center(
            child: Text(item.curDate, style: new TextStyle(color: Colors.white, fontSize: 14),),
          )
        ,);
    }
    String title = _newsData[index].title;
    String imageUrl = _newsData[index].images[0];
    return new InkWell(
        onTap: () {
          // RouteUtil.route2Detail(context, '$id');
        },
        child: new Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: new SizedBox(
              height: Constant.normalItemHeight,
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Text(
                          title,
                          style: new TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w300),
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new SizedBox(
                          height: 80.0,
                          width: 80.0,
                          child: new Image.network(imageUrl),
                        ),
                      )
                    ],
                  ),
                   new Expanded(
                     child: new Align(
                       alignment: Alignment.bottomCenter,
                       child: new Padding(
                         padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                         child: new Divider(height: 1.0),
                       )
                     ),
                   ),
                ],
              ),
            )));
  }

  Widget _buildProgress(){
    return new Center(
      child: CircularProgressIndicator(),
    );
  }
}
