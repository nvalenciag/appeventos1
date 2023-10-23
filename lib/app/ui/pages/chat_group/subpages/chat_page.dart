import 'package:appeventos/app/ui/pages/chat_group/subpages/widgets/widgets.dart';
import 'package:appeventos/app/ui/utils/colors_clei.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/repositories_impl/firebase_service/database_service.dart';
import 'group_info.dart';
import 'widgets/message_tile.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  final String contactName;
  const ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName,
      required this.contactName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

late FocusNode messageFocusNode;

class _ChatPageState extends State<ChatPage> {
  ScrollController _scrollController = new ScrollController();
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";
  int previousLength = 0;

  @override
  void initState() {
    super.initState();
    messageFocusNode = FocusNode();
    getChatandAdmin();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // _agregar10()
      }
    });
  }

  @override
  void dispose() {
    messageFocusNode.dispose();
    // ... (tu código existente)
    super.dispose();
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        centerTitle: true,
        elevation: 0,
        title: Text(
          widget.contactName,
          style: const TextStyle(
              color: Colors.white, fontFamily: 'Roboto', fontSize: 25),
        ),
        backgroundColor: ColorsClei.azulCielo,
        actions: [
          widget.groupName.split(" ")[0] != "personal"
              ? IconButton(
                  onPressed: () {
                    nextScreen(
                        context,
                        GroupInfo(
                          groupId: widget.groupId,
                          groupName: widget.groupName,
                          adminName: admin,
                        ));
                  },
                  icon: const Icon(Icons.info))
              : Container()
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: <Widget>[
                chatMessages(),
                Container(
                  height: 62,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    40), // Ajusta el valor según tus preferencias
                color: Colors.grey[
                    700], // Puedes ajustar el color de fondo según tus necesidades
              ),
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextFormField(
                        controller: messageController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType:
                            TextInputType.multiline, // Para múltiples líneas
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        onTap: () {
                          // Activa el foco y el teclado
                          messageFocusNode.requestFocus();
                          // Detecta enlaces y ábrelos en el navegador
                          launchURLsInText(messageController.text);
                        },
                        decoration: InputDecoration(
                          hintText: "Escribe un mensaje...",
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await sendMessage();
                      _scrollDown();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                controller: _scrollController,
                itemCount: snapshot.data.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sentByMe: widget.userName ==
                          snapshot.data.docs[index]['sender']);
                },
              )
            : Container();
      },
    );
  }

  void launchURLsInText(String text) {
    final RegExp urlRegex = RegExp(
      r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+',
      caseSensitive: false,
    );
    final Iterable<Match> matches = urlRegex.allMatches(text);

    for (Match match in matches) {
      final String url = text.substring(match.start, match.end);
      launchURL(url);
    }
  }

  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('No se pudo abrir el enlace: $url');
    }
  }

  Future sendMessage() async {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      await DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
