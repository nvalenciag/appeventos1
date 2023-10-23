import 'package:appeventos/app/domain/entities/activity.dart';
import 'package:appeventos/app/ui/utils/colors_clei.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';

import 'package:intl/intl.dart';

class ActivityModal extends StatelessWidget {
  final Activity activity;

  const ActivityModal({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
          margin: EdgeInsets.only(left: 24, right: 24, top: 156),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          height: 370,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 150,
                    child: Text(
                      'Información',
                      style:
                          TextStyle(fontSize: 23, fontFamily: 'Roboto'),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: FloatingActionButton(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        onPressed: () {
                          router.pop();
                        },
                        child: Icon(
                          Icons.close_rounded,
                          color: ColorsClei.azulOscuro,
                          size: 30,
                        ),
                      )),
                ],
              ),
             
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textLeft('Nombre'),
                  textRight(activity.title),
                ],
              ),
              Row(
                children: [
                  textLeft('Fecha'),
                  textRight(DateFormat.yMMMd('es').format(activity.date))
                ],
              ),
              Row(
                children: [
                  textLeft('Hora de inicio'),
                  textRight('🕑 ${DateFormat.jm().format(activity.date)}')
                ],
              ),
              Row(
                children: [
                  textLeft('Hora de fin'),
                  textRight(
                      '🕑 ${DateFormat.jm().format(activity.date.add(Duration(minutes: activity.duration)))}')
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [textLeft('Sala'), textRight(activity.room)],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textLeft('Autor(es)'),
                  textRight(activity.authors
                      .toString()
                      .replaceAll('[', '')
                      .replaceAll(']', ''))
                ],
              ),
              
            ],
          )),
    );
  }

  Widget textRight(String text) {
    return Container(
        width: 235,
        child: Text(
          text,
          style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
        ));
  }

  Widget textLeft(String text) {
    return Container(
      width: 150,
      child: Text(
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        text,
        style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 15,
            color: Color.fromARGB(255, 119, 119, 119)),
      ),
    );
  }
}
