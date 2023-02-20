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
import 'package:prosoft_proj/widgets/barcode_tag.dart';

class ContentDetailsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContentDetailsView();
}

class _ContentDetailsView extends State<ContentDetailsView> {
  // Service
  final _apiService = ApiService();

  // State
  late UserInfo _userInfo;

  // Future
  late Future<List<ContentDetails>> _contentDetailsFuture;

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
    _contentDetailsFuture = _getContentDetailsList();
    _contentDetailsFuture.whenComplete(() => setState(
        () => Provider.of<Platform>(context, listen: false).isLoading = false));
  }

  Future<List<ContentDetails>> _getContentDetailsList() async {
    final contentList =
        Provider.of<Session>(context, listen: false).contentList;
    Iterable<Future<ContentDetails>> mappedList =
        contentList.map((MainContent content) async {
      return await _apiService
          .getMainDetails(
              _userInfo.phoneNumber!, content.barcodeId!, content.rfidNumber!)
          .then((res) {
        if (res is String) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('서버 오류 발생'),
              backgroundColor: Colors.black87.withOpacity(0.6),
              duration: const Duration(seconds: 2)));
          return ContentDetails();
        } else {
          return res;
        }
      });
    });
    return await Future.wait(mappedList);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: FutureBuilder(
            future: _contentDetailsFuture,
            builder: (BuildContext context,
                AsyncSnapshot<List<ContentDetails>> snapshot) {
              if (snapshot.data != null) {
                return Column(children: [
                  Padding(
                      padding: EdgeInsets.only(
                        left: context.pWidth * 0.04,
                        right: context.pWidth * 0.04,
                      ),
                      child: Column(children: [
                        HorizontalDivier(),
                        _renderCarFullNo(snapshot.data!),
                        HorizontalDivier(),
                        _renderMatlName(snapshot.data!),
                        Padding(
                          padding: EdgeInsets.all(context.pHeight * 0.01),
                        ),
                        _renderBarcode(snapshot.data![0].barcodeId!),
                        Padding(
                            padding: EdgeInsets.only(
                              top: context.pWidth * 0.06,
                              left: context.pWidth * 0.06,
                              right: context.pWidth * 0.06,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SvgPicture.asset('assets/icons/details.svg',
                                    width: context.pWidth * 0.06,
                                    color: Colors.black),
                                Padding(
                                    padding:
                                        EdgeInsets.all(context.pWidth * 0.02)),
                                Text('상세내역',
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
                          child: _renderDetails(snapshot.data!))),
                ]);
              } else {
                return const SizedBox();
              }
            }));
  }

  Widget _renderCarFullNo(List<ContentDetails> list) {
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

  Widget _renderMatlName(List<ContentDetails> list) {
    final matlName = list.isNotEmpty ? list[0].matlName : 'NULL';
    return Padding(
        padding: EdgeInsets.only(
          left: context.pWidth * 0.02,
          right: context.pWidth * 0.01,
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
                Text(matlName!,
                    style: TextStyle(
                        fontSize: context.pWidth * 0.1,
                        fontFamily: 'SUIT',
                        fontWeight: context.maxWeight,
                        color: AppColors.brightGrey)),
              ],
            ))
          ],
        ));
  }

  Widget _renderBarcode(String url) {
    return Container(
        margin: EdgeInsets.all(context.pWidth * 0.02),
        padding: EdgeInsets.all(
          context.pWidth * 0.04,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.pWidth * 0.06),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 4,
              blurRadius: 6,
              offset: const Offset(5, 8),
            ),
          ],
        ),
        child: Column(children: [
          Row(children: [
            SvgPicture.asset('assets/icons/barcode.svg',
                width: context.pWidth * 0.06, color: AppColors.darkGrey),
            Padding(padding: EdgeInsets.all(context.pWidth * 0.01)),
            Text('바코드',
                style: TextStyle(
                    fontSize: context.pWidth * 0.05,
                    fontFamily: 'SUIT',
                    fontWeight: context.normalWeight,
                    color: Colors.black))
          ]),
          Padding(padding: EdgeInsets.all(context.pHeight * 0.01)),
          BarcodeTag(url: url)
        ]));
  }

  Widget _renderDetails(List<ContentDetails> list) {
    return Padding(
        padding: EdgeInsets.only(
          left: context.pWidth * 0.08,
          right: context.pWidth * 0.08,
          bottom: context.pHeight * 0.01,
        ),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text('거래처',
                      style: TextStyle(
                          fontSize: context.pWidth * 0.05,
                          fontFamily: 'SUIT',
                          fontWeight: context.normalWeight,
                          color: Colors.black))),
              Expanded(
                  flex: 3,
                  child: Text(list[0].custName!,
                      style: TextStyle(
                          fontSize: context.pWidth * 0.05,
                          fontFamily: 'SUIT',
                          fontWeight: context.normalWeight,
                          color: Colors.black))),
            ],
          ),
          Padding(padding: EdgeInsets.all(context.pHeight * 0.005)),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text('명세서',
                      style: TextStyle(
                          fontSize: context.pWidth * 0.05,
                          fontFamily: 'SUIT',
                          fontWeight: context.normalWeight,
                          color: Colors.black))),
              Expanded(
                  flex: 3,
                  child: Text(list[0].reservNo!,
                      style: TextStyle(
                          fontSize: context.pWidth * 0.05,
                          fontFamily: 'SUIT',
                          fontWeight: context.normalWeight,
                          color: Colors.black))),
            ],
          ),
          Padding(padding: EdgeInsets.all(context.pHeight * 0.005)),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text('반입예정',
                      style: TextStyle(
                          fontSize: context.pWidth * 0.05,
                          fontFamily: 'SUIT',
                          fontWeight: context.normalWeight,
                          color: Colors.black))),
              Expanded(
                  flex: 3,
                  child: Text(list[0].inStoreDate!,
                      style: TextStyle(
                          fontSize: context.pWidth * 0.05,
                          fontFamily: 'SUIT',
                          fontWeight: context.normalWeight,
                          color: Colors.black))),
            ],
          ),
          Padding(padding: EdgeInsets.all(context.pHeight * 0.005)),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text('전화번호',
                      style: TextStyle(
                          fontSize: context.pWidth * 0.05,
                          fontFamily: 'SUIT',
                          fontWeight: context.normalWeight,
                          color: Colors.black))),
              Expanded(
                  flex: 3,
                  child: Text(list[0].driverPhoneNo!,
                      style: TextStyle(
                          fontSize: context.pWidth * 0.05,
                          fontFamily: 'SUIT',
                          fontWeight: context.normalWeight,
                          color: Colors.black))),
            ],
          ),
          Padding(padding: EdgeInsets.all(context.pHeight * 0.005)),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text('하차지',
                      style: TextStyle(
                          fontSize: context.pWidth * 0.05,
                          fontFamily: 'SUIT',
                          fontWeight: context.normalWeight,
                          color: Colors.black))),
              Expanded(
                  flex: 3,
                  child: Text(list[0].scrapYardName!,
                      style: TextStyle(
                          fontSize: context.pWidth * 0.05,
                          fontFamily: 'SUIT',
                          fontWeight: context.normalWeight,
                          color: Colors.black))),
            ],
          ),
          Padding(padding: EdgeInsets.all(context.pHeight * 0.005)),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text('입문시각',
                      style: TextStyle(
                          fontSize: context.pWidth * 0.05,
                          fontFamily: 'SUIT',
                          fontWeight: context.normalWeight,
                          color: Colors.black))),
              Expanded(
                  flex: 3,
                  child: Text(list[0].gateInTime!,
                      style: TextStyle(
                          fontSize: context.pWidth * 0.05,
                          fontFamily: 'SUIT',
                          fontWeight: context.normalWeight,
                          color: Colors.black))),
            ],
          ),
          Padding(padding: EdgeInsets.all(context.pHeight * 0.005)),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text('1차계근',
                      style: TextStyle(
                          fontSize: context.pWidth * 0.05,
                          fontFamily: 'SUIT',
                          fontWeight: context.normalWeight,
                          color: Colors.black))),
              Expanded(
                  flex: 3,
                  child: Text(list[0].measrInTime!,
                      style: TextStyle(
                          fontSize: context.pWidth * 0.05,
                          fontFamily: 'SUIT',
                          fontWeight: context.normalWeight,
                          color: Colors.black))),
            ],
          ),
          Padding(padding: EdgeInsets.all(context.pHeight * 0.005)),
        ]));
  }
}
