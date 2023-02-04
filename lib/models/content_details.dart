class ContentDetails {
  final String? custCode;
  final String? custName;
  final String? gateInTime;
  final String? carSelTime;
  final String? matlName;
  final String? fulfillWgt;
  final int? barcodeId;
  final String? rfidNo;
  final String? gateOutTime;
  final String? carFullNo;
  final String? driverName;
  final String? inspResult;
  final String? driverPhoneNo;
  final String? measrOutTime;
  final String? inStoreDate;
  final String? inspProcTime;
  final String? measrInTime;
  final String? reservNo;
  final String? scrapYardName;
  final String? toleranceWgt;
  final String? classNo;
  final String? inspector;

  ContentDetails({
    this.custCode,
    this.custName,
    this.gateInTime,
    this.carSelTime,
    this.matlName,
    this.fulfillWgt,
    this.barcodeId,
    this.rfidNo,
    this.gateOutTime,
    this.carFullNo,
    this.driverName,
    this.inspResult,
    this.driverPhoneNo,
    this.measrOutTime,
    this.inStoreDate,
    this.inspProcTime,
    this.measrInTime,
    this.reservNo,
    this.scrapYardName,
    this.toleranceWgt,
    this.classNo,
    this.inspector,
  });

  factory ContentDetails.fromJson(Map<String, dynamic> json) {
    final data = json['data']['list'][0];
    return ContentDetails(
      custCode: data['CUST_CODE'] ?? '',
      custName: data['CUST_NAME'] ?? '',
      gateInTime: data['GATE_IN_TIME'] ?? '',
      carSelTime: data['CAR_SEL_TIME'] ?? '',
      matlName: data['MATL_NAME'] ?? '',
      fulfillWgt: data['FULFILL_WGT'] ?? '',
      barcodeId: data['BARCODE_ID'] ?? 0,
      rfidNo: data['RFID_NO'] ?? '',
      gateOutTime: data['GATE_OUT_TIME'] ?? '',
      carFullNo: data['CAR_FULL_NO'] ?? '',
      driverName: data['DRIVER_NAME'] ?? '',
      inspResult: data['INSP_RESULT'] ?? '',
      driverPhoneNo: data['DRIVER_PHONE_NO'] ?? '',
      measrOutTime: data['MEASR_OUT_TIME'] ?? '',
      inStoreDate: data['IN_STORE_DATE'] ?? '',
      inspProcTime: data['INSP_PROC_TIME'] ?? '',
      measrInTime: data['MEASR_IN_TIME'] ?? '',
      reservNo: data['RESERV_NO'] ?? '',
      scrapYardName: data['SCRAP_YARD_NAME'] ?? '',
      toleranceWgt: data['TOLERANCE_WGT'] ?? '',
      classNo: data['CLASS'] ?? '',
      inspector: data['INSPECTOR'] ?? '',
    );
  }

  // For debugging
  Map<String, dynamic> toJson() => {
        'custCode': custCode,
        'custName': custName,
        'gateInTime': gateInTime,
        'carSelTime': carSelTime,
        'matlName': matlName,
        'fulfillWgt': fulfillWgt,
        'barcodeId': barcodeId.toString(),
        'rfidNo': rfidNo,
        'gateOutTime': gateOutTime,
        'carFullNo': carFullNo,
        'driverName': driverName,
        'inspResult': inspResult,
        'driverPhoneNo': driverPhoneNo,
        'measrOutTime': measrOutTime,
        'inStoreDate': inStoreDate,
        'inspProcTime': inspProcTime,
        'measrInTime': measrInTime,
        'reservNo': reservNo,
        'scrapYardName': scrapYardName,
        'toleranceWgt': toleranceWgt,
        'classNo': classNo,
        'inspector': inspector,
      };
}
