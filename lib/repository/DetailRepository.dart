import 'dart:async';
import 'dart:io';


import 'package:daily_zhihu/models/baseModel.dart';
import 'package:daily_zhihu/models/detailNews.dart';
import 'package:daily_zhihu/models/detailExtra.dart';
import 'package:daily_zhihu/repository/remote/DioManager.dart';
import 'package:daily_zhihu/repository/remote/Apis.dart';
import 'package:dio/dio.dart';

class DetailRepository{

  Future<BaseModel<DetailNews>> loadStoryDetail(String id) {
    return _getDetailNews(id);
  }

  Future<BaseModel<DetailExtras>> loadStoryExtra(String id) {

    return _getStoryExtra(id);
  }


  Future<BaseModel<DetailExtras>> _getStoryExtra(String id) async {
    Dio dio = DioManager.get().getDio();

    String url = Api.baseUrl + Api.story_extra + id;

    print(url);

    int code;

    String errorMsg;

    DetailExtras storyExtraModel;

    BaseModel<DetailExtras> model;

    try {
      Response response = await dio.get(url);

      code = response.statusCode;

      if (response.statusCode == HttpStatus.OK) {
        storyExtraModel = DetailExtras.fromJson(response.data);
      } else {
        errorMsg = '服务器异常';
      }
    } catch (exception) {
      errorMsg = '您的网络似乎出了什么问题';
    } finally {
      model =
      new BaseModel(code: code, errorMsg: errorMsg, data: storyExtraModel);
    }

    return model;
  }

  Future<BaseModel<DetailNews>> _getDetailNews(String id) async{
    Dio dio = DioManager.get().getDio();

    String url = Api.baseUrl + Api.detail + id;

    print(url);

    int code;

    String errorMsg;

    DetailNews storyDetailModel;

    BaseModel<DetailNews> model;

    try {
      Response response = await dio.get(url);

      code = response.statusCode;

      if (response.statusCode == HttpStatus.OK) {
        storyDetailModel = DetailNews.fromJson(response.data);
      } else {
        errorMsg = '服务器异常';
      }
    } catch (exception) {
      errorMsg = '您的网络似乎出了什么问题';
    } finally {
      model =
      new BaseModel(code: code, errorMsg: errorMsg, data: storyDetailModel);
    }

    return model;
  }


}