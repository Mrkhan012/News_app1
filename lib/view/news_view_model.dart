
import 'package:flutter/foundation.dart';

import '../model/categories_news_model.dart';
import '../model/news_headlines_model.dart';
import '../respository/news_respository.dart';


class NewsViewModel {
  final _rep = NewsRepository();

  Future<NewsHeadlineModel> getNewsApi(String name) async {
    final response = await _rep.getNewsApi(name);

    return response;
  }


  Future<CategoriesNewsModel> getCategoriesApi(String category) async {
    final response = await _rep.getCategoriesApi(category);

    return response;
  }

}