import 'package:appeventos/app/dependecy_inyector/inyector.dart';
import 'package:appeventos/app/domain/entities/user.dart';
import 'package:appeventos/app/domain/repositories/social_authentication_service.dart';
import 'package:appeventos/app/ui/routes/routes.dart';
import 'package:appeventos/app/ui/utils/colors_clei.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/meedu.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarProfile(),
      body: buildProfileView(),
    );
  }

  AppBar appBarProfile() {
    return AppBar(
      title: const Text(
        'Perfil',
        style:
            TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 30),
      ),
      backgroundColor: ColorsClei.azulOscuro,
      toolbarHeight: 65,
      elevation: 0.0,
    );
  }

  Center buildProfileView() {
    Inyector inyector = Get.find<Inyector>();
    final User user = new User(name: "Camilo", email: "aguileracamilo2929@gmail.com", photo: "https://media.gq.com.mx/photos/609c0fdeee4372271f0b9056/1:1/w_2000,h_2000,c_limit/salir%20guapo%20en%20fotos-605380757.jpg", accountCreationDate: DateTime(1));
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 25),
          createAvatar(user.photo),
          const SizedBox(height: 25),
          createInfoUser(user),
          const SizedBox(
            height: 100,
          ),
          
        ],
      ),
    );
  }

  CircleAvatar createAvatar(String photo) {
    return CircleAvatar(
      backgroundImage: Image.network(photo).image,
      radius: 140,
    );
  }

  Column createInfoUser(User user) {
    return Column(
      children: [
        Text(
          user.name,
          style: const TextStyle(
              color: ColorsClei.negro, fontFamily: 'ModernSans', fontSize: 25),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 25,
        ),
        Text(
          user.email,
          style: const TextStyle(
              color: ColorsClei.negro, fontFamily: 'ModernSans', fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 25,
        ),
        Text(
          "Fecha de creación: ${DateFormat.yMMMd('es').format(user.accountCreationDate)}",
          style: const TextStyle(
              color: ColorsClei.negro, fontFamily: 'ModernSans', fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  ElevatedButton buttonSignOut(SocialAuthenticationService socialAuth) {
    return ElevatedButton.icon(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(ColorsClei.azulOscuro),
          fixedSize: MaterialStateProperty.all(const Size(230, 50))),
      onPressed: () async {
        await socialAuth.signOut();
        router.pushNamedAndRemoveUntil(Routes.LOGGIN_PAGE);
      },
      icon: const Icon(Icons.logout),
      label: const Text(
        'Cerrar sesión',
        style: TextStyle(
            color: Colors.white, fontFamily: 'ModernSans', fontSize: 25),
      ),
    );
  }
}
