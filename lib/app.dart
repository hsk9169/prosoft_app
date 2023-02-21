import 'package:flutter/material.dart';
import 'package:prosoft_proj/consts/colors.dart';
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
        fontFamily: "SUIT",
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
      ),
      routes: {
        Routes.SPLASH: (context) => SplashView(),
        Routes.SIGNIN: (context) => SigninView(),
        Routes.SERVICE: (context) => ServiceView(),
        Routes.MAIN: (context) => MainView(),
        Routes.BARCODE_ISSUE: (context) => BarcodeIssueView(),
        Routes.WAITING_ORDER: (context) => WaitingOrderView(),
      },
      initialRoute: Routes.SPLASH,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
