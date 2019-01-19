import 'package:daily_zhihu/models/baseModel.dart';
import 'package:daily_zhihu/models/detailNews.dart';

class DetailRepository{

  Future<BaseModel<DetailNews>> loadStoryDetail(String id) {
    return _getDetailNews(id);
  }

  Future<BaseModel<DetailNews>> _getDetailNews(String id){

  }


}