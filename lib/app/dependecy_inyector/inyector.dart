import 'package:appeventos/app/data/data_source/remote/activity_service_impl.dart';
import 'package:appeventos/app/data/data_source/remote/favorites_service_impl.dart';
import 'package:appeventos/app/data/data_source/remote/news_service_impl.dart';
import 'package:appeventos/app/data/repositories_impl/firebase_service/database_service.dart';

import 'package:appeventos/app/data/repositories_impl/firebase_service/google_authentication_impl.dart';
import 'package:appeventos/app/data/repositories_impl/firebase_service/login_providers.dart';

import 'package:appeventos/app/data/repositories_impl/user_authentication_service_impl.dart';
import 'package:appeventos/app/domain/repositories/social_authentication_service.dart';
import 'package:appeventos/app/domain/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../data/data_source/remote/event_service_imp.dart';

class Inyector {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  UserAuthenticationServiceImpl? userAuth;
  SocialAuthenticationService? socialAuth;
  LoginProviders? loginProviders;
  ActivityServiceImpl? activityService;
  NewsServiceImpl? newsService;
  EventServiceImpl? eventService;
  FavoritesServiceImpl? favoritesService;
  List<int>? idsFavoritesNews = [];
  Inyector() {
    userAuth = UserAuthenticationServiceImpl(auth: firebaseAuth);
    activityService = ActivityServiceImpl(userAuth: userAuth!);
    newsService = NewsServiceImpl(userAuth: userAuth!);
    eventService = EventServiceImpl(userAuth: userAuth!);
    favoritesService = FavoritesServiceImpl(userAuth: userAuth!);
  }

  Future<void> getFavoritesNews() async {
    idsFavoritesNews = await favoritesService!.getFavorites();
  }

  Future<void> loginProvider(LoginType loginType) async {
    switch (loginType) {
      case LoginType.Google:
        final GoogleSignIn googleSignIn = GoogleSignIn();
        socialAuth = GoogleAuthenticationImpl(
            firebaseAuth: firebaseAuth,
            googleSignIn: googleSignIn,
            userAuth: userAuth!);
        break;
    }
    loginProviders =
        LoginProviders(socialAuth: socialAuth!, loginType: loginType);
    void response = await loginProviders!.loginWithProviders();
    print('Usuario: ${userAuth!.user}');
    final CollectionReference<Map<String, dynamic>> userCollection =
        FirebaseFirestore.instance.collection("users");
    try {
      print(
          'Existeeeeee:${(await userCollection.doc(firebaseAuth.currentUser!.uid).get()).exists}');
      if (!(await userCollection.doc(firebaseAuth.currentUser!.uid).get())
          .exists) {
        print('crear usuario en la base de datooooooos');
        await DatabaseService(uid: firebaseAuth.currentUser!.uid)
            .savingUserData(userAuth!.user!.name, userAuth!.user!.email);
      }
    } catch (e) {
      print(e);
    }
    return response;
  }

  logOut() {
    socialAuth!.signOut();
  }
}
