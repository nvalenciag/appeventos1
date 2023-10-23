import 'dart:convert';

import 'package:appeventos/app/data/providers/activity_rest_controller.dart';
import 'package:appeventos/app/data/repositories_impl/user_authentication_service_impl.dart';
import 'package:appeventos/app/domain/entities/activity.dart';
import 'package:appeventos/app/domain/repositories/activity_service.dart';
import 'package:appeventos/app/domain/responses/all_activities.dart';
import 'package:http/http.dart';

class ActivityServiceImpl implements ActivityService {
  final UserAuthenticationServiceImpl userAuth;
  ActivityServiceImpl({required this.userAuth});

  ActivityRestController activityRest = ActivityRestController();
  @override
  Future<List<Activity>?> getAllActivities() async {
    Response? response = await activityRest.getAllActivities(
        userAuth.tokenSession, userAuth.user!.email);
    if (response == null) {
      return null;
    }

    List<dynamic> json = jsonDecode(response.body);
    print(json);
    return AllActivities.fromJson(json).activity;
  }

  @override
  Future<List<Activity>?> getAllActivitiesAfter(
      int page, int sizePage, String date,int idEvent) async {
    Response? response = await activityRest.getAllActivitiesAfter(
        userAuth.tokenSession, userAuth.user!.email, page, sizePage, date,idEvent);
    if (response == null) {
      return null;
    }

    List<dynamic> json = jsonDecode(response.body);
    return AllActivities.fromJson(json).activity;
  }
}
