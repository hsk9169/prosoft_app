import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:prosoft_proj/services/api_service.dart';
import 'package:prosoft_proj/providers/platform_provider.dart';
import 'package:prosoft_proj/providers/session_provider.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/consts/sizes.dart';
import 'package:prosoft_proj/widgets/license_plate.dart';
import 'package:prosoft_proj/widgets/horizontal_divider.dart';
import 'package:prosoft_proj/widgets/barcode_badge.dart';
import 'package:prosoft_proj/widgets/elevated_popup.dart';
import 'package:prosoft_proj/widgets/dark_card.dart';
import 'package:prosoft_proj/models/models.dart';
import 'package:prosoft_proj/routes.dart';
import 'package:prosoft_proj/screens/screens.dart';
import 'package:prosoft_proj/widgets/info_card.dart';

class MainView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainView();
}

class _MainView extends State<MainView> {
  // Service
  ApiService _apiService = ApiService();

  // State
  late UserInfo _userInfo;

  // Future
  late Future<List<MainContent>> _mainContentsFuture;

  @override
  void initState() {
    _initData();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<Platform>(context, listen: false).isLoading = true;
    });
  }

  void _initData() {
    _userInfo = Provider.of<Session>(context, listen: false).userInfo;
    _mainContentsFuture = _getMainContents();
  }

  Future<List<MainContent>> _getMainContents() async {
    return await _apiService.getMainList(_userInfo.phoneNumber!).whenComplete(
        () => Provider.of<Platform>(context, listen: false).isLoading = false);
  }

  void _onTapWaitingOrder(MainContent content) {
    Provider.of<Platform>(context, listen: false).selectedBarcode = content;
    Provider.of<Platform>(context, listen: false).screenNumber = 2;
  }

  void _onTapBarcodeIssue() {
    Provider.of<Platform>(context, listen: false).screenNumber = 1;
  }

  void _onTapWaitingStatus(MainContent content) async {
    await _apiService
        .getWaitingStatus(_userInfo.phoneNumber!, content.measrGbnCode!,
            content.scrapYardCode!)
        .then((value) {
      showDialog(
          context: context,
          barrierColor: AppColors.darkGrey.withOpacity(0.3),
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Dialog(
                insetPadding: EdgeInsets.all(context.pWidth * 0.05),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.pWidth * 0.03)),
                elevation: 20,
                child: Container(
                    width: context.pWidth,
                    height: context.pHeight * 0.75,
                    padding: EdgeInsets.all(context.pWidth * 0.02),
                    child: Stack(children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: context.pHeight * 0.03,
                            bottom: context.pHeight * 0.01),
                        child: Column(children: [
                          Column(children: [
                            _renderMatlName(value),
                            Padding(
                                padding: EdgeInsets.only(
                                  top: context.pWidth * 0.05,
                                  left: context.pWidth * 0.06,
                                  right: context.pWidth * 0.06,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SvgPicture.asset('assets/icons/standby.svg',
                                        width: context.pWidth * 0.09),
                                    Padding(
                                        padding: EdgeInsets.all(
                                            context.pWidth * 0.02)),
                                    Text('대기차량',
                                        style: TextStyle(
                                            fontSize: context.pWidth * 0.05,
                                            fontFamily: 'SUIT',
                                            fontWeight: context.normalWeight,
                                            color: Colors.black))
                                  ],
                                )),
                            HorizontalDivier(),
                          ]),
                          Expanded(
                              child: SingleChildScrollView(
                                  controller: ScrollController(),
                                  child: _renderQueue(value))),
                        ]),
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Icon(Icons.close,
                                  color: Colors.black,
                                  size: context.pWidth * 0.06)))
                    ])));
          });
    }).whenComplete(() =>
            Provider.of<Platform>(context, listen: false).isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<Platform>(context, listen: true).isMessageRecieved) {
      _mainContentsFuture = _getMainContents();
    }
    return SafeArea(
        bottom: false,
        child: FutureBuilder(
            future: _mainContentsFuture,
            builder: (BuildContext context,
                AsyncSnapshot<List<MainContent>> snapshot) {
              if (snapshot.data != null) {
                return Column(children: [
                  Padding(
                      padding: EdgeInsets.only(
                        left: context.pWidth * 0.04,
                        right: context.pWidth * 0.04,
                        bottom: context.pHeight * 0.02,
                      ),
                      child: Column(children: [
                        HorizontalDivier(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                                onTap: () => _onTapBarcodeIssue(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SvgPicture.asset('assets/icons/printer.svg',
                                        color: AppColors.darkGrey,
                                        width: context.pWidth * 0.08),
                                    Padding(
                                        padding: EdgeInsets.all(
                                            context.pWidth * 0.01)),
                                    Text('바코드 발행',
                                        style: TextStyle(
                                            fontSize: context.pWidth * 0.05,
                                            fontFamily: 'SUIT',
                                            fontWeight: context.normalWeight,
                                            color: Colors.black))
                                  ],
                                )),
                          ],
                        ),
                        HorizontalDivier(),
                        InfoCard(number: snapshot.data!.length),
                      ])),
                  Expanded(
                      child: SingleChildScrollView(
                          controller: ScrollController(),
                          child: Column(children: [
                            Column(
                                children: _renderBarcodeBadges(snapshot.data!)),
                            Padding(
                                padding: EdgeInsets.all(context.pHeight * 0.02))
                          ]))),
                ]);
              } else {
                return const SizedBox();
              }
            }));
  }

  List<Widget> _renderBarcodeBadges(List<MainContent> list) {
    return List.generate(
        list.length,
        (index) => BarcodeBadge(
            isEnd: list[index].barcodeEndYn == 'Y' ? true : false,
            onTapOrder: () => _onTapWaitingOrder(list[index]),
            onTapStatus: () => _onTapWaitingStatus(list[index]),
            carFullNo: list[index].carFullNo,
            type: list[index].matlName,
            url: list[index].rfidNumber.toString()));
  }

  Widget _renderMatlName(List<WaitingStatus> list) {
    final scrapYard = list.isNotEmpty ? list[0].scrapYardCode : '';
    final measrGbnCode = list.isNotEmpty ? list[0].measrGbnCode : '';
    return Padding(
        padding: EdgeInsets.only(
          left: context.pWidth * 0.01,
          right: context.pWidth * 0.01,
        ),
        child: Column(
          children: [
            DarkCard(
                child: Column(children: [
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Text('구분',
                          style: TextStyle(
                              fontSize: context.pWidth * 0.05,
                              fontFamily: 'SUIT',
                              fontWeight: context.normalWeight,
                              color: AppColors.brightGrey))),
                  Expanded(
                      flex: 5,
                      child: Text(measrGbnCode!,
                          style: TextStyle(
                              fontSize: context.pWidth * 0.1,
                              fontFamily: 'SUIT',
                              fontWeight: context.maxWeight,
                              color: AppColors.brightGrey))),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(context.pHeight * 0.01),
              ),
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Text('하차지',
                          style: TextStyle(
                              fontSize: context.pWidth * 0.05,
                              fontFamily: 'SUIT',
                              fontWeight: context.normalWeight,
                              color: AppColors.brightGrey))),
                  Expanded(
                      flex: 5,
                      child: Text(scrapYard!,
                          style: TextStyle(
                              fontSize: context.pWidth * 0.1,
                              fontFamily: 'SUIT',
                              fontWeight: context.maxWeight,
                              color: AppColors.lightOrange))),
                ],
              ),
            ]))
          ],
        ));
  }

  Widget _renderQueue(List<WaitingStatus> list) {
    return Padding(
        padding: EdgeInsets.only(
          bottom: context.pHeight * 0.01,
          left: context.pWidth * 0.02,
          right: context.pWidth * 0.02,
        ),
        child: Column(
            children: List.generate(list.length, (index) {
          final bool myTurn = list[index].carFullNo ==
                  Provider.of<Session>(context, listen: false)
                      .contentList[0]
                      .carFullNo
              ? true
              : false;
          final Color color =
              myTurn ? AppColors.lightOrange : AppColors.mediumGrey;
          return Column(children: [
            Container(
                width: context.pWidth,
                padding: EdgeInsets.all(context.pWidth * 0.02),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          waitingNumber(index + 1, color),
                          Padding(
                              padding: EdgeInsets.all(context.pWidth * 0.02)),
                          Text(list[index].carFullNo!,
                              style: TextStyle(
                                  fontSize: context.pWidth * 0.08,
                                  fontFamily: 'SUIT',
                                  fontWeight: context.boldWeight,
                                  color: color))
                        ]),
                        Text(list[index].visitName!,
                            style: TextStyle(
                                fontSize: context.pWidth * 0.05,
                                fontFamily: 'SUIT',
                                fontWeight: context.normalWeight,
                                color: color))
                      ],
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Text(list[index].measrStatus!,
                            style: TextStyle(
                                fontSize: context.pWidth * 0.07,
                                fontFamily: 'SUIT',
                                fontWeight: context.boldWeight,
                                color: Colors.black)))
                  ],
                )),
            index < list.length - 1 ? HorizontalDivier() : const SizedBox(),
          ]);
        })));
  }

  Widget waitingNumber(int number, Color bgColor) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(context.pWidth * 0.003),
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: Text(number.toString(),
            style: TextStyle(
                fontSize: context.pWidth * 0.045,
                fontFamily: 'SUIT',
                fontWeight: context.boldWeight,
                color: Colors.white)));
  }
}
