import 'package:appeventos/app/data/repositories_impl/firebase_service/database_service.dart';
import 'package:appeventos/app/ui/pages/chat_group/subpages/search_page.dart';
import 'package:appeventos/app/ui/pages/chat_group/widgets/group_tile.dart';
import 'package:appeventos/app/ui/utils/colors_clei.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/meedu.dart';

import '../../../dependecy_inyector/inyector.dart';
import 'subpages/widgets/widgets.dart';

class ChatGroupPage extends StatefulWidget {
  const ChatGroupPage({Key? key}) : super(key: key);

  @override
  State<ChatGroupPage> createState() => _ChatGroupState();
}

class _ChatGroupState extends State<ChatGroupPage> {
  Stream<DocumentSnapshot<Map<String, dynamic>?>>? groups;
  bool _isLoading = false;
  String groupName = "";
  User? user;

  @override
  initState() {
    super.initState();
    user = Get.find<Inyector>().firebaseAuth.currentUser;
    gettingUserData();
  }

  // string manipulation8
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  String getNamesUser(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    // getting the list of snapshots in our stream
    await DatabaseService(uid: user!.uid).getUserGroups().then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const SearchPage());
              },
              icon: const Icon(
                Icons.search,
                size: 32,
              )),
          SizedBox(
            width: 8,
          )
        ],
        elevation: 0,
        toolbarHeight: 65,
        backgroundColor: ColorsClei.azulCielo,
        title: const Text(
          "Chats",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: ColorsClei.azulCielo,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Crea un grupo",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        )
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              groupName = val;
                            });
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 54, 114, 244)),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style:
                      ElevatedButton.styleFrom(primary: ColorsClei.azulCielo),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        _isLoading = true;
                      });

                      var resp = await DatabaseService(uid: user!.uid)
                          .createGroup(user!.displayName!, user!.uid, groupName)
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackbar(
                          context,
                          resp == 0 ? Colors.red : Colors.green,
                          resp == 0
                              ? "Ya existe un grupo con ese nombre"
                              : "Grupo creado de forma exitosa");
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(primary: ColorsClei.azulCielo),
                  child: const Text("Crear"),
                )
              ],
            );
          }));
        });
  }

  groupList() {
    return StreamBuilder<DocumentSnapshot>(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  String contactName = "";
                  if (getName(snapshot.data['groups'][reverseIndex])
                          .split(" ")[0] ==
                      "personal") {
                    print(getName(snapshot.data['groups'][reverseIndex]));
                    List<String> names =
                        getName(snapshot.data['groups'][reverseIndex])
                            .split("[");

                    contactName = snapshot.data['fullName'] == names[1]
                        ? names[2]
                        : names[1];
                  } else {
                    contactName =
                        getName(snapshot.data['groups'][reverseIndex]);
                  }
                  print(snapshot.data['fullName']);
                  return GroupTile(
                      groupId: getId(snapshot.data['groups'][reverseIndex]),
                      groupName: getName(snapshot.data['groups'][reverseIndex]),
                      userName: snapshot.data['fullName'],
                      contactName: contactName);
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Color.fromARGB(255, 99, 166, 195),
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "No hay chats para mostrar, realize la busqueda de chats para comenzar a chatear.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
