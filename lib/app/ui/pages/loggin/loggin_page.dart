import 'package:appeventos/app/dependecy_inyector/inyector.dart';
import 'package:appeventos/app/domain/utils/resource.dart';
import 'package:appeventos/app/ui/pages/loggin/widgets/loggin_button.dart';
import 'package:appeventos/app/ui/utils/colors_clei.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/meedu.dart';

class LogginPage extends StatefulWidget {
  const LogginPage({Key? key}) : super(key: key);

  @override
  State<LogginPage> createState() => _LogginPageState();
}

class _LogginPageState extends State<LogginPage> {
  bool _isAvailable = true;
  _LogginPageState();

  bool _isChecked = false;
  bool _termsAccepted = false;

  void _toggleCheckbox(bool? value) {
    setState(() {
      _isChecked = value!;
      _termsAccepted = value;
    });
  }

  @override
  void initState() {
    Inyector _inyector = Get.find<Inyector>();

    _inyector.userAuth!.checkUserAvailable().then((available) async {

      if (available) {
        print(await _inyector.userAuth!.toString());
        print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
        _isAvailable = true;
        await _inyector.userAuth!.validateAuthenticationToken();
        await _inyector.loginProvider(LoginType.values.byName(capitalize(
            _inyector.firebaseAuth.currentUser!.providerData[0].providerId
                .replaceAll('.com', ''))));
      } else if (!available) {
        _isAvailable = false;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isAvailable) {
      return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: _imagenFondo()),
              const CircularProgressIndicator()
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 80.0, 40.0, 15.0),
          child: _login(),
        ),
      );
    }
  }

  Widget _login() {
    return Column(
      children: [
        Container(
          child: _imagenFondo(),
          margin: EdgeInsets.only(top: 40),
        ),
        Container(
          margin: EdgeInsets.only(top: 120),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 600,
                  // height: double.infinity,
                  child: LogginButton(
                    iconPath: 'assets/google.png',
                    text: 'Iniciar con Google',
                    loginType: LoginType.Google,
                    colorFont: ColorsClei.negro,
                    colorBackground: Colors.white,
                    isDisabled: !_isChecked,
                  ),
                ),
                Container(
                  height: 15.0,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: _toggleCheckbox,
                    ),
                    Text(
                      'Aceptar ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: _showTermsModal,
                      child: Text(
                        'Términos y Condiciones',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _imagenFondo() {
    return const FittedBox(
      alignment: Alignment.topCenter,
      fit: BoxFit.contain, // otherwise the logo will be tiny
      child: Center(
        child: Image(
          height: 350.0,
          width: 350.0,
          image: AssetImage('assets/logo_login.jpg'),
        ),
      ),
    );
  }

  void _showTermsModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Términos y Condiciones'),
          content: SingleChildScrollView(
            child: Text(
              // Aquí puedes colocar el texto de los términos y condiciones
              'Términos y Condiciones de Uso de la Aplicación de Perfiles y Chats Última actualización: 19/08/2023 Bienvenido/a aplicación de eventos Universidad del Quindío. Los siguientes términos y condiciones rigen el uso de la Aplicación y la protección de los datos de perfil y chats. Al acceder y utilizar la Aplicación, aceptas cumplir con estos términos. Si no estás de acuerdo con ellos, por favor no uses la Aplicación.\n' +
                  '1. Uso de la Aplicación \n1.1. La Aplicación te permite gestionar tu perfil, así como comunicarte con otros usuarios a través de chats. \n1.2. Eres responsable de la información que proporcionas en tu perfil y los mensajes que envías a través de los chats. Asegúrate de que tu contenido cumple con las normas de conducta y no infringe los derechos de terceros. \n2. Privacidad y Datos Personales \n2.1. Al utilizar la Aplicación, aceptas nuestra Política de Privacidad, que detalla cómo recopilamos, utilizamos y protegemos tus datos personales y la información de perfil. \n2.2. Entiendes y aceptas que los mensajes enviados a través de los chats pueden ser almacenados en nuestros servidores para su entrega y visualización por parte de los usuarios autorizados. \n3. Derechos de Propiedad \n3.1. La Aplicación y todo su contenido, incluidos diseños, textos, gráficos, imágenes, videos, logotipos y marcas registradas, son propiedad de Universidad del Quindío o de sus licenciantes, y están protegidos por las leyes de propiedad intelectual. \n3.2. No tienes derecho a utilizar, copiar, reproducir, modificar, distribuir o crear trabajos derivados basados en el contenido de la Aplicación sin el consentimiento previo por escrito de la Universidad del Quindio \n4. Restricciones de Uso \n4.1. No utilizarás la Aplicación para fines ilegales, fraudulentos, difamatorios, obscenos o que violen los derechos de terceros. \n4.2. No intentarás acceder a áreas restringidas de la Aplicación sin autorización, ni realizarás ingeniería inversa, descompilación ni intentarás eludir las medidas de seguridad. \n5. Limitación de Responsabilidad \n5.1. La Aplicación se proporciona "tal cual", y Universidad del Quindío no garantiza su disponibilidad, precisión o idoneidad para un propósito específico. \n5.2. Universidad del Quindío no será responsable de ningún daño directo, indirecto, incidental, consecuente o punitivo derivado del uso de la Aplicación. \n6. Modificaciones a los Términos \n6.1. Universidad del Quindío se reserva el derecho de modificar estos términos en cualquier momento. Las modificaciones entrarán en vigencia al ser publicadas en la Aplicación. \n7. Terminación \n7.1. Universidad del Quindío puede, a su discreción, suspender o cancelar tu acceso a la Aplicación si considera que has violado estos términos o has actuado de manera perjudicial para otros usuarios. Al utilizar la Aplicación, confirmas que has leído, comprendido y aceptado estos Términos y Condiciones. Si no estás de acuerdo con ellos, te pedimos que no utilices la Aplicación. Gracias por elegir aplicación de eventos Universidad del Quindío. Universidad del Quindío 19/08/2023 \n \nPolítica de Privacidad de la Aplicación de eventos de la Universidad del Quindío Última actualización: 19/08/2023 Gracias por utilizar aplicación de Eventos Universidad del Quindío. En esta Política de Privacidad, te explicamos cómo recopilamos, utilizamos y protegemos tu información personal, especialmente los datos de tu correo Gmail y los mensajes de chat en nuestra aplicación. Al utilizar nuestra aplicación, aceptas los términos de esta Política de Privacidad. \n1. Recopilación de Datos \n1.1. Datos de Correo Gmail: Para brindarte la mejor experiencia posible, solicitamos acceso a tu cuenta de correo Gmail. Esto nos permite acceder a tu dirección de correo electrónico y los datos necesarios para proporcionarte funciones de la aplicación, como la autenticación de usuarios. \n1.2. Mensajes de Chats: Al utilizar la función de chat en nuestra aplicación, recopilamos y almacenamos los mensajes que envías y recibes. Estos mensajes se almacenan en nuestros servidores para que puedas acceder a ellos y comunicarte con otros usuarios. \n2. Uso de Datos \n2.1. Utilizamos tus datos de correo Gmail para: •	Autenticarte en la aplicación. •	Enviar notificaciones relacionadas con tu cuenta y actividad en la aplicación. \n2.2. Utilizamos los mensajes de chat para: •	Entregar y mostrar los mensajes a los destinatarios correspondientes. •	Facilitar la comunicación entre usuarios dentro de la aplicación. \n3. Compartir de Datos \n3.1. Los mensajes de chat se comparten únicamente con los usuarios con los que interactúas en la aplicación. \n4. Seguridad de Datos \n4.1. Tomamos medidas razonables para proteger tus datos personales. Sin embargo, debes ser consciente de que ninguna transmisión de datos por internet es completamente segura. \n5. Acceso y Control de Datos \n5.1. Puedes eliminar tus mensajes de chat en cualquier momento, lo que eliminará esos mensajes de nuestros servidores. \n6. Cambios en la Política de Privacidad \n6.1. Nos reservamos el derecho de modificar esta Política de Privacidad en cualquier momento. Te notificaremos sobre cambios significativos.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }
}
