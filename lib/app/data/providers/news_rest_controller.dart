import '../../domain/utils/config.dart';
import 'package:http/http.dart' as http;

class NewsRestController {
  final String _url = Config.url;

  Future<http.Response?> getNewsRecents(
      String tokenSession, String email, int page, int sizePage, String date,int idEvent) async {
    final String url = '$_url/NewsRecents';

    final resp = await http.get(Uri.parse(url), headers: {
      "token_session": tokenSession,
      "user_email": email,
      "page": page.toString(),
      "size_page": sizePage.toString(),"date": date,"idEvent":idEvent.toString()
    });
    if (resp.statusCode != 200) {
      return null;
    }

    return resp;
  }
  Future<http.Response?> getAllNews(
      String tokenSession, String email) async {
    final String url = '$_url/AllNews';

    final resp = await http.get(Uri.parse(url), headers: {
      "token_session": tokenSession,
      "user_email": email,
    });
    if (resp.statusCode != 200) {
      return null;
    }

    return resp;
  }

  Future<http.Response?> getNewsPhotos(
      String tokenSession, String email, int idNews) async {
    final String url = '$_url/NewsPhotos';

    final resp = await http.get(Uri.parse(url), headers: {
      "token_session": tokenSession,
      "user_email": email,
      "id_news": idNews.toString()
    });
    if (resp.statusCode != 200) {
      return null;
    }

    return resp;
  }

}
