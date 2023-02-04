import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prosoft_proj/services/api_service.dart';
import 'package:prosoft_proj/services/encrypted_storage_service.dart';
import 'package:prosoft_proj/providers/platform_provider.dart';
import 'package:prosoft_proj/providers/session_provider.dart';
import 'package:prosoft_proj/consts/sizes.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/routes.dart';
import 'package:prosoft_proj/screens/screens.dart';

class SplashView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashView();
}

class _SplashView extends State<SplashView> {
  // Service, Util classes
  final _apiService = ApiService();
  final _encryptedStorageService = EncryptedStorageService();

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
      if (await _tryAutoLogin()) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const ServiceView(screenNumber: 2)),
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.SIGNIN, (Route<dynamic> route) => false,
            arguments: 0);
      }
    });
  }

  Future<void> _initializeDeviceStorage() async {
    await _encryptedStorageService.initStorage();
    //await _encryptedStorageService.deleteAllData();
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('first_run') ?? true) {
      await _encryptedStorageService.deleteAllData();
      prefs.setBool('first_run', false);
    }

    await _encryptedStorageService.readData('auto_login').then((value) {
      if (value == 'true') {
        _platformProvider.isAutoLoginChecked = true;
      } else {
        _platformProvider.isAutoLoginChecked = false;
      }
    });
  }

  Future<bool> _tryAutoLogin() async {
    if (_platformProvider.isAutoLoginChecked) {
      _platformProvider.phoneNumber =
          await _encryptedStorageService.readData('phone_number');
      _platformProvider.password =
          await _encryptedStorageService.readData('password');
      final res =
          await _apiService.login('010-3847-7447', '1234', 'test', 'IOS');
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
    return Container(
        color: Colors.white,
        width: context.pWidth,
        height: context.pHeight,
        child: Center(
            child: CupertinoActivityIndicator(
          animating: true,
          radius: context.pWidth * 0.05,
        )));
  }
}
