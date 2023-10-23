import 'dart:convert';

import 'package:appeventos/app/data/providers/news_rest_controller.dart';
import 'package:appeventos/app/domain/entities/news.dart';
import 'package:appeventos/app/domain/repositories/favorites_service.dart';
import 'package:appeventos/app/domain/repositories/news_service.dart';
import 'package:appeventos/app/data/repositories_impl/user_authentication_service_impl.dart';
import 'package:appeventos/app/domain/responses/list_news.dart';
import 'package:appeventos/app/domain/responses/news_photos.dart';
import 'package:http/http.dart';

import '../../../domain/responses/favorites.dart';
import '../../providers/favorites_rest_controller.dart';

class FavoritesServiceImpl implements FavoritesService {
  final UserAuthenticationServiceImpl userAuth;

  FavoritesServiceImpl({required this.userAuth});

  FavoritesRestController favoritesRest = FavoritesRestController();

@override
  Future<bool> setFavoriteState(int idNews) async {
    bool response = await favoritesRest.setFavoriteState(
        userAuth.tokenSession, userAuth.user!.email, idNews);

    return response;
  }
  
  @override
  Future<List<int>?> getFavorites() async {
    Response? response = await favoritesRest.getFavorites(
        userAuth.tokenSession, userAuth.user!.email);
    if (response == null) {
      return null;
    }

    List<dynamic> json = jsonDecode(response.body);
    return Favorites.fromJson(json).listFavorites;
  }
}