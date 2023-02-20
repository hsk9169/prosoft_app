import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prosoft_proj/services/api_service.dart';
import 'package:prosoft_proj/providers/platform_provider.dart';
import 'package:prosoft_proj/providers/session_provider.dart';
import 'package:prosoft_proj/consts/sizes.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/models/models.dart';
import 'package:prosoft_proj/widgets/horizontal_divider.dart';
import 'package:prosoft_proj/widgets/dark_card.dart';

class WaitingStatusView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WaitingStatusView();
}

class _WaitingStatusView extends State<WaitingStatusView> {
  // Service
  final _apiService = ApiService();

  // State
  late UserInfo _userInfo;

  // Future
  late Future<List<WaitingStatus>> _waitingStatusFuture;

  @override
  void initState() {
    _initData();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<Platform>(context, listen: false).isLoading = true;
    });
  }

  void _initData() async {
    _userInfo = Provider.of<Session>(context, listen: false).userInfo;
    _waitingStatusFuture = _getWaitingStatusData();
  }

  Future<List<WaitingStatus>> _getWaitingStatusData() async {
    final contentList =
        Provider.of<Session>(context, listen: false).contentList;
    return await _apiService
        //.getWaitingStatus(_userInfo.phoneNumber!, contentList[0].measrGbnCode!,
        //    contentList[0].scrapYardCode!)
        .getWaitingStatus(_userInfo.phoneNumber!, '21', 'C12')
        .whenComplete(() =>
            Provider.of<Platform>(context, listen: false).isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FutureBuilder(
            future: _waitingStatusFuture,
            builder: (BuildContext context,
                AsyncSnapshot<List<WaitingStatus>> snapshot) {
              if (snapshot.data != null) {
                return Column(children: [
                  Padding(
                      padding: EdgeInsets.only(
                        left: context.pWidth * 0.04,
                        right: context.pWidth * 0.04,
                      ),
                      child: Column(children: [
                        HorizontalDivier(),
                        _renderCarFullNo(),
                        HorizontalDivier(),
                        _renderMatlName(snapshot.data!),
                        Padding(
                            padding: EdgeInsets.only(
                              top: context.pWidth * 0.1,
                              left: context.pWidth * 0.06,
                              right: context.pWidth * 0.06,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SvgPicture.asset('assets/icons/standby.svg',
                                    width: context.pWidth * 0.09,
                                    color: Colors.black),
                                Padding(
                                    padding:
                                        EdgeInsets.all(context.pWidth * 0.02)),
                                Text('대기차량',
                                    style: TextStyle(
                                        fontSize: context.pWidth * 0.05,
                                        fontFamily: 'SUIT',
                                        fontWeight: context.normalWeight,
                                        color: Colors.black))
                              ],
                            )),
                        HorizontalDivier(),
                      ])),
                  Expanded(
                      child: SingleChildScrollView(
                          controller: ScrollController(),
                          child: _renderQueue(snapshot.data!))),
                ]);
              } else {
                return const SizedBox();
              }
            }));
  }

  Widget _renderCarFullNo() {
    final carFullNo = Provider.of<Session>(context, listen: false)
            .contentList
            .isNotEmpty
        ? Provider.of<Session>(context, listen: false).contentList[0].carFullNo
        : 'NULL';
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
                    child: Text(carFullNo!,
                        style: TextStyle(
                            fontSize: context.pWidth * 0.09,
                            fontFamily: 'SUIT',
                            fontWeight: context.boldWeight,
                            color: Colors.black))))
          ],
        ));
  }

  Widget _renderMatlName(List<WaitingStatus> list) {
    final scrapYard = list.isNotEmpty ? list[0].scrapYardCode : 'NULL';
    final measrGbnCode = list.isNotEmpty ? list[0].measrGbnCode : 'NULL';
    return Padding(
        padding: EdgeInsets.only(
          left: context.pWidth * 0.02,
          right: context.pWidth * 0.01,
        ),
        child: Column(
          children: [
            DarkCard(
                child: Column(children: [
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Text('구분',
                          style: TextStyle(
                              fontSize: context.pWidth * 0.05,
                              fontFamily: 'SUIT',
                              fontWeight: context.normalWeight,
                              color: AppColors.brightGrey))),
                  Expanded(
                      flex: 3,
                      child: Text(measrGbnCode!,
                          style: TextStyle(
                              fontSize: context.pWidth * 0.12,
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
                      flex: 1,
                      child: Text('하차지',
                          style: TextStyle(
                              fontSize: context.pWidth * 0.05,
                              fontFamily: 'SUIT',
                              fontWeight: context.normalWeight,
                              color: AppColors.brightGrey))),
                  Expanded(
                      flex: 3,
                      child: Text(scrapYard!,
                          style: TextStyle(
                              fontSize: context.pWidth * 0.12,
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
          left: context.pWidth * 0.06,
          right: context.pWidth * 0.06,
          bottom: context.pHeight * 0.01,
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
                          SvgPicture.asset('assets/icons/${index + 1}.svg',
                              width: context.pWidth * 0.06, color: color),
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
}
