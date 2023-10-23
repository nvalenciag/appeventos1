import 'dart:convert';

import 'package:appeventos/app/data/providers/user_rest_controller.dart';
import 'package:appeventos/app/domain/entities/user.dart' as u;
import 'package:appeventos/app/domain/models/jwt_model.dart';
import 'package:appeventos/app/domain/repositories/user_authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class UserAuthenticationServiceImpl implements UserAuthenticationService {
  final FirebaseAuth _auth;
  String _tokenSession = '';
  u.User? _user;

  get tokenSession => _tokenSession;
  u.User? get user => _user;

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  UserAuthenticationServiceImpl({required FirebaseAuth auth}) : _auth = auth;
  @override
  Future<bool> validateAuthenticationToken() async {
    String? idToken = await _auth.currentUser!.getIdToken(true);
    if (idToken.isNotEmpty) {
      print('Token: $idToken');
      String? tokenFCM = await _firebaseMessaging.getToken();
      http.Response? response = await validateAthentication(idToken,tokenFCM);
      if(response == null){
        print('Error de servidor');
        return false;
      }
      if (response.statusCode != 200) {
        print('Acceso no autorizado');
        return false;
      }
      
      saveTokenSession(response);
      saveUser(response);
      return true;
    } else {
      print('Error al verificar');
      return false;
    }
  }

  void saveTokenSession(response) {
    JwtModel _jwt = JwtModel(token: response.headers['token-session']);
    _tokenSession = _jwt.getToken!;
  }

  Future<http.Response?> validateAthentication(String idToken,String? tokenFCM) async {
    UserRestController userRest = UserRestController();
    return await userRest.sendAuthenticationToken(idToken,tokenFCM!);
  }
  
  void saveUser(http.Response response) {
    Map<String,dynamic> userMap=jsonDecode(response.body);
    _user= u.User(name: userMap['name'], email: userMap['email'], photo: userMap['photo'], accountCreationDate: DateTime.parse(userMap['creationDate']));
  }

  Future<bool> checkUserAvailable() async{
    User? user = _auth.currentUser;

    if(user != null){
      return true;
    }
    return false;
  }
}
