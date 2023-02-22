import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:prosoft_proj/providers/platform_provider.dart';
import 'package:prosoft_proj/providers/session_provider.dart';
import 'package:prosoft_proj/services/api_service.dart';
import 'package:prosoft_proj/models/models.dart';
import 'package:prosoft_proj/widgets/horizontal_divider.dart';
import 'package:prosoft_proj/widgets/info_card.dart';
import 'package:prosoft_proj/widgets/barcode_details.dart';
import 'package:prosoft_proj/consts/sizes.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/utils/number_handler.dart';
import 'package:prosoft_proj/widgets/dark_button.dart';

class BarcodeIssueView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BarcodeIssueView();
}

class _BarcodeIssueView extends State<BarcodeIssueView> {
  // Service
  ApiService _apiService = ApiService();

  // Future
  late Future<List<IssueBarcode>> _barcodeIssueFuture;

  // State
  late UserInfo _userInfo;
  List<ContentDetails> _contentDetailsList = [];
  DateTime _currentDatetime = DateTime.now();
  DateTime _selectedDatetime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<Platform>(context, listen: false).isLoading = true;
    });
  }

  void _initData() {
    _userInfo = Provider.of<Session>(context, listen: false).userInfo;
    _barcodeIssueFuture = _getBarcodeIssueList()
      ..whenComplete(() =>
          Provider.of<Platform>(context, listen: false).isLoading = false);
  }

  Future<List<IssueBarcode>> _getBarcodeIssueList() async {
    return await _apiService
        .getBarcodeIssueList(_userInfo.phoneNumber!,
            _selectedDatetime.toLocal().toString().substring(0, 10))
        .then((res) {
      if (res is String) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('바코드 생성 중에 오류가 발생했습니다.'),
            backgroundColor: Colors.black87.withOpacity(0.6),
            duration: const Duration(seconds: 2)));
        return [IssueBarcode()];
      } else {
        return res;
      }
    });
  }

  void _onTapCalendar() async {
    final now = DateTime.now();
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              insetPadding: EdgeInsets.all(context.pWidth * 0.05),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                width: context.pWidth,
                height: context.pHeight * 0.6,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: SfDateRangePicker(
                  initialSelectedDate: _selectedDatetime,
                  minDate: now,
                  maxDate: DateTime(now.year + 100),
                  view: DateRangePickerView.month,
                  headerHeight: context.pHeight * 0.1,
                  headerStyle: DateRangePickerHeaderStyle(
                      backgroundColor: AppColors.lightGrey,
                      textStyle: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: context.pHeight * 0.03,
                        color: Colors.white,
                      )),
                  monthViewSettings: DateRangePickerMonthViewSettings(
                      viewHeaderHeight: context.pHeight * 0.06,
                      dayFormat: 'EEE',
                      viewHeaderStyle: DateRangePickerViewHeaderStyle(
                          textStyle: TextStyle(
                              fontSize: context.pHeight * 0.02,
                              letterSpacing: 1,
                              color: AppColors.lightGrey))),
                  selectionTextStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  onSelectionChanged: _onSelectionChanged,
                  onSubmit: (value) => _onDateSelected(),
                  onCancel: () => _onDateSelectCanceled(),
                  selectionMode: DateRangePickerSelectionMode.single,
                  showActionButtons: true,
                  showNavigationArrow: true,
                  confirmText: '확인',
                  cancelText: '닫기',
                ),
              ));
        });
  }

  void _onTapBarcodeIssue(IssueBarcode data) async {
    final userInfo = Provider.of<Session>(context, listen: false).userInfo;

    showDialog(
        context: context,
        barrierColor: AppColors.darkGrey.withOpacity(0.3),
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('바코드 발행',
                style: TextStyle(
                    fontSize: context.pWidth * 0.05,
                    fontFamily: 'SUIT',
                    fontWeight: context.normalWeight,
                    color: Colors.black)),
            content: Text('모바일 바코드를 발행하시겠습니까?',
                style: TextStyle(
                    fontSize: context.pWidth * 0.05,
                    fontFamily: 'SUIT',
                    fontWeight: context.normalWeight,
                    color: Colors.black)),
            actions: <Widget>[
              TextButton(
                  child: const Text('확인'),
                  onPressed: () async {
                    Provider.of<Platform>(context, listen: false).isLoading =
                        true;
                    await _apiService
                        .issueBarcode(
                            data.compCd!,
                            data.reservNo!,
                            userInfo.phoneNumber!,
                            userInfo.name!,
                            userInfo.fcmToken!)
                        .then((value) {
                      if (value == 'SUCCESS') {
                        _barcodeIssueFuture = _getBarcodeIssueList();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(value),
                            backgroundColor: Colors.black87.withOpacity(0.6),
                            duration: const Duration(seconds: 2)));
                      }
                      Navigator.of(context).pop();
                      Provider.of<Platform>(context, listen: false).isLoading =
                          false;
                    });
                  }),
              TextButton(
                child: const Text('취소'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _selectedDatetime = args.value;
    });
  }

  void _onDateSelected() {
    if (_currentDatetime != _selectedDatetime) {
      Provider.of<Platform>(context, listen: false).isLoading = true;

      setState(() {
        _barcodeIssueFuture = _getBarcodeIssueList();
        _currentDatetime = _selectedDatetime;
      });
      _barcodeIssueFuture.whenComplete(() =>
          Provider.of<Platform>(context, listen: false).isLoading = false);
    }
    Navigator.pop(context);
  }

  void _onDateSelectCanceled() {
    Navigator.pop(context);
    setState(() => _selectedDatetime = _currentDatetime);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: FutureBuilder(
            future: _barcodeIssueFuture,
            builder: (BuildContext context,
                AsyncSnapshot<List<IssueBarcode>> snapshot) {
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
                        _renderGateInTime(),
                        HorizontalDivier(),
                        _renderInfoCard(snapshot.data!),
                      ])),
                  Expanded(
                      child: SingleChildScrollView(
                          controller: ScrollController(),
                          child: Column(children: [
                            Column(
                                children:
                                    _renderBarcodeDetails(snapshot.data!)),
                            Padding(
                                padding: EdgeInsets.all(context.pHeight * 0.02))
                          ]))),
                ]);
              } else {
                return const SizedBox();
              }
            }));
  }

  Widget _renderGateInTime() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('입고예정일자',
          style: TextStyle(
              fontSize: context.pWidth * 0.05,
              fontFamily: 'SUIT',
              fontWeight: context.normalWeight,
              color: Colors.black)),
      Padding(
        padding: EdgeInsets.all(context.pHeight * 0.01),
      ),
      Text(
          NumberHandler()
              .getDateFromDatetime(_selectedDatetime.toLocal().toString()),
          style: TextStyle(
              fontSize: context.pWidth * 0.06,
              fontFamily: 'SUIT',
              fontWeight: context.boldWeight,
              color: Colors.black)),
      Padding(
        padding: EdgeInsets.all(context.pHeight * 0.005),
      ),
      InkWell(
          onTap: () => _onTapCalendar(),
          child: Icon(Icons.calendar_month,
              color: AppColors.darkGrey, size: context.pWidth * 0.08))
    ]);
  }

  Widget _renderInfoCard(List<IssueBarcode> data) {
    return Container(
        padding: EdgeInsets.only(
          top: context.pWidth * 0.05,
          bottom: context.pWidth * 0.05,
          left: context.pWidth * 0.07,
          right: context.pWidth * 0.07,
        ),
        alignment: Alignment.center,
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
        child: Text('${data.length.toString()} 건의 입고예정 정보가 있습니다.',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'SUIT',
                fontSize: context.pWidth * 0.04,
                fontWeight: context.normalWeight)));
  }

  List<Widget> _renderBarcodeDetails(List<IssueBarcode> list) {
    return List.generate(
        list.length,
        (index) => BarcodeDetails(
              onTapIssue: () => _onTapBarcodeIssue(list[index]),
              type: list[index].matlName,
              carFullNo: list[index].carFullNo,
              custName: list[index].custName,
              inStoreTime: list[index].inStoreTime,
            ));
  }
}
