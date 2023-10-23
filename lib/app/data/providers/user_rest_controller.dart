import 'package:appeventos/app/domain/utils/config.dart';
import 'package:http/http.dart' as http;

class UserRestController {
  final String _url = Config.url;

  Future<http.Response?> sendAuthenticationToken(
      String idToken, String tokenFCM) async {
    final String url = '$_url/crearUsuario';
    try {
      print('crear usuario' + tokenFCM);
      http.Response resp = await http.get(Uri.parse(url),
          headers: {"X-Firebase-AppCheck": idToken, "token-fcm": tokenFCM});
      return resp;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
