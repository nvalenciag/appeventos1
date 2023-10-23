import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // reference for our collections
  final CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference<Map<String, dynamic>> groupCollection =
      FirebaseFirestore.instance.collection("groups");

  // saving the userdata
  Future? savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot? snapshot =
        await userCollection.where("uid", isEqualTo: uid).get();
    return snapshot;
  }

  // get user groups
  Future<Stream<DocumentSnapshot<Map<String, dynamic>?>>>
      getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  // creating a group
  Future createGroup(String userName, String id, String groupName) async {
    // Check if a group with the same name already exists
    final groupQuery =
        await groupCollection.where("groupName", isEqualTo: groupName).get();
    final userQuery2 =
        await userCollection.where("fullName", isEqualTo: groupName).get();

    if (groupQuery.docs.isNotEmpty || userQuery2.docs.isNotEmpty) {
      // A group with the same name already exists
      return 0;
    }

    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  Future createPersonalChat(String userName1, String id1, String id2,
      String userName2, String groupName) async {
    // Check if a group with the same name already exists
    final groupQuery =
        await groupCollection.where("groupName", isEqualTo: groupName).get();

    if (groupQuery.docs.isNotEmpty) {
      // A group with the same name already exists
      throw Exception("Group with the same name already exists.");
    }

    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    // update the members
    await groupDocumentReference.update({
      "members":
          FieldValue.arrayUnion(["${id1}_$userName1", "${id2}_$userName2"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference2 = userCollection.doc(id2);
    userDocumentReference2.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  getNameByEmail(String email) {
    return userCollection.where("email", isEqualTo: email).get();
  }

  // getting the chats
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get group members
  Future<Stream<DocumentSnapshot<Map<String, dynamic>?>>> getGroupMembers(
      groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  // search
  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  searchUserByName(String user) {
    return userCollection
        .where("fullName", isGreaterThanOrEqualTo: user)
        .where("fullName", isLessThanOrEqualTo: user + '\uf8ff')
        .get();
  }

  // function -> bool
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = documentSnapshot['groups'];

    if (groups.contains("${groupId}_$groupName")) {
      return true;
    }
    return false;
  }

  // toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part rejoin
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  // send message
  Future<void> sendMessage(
      String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    await groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}
