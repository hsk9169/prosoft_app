import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:prosoft_proj/services/api_service.dart';
import 'package:prosoft_proj/providers/platform_provider.dart';
import 'package:prosoft_proj/providers/session_provider.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/consts/sizes.dart';
import 'package:prosoft_proj/widgets/license_plate.dart';
import 'package:prosoft_proj/widgets/app_bar_contents.dart';
import 'package:prosoft_proj/widgets/barcode_badge.dart';
import 'package:prosoft_proj/models/models.dart';
import 'package:prosoft_proj/routes.dart';
import 'package:prosoft_proj/screens/screens.dart';

class MainView extends StatefulWidget {
  final int? index;
  const MainView({this.index});
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
      if (widget.index! > 0) {
        //await _apiService.getLatestMsg(_userInfo.phoneNumber!).then((data) {
        await _apiService.getLatestMsg('010-111-1111').then((data) {
          final content =
              MainContent(barcodeId: data.barcodeId, rfidNumber: data.rfidNo);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WaitingOrderView(
                        content: content,
                      )));
        });
      }
    });
  }

  void _initData() {
    _userInfo = Provider.of<Session>(context, listen: false).userInfo;
    _mainContentsFuture = _getMainContents();
  }

  Future<List<MainContent>> _getMainContents() async {
    //return await _apiService.getMainList(_userInfo.phoneNumber!);
    return await _apiService.getMainList('010-3499-8507').whenComplete(
        () => Provider.of<Platform>(context, listen: false).isLoading = false);
  }

  void _onTapBarcode(MainContent content) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WaitingOrderView(
                  content: content,
                )));
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<Platform>(context, listen: true).isMessageRecieved) {
      _mainContentsFuture = _getMainContents();
    }
    return SafeArea(
        child: Padding(
            padding: EdgeInsets.only(
                top: context.pHeight * 0.02,
                left: context.pWidth * 0.04,
                right: context.pWidth * 0.04),
            child: FutureBuilder(
                future: _mainContentsFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<List<MainContent>> snapshot) {
                  if (snapshot.data != null) {
                    return Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset('assets/icons/dump_truck_icon.svg',
                                width: context.pWidth * 0.16),
                            LicensePlate(
                                licenseNum: snapshot.data!.isNotEmpty
                                    ? snapshot.data![0].carFullNo!
                                    : '',
                                width: context.pWidth * 0.7,
                                height: context.pHeight * 0.08),
                          ]),
                      Padding(
                        padding: EdgeInsets.all(context.pHeight * 0.02),
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding:
                              EdgeInsets.only(bottom: context.pHeight * 0.02),
                          child: Text(
                              snapshot.data!.isNotEmpty
                                  ? '금일 ${snapshot.data!.length} 바코드 정보가 있습니다.'
                                  : '금일 바코드 정보가 없습니다.',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: context.pWidth * 0.05,
                                  fontWeight: FontWeight.bold))),
                      Expanded(
                          child: SingleChildScrollView(
                              controller: ScrollController(),
                              child: Column(
                                  children:
                                      _renderBarcodeBadges(snapshot.data!))))
                    ]);
                  } else {
                    return SizedBox();
                  }
                })));
  }

  List<Widget> _renderBarcodeBadges(List<MainContent> list) {
    return List.generate(
        list.length,
        (index) => BarcodeBadge(
            onTap: () => _onTapBarcode(list[index]),
            width: context.pWidth,
            level: list[index].measrGbnCode,
            type: list[index].matlName,
            url: list[index].barcodeId.toString()));
  }
}
