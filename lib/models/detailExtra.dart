class DetailExtras{

  final int longComments;
  final int popularity;
  final int shortComments;
  final int comments;

  const DetailExtras(
      {this.longComments, this.popularity, this.shortComments, this.comments});

  DetailExtras.fromJson(Map<String, dynamic> json)
      : longComments = json['long_comments'],
        popularity = json['popularity'],
        shortComments = json['short_comments'],
        comments = json['comments'];
  }