import 'package:appeventos/app/dependecy_inyector/inyector.dart';
import 'package:appeventos/app/domain/utils/resource.dart';
import 'package:appeventos/app/ui/pages/loggin/widgets/loggin_button_controller/loggin_button_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/meedu.dart';
import 'package:flutter_meedu/ui.dart';

class LogginButton extends StatelessWidget {
  bool isLoadSocial = false;
  final String iconPath;
  final String text;
  final Color colorFont;
  final Color colorBackground;
  final LoginType loginType;
  final bool isDisabled;

  LogginButton({
    Key? key,
    required this.iconPath,
    required this.text,
    required this.colorFont,
    required this.colorBackground,
    required this.loginType,
    required this.isDisabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return button(
        iconPath: iconPath,
        text: text,
        style: styleButton(colorFont, colorBackground),
        loginType: loginType);
  }

  Widget button(
      {required String iconPath,
      required String text,
      required ButtonStyle style,
      required LoginType loginType}) {
    return ElevatedButton(
      style: style,
      onPressed: isDisabled
          ? null
          : () async {
              Inyector inyector = Get.find<Inyector>();
              logginButtonProvider.read.processLoad();
              isLoadSocial = true;
              await inyector.loginProvider(loginType);
              logginButtonProvider.read.processLoad();
              isLoadSocial = false;
            },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Consumer(
            builder: (context, ref, child) {
              final controller = ref.watch(logginButtonProvider);
              bool isLoading = controller.isLoading;
              if (isLoading != true || isLoadSocial != true) {
                return Image(
                  height: 50.0,
                  width: 50.0,
                  image: AssetImage(iconPath),
                );
              }
              return const SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                    strokeWidth: 6, color: Color.fromARGB(255, 125, 240, 196)),
              );
            },
          ),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyle styleButton(Color colorFont, Color colorBackground) {
    return ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        textStyle: const TextStyle(fontSize: 30, fontFamily: 'ModernSans'),
        onPrimary: colorFont,
        primary: colorBackground);
  }
}
