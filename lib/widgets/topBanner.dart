import 'package:flutter/material.dart';
import 'dart:async';

class TopBanner extends StatefulWidget {
@override
State<StatefulWidget> createState() => TopState();
}

class TopState extends State<TopBanner> {
  List<Widget> _indicators = [];
  int _currentIndex = 0;
  int _currentPageIndex = 0;
  int _maxPages = 5;
  PageController _pageController = new PageController();
  bool _isEndScroll = true;
  Timer _timer;
  Duration _bannerDuration = new Duration(seconds: 3);
  Duration _bannerAnimationDuration = new Duration(milliseconds: 500);
  Duration _bannerBounceBack = new Duration( milliseconds: 200);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(_timer == null){
      _timer = new Timer.periodic(_bannerDuration, (timer) {
        if(_isEndScroll){
          Duration d = _bannerAnimationDuration;
          int page = _currentPageIndex+1;
          if(_currentPageIndex>= _maxPages-1){
            d = _bannerBounceBack;
            page = 0;
          }
          _pageController.animateToPage(page,duration: d, curve: Curves.linear);
        }
      });
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  void initIndicators() {
    _indicators.clear();
    for (int i = 0; i < 5; i++) {
      _indicators.add(new SizedBox(
        width: 5.0,
        height: 5.0,
        child: new Container(
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: i == _currentIndex ? Colors.white : Colors.grey,
          ),

        ),
      ));
    }
  }

  _changePage(int index) {
    _currentPageIndex = index;
    _currentIndex = index % 5;
    setState(() {});
  }

  Widget _buildIndicators() {
    initIndicators();
    return new Align(
      alignment: Alignment.bottomCenter,
      child: new Container(
          color: Colors.black45,
          height: 20.0,
          child: new Center(
            child: new SizedBox(
              width: 80.0,
              height: 5.0,
              child: new Row(
                children: _indicators,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ),
          )),
    );
  }

  Widget _buildPagerView() {
    return new NotificationListener(
        onNotification: (ScrollNotification scrollNotification) {
          if (scrollNotification is ScrollEndNotification ||
              scrollNotification is UserScrollNotification) {
            _isEndScroll = true;
          } else {
            _isEndScroll = false;
          }
          return false;
        },
        child: new PageView.builder(
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            return _buildItem(context, index);
          },
          itemCount: _maxPages,
          onPageChanged: (index) {
            _changePage(index);
          },
        ));
  }

  Widget _buildItem(BuildContext context, int index) {
    return new GestureDetector(
      child: new GestureDetector(
        onTapDown: (donw) {
          _isEndScroll = false;
        },
        onTapUp: (up) {
          _isEndScroll = true;
        },
        child: new Image.asset(
            'images/appbar_def_bg.jpeg',
            fit: BoxFit.fill),

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Stack(
        children: <Widget>[
          _buildPagerView(),
          _buildIndicators()
        ],
      ),
    );
  }
}
