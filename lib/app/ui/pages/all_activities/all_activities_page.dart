import 'package:flutter/material.dart';
import 'package:flutter_meedu/meedu.dart';
import 'package:flutter_meedu/ui.dart';
import '../../../dependecy_inyector/inyector.dart';
import '../../../domain/entities/activity.dart';
import '../../global_widgets/activity_card/activity_card.dart';
import '../../utils/colors_clei.dart';
import '../../utils/icons_clei_icons.dart';
import 'controller/all_activities_provider.dart';

class AllActivitiesPage extends StatelessWidget {
  const AllActivitiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 34,
          ),
          onPressed: () {
            router.pop();
          },
        ),
        title: const Text(
          'Todas las Actividades',
          style: TextStyle(
              color: Colors.white, fontFamily: 'Roboto', fontSize: 30),
        ),
        backgroundColor: ColorsClei.azulOscuro,
        toolbarHeight: 65,
        elevation: 0.0,
      ),
      body: Center(child: _bodyPage()),
    );
  }

  _bodyPage() {
    return Container(
      width: 370,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: _loadingActivitiesWidget(),
    );
  }

  Consumer _loadingActivitiesWidget() {
    Inyector inyector = Get.find<Inyector>();
    return Consumer(
      builder: (context, ref, child) {
        final controller = ref.watch(allActivitiesProvider);
        if (controller.isLoadingActivities) {
          return Stack(children: const [
            Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            ),
          ]);
        } else {
          List<Activity> activities = controller.activities!;
          return ListView(
            scrollDirection: Axis.vertical,
            children: () {
              List<Widget> activitiesCard = [];
              for (Activity activity in activities) {
                activitiesCard.add(Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ActivityCard(
                      activityData: Activity(
                          id: activity.id,
                          title: activity.title,
                          room: activity.room,
                          date: activity.date,
                          duration: activity.duration,
                          authors: activity.authors)),
                ));
              }
              return activitiesCard;
            }(),
          );
        }
      },
    );
  }
}
