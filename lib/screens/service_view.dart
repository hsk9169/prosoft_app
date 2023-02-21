import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prosoft_proj/screens/screens.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/consts/sizes.dart';
import 'package:prosoft_proj/providers/platform_provider.dart';
import 'package:prosoft_proj/providers/session_provider.dart';
import 'package:prosoft_proj/services/encrypted_storage_service.dart';
import 'package:prosoft_proj/widgets/app_bar_contents.dart';
import 'package:prosoft_proj/routes.dart';
import 'package:prosoft_proj/models/models.dart';
import 'package:prosoft_proj/services/api_service.dart';
import 'package:prosoft_proj/consts/screen_code.dart';

class ServiceView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ServiceView();
}

class _ServiceView extends State<ServiceView> {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final notificationDetails = const NotificationDetails(
    // Android details
    android: AndroidNotificationDetails('main_channel', 'Main Channel',
        channelDescription: "ashwin",
        importance: Importance.max,
        priority: Priority.max),
    // iOS details
    iOS: IOSNotificationDetails(),
  );

  // State
  bool isMessage = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _initMessaging();
    super.initState();
    _initData();
    //_checkLatestMsg();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {});
  }

  void _initData() async {
    final session = Provider.of<Session>(context, listen: false);
    await ApiService()
        .getMainList(session.userInfo.phoneNumber!)
        .then((value) => session.contentList = value);
  }

  void _checkLatestMsg() async {
    final phoneNumber =
        Provider.of<Platform>(context, listen: false).phoneNumber;
    await ApiService().getLatestMsg(phoneNumber).then((data) {
      if (data is String) {
        Provider.of<Platform>(context, listen: false).screenNumber = 0;
      } else {
        Provider.of<Platform>(context, listen: false).screenNumber =
            ScreenCode.dict.containsKey(data.appPgmId!)
                ? ScreenCode.dict[data.appPgmId!]!
                : 0;
      }
    });
  }

  void _onTapLogout() async {
    await EncryptedStorageService().deleteAllData().whenComplete(() =>
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.SIGNIN, (route) => false));
  }

  Widget? _bodyWidget(int screenNumber) {
    switch (screenNumber) {
      case 0:
        return MainView();
      case 1:
        return BarcodeIssueView();
      case 2:
        return WaitingOrderView();
      default:
        break;
    }
  }

  void _onTapItem(int num) async {
    Provider.of<Platform>(context, listen: false).screenNumber = num;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = Provider.of<Platform>(context, listen: true).isLoading;
    bool isMessageRecieved =
        Provider.of<Platform>(context, listen: true).isMessageRecieved;
    bool isErrorMessagePoppedUp =
        Provider.of<Platform>(context, listen: true).isErrorMessagePoppedUp;
    int screenNumber =
        Provider.of<Platform>(context, listen: true).screenNumber;

    final String userName =
        Provider.of<Session>(context, listen: false).userInfo.name!;
    final Color bgColor = screenNumber > 1
        ? Colors.white
        : const Color.fromARGB(255, 232, 231, 231);
    return AbsorbPointer(
        absorbing: isLoading,
        child: Stack(children: [
          Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            backgroundColor: bgColor,
            appBar: PreferredSize(
              preferredSize: Size(context.pWidth, context.pHeight * 0.05),
              child: AppBar(
                  titleSpacing: 0,
                  backgroundColor: bgColor,
                  title: AppBarContents(id: userName),
                  elevation: 0,
                  leading: Padding(
                      padding: EdgeInsets.all(context.pWidth * 0.01),
                      child: IconButton(
                          icon: Icon(Icons.list,
                              color: AppColors.mediumGrey,
                              size: context.pWidth * 0.1),
                          onPressed: () =>
                              _scaffoldKey.currentState!.openDrawer()))),
            ),
            body: _bodyWidget(screenNumber),
            drawer: _sideDrawer(userName),
          ),
          isLoading
              ? Container(
                  width: context.pWidth,
                  height: context.pHeight,
                  color: Colors.grey.withOpacity(0.4),
                  child: CupertinoActivityIndicator(
                      radius: context.pHeight * 0.02))
              : const SizedBox()
        ]));
  }

  Widget _sideDrawer(String id) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 97, 99, 105),
      width: context.pWidth * 0.75,
      child: Column(
        children: [
          DrawerHeader(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(0),
              child: Column(children: [
                ListTile(
                    leading: InkWell(
                        child: Icon(Icons.close_rounded,
                            color: Colors.white, size: context.pHeight * 0.04),
                        onTap: () => Navigator.pop(context))),
                ListTile(
                    leading: Icon(Icons.person,
                        color: Colors.white, size: context.pHeight * 0.04),
                    title: Text('$id 님 환영합니다.',
                        style: TextStyle(
                            fontSize: context.pHeight * 0.025,
                            fontFamily: 'SUIT',
                            fontWeight: context.boldWeight,
                            color: Colors.white)),
                    onTap: null)
              ])),
          Container(
              padding: EdgeInsets.only(left: context.pWidth * 0.04),
              height: context.pHeight * 0.6,
              child: Column(children: [
                ListTile(
                  leading: SvgPicture.asset('assets/icons/barcode.svg',
                      width: context.pWidth * 0.055, color: Colors.white),
                  title: Text('모바일 바코드 조회',
                      style: TextStyle(
                          fontSize: context.pHeight * 0.022,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  onTap: () => _onTapItem(0),
                ),
                Padding(padding: EdgeInsets.all(context.pHeight * 0.01)),
                ListTile(
                  leading: SvgPicture.asset('assets/icons/printer.svg',
                      width: context.pWidth * 0.055, color: Colors.white),
                  title: Text('모바일 바코드 발행',
                      style: TextStyle(
                          fontSize: context.pHeight * 0.022,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  onTap: () => _onTapItem(1),
                ),
              ])),
          ListTile(
              leading: Icon(Icons.logout,
                  color: Colors.white, size: context.pHeight * 0.03),
              title: Text('로그아웃',
                  style: TextStyle(
                      fontSize: context.pHeight * 0.025,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              onTap: () => _onTapLogout()),
        ],
      ),
    );
  }

  void _initMessaging() async {
    final _platformProvider = Provider.of<Platform>(context, listen: false);
    final _sessionProvider = Provider.of<Session>(context, listen: false);

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    //await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //    onSelectNotification: (String? payload) =>
    //        selectNotification(payload));

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (android != null) {
        print(message.notification!);
        showLocalNotification(message, true);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(message.data);
      selectNotification(message.data);
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (android != null) {
      print(message.data);
      showLocalNotification(message, false);
    }
  }

  Future<void> showLocalNotification(
      RemoteMessage message, bool isForeground) async {
    var platform = Theme.of(context).platform;

    _flutterLocalNotificationsPlugin.show(
        0,
        'local ${message.notification!.title}',
        message.notification!.body,
        notificationDetails);

    /*
    switch (alarm_type) {
      case 'maxload':
        Provider.of<Platform>(context, listen: false).popupErrorMessage = '2';
        _showErrorDialog(true);
        if (platform == TargetPlatform.android && isForeground) {
          Provider.of<Platform>(context, listen: false).popupErrorMessage = '3';
          _showErrorDialog(true);
          _flutterLocalNotificationsPlugin.show(
              0,
              maxloadTitle,
              '${maxloadBody.substring(0, 2)} $time ${maxloadBody.substring(3)}',
              notificationDetails);
        }
        Provider.of<Platform>(context, listen: false).addPeakBadgeCount();
        FlutterAppBadger.updateBadgeCount(
            Provider.of<Platform>(context, listen: false).totalBadgeCount);
        break;
      case 'reduce':
        _flutterLocalNotificationsPlugin.cancelAll();
        _flutterLocalNotificationsPlugin.show(
            1,
            mitigationTitle,
            '${mitigationBody.substring(0, 2)} $startTime - $endTime시 ${mitigationBody.substring(3)}',
            notificationDetails);
        Provider.of<Platform>(context, listen: false).isMitigating = true;
        Provider.of<Platform>(context, listen: false).mitigationTime =
            mitigationDate;
        Provider.of<Platform>(context, listen: false).addMitigationBadgeCount();
        FlutterAppBadger.updateBadgeCount(
            Provider.of<Platform>(context, listen: false).totalBadgeCount);
        _flutterLocalNotificationsPlugin.zonedSchedule(
            2,
            mitigationTitle,
            '${mitigationBody.substring(0, 2)} $startTime - $endTime시 ${mitigationBody.substring(3)}, 해제까지 30분 남음',
            tz.TZDateTime.now(tz.local).add(const Duration(minutes: 30)),
            notificationDetails,
            payload: 'reduce',
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidAllowWhileIdle: true);
        _flutterLocalNotificationsPlugin.zonedSchedule(
            3,
            mitigationTitle,
            '${mitigationBody.substring(0, 2)} $startTime - $endTime시 ${mitigationBody.substring(3)}, 해제까지 10분 남음',
            tz.TZDateTime.now(tz.local).add(const Duration(minutes: 50)),
            notificationDetails,
            payload: 'reduce',
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidAllowWhileIdle: true);
        break;
      default:
        break;
    }
    */
  }

  Future<void> selectNotification(Map<String, dynamic> data) async {
    await ApiService().checkMsgRead(
        Provider.of<Platform>(context, listen: false).phoneNumber,
        data['MSG_DATE'],
        data['MSG_SEQ']);
    //Provider.of<Platform>(context, listen: false).screenNumber =
    //    ScreenCode.dict.containsKey(data['PGM_ID']) ? ScreenCode.dict['PGM_ID']! : 0;
  }
}
