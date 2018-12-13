import 'dart:async';
import 'dart:io';


import 'package:daily_zhihu/models/baseModel.dart';
import 'package:daily_zhihu/models/hotNews.dart';
import 'package:daily_zhihu/repository/remote/Apis.dart';
import 'package:daily_zhihu/repository/remote/DioManager.dart';
import 'package:dio/dio.dart';


class HotNewsRepository{

      Future<BaseModel<HotNews>> loadNews(){

          return _load();


      }
    
      Future<BaseModel<HotNews>> _load() async {

         HotNews hotNews;
         BaseModel<HotNews> baseModel;
  
          Dio dio = DioManager.get().getDio();
          String url = Api.baseUrl+ Api.latest;

          Response response = await dio.get(url);

          if(response.statusCode == HttpStatus.OK){
                String date = response.data['date'];

                List news = response.data['stories'];

                List topNews = response.data['top_stories'];

                List<News> newsList = news.map((model) {
        return new News.fromJson(model);
      }).toList();

                List<TopNews> topNewsList = topNews.map((model) {
                  return new TopNews.fromJson(model);
                }).toList();

                hotNews = new HotNews(date: date, news: newsList, topNews: topNewsList);

                baseModel = new BaseModel(code: 200, errorMsg: "", data: hotNews);
          }

         return baseModel;




      }
}