import 'package:appeventos/app/dependecy_inyector/inyector.dart';

import 'package:flutter_meedu/meedu.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../../../domain/entities/User.dart';

class NewsViewController extends SimpleNotifier {
  final Inyector _inyector = Get.find<Inyector>();
  bool isButtonFavorite = false;
  bool isFavoriteResult = true;
  int indexDot=0;

  void changeIndexDot(int index){
    indexDot=index;
    notify();
  }
  void setisFavorite(bool isFavorite) {
    isButtonFavorite = isFavorite;
    notify();
  }

  List<String>? newsPhotos = [];

  void getNewsPhotos(int idNews) async {
    newsPhotos = (await _inyector.newsService!.getNewsPhotos(idNews))!;
    notify();
  }

  void isChangeFavoriteState(int idNews) async {
    isButtonFavorite = !isButtonFavorite;
    notify();
    isFavoriteResult =
        (await _inyector.favoritesService!.setFavoriteState(idNews));
    if (!isFavoriteResult) {
      isButtonFavorite = !isButtonFavorite;
      notify();
    }
  }
}
