class HotNews {
  final String date;

  final List news;

  final List<TopNews> topNews;

  const HotNews({this.date, this.news, this.topNews});
}

class News {
  final List images;
  final int type;
  final int id;
  final String title;

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
