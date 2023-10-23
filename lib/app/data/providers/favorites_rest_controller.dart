import '../../domain/utils/config.dart';
import 'package:http/http.dart' as http;

class FavoritesRestController {
  final String _url = Config.url;

  Future<bool> setFavoriteState(
      String tokenSession, String email, int idNews) async {
    final String url = '$_url/Favorites';

    final resp = await http.post(Uri.parse(url), headers: {
      "token_session": tokenSession,
      "user_email": email,
      "id_news": idNews.toString()
    });
    if (resp.statusCode != 200) {
      return false;
    }

    return true;
  }

 Future<http.Response?> getFavorites(
      String tokenSession, String email) async {
    final String url = '$_url/Favorites';

    final resp = await http.get(Uri.parse(url), headers: {
      "token_session": tokenSession,
      "user_email": email,
    });
    if (resp.statusCode != 200) {
      return null;
    }

    return resp;
  }
}