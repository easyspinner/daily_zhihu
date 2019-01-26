import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daily_zhihu/models/comments.dart';
import 'package:daily_zhihu/repository/CommentRepository.dart';
import 'package:daily_zhihu/commons/Constant.dart';
import 'package:daily_zhihu/utils/dateUtil.dart';

class CommentPage extends StatefulWidget {
  String id;

  CommentPage(this.id);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CommentState();
  }
}

class CommentState extends State<CommentPage> {
  List<Comment> _longComments;
  List<Comment> _shortComments;
  CommentRepository _commentRepository;
  List<Comment> _datas = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_commentRepository == null) {
      _commentRepository = new CommentRepository();
    }

    _commentRepository.loadLongComments(widget.id).then((data) {
      _longComments = data.data;
      _datas.add(new Comment(itemType: Comment.longCommentType));
      _datas.addAll(_longComments);
      _commentRepository.loadShortComments(widget.id).then((data) {
        _shortComments = data.data;
        _datas.add(new Comment(itemType: Comment.shortCommentType));
        setState(() {});
      });
    });
  }

  bool _checkProgress() {
    return _datas.length > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text("评论列表"),
      ),
      body: _checkProgress() ? _buildContent() : _buildProgress(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildContent() {
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _datas.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildList(_datas[index]);
        });
  }

  Widget _buildList(Comment item) {
    Widget widget;

    switch (item.itemType) {
      case Comment.longCommentType:
        widget = _buildTotal("${_longComments.length}条长评论");
        break;
      case Comment.normalCommentType:
        widget = _buildItem(item);
        break;
      case Comment.shortCommentType:
        widget = _buildShortComments();
        break;
    }

    return widget;
  }

  Widget _buildTotal(String total) {
    return new Column(
      children: <Widget>[
        new Container(
            height: 50.0,
            padding: EdgeInsets.all(12.0),
            child: new Align(
              alignment: Alignment.centerLeft,
              child: new Text(
                total,
                style: new TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            )),
        new Divider(
          height: 1,
        )
      ],
    );
  }



  Widget _buildItem(Comment item) {
    String time = DateUtil.formatDate(item.time * 1000);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: new Column(
//        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Row(
//            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 12,
                backgroundImage: new NetworkImage(
                    item.avatar.isEmpty ? Constant.defHeadimg : item.avatar),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: new Text('${item.author}',
                    style: new TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    )),
              ),
              new Expanded(
                  child: new Container(
                child: new Align(
                  alignment: Alignment.topRight,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Icon(
                        Icons.thumb_up,
                        color: Colors.grey,
                        size: 18.0,
                      ),
                      new Text(
                        '(${item.likes})',
                        style: new TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ))
            ],
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 35.0, top: 4.0, bottom: 10.0),
            child: new Container(
              alignment: Alignment.topLeft,
              child: new Text('${item.content}',
                  style: new TextStyle(fontSize: 14.0, color: Colors.black)),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
            child: new Container(
              alignment: Alignment.topRight,
              child: new Text('$time'),
            ),
          ),
          new Divider(
            height: 1.0,
          )
        ],
      ),
    );
  }

  Widget _buildShortComments() {
    return new ExpansionTile(
      title: new Text('${_shortComments.length} 条短评论',
          style: new TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.black)),
      children: _shortComments.map((Comment model) {
        return _buildItem(model);
      }).toList(),
    );
  }

  Widget _buildBottomBar() {
    return new BottomAppBar(
      child: new InkWell(
        onTap: () {},
        child: new Container(
          height: 40.0,
          child: new Center(
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(
                  Icons.edit,
                  color: Colors.blue,
                  size: 20.0,
                ),
                new Text(
                  '写点评',
                  style: new TextStyle(fontSize: 16.0, color: Colors.blue),
                ),
              ],
            ),
          ),
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
}
