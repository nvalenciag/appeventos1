import 'dart:convert';

import 'package:appeventos/app/data/providers/news_rest_controller.dart';
import 'package:appeventos/app/domain/entities/news.dart';
import 'package:appeventos/app/domain/repositories/news_service.dart';
import 'package:appeventos/app/data/repositories_impl/user_authentication_service_impl.dart';
import 'package:appeventos/app/domain/responses/list_news.dart';
import 'package:appeventos/app/domain/responses/news_photos.dart';
import 'package:http/http.dart';

class NewsServiceImpl implements NewsService {
  final UserAuthenticationServiceImpl userAuth;
  NewsServiceImpl({required this.userAuth});

  NewsRestController newsRest = NewsRestController();

  @override
  Future<List<News>?> getNewsRencents(int page, int sizePage,String date,int idEvent) async {
    Response? response = await newsRest.getNewsRecents(
        "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxNyIsImV4cCI6MTY5ODE4MTI1OCwiaWF0IjoxNjk4MDk0ODU4fQ.TupMwLFKyTMZWj0vkm13KVbq7ik86nhqwaJdLiPu93LfPieLYyGp6YkZXl6IDpOyNd9-MKGUv8Vl9deGwJsZhg", "aguileracamilo2929@gmail.com", page, sizePage,date,idEvent);
    if (response == null) {
      return null;
    }

    List<dynamic> json = jsonDecode(response.body);
    print("iiiiiiiiiii");
    print(json);
    return ListNews.fromJson(json).listNews;
  }

  @override
  Future<List<String>?> getNewsPhotos(int idNews) async {
    Response? response = await newsRest.getNewsPhotos(
        "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxNyIsImV4cCI6MTY5ODE4MTI1OCwiaWF0IjoxNjk4MDk0ODU4fQ.TupMwLFKyTMZWj0vkm13KVbq7ik86nhqwaJdLiPu93LfPieLYyGp6YkZXl6IDpOyNd9-MKGUv8Vl9deGwJsZhg", "aguileracamilo2929@gmail.com", idNews);
    if (response == null) {
      return null;
    }

    List<dynamic> json = jsonDecode(response.body);
    return NewsPhotos.fromJson(json).newsPhotos;
  }
@override
  Future<List<News>?> getAllNews() async {
    Response? response = await newsRest.getAllNews(
        userAuth.tokenSession, userAuth.user!.email);
    if (response == null) {
      print('aaaaaa');
      return null;
    }

    List<dynamic> json = jsonDecode(response.body);
    return ListNews.fromJson(json).listNews;
  }
}
