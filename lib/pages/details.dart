import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daily_zhihu/repository/DetailRepository.dart';
import 'package:daily_zhihu/models/detailNews.dart';
import 'package:daily_zhihu/models/detailExtra.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:daily_zhihu/utils/uitls.dart';
import 'package:daily_zhihu/pages/comments.dart';

class DetailPage extends StatefulWidget {
  final String id;

  DetailPage(this.id);

  @override
  State<StatefulWidget> createState() {
    return DetailState();
  }
}

class DetailState extends State<DetailPage> {
  DetailRepository _detailRepository;
  String details = "";
  String title = "";
  DetailNews _detailNews;
  DetailExtras _detailExtras;
  String html = '<body>Hello world! <a href="www.html5rocks.com">HTML5 rocks!';
  int _like = 0;
  int _comments;
  var _store = false;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  void _loadDetails() {
    if (_detailRepository == null) {
      _detailRepository = new DetailRepository();
    }

    _detailRepository.loadStoryDetail(widget.id).then((data) {
      _detailNews = data.data;
      title = data.data.title;
//      details = "<body>"+data.data.body+"</body>";
      details = data.data.body;
//      print("-----: "+data.data.body);
      setState(() {});
//      details = data.data.body;
    });

    _detailRepository.loadStoryExtra(widget.id).then((data){
      _detailExtras = data.data;
      _comments = _detailExtras.comments;
      _like = _detailExtras.popularity;

      setState(() {

      });


    });
  }

  @override
  Widget build(BuildContext context) {
//    return new Container(color: Colors.blue,
//    child: new Text(details, style: TextStyle(color: Colors.black),),);
    return Scaffold(
      backgroundColor: Colors.white,
//      appBar: new AppBar(
//        title: new Text(title),
//      ),
      body: _detailNews == null ? _buildProgress() : _buildContent(),
      bottomNavigationBar: _buildBottom(),
    );
//    body: _detailNews == null?_buildProgress():_buildWeb(title, _detailNews.shareUrl),
//    )
//    return new WebviewScaffold(
//      url: "http://www.baidu.com",
//      appBar: new AppBar(
//        title: new Text(title),
//      ),
//      withZoom: true,
//      withLocalStorage: true,
//      withJavascript: true,
//    );
  }

  Widget _buildContent() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          new SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            child: new SliverAppBar(
              pinned: true,
              expandedHeight: 250.0,
              title: Text(title),
//              // 这个高度必须比flexibleSpace高度大
//              forceElevated: innerBoxIsScrolled,
              flexibleSpace: new FadeInImage.memoryNetwork(
                  height: 300,
                  placeholder: kTransparentImage,
                  image: _detailNews.image,
                  fit: BoxFit.cover),
            ),
          ),
        ];
      },
      body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: new Padding(
              padding:
                  EdgeInsets.only(left: 20, top: 120, right: 20, bottom: 20),
              child: new Html(
                data: details,
                backgroundColor: Colors.white70,
                defaultTextStyle: TextStyle(
                    fontSize: 20.0,
                    wordSpacing: 2,
                    letterSpacing: 2,
                    fontFamily: 'serif'),
              ))),
    );

//      physics: new AlwaysScrollableScrollPhysics(),
//      slivers: <Widget>[
//        new SliverAppBar(
//          title: new Text(
//            title,
//            style: new TextStyle(fontSize: 16.0),
//          ),
//          pinned: true,
//          expandedHeight: 220.0,
//          centerTitle: true,
//          flexibleSpace: new FlexibleSpaceBar(
//            collapseMode: CollapseMode.pin,
//            background: new FadeInImage.memoryNetwork(
//                placeholder: kTransparentImage,
//                image: _detailNews.image,
//                fit: BoxFit.cover),
//          ),
//        ),
//        new Padding(
//            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//            child: new Html(
//              data: details,
//              backgroundColor: Colors.white70,
//              defaultTextStyle: TextStyle(
//                  fontSize: 20.0,
//                  wordSpacing: 2,
//                  letterSpacing: 2,
//                  fontFamily: 'serif'),
//            )),
//      ],
//    );
  }

  Widget _buildBottom() {
    return new BottomAppBar(
      child: new Container(
        height: 45.0,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new InkWell(
              onTap: () {},
              child: new Stack(
                children: <Widget>[
                  new Icon(
                    Icons.thumb_up,
                    size: 25.0,
                    color: Colors.grey,
                  ),
                  new Container(
                      margin: const EdgeInsets.only(left: 24.0),
                      child: new Text(
                        0 == _like ? '' : ('$_like'),
                        style:
                            new TextStyle(fontSize: 12.0, color: Colors.grey),
                      )),
                ],
              ),
            ),
            new InkWell(
              onTap: () {
           _showBottomSheet();
              },
              child: new Icon(
                Icons.share,
                size: 25.0,
                color: Colors.grey,
              ),
            ),
            new InkWell(
              onTap: () {

                setState(() {
                  _store = !_store;
                });
              },
              child: new Icon(
                Icons.bookmark,
                size: 25.0,
                color: _store?Colors.blue:Colors.grey,
              ),
            ),
            new InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CommentPage(widget.id)),
                );
              },
              child: new Stack(
                children: <Widget>[
                  new Icon(
                    Icons.comment,
                    size: 25.0,
                    color: Colors.grey,
                  ),
                  new Container(
                      color: Colors.lightBlue,
                      margin: const EdgeInsets.only(left: 16.0),
                      padding: EdgeInsets.symmetric( horizontal: 2),
                      child: new Text(
                        "$_comments",
                        style:
                            new TextStyle(fontSize: 10.0, color: Colors.white),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProgress() {
    return new Center(
      child: CupertinoActivityIndicator(
        radius: 18,
      ),
    );
  }

   _showBottomSheet(){
     Utils.buildShareBottomPop(context);
  }
}
