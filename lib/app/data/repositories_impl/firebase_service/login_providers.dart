import 'package:appeventos/app/domain/repositories/social_authentication_service.dart';
import 'package:appeventos/app/domain/utils/resource.dart';
import 'package:appeventos/app/ui/pages/loggin/widgets/alert_firebase_exception.dart';
import 'package:appeventos/app/ui/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_meedu/ui.dart';

class LoginProviders {
  final LoginType loginType;
  final SocialAuthenticationService _socialAuth;

  LoginProviders({required SocialAuthenticationService socialAuth, required this.loginType})
      : _socialAuth = socialAuth;

  Future<void> loginWithProviders() async {
    String? displayName;
    Resource? result = Resource(status: Status.Error);
    try {
      switch (loginType) {
        case LoginType.Google:
          displayName = (await _socialAuth.signIn());
          break;
      }
      if (result!.status == Status.Success || displayName != null) {
        router.pushNamedAndRemoveUntil(Routes.INIT);
      }
    } on Exception catch (e) {
      if (e is FirebaseAuthException) {

        AlertFirebaseException().showMessage(e);
      }
    }
  }
}
