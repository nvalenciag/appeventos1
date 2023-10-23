import 'package:appeventos/app/data/repositories_impl/firebase_service/database_service.dart';
import 'package:appeventos/app/ui/utils/colors_clei.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/meedu.dart';

import '../../../../dependecy_inyector/inyector.dart';
import '../subpages/chat_page.dart';
import '../subpages/widgets/widgets.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  final String contactName;
  const GroupTile(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName,
      required this.contactName})
      : super(key: key);

  @override
  State<GroupTile> createState()  {
    
    return _GroupTileState();}
}

class _GroupTileState extends State<GroupTile> {
  String personName = "";
  @override
  Widget build(BuildContext context) {
    List<String> groupName = widget.groupName.split(" ");
    if (groupName[0] == "personal") {
      print(widget.groupName);
      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      print(groupName[0]);

      _getNamePerson(groupName);
    }
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ChatPage(
              groupId: widget.groupId,
              groupName: widget.groupName,
              userName: widget.userName,
              contactName: widget.contactName,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: ColorsClei.azulCielo,
            child: Text(
              widget.contactName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            widget.contactName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Unirse a la conversación como ${widget.userName}",
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }

  _getNamePerson(List<String> groupName) async {
    Inyector inyector = Get.find<Inyector>();
    final String emailU1 = "aguileracamilo2929@gmail.com";
    String email = "";
    if (emailU1 != groupName[1]) {
    
      email = groupName[1];
    } else {
    
      email = groupName[2];
    }
    await DatabaseService().searchUserByName(email).then((snapshot) {
      snapshot!.docs.forEach((doc) {
        print("asjkmkjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj");
        print(doc['fullName']);
      
        personName = doc['fullName'];
      });
    });
    
  }
}
