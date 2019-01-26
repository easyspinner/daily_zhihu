import 'dart:async';
import 'dart:io';


import 'package:daily_zhihu/models/baseModel.dart';
import 'package:daily_zhihu/models/hotNews.dart';
import 'package:daily_zhihu/repository/remote/Apis.dart';
import 'package:daily_zhihu/repository/remote/DioManager.dart';
import 'package:dio/dio.dart';


class HotNewsRepository{

      Future<BaseModel<HotNews>> loadNews(String date){

          return _load(date);


      }
    
      Future<BaseModel<HotNews>> _load(String date) async {

         HotNews hotNews;
         BaseModel<HotNews> baseModel;
  
          Dio dio = DioManager.get().getDio();
          String url = Api.baseUrl+ Api.latest;
          if(date != null){
            url = Api.baseUrl + Api.before + date;
          }

          Response response = await dio.get(url);
          print("response: "+ response.data.toString());

          if(response.statusCode == HttpStatus.OK){
                String date = response.data['date'];

                List news = response.data['stories'];

                List topNews = response.data['top_stories'];
                List<TopNews> topNewsList;

                List<News> newsList = news.map((model) {
        return new News.fromJson(model);
      }).toList();
                if(topNews!=null){
                  topNewsList = topNews.map((model) {
                    return new TopNews.fromJson(model);
                  }).toList();
                }

                hotNews = new HotNews(date: date, news: newsList, topNews: topNewsList);

                baseModel = new BaseModel(code: 200, errorMsg: "", data: hotNews);
          }

         return baseModel;




      }
}