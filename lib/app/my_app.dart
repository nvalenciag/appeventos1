import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'ui/routes/app_routes.dart';
import 'ui/routes/routes.dart';

import 'package:responsive_framework/responsive_framework.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('es');
    //debugPaintSizeEnabled = true;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget!),
          maxWidth: 1200,
          minWidth: 480,
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(480, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(800, name: TABLET),
            const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ],
          background: Container(color: const Color(0xFFF5F5F5))),
      key: router.appKey,
      title: 'AppEventosUQ',
      navigatorKey: router.navigatorKey,
      navigatorObservers: [
        router.observer,
      ],
      routes: appRoutes,
      initialRoute: Routes.INIT,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
