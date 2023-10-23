import 'package:appeventos/app/ui/pages/home/widgets/activity_modal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/activity.dart';
import '../../utils/colors_clei.dart';

class ActivityCard extends StatefulWidget {
  final Activity activityData;

  const ActivityCard({
    Key? key,
    required this.activityData,
  }) : super(key: key);

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  String text="";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return ActivityModal(activity: widget.activityData);
            },
          );
      },
      child: Container(
        decoration: _putColor(),
        width: 270,
        height: 170,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(right: 15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Text('${DateFormat.MMMd('es').format(widget.activityData.date)}   ',
                      style: const TextStyle(
                          color: ColorsClei.azulOscuro,
                          fontFamily: 'Roboto',
                          fontSize: 20)),
                  
                Expanded(child: Container()),Text(text)],
              ),
              Text(widget.activityData.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      height: 1,
                      color: ColorsClei.negro,
                      fontFamily: 'Roboto',
                      fontSize: 20)),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [const Icon(Icons.location_on, color: Color(0xFF575756)),
                  Text(widget.activityData.room.split(" ")[1]),
                    Expanded(child: Container()),
                    const Icon(Icons.watch_later, color: Color(0xFF575756)),
                    Text(
                        ' ${DateFormat.jm().format(widget.activityData.date)}-${DateFormat.jm().format(widget.activityData.date.add(Duration(minutes: widget.activityData.duration)))}',
                        style: const TextStyle(
                            color: Color(0xFF575756),
                            fontFamily: 'Roboto',
                            fontSize: 16)),
                  ],
                ),
              )
            ]),
      ),
    );
  }
  String _getRoom(String room){

    return "";

  }

  BoxDecoration _putColor() {
    DateTime dateActivity = widget.activityData.date;
    DateTime dateActivityEnd = dateActivity.add(Duration(minutes: widget.activityData.duration));
    DateTime dateNow = DateTime.now();
    if (dateNow.isAfter(dateActivity) && dateNow.isBefore(dateActivityEnd)) {
     text= "En curso";
      return const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFEDECAA),
              Color(0xFFA3CF9C),
            ],
          ));
    }
    if (dateNow.isBefore(dateActivity)) {
      text="Proximamente";
      return const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 148, 143, 193),
              Color(0xFFBEE4F9),
            ],
          ));
    }
  text="Terminado";
    return const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromARGB(255, 142, 143, 145),
            Color.fromARGB(255, 224, 225, 227),
          ],
        ));
  }
}
