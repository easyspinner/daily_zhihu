import 'package:daily_zhihu/utils/dateUtil.dart';
class HotNews {
  final String date;

  final List<News> news;

  final List<TopNews> topNews;

  const HotNews({this.date, this.news, this.topNews});
}

class News {

  static const int itemTypeNormal = 0;
  static const int itemTypeDate = 1;
  final List images;
  final int type;
  final int id;
  final String title;

  int itemType = itemTypeNormal;
  String curDate;

  setItemType(int type) {
    this.itemType = type;
  }

  setCurDate(DateTime dt) {
    curDate = DateUtil.formatDateWithWeek(dt);
  }

  News({this.images, this.type, this.id, this.title});

  News.fromJson(Map<String, dynamic> json)
      : images = json['images'],
        type = json['type'],
        id = json['id'],
        title = json['title'];
}

class TopNews {
  final String image;
  final int type;
  final int id;
  final String title;

  const TopNews({this.image, this.type, this.id, this.title});

  TopNews.fromJson(Map<String, dynamic> json)
      : image = json['image'],
        type = json['type'],
        id = json['id'],
        title = json['title'];
}
