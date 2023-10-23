import 'package:appeventos/app/domain/utils/resource.dart';

abstract class SocialAuthenticationService{
  Future<dynamic> signIn();
  Future<void> signOut();
}