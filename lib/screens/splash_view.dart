import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prosoft_proj/services/api_service.dart';
import 'package:prosoft_proj/services/encrypted_storage_service.dart';
import 'package:prosoft_proj/providers/platform_provider.dart';
import 'package:prosoft_proj/providers/session_provider.dart';
import 'package:prosoft_proj/consts/sizes.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/routes.dart';
import 'package:prosoft_proj/screens/screens.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../firebase_options.dart';

class SplashView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashView();
}

class _SplashView extends State<SplashView> {
  // Service, Util classes
  final _apiService = ApiService();

  // Providers
  late dynamic _sessionProvider;
  late dynamic _platformProvider;

  @override
  void initState() {
    super.initState();
    _initData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _sessionProvider = Provider.of<Session>(context, listen: false);
      _platformProvider = Provider.of<Platform>(context, listen: false);
    });
  }

  void _initData() async {
    await _initializeDeviceStorage();
    await Future.delayed(const Duration(seconds: 2), () async {
      await _tryAutoLogin().then((value) {
        if (value) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ServiceView()),
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.SIGNIN, (Route<dynamic> route) => false,
              arguments: 0);
        }
      });
    });
  }

  Future<void> _initializeDeviceStorage() async {
    await EncryptedStorageService().initStorage();
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('first_run') ?? true) {
      await EncryptedStorageService().deleteAllData();
      prefs.setBool('first_run', false);
    }

    await EncryptedStorageService().readData('auto_login').then((value) {
      if (value == 'true') {
        _platformProvider.isAutoLoginChecked = true;
      } else {
        _platformProvider.isAutoLoginChecked = false;
      }
    });
  }

  Future<bool> _tryAutoLogin() async {
    _platformProvider.platformType =
        Theme.of(context).platform == TargetPlatform.iOS ? 'IOS' : 'ANDROID';

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.getToken().then((value) {
      _platformProvider.fcmToken = value;
    });
    if (_platformProvider.isAutoLoginChecked) {
      _platformProvider.phoneNumber =
          await EncryptedStorageService().readData('phone_number');
      _platformProvider.password =
          await EncryptedStorageService().readData('password');
      final res = await _apiService.login(
          _platformProvider.phoneNumber,
          _platformProvider.password,
          _platformProvider.fcmToken,
          _platformProvider.platformType);
      if (res.runtimeType == String) {
        return false;
      } else {
        _sessionProvider.userInfo = res;
        return true;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: AppColors.darkOrange,
          width: context.pWidth,
          height: context.pHeight,
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/logo_simple.svg',
                    color: Colors.white, width: context.pWidth * 0.6),
                Padding(padding: EdgeInsets.all(context.pHeight * 0.02)),
                SizedBox(
                    width: context.pWidth * 0.3,
                    height: context.pHeight * 0.02,
                    child: const LoadingIndicator(
                      indicatorType: Indicator.ballPulse,
                      colors: [Colors.white],
                      strokeWidth: 1,
                    ))
              ])),
    );
  }
}
