import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:prosoft_proj/services/api_service.dart';
import 'package:prosoft_proj/providers/platform_provider.dart';
import 'package:prosoft_proj/providers/session_provider.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/consts/sizes.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/models/models.dart';
import 'package:prosoft_proj/widgets/horizontal_divider.dart';
import 'package:prosoft_proj/widgets/dark_card.dart';
import 'package:prosoft_proj/widgets/elevated_popup.dart';
import 'package:prosoft_proj/utils/number_handler.dart';

class WaitingOrderView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WaitingOrderView();
}

class _WaitingOrderView extends State<WaitingOrderView> {
  // Service
  ApiService _apiService = ApiService();

  // State
  late Future<List<dynamic>> _waitingOrderFuture;
  late UserInfo _userInfo;
  int _curStage = -1;

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
    _waitingOrderFuture = _getWaitingOrderData();
    _waitingOrderFuture.then((value) {
      Provider.of<Session>(context, listen: false).waitingOrder = value
          .map<WaitingOrder>(
              (dynamic element) => WaitingOrder.fromJson(element))
          .toList();
      switch (value[0]['CURRENT_STATUS']) {
        case '입문':
          setState(() => _curStage = 0);
          break;
        case '1차 계근':
          setState(() => _curStage = 1);
          break;
        case '검사장 입차 호출':
          setState(() => _curStage = 2);
          break;
        case '검사 결과':
          setState(() => _curStage = 3);
          break;
        case '2차 계근':
          setState(() => _curStage = 4);
          break;
        case '출문':
          setState(() => _curStage = 5);
          break;
      }
    });
  }

  Future<List<dynamic>> _getWaitingOrderData() async {
    final barcodeData =
        Provider.of<Platform>(context, listen: false).selectedBarcode;
    return await _apiService
        .getWaitingOrder(_userInfo.phoneNumber!, barcodeData.barcodeId!,
            barcodeData.rfidNumber!)
        //.getWaitingOrder(_userInfo.phoneNumber!, '2302140001', '21076979')
        .whenComplete(() =>
            Provider.of<Platform>(context, listen: false).isLoading = false);
  }

  void _onTapDetails(Map<String, dynamic> data) async {
    final barcodeData =
        Provider.of<Platform>(context, listen: false).selectedBarcode;
    await _apiService
        .getMainDetails(_userInfo.phoneNumber!, barcodeData.barcodeId!,
            barcodeData.rfidNumber!)
        //.getMainDetails(_userInfo.phoneNumber!, '2302140001', '21076979')
        .then((value) {
      showDialog(
          context: context,
          barrierColor: AppColors.darkGrey.withOpacity(0.3),
          barrierDismissible: true,
          builder: (BuildContext context) {
            return ElevatedPopup(
                height: context.pHeight * 0.8,
                onTapClose: () => Navigator.pop(context),
                children: Column(children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      width: context.pWidth,
                      height: context.pHeight * 0.06,
                      child: Row(children: [
                        Container(
                            padding: EdgeInsets.only(
                                top: context.pHeight * 0.005,
                                bottom: context.pHeight * 0.005,
                                left: context.pWidth * 0.04,
                                right: context.pWidth * 0.04),
                            decoration: BoxDecoration(
                              color: AppColors.darkGrey,
                              borderRadius:
                                  BorderRadius.circular(context.pWidth * 0.04),
                            ),
                            child: Text('품명',
                                style: TextStyle(
                                    fontSize: context.pWidth * 0.04,
                                    fontFamily: 'SUIT',
                                    fontWeight: context.normalWeight,
                                    color: Colors.white))),
                        Padding(
                          padding: EdgeInsets.all(context.pWidth * 0.01),
                        ),
                        Text(data['MATL_NAME'],
                            style: TextStyle(
                                fontSize: context.pWidth * 0.06,
                                fontFamily: 'SUIT',
                                fontWeight: context.boldWeight,
                                color: AppColors.lightOrange))
                      ])),
                  Container(
                    width: context.pWidth * 0.5,
                    height: context.pWidth * 0.3,
                    alignment: Alignment.center,
                    color: Colors.white,
                    padding: data['BARCODE_ID'].isNotEmpty
                        ? EdgeInsets.only(
                            top: context.pWidth * 0.05,
                            left: context.pWidth * 0.02,
                            right: context.pWidth * 0.02,
                          )
                        : null,
                    child: data['BARCODE_ID'].isNotEmpty
                        ? BarcodeWidget(
                            barcode: Barcode.code128(),
                            data: data['BARCODE_ID'],
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'SUIT',
                                fontWeight: context.normalWeight,
                                fontSize: context.pWidth * 0.05))
                        : Text('EMPTY',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: context.pWidth * 0.1,
                                fontFamily: 'SUIT',
                                fontWeight: context.maxWeight)),
                  ),
                  Padding(padding: EdgeInsets.all(context.pHeight * 0.01)),
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: AppColors.darkGrey,
                                      width: context.pHeight * 0.002),
                                  bottom: BorderSide(
                                      color: AppColors.darkGrey,
                                      width: context.pHeight * 0.002))),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                      padding: EdgeInsets.only(
                                        top: context.pHeight * 0.02,
                                        bottom: context.pHeight * 0.02,
                                        left: context.pWidth * 0.03,
                                        right: context.pWidth * 0.03,
                                      ),
                                      color: AppColors.brightGrey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text('거래처',
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text('명세서',
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text('반입예정일자',
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text('차량번호',
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text('기사성명',
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text('전화번호',
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text('품명',
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text('하차지',
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text('입문시간',
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text('1차계근시간',
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text('1차계근중량',
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text('검사입문 호출 시간',
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text('검사시간',
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text('검사결과',
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text('2차계근시간',
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text('2차계근중량',
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                        ],
                                      ))),
                              Expanded(
                                  flex: 3,
                                  child: Container(
                                      padding: EdgeInsets.only(
                                        top: context.pHeight * 0.02,
                                        bottom: context.pHeight * 0.02,
                                        left: context.pWidth * 0.03,
                                        right: context.pWidth * 0.03,
                                      ),
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(value.custName,
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text(value.reservNo,
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text(value.inStoreDate,
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text(value.carFullNo,
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text(value.driverName,
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text(value.driverPhoneNo,
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text(value.matlName,
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text(value.scrapYardName,
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text(value.gateInTime,
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text(value.measrInTime,
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text(value.fulfillWgt,
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text(value.carSelTime,
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text(value.inspProcTime,
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text(value.inspResult,
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text(value.measrOutTime,
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                          Text(value.toleranceWgt,
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.033,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.normalWeight,
                                                  color: Colors.black)),
                                        ],
                                      )))
                            ],
                          )))
                ]));
          });
    });
  }

  void _onTapImage(Map<String, dynamic> data) async {
    final mearInNo =
        Provider.of<Session>(context, listen: false).waitingOrder[0].measrInNo!;
    await _apiService
        .getMeasrImage(_userInfo.phoneNumber!, mearInNo)
        .then((value) {
      showDialog(
          context: context,
          barrierColor: AppColors.darkGrey.withOpacity(0.3),
          barrierDismissible: true,
          builder: (BuildContext context) {
            Uint8List image = const Base64Codec().decode(value.image!);
            return ElevatedPopup(
                height: context.pHeight * 0.8,
                onTapClose: () => Navigator.pop(context),
                children: Column(children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      width: context.pWidth,
                      height: context.pHeight * 0.06,
                      child: Row(children: [
                        Container(
                            padding: EdgeInsets.only(
                                top: context.pHeight * 0.005,
                                bottom: context.pHeight * 0.005,
                                left: context.pWidth * 0.02,
                                right: context.pWidth * 0.02),
                            decoration: BoxDecoration(
                              color: AppColors.darkGrey,
                              borderRadius:
                                  BorderRadius.circular(context.pWidth * 0.04),
                            ),
                            child: Text('품명',
                                style: TextStyle(
                                    fontSize: context.pWidth * 0.04,
                                    fontFamily: 'SUIT',
                                    fontWeight: context.normalWeight,
                                    color: Colors.white))),
                        Text(data['MATL_NAME'],
                            style: TextStyle(
                                fontSize: context.pWidth * 0.06,
                                fontFamily: 'SUIT',
                                fontWeight: context.boldWeight,
                                color: AppColors.lightOrange))
                      ])),
                  SizedBox(
                      width: context.pWidth,
                      height: context.pHeight,
                      child: Image.memory(image))
                ]));
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: FutureBuilder(
            future: _waitingOrderFuture,
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
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
                        _renderCarFullNo(),
                        HorizontalDivier(),
                        _renderMatlName(snapshot.data!),
                      ])),
                  Padding(
                      padding: EdgeInsets.only(
                          top: context.pHeight * 0.01,
                          bottom: context.pHeight * 0.02,
                          left: context.pWidth * 0.08),
                      child: Row(children: [
                        SvgPicture.asset('assets/icons/check.svg',
                            width: context.pWidth * 0.08, color: Colors.black),
                        Padding(
                          padding: EdgeInsets.all(context.pWidth * 0.02),
                        ),
                        Text('계근 진행 상태',
                            style: TextStyle(
                                fontSize: context.pWidth * 0.07,
                                fontFamily: 'SUIT',
                                fontWeight: context.boldWeight,
                                color: Colors.black))
                      ])),
                  Expanded(
                      child: SingleChildScrollView(
                          controller: ScrollController(),
                          child: Column(children: [
                            _renderWaitingOrder(snapshot.data!),
                            Padding(
                                padding: EdgeInsets.all(context.pHeight * 0.02))
                          ]))),
                ]);
              } else {
                return const SizedBox();
              }
            }));
  }

  Widget _renderCarFullNo() {
    final carFullNo =
        Provider.of<Platform>(context, listen: false).selectedBarcode.carFullNo;
    print(
        Provider.of<Platform>(context, listen: false).selectedBarcode.toJson());
    return Container(
        width: context.pWidth,
        padding: EdgeInsets.only(
            top: context.pHeight * 0.02, left: context.pWidth * 0.04),
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/truck.svg',
                width: context.pWidth * 0.15, color: AppColors.darkGrey),
            Padding(
              padding: EdgeInsets.all(context.pWidth * 0.01),
            ),
            Expanded(
                child: Align(
                    alignment: Alignment.center,
                    child: Text(carFullNo ?? 'NULL',
                        style: TextStyle(
                            fontSize: context.pWidth * 0.09,
                            fontFamily: 'SUIT',
                            fontWeight: context.boldWeight,
                            color: Colors.black))))
          ],
        ));
  }

  Widget _renderMatlName(List<dynamic> list) {
    final matlName = list.isNotEmpty ? list[0]['MATL_NAME'] : 'NULL';
    return Padding(
        padding: EdgeInsets.only(
          left: context.pWidth * 0.02,
          right: context.pWidth * 0.02,
        ),
        child: Column(
          children: [
            DarkCard(
                child: Row(
              children: [
                Text('품명',
                    style: TextStyle(
                        fontSize: context.pWidth * 0.05,
                        fontFamily: 'SUIT',
                        fontWeight: context.normalWeight,
                        color: AppColors.brightGrey)),
                Padding(padding: EdgeInsets.all(context.pWidth * 0.04)),
                Expanded(
                    child: Text(matlName!,
                        style: TextStyle(
                            fontSize: context.pWidth * 0.1,
                            fontFamily: 'SUIT',
                            fontWeight: context.maxWeight,
                            color: AppColors.brightGrey))),
              ],
            ))
          ],
        ));
  }

  Widget _renderWaitingOrder(List<dynamic> list) {
    final waitingYn =
        Provider.of<Platform>(context, listen: false).selectedBarcode.waitingYn;
    final stageHeight = context.pHeight * 0.55;
    final content = list.isNotEmpty ? list[0] : null;
    return Padding(
        padding: EdgeInsets.only(left: context.pWidth * 0.08),
        child: Container(
            width: context.pWidth,
            margin: EdgeInsets.only(
              left: context.pWidth * 0.03,
              right: context.pWidth * 0.11,
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  width: context.pWidth * 0.08,
                  height: stageHeight,
                  margin: EdgeInsets.only(top: context.pHeight * 0.01),
                  child: Stack(alignment: Alignment.topCenter, children: [
                    Container(
                      color: AppColors.brightGrey,
                      width: context.pWidth * 0.02,
                      height: waitingYn == 'Y'
                          ? stageHeight * 5 / 6
                          : stageHeight / 2,
                    ),
                    _renderNumbers(stageHeight / 6)
                  ])),
              Padding(padding: EdgeInsets.all(context.pWidth * 0.02)),
              Expanded(child: _renderStageData(stageHeight / 6, content!))
            ])));
  }

  Widget _renderNumbers(double height) {
    final waitingYn =
        Provider.of<Platform>(context, listen: false).selectedBarcode.waitingYn;
    return waitingYn == 'Y'
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                6,
                (index) => SizedBox(
                    width: context.pWidth * 0.3,
                    height: height,
                    child: Stack(alignment: Alignment.topCenter, children: [
                      Container(
                        width: context.pWidth * 0.06,
                        height: context.pWidth * 0.06,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                      ),
                      SvgPicture.asset('assets/icons/${index + 1}.svg',
                          width: context.pWidth * 0.07,
                          color: index < _curStage
                              ? AppColors.mediumGrey
                              : index == _curStage
                                  ? AppColors.lightOrange
                                  : AppColors.lightGrey),
                    ]))))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                6,
                (index) => index < 2
                    ? SizedBox(
                        width: context.pWidth * 0.3,
                        height: height,
                        child: Stack(alignment: Alignment.topCenter, children: [
                          Container(
                            width: context.pWidth * 0.06,
                            height: context.pWidth * 0.06,
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                          ),
                          SvgPicture.asset('assets/icons/${index + 1}.svg',
                              width: context.pWidth * 0.07,
                              color: index < _curStage
                                  ? AppColors.mediumGrey
                                  : index == _curStage
                                      ? AppColors.lightOrange
                                      : AppColors.lightGrey),
                        ]))
                    : index > 3
                        ? SizedBox(
                            width: context.pWidth * 0.3,
                            height: height,
                            child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Container(
                                    width: context.pWidth * 0.06,
                                    height: context.pWidth * 0.06,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                  ),
                                  SvgPicture.asset(
                                      'assets/icons/${index - 1}.svg',
                                      width: context.pWidth * 0.07,
                                      color: index < _curStage
                                          ? AppColors.mediumGrey
                                          : index == _curStage
                                              ? AppColors.lightOrange
                                              : AppColors.lightGrey),
                                ]))
                        : const SizedBox()));
  }

  Widget _renderStageData(double height, Map<String, dynamic> content) {
    final waitingYn =
        Provider.of<Platform>(context, listen: false).selectedBarcode.waitingYn;
    return Padding(
        padding: EdgeInsets.only(top: context.pHeight * 0.005),
        child: waitingYn == 'Y'
            ? Column(
                children: List.generate(
                6,
                (index) => SizedBox(
                    width: context.pWidth,
                    height: height,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Text(
                                      content['STEP_${index + 1}_STATUS'] ?? '',
                                      style: TextStyle(
                                          fontSize: context.pWidth * 0.07,
                                          fontFamily: 'SUIT',
                                          fontWeight: context.boldWeight,
                                          color: index < _curStage
                                              ? AppColors.mediumGrey
                                              : index == _curStage
                                                  ? AppColors.lightOrange
                                                  : AppColors.lightGrey)),
                                  Text(
                                      content['STEP_${index + 1}_DATA'] != null
                                          ? index == 1 || index == 4
                                              ? '  - ${NumberHandler().addComma(content['STEP_${index + 1}_DATA'])} kg'
                                              : index == 3
                                                  ? content['STEP_${index + 1}_DATA'] ==
                                                          'Y'
                                                      ? '  - 합격'
                                                      : '  - 불합격'
                                                  : '  - ${NumberHandler().addComma(content['STEP_${index + 1}_DATA'])}'
                                          : '',
                                      style: TextStyle(
                                          fontSize: context.pWidth * 0.05,
                                          fontFamily: 'SUIT',
                                          fontWeight: context.boldWeight,
                                          color: index < _curStage
                                              ? AppColors.mediumGrey
                                              : index == _curStage
                                                  ? AppColors.lightOrange
                                                  : AppColors.lightGrey)),
                                ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      index == 4
                                          ? InkWell(
                                              onTap: () => index <= _curStage
                                                  ? _onTapImage(content)
                                                  : null,
                                              child: SvgPicture.asset(
                                                  'assets/icons/details.svg',
                                                  width: context.pWidth * 0.05,
                                                  color: index > _curStage
                                                      ? AppColors.lightGrey
                                                      : AppColors.mediumGrey))
                                          : const SizedBox(),
                                      Padding(
                                        padding: EdgeInsets.all(
                                            context.pWidth * 0.01),
                                      ),
                                      InkWell(
                                          onTap: () => index <= _curStage
                                              ? _onTapDetails(content)
                                              : null,
                                          child: SvgPicture.asset(
                                              'assets/icons/detailpage.svg',
                                              width: context.pWidth * 0.06,
                                              color: index > _curStage
                                                  ? AppColors.lightGrey
                                                  : AppColors.mediumGrey))
                                    ])
                              ]),
                          Text(content['STEP_${index + 1}_TIME'] ?? '',
                              style: TextStyle(
                                  fontSize: context.pWidth * 0.035,
                                  fontFamily: 'SUIT',
                                  fontWeight: context.boldWeight,
                                  color: AppColors.mediumGrey)),
                        ])),
              ))
            : Column(
                children: List.generate(
                    6,
                    (index) => index != 2 && index != 3
                        ? SizedBox(
                            width: context.pWidth,
                            height: height,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(children: [
                                          Text(
                                              content['STEP_${index + 1}_STATUS'] ??
                                                  '',
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.07,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.boldWeight,
                                                  color: index < _curStage
                                                      ? AppColors.mediumGrey
                                                      : index == _curStage
                                                          ? AppColors
                                                              .lightOrange
                                                          : AppColors
                                                              .lightGrey)),
                                          Text(
                                              content['STEP_${index + 1}_DATA'] !=
                                                      null
                                                  ? index == 1 || index == 4
                                                      ? '  - ${NumberHandler().addComma(content['STEP_${index + 1}_DATA'])} kg'
                                                      : index == 3
                                                          ? content['STEP_${index + 1}_DATA'] ==
                                                                  'Y'
                                                              ? '  - 합격'
                                                              : '  - 불합격'
                                                          : '  - ${NumberHandler().addComma(content['STEP_${index + 1}_DATA'])}'
                                                  : '',
                                              style: TextStyle(
                                                  fontSize:
                                                      context.pWidth * 0.05,
                                                  fontFamily: 'SUIT',
                                                  fontWeight:
                                                      context.boldWeight,
                                                  color: index < _curStage
                                                      ? AppColors.mediumGrey
                                                      : index == _curStage
                                                          ? AppColors
                                                              .lightOrange
                                                          : AppColors
                                                              .lightGrey)),
                                        ]),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              index == 4
                                                  ? InkWell(
                                                      onTap: () => index <=
                                                              _curStage
                                                          ? _onTapImage(content)
                                                          : null,
                                                      child: SvgPicture.asset(
                                                          'assets/icons/details.svg',
                                                          width:
                                                              context.pWidth *
                                                                  0.05,
                                                          color: index >
                                                                  _curStage
                                                              ? AppColors
                                                                  .lightGrey
                                                              : AppColors
                                                                  .mediumGrey))
                                                  : const SizedBox(),
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    context.pWidth * 0.01),
                                              ),
                                              InkWell(
                                                  onTap: () => index <=
                                                          _curStage
                                                      ? _onTapDetails(content)
                                                      : null,
                                                  child: SvgPicture.asset(
                                                      'assets/icons/detailpage.svg',
                                                      width:
                                                          context.pWidth * 0.06,
                                                      color: index > _curStage
                                                          ? AppColors.lightGrey
                                                          : AppColors
                                                              .mediumGrey))
                                            ])
                                      ]),
                                  Text(content['STEP_${index + 1}_TIME'] ?? '',
                                      style: TextStyle(
                                          fontSize: context.pWidth * 0.035,
                                          fontFamily: 'SUIT',
                                          fontWeight: context.boldWeight,
                                          color: index > _curStage
                                              ? AppColors.lightGrey
                                              : AppColors.mediumGrey)),
                                ]))
                        : const SizedBox())));
  }
}
