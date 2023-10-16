import 'package:dio/dio.dart';

import '../model/categories_news_model.dart';
import '../model/news_headlines_model.dart';

class NewsRepository {
  Future<NewsHeadlineModel> getNewsApi(String newsChannel) async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=$newsChannel&apiKey=93cfd28d097b40158e9c63e7d78ca5ec";
    try {
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        final body = response.data as Map<String, dynamic>;
        return NewsHeadlineModel.fromJson(body);
      } else {
        throw Exception(
            "Failed to fetch data. Status code ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to fetch data. Error: $e");
    }
  }


  Future<CategoriesNewsModel> getCategoriesApi(String category) async {

    String url =
        "https://newsapi.org/v2/everything?q=${category}&apiKey=93cfd28d097b40158e9c63e7d78ca5ec";
    try {
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        final body = response.data as Map<String, dynamic>;
        return CategoriesNewsModel.fromJson(body);
      } else {
        throw Exception(
            "Failed to fetch data. Status code ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to fetch data. Error: $e");
    }
  }
}
