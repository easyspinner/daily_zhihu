import 'package:dio/dio.dart';


class DioManager{
  
     static  Dio _dio;
     static DioManager _instance;

     static DioManager get() {
    if (_instance == null) {
      _instance = new DioManager._();
      _instance._init();
    }
    return _instance;
  }

  DioManager._();

  _init(){
    _dio = new Dio();
  }

  getDio() {
    return _dio;
  }
}



