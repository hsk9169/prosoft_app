import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:prosoft_proj/services/api_service.dart';
import 'package:prosoft_proj/services/encrypted_storage_service.dart';
import 'package:prosoft_proj/providers/platform_provider.dart';
import 'package:prosoft_proj/providers/session_provider.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/consts/sizes.dart';
import 'package:prosoft_proj/routes.dart';
import 'package:prosoft_proj/screens/screens.dart';

class SigninView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SigninView();
}

class _SigninView extends State<SigninView> {
  // Service
  final _apiService = ApiService();
  final _encryptedStorageService = EncryptedStorageService();

  // Controller
  late TextEditingController _idController;
  late TextEditingController _pwdController;

  // States
  bool _isLoading = false;
  String _id = '010-3847-7447';
  String _pwd = '1234';
  bool _isAutoChecked = false;

  @override
  void initState() {
    super.initState();
    _encryptedStorageService.initStorage();
    _idController = TextEditingController();
    _pwdController = TextEditingController();
    _idController.addListener(_onIdChanged);
    _pwdController.addListener(_onPwdChanged);
    _initData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {});
  }

  void _initData() {
    _idController.text = _id;
    _pwdController.text = _pwd;
    setState(() {
      //_id = Provider.of<Platform>(context, listen: false).phoneNumber;
      //_pwd = Provider.of<Platform>(context, listen: false).password;
      _isAutoChecked =
          Provider.of<Platform>(context, listen: false).isAutoLoginChecked;
    });
  }

  void _onIdChanged() {
    setState(() => _id = _idController.text);
  }

  void _onPwdChanged() {
    setState(() => _pwd = _pwdController.text);
  }

  void _onTapPwdReset() {
    print('reset');
  }

  void _onTapAccountEdit() {
    print('edit');
  }

  void _onTapSignin() async {
    final platformProvider = Provider.of<Platform>(context, listen: false);
    final sessionProvider = Provider.of<Session>(context, listen: false);
    String platform =
        Theme.of(context).platform == TargetPlatform.iOS ? 'IOS' : 'ANDROID';
    await _apiService.login(_id, _pwd, 'test', platform).then((value) async {
      if (value is String) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('에러 발생 : 로그인 실패'),
            backgroundColor: Colors.black87.withOpacity(0.6),
            duration: const Duration(seconds: 2)));
      } else {
        sessionProvider.userInfo = value;
        platformProvider.isAutoLoginChecked = _isAutoChecked;
        platformProvider.phoneNumber = _id;
        platformProvider.phoneNumber = _pwd;
        await _encryptedStorageService.saveData(
            'auto_login', _isAutoChecked ? 'true' : 'false');
        await _encryptedStorageService.saveData('phone_number', _id);
        await _encryptedStorageService.saveData('password', _pwd).whenComplete(
            () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ServiceView(screenNumber: 0)),
                  (Route<dynamic> route) => false,
                )
            //Navigator.pushNamedAndRemoveUntil(
            //    context, Routes.MAIN, (Route<dynamic> route) => false));
            );
      }
    });
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(children: [
          Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body: SafeArea(
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: context.pWidth * 0.04,
                          right: context.pWidth * 0.04),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('원부자재 입/출고 사용자 APP',
                                style: TextStyle(
                                    color: AppColors.bold,
                                    fontSize: context.pHeight * 0.03,
                                    fontWeight: FontWeight.bold)),
                            Padding(
                              padding: EdgeInsets.only(
                                top: context.pHeight * 0.05,
                                bottom: context.pHeight * 0.05,
                              ),
                            ),
                            _renderSigninBox(),
                            Container(
                                width: context.pWidth,
                                padding: EdgeInsets.all(context.pWidth * 0.02),
                                child: Row(children: [
                                  Text('자동 로그인',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: context.pWidth * 0.03,
                                          fontWeight: FontWeight.normal)),
                                  SizedBox(
                                      width: context.pWidth * 0.07,
                                      height: context.pWidth * 0.06,
                                      child: Checkbox(
                                        checkColor: Colors.white,
                                        value: _isAutoChecked,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _isAutoChecked = value!;
                                          });
                                        },
                                      )),
                                  Padding(
                                      padding: EdgeInsets.all(
                                          context.pWidth * 0.01)),
                                  GestureDetector(
                                      onTap: () => _onTapPwdReset(),
                                      child: Text('비밀번호 재설정',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: context.pWidth * 0.03,
                                              fontWeight: FontWeight.normal)))
                                ])),
                            Padding(
                              padding: EdgeInsets.all(context.pHeight * 0.015),
                            ),
                            GestureDetector(
                                onTap: () => _onTapAccountEdit(),
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black,
                                                width:
                                                    context.pWidth * 0.003))),
                                    child: Text('사용자 계정 생성/수정',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: context.pWidth * 0.04,
                                            fontWeight: FontWeight.bold)))),
                            Padding(
                              padding: EdgeInsets.all(context.pHeight * 0.02),
                            ),
                            _renderSigninButton()
                          ])))),
          _isLoading
              ? Container(
                  width: context.pWidth,
                  height: context.pHeight,
                  color: Colors.grey.withOpacity(0.4),
                  child: CupertinoActivityIndicator(
                      radius: context.pHeight * 0.02))
              : SizedBox()
        ]));
  }

  Widget _renderSigninBox() {
    return Container(
        width: context.pWidth,
        padding: EdgeInsets.only(
          top: context.pHeight * 0.05,
          bottom: context.pHeight * 0.05,
          left: context.pWidth * 0.04,
          right: context.pWidth * 0.04,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border.all(color: AppColors.bold, width: context.pWidth * 0.01),
            borderRadius: BorderRadius.circular(context.pWidth * 0.05)),
        child: Column(children: [
          Row(children: [
            Expanded(
                child: Text('ID(Phone No.)',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: context.pWidth * 0.055,
                        fontWeight: FontWeight.bold))),
            Expanded(
                child: TextField(
              controller: _idController,
              onChanged: (value) => setState(() => _id = value),
              obscureText: false,
              textAlignVertical: TextAlignVertical.center,
              autofocus: false,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: context.pWidth * 0.04,
                  fontWeight: context.normalWeight),
              keyboardType: TextInputType.text,
            ))
          ]),
          Row(children: [
            Expanded(
                child: Text('비 밀 번 호',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: context.pWidth * 0.055,
                        fontWeight: FontWeight.bold))),
            Expanded(
                child: TextField(
              controller: _pwdController,
              onChanged: (value) => setState(() => _pwd = value),
              obscureText: true,
              textAlignVertical: TextAlignVertical.center,
              autofocus: false,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: context.pWidth * 0.04,
                  fontWeight: context.normalWeight),
              keyboardType: TextInputType.text,
            ))
          ])
        ]));
  }

  Widget _renderSigninButton() {
    return ElevatedButton(
        onPressed: () {
          if (_idController.text.isNotEmpty && _pwdController.text.isNotEmpty) {
            _onTapSignin();
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.pWidth * 0.02)),
        ),
        child: Ink(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.pWidth * 0.02),
                gradient: LinearGradient(
                    colors: [AppColors.light, AppColors.bold],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Container(
              color: Colors.transparent,
              width: context.pWidth * 0.5,
              height: context.pHeight * 0.07,
              alignment: Alignment.center,
              child: Text(
                '로그인',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: context.pWidth * 0.04,
                    fontWeight: FontWeight.bold),
              ),
            )));
  }
}
