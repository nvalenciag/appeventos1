import 'package:flutter_meedu/meedu.dart';

import '../../../../dependecy_inyector/inyector.dart';
import '../../../../domain/entities/activity.dart';

class AllActivitiesController extends SimpleNotifier {

  final Inyector _inyector = Get.find<Inyector>();
  bool isLoadingActivities = false;
   List<Activity>? activities = [];

AllActivitiesController(){
  loadActivity();
}

 void loadActivity() async {
    isLoadingActivities = true;
    await  _loadingActivities();
    isLoadingActivities = false;
    notify();
  }
  _loadingActivities() async {
    List<Activity> temp = (await _inyector.activityService!.getAllActivities())!;

    if (temp.isNotEmpty) {
      activities?.addAll(temp);
    }
  }
}
  