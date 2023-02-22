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
      custCode: json['CUST_CODE'],
      custName: json['CUST_NAME'],
      gateInTime: json['GATE_IN_TIME'],
      carSelTime: json['CAR_SEL_TIME'],
      matlName: json['MATL_NAME'],
      fulfillWgt: json['FULFILL_WGT'],
      barcodeId: json['BARCODE_ID'],
      rfidNo: json['RFID_NO'],
      gateOutTime: json['GATE_OUT_TIME'],
      carFullNo: json['CAR_FULL_NO'],
      driverName: json['DRIVER_NANE'],
      inspResult: json['INSP_RESULT'],
      driverPhoneNo: json['DRIVER_PHONE_NO'],
      measrOutTime: json['MEASR_OUT_TIME'],
      inStoreDate: json['IN_STORE_DATE'],
      inspProcTime: json['INSP_PROC_TIME'],
      measrInTime: json['MEASR_IN_TIME'],
      reservNo: json['RESERV_NO'],
      scrapYardName: json['SCRAP_YARD_NAME'],
      toleranceWgt: json['TOLERANCE_WGT'],
      classNo: json['CLASS'],
      inspector: json['INSPECTOR'],
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
