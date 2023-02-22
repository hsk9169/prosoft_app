import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:prosoft_proj/services/api_service.dart';
import 'package:prosoft_proj/services/encrypted_storage_service.dart';
import 'package:prosoft_proj/providers/platform_provider.dart';
import 'package:prosoft_proj/providers/session_provider.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/consts/sizes.dart';
import 'package:prosoft_proj/screens/screens.dart';
import 'package:prosoft_proj/widgets/elevated_popup.dart';
import 'package:prosoft_proj/widgets/popup_button.dart';

class SigninView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SigninView();
}

class _SigninView extends State<SigninView> {
  // Service
  final _apiService = ApiService();

  // Controller
  late TextEditingController _idController;
  late TextEditingController _pwdController;

  // States
  bool _isLoading = false;
  String _id = '010-1111-2222';
  String _pwd = '1234';
  bool _isAutoChecked = false;
  String _idSearchId = '';
  String _nameSearchId = '';
  String _pwdChangePwd = '';
  String _pwdCheckChangePwd = '';
  String _idAddAccount = '';
  String _nameAddAccount = '';
  String _pwdAddAccount = '';

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: _id);
    _pwdController = TextEditingController(text: _pwd);
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
    print(_pwd);
  }

  void _onTapClosePopup() {
    setState(() {
      _idSearchId = '';
      _nameSearchId = '';
      _pwdChangePwd = '';
      _pwdCheckChangePwd = '';
      _idAddAccount = '';
      _nameAddAccount = '';
      _pwdAddAccount = '';
    });
    Navigator.pop(context);
  }

  void _onTapPwdReset() {
    showDialog(
        context: context,
        barrierColor: AppColors.darkGrey.withOpacity(0.3),
        builder: (BuildContext context) {
          return ElevatedPopup(
              height: context.pHeight * 0.55,
              onTapClose: _onTapClosePopup,
              children: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: context.pHeight * 0.1,
                        alignment: Alignment.topLeft,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset('assets/icons/key.svg',
                                  color: Colors.black,
                                  width: context.pWidth * 0.1),
                              Padding(
                                  padding:
                                      EdgeInsets.all(context.pWidth * 0.02)),
                              Text('비밀번호 재설정',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SUIT',
                                      fontSize: context.pWidth * 0.07,
                                      fontWeight: FontWeight.w700))
                            ])),
                    SizedBox(
                      height: context.pHeight * 0.31,
                      width: context.pWidth * 0.8,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID(Phone No.)',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SUIT',
                                    fontSize: context.pWidth * 0.05,
                                    fontWeight: FontWeight.w700)),
                            Padding(
                                padding:
                                    EdgeInsets.all(context.pHeight * 0.005)),
                            TextField(
                              onChanged: (value) =>
                                  setState(() => _idSearchId = value),
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SUIT',
                                  fontSize: context.pWidth * 0.055,
                                  fontWeight: FontWeight.w700),
                              decoration: InputDecoration(
                                hintText: '휴대폰 번호를 입력하세요.',
                                hintStyle: TextStyle(
                                    color: AppColors.lightGrey,
                                    fontFamily: 'SUIT',
                                    fontSize: context.pWidth * 0.055,
                                    fontWeight: FontWeight.w700),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.darkOrange),
                                ),
                              ),
                              cursorColor: AppColors.darkOrange,
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.all(context.pHeight * 0.03)),
                            Text('Name',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SUIT',
                                    fontSize: context.pWidth * 0.05,
                                    fontWeight: FontWeight.w700)),
                            Padding(
                                padding:
                                    EdgeInsets.all(context.pHeight * 0.005)),
                            TextField(
                              onChanged: (value) =>
                                  setState(() => _nameSearchId = value),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SUIT',
                                  fontSize: context.pWidth * 0.055,
                                  fontWeight: FontWeight.w700),
                              decoration: InputDecoration(
                                hintText: '성명을 입력하세요.',
                                hintStyle: TextStyle(
                                    color: AppColors.lightGrey,
                                    fontFamily: 'SUIT',
                                    fontSize: context.pWidth * 0.055,
                                    fontWeight: FontWeight.w700),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.darkOrange),
                                ),
                              ),
                              cursorColor: AppColors.darkOrange,
                            ),
                          ]),
                    ),
                    Padding(padding: EdgeInsets.all(context.pHeight * 0.005)),
                    Align(
                        alignment: Alignment.center,
                        child: PopupButton(
                            buttonText: 'ID(Phone No.)찾기', onTap: _onTapFindId))
                  ]));
        });
  }

  void _onTapFindId() async {
    setState(() => _isLoading = true);
    await _apiService.getUserInfo(_idSearchId, _nameSearchId).then((res) {
      setState(() => _isLoading = false);
      if (res == 'SUCCESS') {
        setState(() {
          _nameSearchId = '';
        });
        Navigator.pop(context);
        showDialog(
            context: context,
            barrierColor: AppColors.darkGrey.withOpacity(0.3),
            barrierDismissible: true,
            builder: (BuildContext context) {
              return ElevatedPopup(
                  height: context.pHeight * 0.55,
                  onTapClose: _onTapClosePopup,
                  children: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: context.pHeight * 0.1,
                            alignment: Alignment.topLeft,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset('assets/icons/key.svg',
                                      color: Colors.black,
                                      width: context.pWidth * 0.1),
                                  Padding(
                                      padding: EdgeInsets.all(
                                          context.pWidth * 0.02)),
                                  Text('비밀번호 재설정',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'SUIT',
                                          fontSize: context.pWidth * 0.07,
                                          fontWeight: FontWeight.w700))
                                ])),
                        SizedBox(
                          height: context.pHeight * 0.31,
                          width: context.pWidth * 0.8,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('비밀번호 입력',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'SUIT',
                                        fontSize: context.pWidth * 0.05,
                                        fontWeight: FontWeight.w700)),
                                Padding(
                                    padding: EdgeInsets.all(
                                        context.pHeight * 0.005)),
                                TextField(
                                  onChanged: (value) =>
                                      setState(() => _pwdChangePwd = value),
                                  maxLength: 4,
                                  obscureText: true,
                                  obscuringCharacter: '*',
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SUIT',
                                      fontSize: context.pWidth * 0.055,
                                      fontWeight: FontWeight.w700),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    hintText: '숫자 4자리',
                                    hintStyle: TextStyle(
                                        color: AppColors.lightGrey,
                                        fontFamily: 'SUIT',
                                        fontSize: context.pWidth * 0.055,
                                        fontWeight: FontWeight.w700),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.darkOrange),
                                    ),
                                  ),
                                  cursorColor: AppColors.darkOrange,
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.all(context.pHeight * 0.03)),
                                Text('비밀번호 재입력',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'SUIT',
                                        fontSize: context.pWidth * 0.05,
                                        fontWeight: FontWeight.w700)),
                                Padding(
                                    padding: EdgeInsets.all(
                                        context.pHeight * 0.005)),
                                TextField(
                                  onChanged: (value) => setState(
                                      () => _pwdCheckChangePwd = value),
                                  maxLength: 4,
                                  obscureText: true,
                                  obscuringCharacter: '*',
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SUIT',
                                      fontSize: context.pWidth * 0.055,
                                      fontWeight: FontWeight.w700),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    hintText: '숫자 4자리',
                                    hintStyle: TextStyle(
                                        color: AppColors.lightGrey,
                                        fontFamily: 'SUIT',
                                        fontSize: context.pWidth * 0.055,
                                        fontWeight: FontWeight.w700),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.darkOrange),
                                    ),
                                  ),
                                  cursorColor: AppColors.darkOrange,
                                ),
                              ]),
                        ),
                        Padding(
                            padding: EdgeInsets.all(context.pHeight * 0.005)),
                        Align(
                            alignment: Alignment.center,
                            child: PopupButton(
                                buttonText: '비밀번호 변경', onTap: _onTapChangePwd))
                      ]));
            });
      } else if (res == 'FAILED') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('ID 찾기 실패'),
            backgroundColor: Colors.black87.withOpacity(0.6),
            duration: const Duration(seconds: 2)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('오류 발생'),
            backgroundColor: Colors.black87.withOpacity(0.6),
            duration: const Duration(seconds: 2)));
      }
    });
  }

  void _onTapChangePwd() async {
    setState(() => _isLoading = true);
    await _apiService.updatePwd(_idSearchId, _pwdCheckChangePwd).then((res) {
      setState(() => _isLoading = false);
      if (res == 'SUCCESS') {
        setState(() {
          _idSearchId = '';
          _nameSearchId = '';
          _pwdChangePwd = '';
          _pwdCheckChangePwd = '';
        });
        Navigator.pop(context);
      } else if (res == 'FAILED') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('비밀번호 변경 실패'),
            backgroundColor: Colors.black87.withOpacity(0.6),
            duration: const Duration(seconds: 2)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('오류 발생'),
            backgroundColor: Colors.black87.withOpacity(0.6),
            duration: const Duration(seconds: 2)));
      }
    });
  }

  void _onTapAccountEdit() {
    showDialog(
        context: context,
        barrierColor: AppColors.darkGrey.withOpacity(0.3),
        barrierDismissible: true,
        builder: (BuildContext context) {
          return ElevatedPopup(
              height: context.pHeight * 0.55,
              onTapClose: _onTapClosePopup,
              children: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: context.pHeight * 0.08,
                        alignment: Alignment.topLeft,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset('assets/icons/addaccount.svg',
                                  color: Colors.black,
                                  width: context.pWidth * 0.08),
                              Padding(
                                  padding:
                                      EdgeInsets.all(context.pWidth * 0.02)),
                              Text('사용자 계정 생성',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SUIT',
                                      fontSize: context.pWidth * 0.07,
                                      fontWeight: FontWeight.w700))
                            ])),
                    SizedBox(
                      height: context.pHeight * 0.33,
                      width: context.pWidth * 0.8,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID(Phone No.)',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SUIT',
                                    fontSize: context.pWidth * 0.05,
                                    fontWeight: FontWeight.w700)),
                            Padding(
                                padding:
                                    EdgeInsets.all(context.pHeight * 0.002)),
                            TextField(
                              onChanged: (value) =>
                                  setState(() => _idAddAccount = value),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SUIT',
                                  fontSize: context.pWidth * 0.055,
                                  fontWeight: FontWeight.w700),
                              decoration: InputDecoration(
                                hintText: '휴대폰 번호를 입력하세요.',
                                hintStyle: TextStyle(
                                    color: AppColors.lightGrey,
                                    fontFamily: 'SUIT',
                                    fontSize: context.pWidth * 0.055,
                                    fontWeight: FontWeight.w700),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.darkOrange),
                                ),
                              ),
                              cursorColor: AppColors.darkOrange,
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.all(context.pHeight * 0.01)),
                            Text('Name',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SUIT',
                                    fontSize: context.pWidth * 0.05,
                                    fontWeight: FontWeight.w700)),
                            Padding(
                                padding:
                                    EdgeInsets.all(context.pHeight * 0.002)),
                            TextField(
                              onChanged: (value) =>
                                  setState(() => _nameAddAccount = value),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SUIT',
                                  fontSize: context.pWidth * 0.055,
                                  fontWeight: FontWeight.w700),
                              decoration: InputDecoration(
                                hintText: '성명을 입력하세요.',
                                hintStyle: TextStyle(
                                    color: AppColors.lightGrey,
                                    fontFamily: 'SUIT',
                                    fontSize: context.pWidth * 0.055,
                                    fontWeight: FontWeight.w700),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.darkOrange),
                                ),
                              ),
                              cursorColor: AppColors.darkOrange,
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.all(context.pHeight * 0.01)),
                            Text('Password',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SUIT',
                                    fontSize: context.pWidth * 0.05,
                                    fontWeight: FontWeight.w700)),
                            Padding(
                                padding:
                                    EdgeInsets.all(context.pHeight * 0.002)),
                            TextField(
                              onChanged: (value) =>
                                  setState(() => _pwdAddAccount = value),
                              maxLength: 4,
                              obscureText: true,
                              obscuringCharacter: '*',
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: '숫자 4자리',
                                hintStyle: TextStyle(
                                    color: AppColors.lightGrey,
                                    fontFamily: 'SUIT',
                                    fontSize: context.pWidth * 0.055,
                                    fontWeight: FontWeight.w700),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.darkOrange),
                                ),
                              ),
                              cursorColor: AppColors.darkOrange,
                            ),
                          ]),
                    ),
                    Padding(padding: EdgeInsets.all(context.pHeight * 0.005)),
                    Align(
                        alignment: Alignment.center,
                        child: PopupButton(
                            buttonText: '사용자 계정 생성', onTap: _onTapAddAccount))
                  ]));
        });
  }

  void _onTapAddAccount() async {
    setState(() => _isLoading = true);
    await _apiService
        .updateUserInfo(_idAddAccount, _pwdAddAccount, _nameAddAccount)
        .then((res) {
      setState(() => _isLoading = false);
      if (res == 'SUCCESS') {
        setState(() {
          _idAddAccount = '';
          _nameAddAccount = '';
          _pwdAddAccount = '';
        });
        Navigator.pop(context);
      } else if (res == 'FAILED') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('계정 생성 실패'),
            backgroundColor: Colors.black87.withOpacity(0.6),
            duration: const Duration(seconds: 2)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('오류 발생'),
            backgroundColor: Colors.black87.withOpacity(0.6),
            duration: const Duration(seconds: 2)));
      }
    });
  }

  void _onTapSignin() async {
    final platformProvider = Provider.of<Platform>(context, listen: false);
    final sessionProvider = Provider.of<Session>(context, listen: false);
    platformProvider.platformType =
        Theme.of(context).platform == TargetPlatform.iOS ? 'IOS' : 'ANDROID';
    await FirebaseMessaging.instance.getToken().then((value) {
      platformProvider.fcmToken = value!;
      print(value.toString());
    });
    setState(() => _isLoading = true);
    await _apiService
        .login(
            _id, _pwd, platformProvider.fcmToken, platformProvider.platformType)
        .then((value) async {
      setState(() => _isLoading = false);
      if (value is String) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('로그인 실패'),
            backgroundColor: Colors.black87.withOpacity(0.6),
            duration: const Duration(seconds: 2)));
      } else {
        sessionProvider.userInfo = value;
        platformProvider.isAutoLoginChecked = _isAutoChecked;
        platformProvider.phoneNumber = _id;
        platformProvider.phoneNumber = _pwd;
        await EncryptedStorageService()
            .saveData('auto_login', _isAutoChecked ? 'true' : 'false');
        await EncryptedStorageService().saveData('phone_number', _id);
        await EncryptedStorageService()
            .saveData('password', _pwd)
            .whenComplete(() => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => ServiceView()),
                  (Route<dynamic> route) => false,
                ));
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
                  child: Container(
                      width: context.pWidth,
                      padding: EdgeInsets.only(
                          left: context.pWidth * 0.04,
                          right: context.pWidth * 0.04),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _renderTitle(),
                            Padding(
                              padding: EdgeInsets.all(
                                context.pHeight * 0.06,
                              ),
                            ),
                            _renderSigninBox(),
                            Padding(
                              padding: EdgeInsets.all(context.pHeight * 0.015),
                            ),
                            _renderOptions(),
                            Padding(
                              padding: EdgeInsets.all(context.pHeight * 0.03),
                            ),
                            _renderSigninButton(),
                            Padding(
                              padding: EdgeInsets.all(context.pHeight * 0.03),
                            ),
                            SvgPicture.asset('assets/icons/logo.svg',
                                width: context.pWidth * 0.4)
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

  Widget _renderTitle() {
    return SizedBox(
        width: context.pWidth * 0.85,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('모바일 시스템',
              style: TextStyle(
                  color: AppColors.darkOrange,
                  fontFamily: 'SUIT',
                  fontSize: context.pHeight * 0.03,
                  fontWeight: FontWeight.w700)),
          Padding(
            padding: EdgeInsets.all(
              context.pHeight * 0.001,
            ),
          ),
          Text('사용자 전용',
              style: TextStyle(
                  color: AppColors.darkGrey,
                  fontFamily: 'SUIT',
                  fontSize: context.pHeight * 0.04,
                  fontWeight: FontWeight.w800)),
        ]));
  }

  Widget _renderSigninBox() {
    return SizedBox(
        width: context.pWidth * 0.8,
        height: context.pHeight * 0.18,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Expanded(
                    flex: 1,
                    child: Container(
                        padding: EdgeInsets.only(
                          top: context.pWidth * 0.032,
                          bottom: context.pWidth * 0.032,
                          left: context.pWidth * 0.04,
                          right: context.pWidth * 0.04,
                        ),
                        alignment: Alignment.center,
                        color: AppColors.darkOrange,
                        child: Text('ID',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'SUIT',
                                fontSize: context.pWidth * 0.055,
                                fontWeight: context.maxWeight)))),
                Expanded(
                    flex: 3,
                    child: Container(
                        padding: EdgeInsets.only(
                          left: context.pWidth * 0.04,
                          right: context.pWidth * 0.04,
                        ),
                        color: const Color.fromARGB(255, 237, 243, 247),
                        child: TextField(
                          maxLength: 13,
                          controller: _idController,
                          obscureText: false,
                          textAlignVertical: TextAlignVertical.center,
                          autofocus: false,
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                              border: InputBorder.none, counterText: ''),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: context.pWidth * 0.06,
                              fontWeight: context.thinWeight),
                          keyboardType: TextInputType.text,
                        )))
              ]),
              Padding(
                padding: EdgeInsets.all(context.pHeight * 0.01),
              ),
              Row(children: [
                Expanded(
                    flex: 1,
                    child: Container(
                        padding: EdgeInsets.only(
                          top: context.pWidth * 0.032,
                          bottom: context.pWidth * 0.032,
                          left: context.pWidth * 0.04,
                          right: context.pWidth * 0.04,
                        ),
                        color: AppColors.darkOrange,
                        alignment: Alignment.center,
                        child: Text('PW',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'SUIT',
                                fontSize: context.pWidth * 0.055,
                                fontWeight: context.maxWeight)))),
                Expanded(
                    flex: 3,
                    child: Container(
                        padding: EdgeInsets.only(
                          left: context.pWidth * 0.04,
                          right: context.pWidth * 0.04,
                        ),
                        color: const Color.fromARGB(255, 237, 243, 247),
                        child: TextField(
                          controller: _pwdController,
                          maxLength: 4,
                          obscureText: true,
                          obscuringCharacter: '*',
                          textAlignVertical: TextAlignVertical.center,
                          autofocus: false,
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                              border: InputBorder.none, counterText: ''),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: context.pWidth * 0.06,
                              fontWeight: context.thinWeight),
                          keyboardType: TextInputType.number,
                        )))
              ])
            ]));
  }

  Widget _renderOptions() {
    return SizedBox(
        width: context.pWidth * 0.8,
        child: Column(children: [
          Row(children: [
            SizedBox(
                width: context.pWidth * 0.05,
                height: context.pWidth * 0.05,
                child: Checkbox(
                  side: MaterialStateBorderSide.resolveWith((states) =>
                      BorderSide(
                          width: context.pWidth * 0.001,
                          color: AppColors.darkOrange)),
                  activeColor: AppColors.darkOrange,
                  checkColor: Colors.white,
                  value: _isAutoChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isAutoChecked = value!;
                    });
                  },
                )),
            Padding(padding: EdgeInsets.all(context.pWidth * 0.005)),
            Text('자동 로그인',
                style: TextStyle(
                    color: AppColors.darkGrey,
                    fontFamily: 'SUIT',
                    fontSize: context.pWidth * 0.035,
                    fontWeight: context.thinWeight)),
          ]),
          Padding(padding: EdgeInsets.all(context.pHeight * 0.02)),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Icon(Icons.arrow_right_alt,
                  color: AppColors.darkOrange, size: context.pWidth * 0.06),
              Padding(padding: EdgeInsets.all(context.pWidth * 0.005)),
              InkWell(
                  onTap: () => _onTapPwdReset(),
                  child: Text('비밀번호 재설정',
                      style: TextStyle(
                          color: AppColors.darkGrey,
                          fontFamily: 'SUIT',
                          fontSize: context.pWidth * 0.035,
                          fontWeight: context.thinWeight)))
            ]),
            Padding(padding: EdgeInsets.all(context.pHeight * 0.005)),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Icon(Icons.arrow_right_alt,
                  color: AppColors.darkOrange, size: context.pWidth * 0.06),
              Padding(padding: EdgeInsets.all(context.pWidth * 0.005)),
              InkWell(
                  onTap: () => _onTapAccountEdit(),
                  child: Text('사용자 계정 생성 및 수정',
                      style: TextStyle(
                          color: AppColors.darkGrey,
                          fontFamily: 'SUIT',
                          fontSize: context.pWidth * 0.035,
                          fontWeight: context.thinWeight)))
            ])
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
              color: AppColors.darkOrange,
              borderRadius: BorderRadius.circular(context.pWidth * 0.01),
            ),
            child: Container(
              color: Colors.transparent,
              width: context.pWidth * 0.5,
              height: context.pHeight * 0.045,
              alignment: Alignment.center,
              child: Text(
                '로그인',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SUIT',
                    fontSize: context.pWidth * 0.045,
                    fontWeight: context.boldWeight),
              ),
            )));
  }
}
