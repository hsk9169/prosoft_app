class IssueBarcode {
  final String? compCd;
  final String? reservNo;
  final String? custName;
  final String? matlName;
  final String? barcodeId;
  final String? rfidNo;
  final String? carFullNo;
  final String? driverName;
  final String? driverPhoneNo;
  final String? inStoreTime;

  IssueBarcode({
    this.compCd,
    this.reservNo,
    this.custName,
    this.matlName,
    this.barcodeId,
    this.rfidNo,
    this.carFullNo,
    this.driverName,
    this.driverPhoneNo,
    this.inStoreTime,
  });

  factory IssueBarcode.fromJson(Map<String, dynamic> json) {
    return IssueBarcode(
      compCd: json['COMP_CD'],
      reservNo: json['RESERV_NO'],
      custName: json['CUST_NAME'],
      matlName: json['MATL_NAME'],
      barcodeId: json['BARCODE_ID'],
      rfidNo: json['RFID_NO'],
      carFullNo: json['CAR_FULL_NO'],
      driverName: json['DRIVER_NAME'],
      driverPhoneNo: json['DRIVER_PHONE_NO'],
      inStoreTime: json['IN_STORE_TIME'],
    );
  }

  // For debugging
  Map<String, dynamic> toJson() => {
        'custName': custName,
        'matlName': matlName,
        'barcodeId': barcodeId,
        'rfidNo': rfidNo,
        'carFullNo': carFullNo,
        'driverName': driverName,
        'driverPhoneNo': driverPhoneNo,
        'inStoreTime': inStoreTime,
      };
}
