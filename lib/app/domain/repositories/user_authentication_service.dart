import 'package:http/http.dart' as http;

abstract class UserAuthenticationService {
  Future<bool> validateAuthenticationToken();

  void saveTokenSession(response);
  Future<http.Response?> validateAthentication(String idToken,String fcm);

  void saveUser(http.Response response);

  Future<bool> checkUserAvailable();
}
