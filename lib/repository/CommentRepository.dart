import 'dart:async';
import 'dart:io';
import 'package:daily_zhihu/repository/remote/DioManager.dart';
import 'package:daily_zhihu/repository/remote/Apis.dart';

import 'package:daily_zhihu/models/baseModel.dart';
import 'package:daily_zhihu/models/comments.dart';
import 'package:dio/dio.dart';


class CommentRepository{
  Future<BaseModel<List<Comment>>> loadLongComments(String id) {
    return _getLongComments(id);
  }

  Future<BaseModel<List<Comment>>> loadShortComments(String id) {
    return _getShortComments(id);
  }
}

Future<BaseModel<List<Comment>>> _getLongComments(String id) async {
  Dio dio = DioManager.get().getDio();

  String url = (Api.baseUrl + Api.long_comment).replaceAll('id', id);

  print(url);

  int code;

  String errorMsg;

  List<Comment> commentList;

  BaseModel<List<Comment>> model;

  try {
    Response response = await dio.get(url);

    code = response.statusCode;

    if (response.statusCode == HttpStatus.OK) {
      List comments = response.data['comments'];

      print(comments.toString());
      commentList = comments.map((model) {
        return new Comment.fromJson(model);
      }).toList();

      commentList.forEach((model) {
        if (null != model.replyToJson) {
          ReplyToModel replyToModel =
          new ReplyToModel.fromJson(model.replyToJson);
          model.replyTo = replyToModel;
        }
      });
    } else {
      errorMsg = '服务器异常';
    }
  } catch (exception) {
    errorMsg = '您的网络似乎出了什么问题';
  } finally {
    model = new BaseModel(code: code, errorMsg: errorMsg, data: commentList);
  }

  return model;
}

Future<BaseModel<List<Comment>>> _getShortComments(String id) async {
  Dio dio = DioManager.get().getDio();

  String url = (Api.baseUrl + Api.short_comment).replaceAll('id', id);

  print(url);

  int code;

  String errorMsg;

  List<Comment> commentList;

  BaseModel<List<Comment>> model;

  try {
    Response response = await dio.get(url);

    code = response.statusCode;

    if (response.statusCode == HttpStatus.OK) {
      List comments = response.data['comments'];

      commentList = comments.map((model) {
        return new Comment.fromJson(model);
      }).toList();

      commentList.forEach((model) {
        if (null != model.replyToJson) {
          ReplyToModel replyToModel =
          new ReplyToModel.fromJson(model.replyToJson);
          model.replyTo = replyToModel;
        }
      });
    } else {
      errorMsg = '服务器异常';
    }
  } catch (exception) {
    errorMsg = '您的网络似乎出了什么问题';
  } finally {
    model = new BaseModel(code: code, errorMsg: errorMsg, data: commentList);
  }

  return model;
}