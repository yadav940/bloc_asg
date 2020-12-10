
import 'package:bloc_asg/res/strings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'api_result_model.dart';


abstract class ArticleRepository {
  Future<dynamic> getArticles();
}

class ArticleRepositoryImpl implements ArticleRepository {

  @override
  Future<dynamic> getArticles() async {
    var response = await http.get(AppStrings.cricArticleUrl);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Articles> articles = ApiResultModel.fromJson(data).articles;
      return articles;
    } else {
      throw Exception();
    }
  }

}