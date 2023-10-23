import 'package:appeventos/app/domain/entities/activity.dart';

abstract class ActivityService{

  Future<List<Activity>?> getAllActivities();

  Future<List<Activity>?> getAllActivitiesAfter(int page, int sizePage,String date,int idEvent);
}