// ignore_for_file: dead_code, sized_box_for_whitespace, sort_child_properties_last

import 'package:appeventos/app/domain/entities/event.dart';
import 'package:appeventos/app/ui/pages/home/controller/home_provider.dart';
import 'package:appeventos/app/ui/routes/routes.dart';
import 'package:appeventos/app/ui/utils/colors_clei.dart';
import 'package:appeventos/app/ui/utils/icons_clei_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/meedu.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:intl/intl.dart';

import '../../../dependecy_inyector/inyector.dart';
import '../../../domain/entities/event.dart';

class EventCard extends StatefulWidget {
  final Event event;
  final double sizeImage;

  const EventCard(
      {Key? key,
      required this.event,
      /* required this.isFavorite,*/ required this.sizeImage})
      : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  final bool isFavorite = true;

  bool attendance = false;

  @override
  void initState() {
    super.initState();
    attendance = widget.event.attendance;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        router.pushNamed(Routes.EVENT_VIEW,
            arguments: [widget.event, isFavorite]);
      },
      child: Container(
          height: 145,
          width: 440,
          alignment: Alignment.topCenter,
          color: Color.fromARGB(31, 201, 201, 201),
          child: Container(
            width: widget.sizeImage,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius:
                        BorderRadius.circular(20.0), // Bordes redondeados
                  ),
                  width: 100,
                  height: 110,
                  child: FadeInImage(
                    image: NetworkImage(widget.event.photo),
                    placeholder: const AssetImage('assets/default_image.png'),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/default_image.png',
                          fit: BoxFit.fitWidth);
                    },
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          child: titleEvent(),
                          width: 218,
                          height: 64,
                        ),
                        InkWell(
                          onTap: () async {
                            // attendance = !attendance;

                            Inyector inyector = Get.find<Inyector>();
                            await inyector.eventService!
                                .changeAttendance(widget.event.id,
                                    inyector.userAuth!.user!.email, attendance)
                                .then((value) => {
                                      attendance = value,
                                      for (Event e
                                          in homeProvider.read.listEvent!)
                                        {
                                          if (e.id == widget.event.id)
                                            {
                                              e.attendance = value,
                                            },
                                        },
                                      widget.event.attendance = value
                                    });
                            setState(() {});
                          },
                          child: attendance
                              ? Container(
                                  width: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black,
                                    border: Border.all(
                                        color: Colors.white, width: 1),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 8),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.notifications_off,
                                        color: Colors.white,
                                        size: 19,
                                      ),
                                      Text(
                                        "Cancelar",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.187,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ColorsClei.azulCielo,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.notifications_active_sharp,
                                        color: Colors.white,
                                        size: 19,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            2, 0, 0, 0),
                                        child: Text("Asistiré",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03)),
                                      ),
                                    ],
                                  ),
                                ),
                        )
                      ],
                    ),
                    Container(
                      child: descriptionEvent(),
                      height: 54,
                      width: 300,
                    ),
                    Expanded(
                      child: Container(
                        height: 5,
                        width: MediaQuery.of(context).size.width * 0.62,
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${DateFormat.MMMd('es').format(widget.event.date)} a las ${DateFormat.jm().format(widget.event.date)}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.025),
                        ),
                      ),
                    ), /*
                    Container(
                      height: 20.0,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width *
                                  0.32), // Espacio desde la derecha
                          child: Text(
                            "${DateFormat.MMMd('es').format(widget.event.date)} a las ${DateFormat.jm().format(widget.event.date)}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.02),
                          ),
                        ),
                      ),
                    )*/
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
              ],
            ),
          )),
    );
  }

  Container contentCard() {
    return Container(
      height: 220,
      width: widget.sizeImage - 50,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 4),
            height: 150,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: ColorsClei.grisClaro, width: 1)),
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: () {
                      if (isFavorite) {
                        return const Icon(
                          IconsClei.favorito_2,
                          color: Colors.red,
                        );
                      }

                      return Container();
                    }()),
                Center(child: titleEvent()),
                Align(
                  alignment: Alignment.bottomRight,
                  child: dateCreationEvent(),
                )
              ],
            ),
          ),
          descriptionEvent()
        ],
      ),
    );
  }

  Text dateCreationEvent() {
    return Text("sdkl",
        style: const TextStyle(
            fontFamily: 'Roboto', fontSize: 14, color: ColorsClei.gris));
  }

  Padding descriptionEvent() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Text(widget.event.description,
            textAlign: TextAlign.justify,
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: MediaQuery.of(context).size.width * 0.026,
                height: 1),
            maxLines: 3,
            overflow: TextOverflow.ellipsis));
  }

  Padding titleEvent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 15, 2, 5),
      child: Text(
        widget.event.title,
        style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: MediaQuery.of(context).size.width * 0.036),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
