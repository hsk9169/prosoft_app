import 'package:flutter/material.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/models/models.dart';
import 'package:prosoft_proj/routes.dart';
import 'package:prosoft_proj/screens/screens.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: AppColors.mainMaterialColor,
        scaffoldBackgroundColor: Colors.white,
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
      ),
      routes: {
        Routes.SPLASH: (context) => SplashView(),
        Routes.SIGNIN: (context) => SigninView(),
        Routes.SERVICE: (context) => const ServiceView(),
        Routes.MAIN: (context) => const MainView(),
        Routes.WAITING_ORDER: (context) =>
            WaitingOrderView(content: MainContent()),
      },
      initialRoute: Routes.SPLASH,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
