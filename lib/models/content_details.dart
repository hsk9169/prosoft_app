class ContentDetails {
  final String? custCode;
  final String? custName;
  final String? gateInTime;
  final String? carSelTime;
  final String? matlName;
  final String? fulfillWgt;
  final String? barcodeId;
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
    return ContentDetails(
      custCode: json['CUST_CODE'] ?? 'NULL',
      custName: json['CUST_NAME'] ?? 'NULL',
      gateInTime: json['GATE_IN_TIME'] ?? 'NULL',
      carSelTime: json['CAR_SEL_TIME'] ?? 'NULL',
      matlName: json['MATL_NAME'] ?? 'NULL',
      fulfillWgt: json['FULFILL_WGT'] ?? 'NULL',
      barcodeId: json['BARCODE_ID'] ?? 'NULL',
      rfidNo: json['RFID_NO'] ?? 'NULL',
      gateOutTime: json['GATE_OUT_TIME'] ?? 'NULL',
      carFullNo: json['CAR_FULL_NO'] ?? 'NULL',
      driverName: json['DRIVER_NAME'] ?? 'NULL',
      inspResult: json['INSP_RESULT'] ?? 'NULL',
      driverPhoneNo: json['DRIVER_PHONE_NO'] ?? 'NULL',
      measrOutTime: json['MEASR_OUT_TIME'] ?? 'NULL',
      inStoreDate: json['IN_STORE_DATE'] ?? 'NULL',
      inspProcTime: json['INSP_PROC_TIME'] ?? 'NULL',
      measrInTime: json['MEASR_IN_TIME'] ?? 'NULL',
      reservNo: json['RESERV_NO'] ?? 'NULL',
      scrapYardName: json['SCRAP_YARD_NAME'] ?? 'NULL',
      toleranceWgt: json['TOLERANCE_WGT'] ?? 'NULL',
      classNo: json['CLASS'] ?? 'NULL',
      inspector: json['INSPECTOR'] ?? 'NULL',
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
        'barcodeId': barcodeId,
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
