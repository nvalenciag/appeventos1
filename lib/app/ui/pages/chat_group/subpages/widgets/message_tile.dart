import 'package:appeventos/app/ui/utils/colors_clei.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;

  const MessageTile({
    Key? key,
    required this.message,
    required this.sender,
    required this.sentByMe,
  }) : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    List<InlineSpan> buildMessageContent() {
      final List<InlineSpan> spans = [];

      final words = widget.message.split(' ');

      for (final word in words) {
        if (word.contains(':') && !word.startsWith('http')) {
          spans.add(
            TextSpan(
              text: word + ' ',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          );
        } else if (Uri.parse(word).isAbsolute) {
          spans.add(
            WidgetSpan(
              child: GestureDetector(
                onTap: () async {
                  if (await canLaunch(word)) {
                    await launch(word);
                  }
                },
                child: Text(
                  word,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          );
        } else {
          spans.add(
            TextSpan(
              text: word + ' ',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          );
        }
      }

      return spans;
    }

    return Container(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: widget.sentByMe ? 0 : 24,
        right: widget.sentByMe ? 24 : 0,
      ),
      alignment:
          widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(
          top: 17,
          bottom: 17,
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: widget.sentByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
          color: widget.sentByMe ? ColorsClei.azulCielo : Colors.grey[700],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sender.toUpperCase(),
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            RichText(
              text: TextSpan(
                children: buildMessageContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
