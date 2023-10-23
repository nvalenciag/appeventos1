import 'dart:math';

import 'package:appeventos/app/ui/pages/chat_group/subpages/widgets/widgets.dart';
import 'package:appeventos/app/ui/utils/colors_clei.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/meedu.dart';

import '../../../../data/repositories_impl/firebase_service/database_service.dart';
import '../../../../dependecy_inyector/inyector.dart';
import 'chat_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  QuerySnapshot? searchSnapshot2;
  bool hasUserSearched = false;
  String userName = "";
  bool isJoined = false;
  User? user;

  @override
  void initState() {
    super.initState();
    user = Get.find<Inyector>().firebaseAuth.currentUser;
    userName = user!.displayName!;
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorsClei.azulCielo,
        title: const Text(
          "Busqueda",
          style: TextStyle(
              fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: ColorsClei.azulCielo,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Busca un grupo o un usuario para chatear",
                        hintStyle:
                            TextStyle(color: Colors.white, fontSize: 16)),
                            onSubmitted: (String value) {
                              initiateSearchMethod();
                            }
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40)),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                )
              : groupList(),
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService()
          .searchUserByName(searchController.text)
          .then((snapshot) {
        print(snapshot);
        setState(() {
          searchSnapshot = snapshot;
          //isLoading = false;
          //hasUserSearched = true;
        });
      });
      await DatabaseService()
          .searchByName(searchController.text)
          .then((snapshot) {
        print(snapshot);
        setState(() {
          searchSnapshot2 = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: (searchSnapshot?.docs.length ?? 0) +
                (searchSnapshot2?.docs.length ?? 0),
            itemBuilder: (context, index) {
              if (index < (searchSnapshot?.docs.length ?? 0)) {
                print("eeeeeeeeeeeeeee");
                return groupTile(
                    searchSnapshot!.docs[index]['email'],
                    searchSnapshot!.docs[index]['fullName'],
                    searchSnapshot!.docs[index]['uid'],
                    "searchSnapshot!.docs[index]['email']",
                    searchSnapshot!.docs[index]['email'],
                    "searchSnapshot!.docs[index]['admin']",
                    "person");
              } else {
                return groupTile(
                    searchSnapshot2!
                            .docs[index - (searchSnapshot?.docs.length ?? 0)]
                        ['groupName'],
                    searchSnapshot2!
                            .docs[index - (searchSnapshot?.docs.length ?? 0)]
                        ['groupName'],
                    "searchSnapshot2!.docs[index - (searchSnapshot?.docs.length ?? 0)]['groupName']",
                    searchSnapshot2!.docs[index]['groupId'],
                    searchSnapshot2!
                            .docs[index - (searchSnapshot?.docs.length ?? 0)]
                        ['groupName'],
                    "searchSnapshot2!.docs[index]['admin']",
                    "group");
              }
            },
          )
        : Container();
  }

  joinedOrNot(
      String userName, String groupId, String groupname, String admin) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupname, groupId, userName)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  Widget groupTile(String email, String name2, String id2, String groupId,
      String groupName, String admin, String typeSearch) {
    // function to check whether user already exists in group
    joinedOrNot(userName, groupId, groupName, admin);
    return GestureDetector(
      onTap: () => {
        if (typeSearch == "person")
          {_loadChatUser(email, name2, id2)}
        else
          {_loadChatGroup()}
      },
      child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: ColorsClei.azulCielo,
            child: Text(
              name2.substring(0, 1).toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title:
              Text(name2, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(email),
          trailing: InkWell(
            onTap: () async {
              if (typeSearch == "group") {
                await DatabaseService(uid: user!.uid)
                    .toggleGroupJoin(groupId, userName, groupName);
                if (isJoined) {
                  setState(() {
                    isJoined = !isJoined;
                  });
                  showSnackbar(
                      context, Colors.green, "Se ha unido satisfactoriamente a un grupo");
                  Future.delayed(const Duration(seconds: 2), () {
                    nextScreen(
                        context,
                        ChatPage(
                            groupId: groupId,
                            groupName: groupName,
                            userName: userName,
                            contactName: groupName));
                  });
                } else {
                  setState(() {
                    isJoined = !isJoined;
                    showSnackbar(
                        context,
                        typeSearch == "group"
                            ? ColorsClei.azulCielo
                            : Colors.white,
                        "Se ha abandonado el grupo $groupName");
                  });
                }
              }
            },
            child: isJoined
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: const Text(
                      "Salir",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: typeSearch == "group" ? ColorsClei.azulCielo : Colors.white.withOpacity(0.1),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: const Text("Unirse",
                        style: TextStyle(color: Colors.white)),
                  ),
          )),
    );
  }

  _loadChatGroup() {}

  _loadChatUser(String emailU2, String userName2, String id2) async {
    Inyector inyector = Get.find<Inyector>();
    final String emailU1 = inyector.userAuth!.user!.email;
    final String fullName = inyector.userAuth!.user!.name;
    bool exist = false;
    String nameAlpha = emailU1.compareTo(emailU2) < 0
        ? '$emailU1 $emailU2'
        : '$emailU2 $emailU1';
    String nameAlpha2 = fullName.compareTo(userName2) < 0
        ? '[$fullName[$userName2'
        : '[$userName2[$fullName';

    await DatabaseService()
        .searchByName("personal " + nameAlpha + nameAlpha2)
        .then((snapshot) {
      snapshot!.docs.forEach((doc) {
        exist = true;
        nextScreen(
          context,
          ChatPage(
            groupId: doc['groupId'],
            groupName: doc['groupName'],
            userName: fullName,
            contactName: userName2,
          ),
        );
      });
    });

    if (!exist) {
      DatabaseService(uid: user!.uid)
          .createPersonalChat(user!.displayName!, user!.uid, id2, userName2,
              "personal " + nameAlpha + nameAlpha2)
          .whenComplete(() {
        //_isLoading = false;
      });
    }
  }
}
