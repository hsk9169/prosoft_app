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
      compCd: json['COMP_CD'] ?? 'NULL',
      reservNo: json['RESERV_NO'] ?? 'NULL',
      custName: json['CUST_NAME'] ?? 'NULL',
      matlName: json['MATL_NAME'] ?? 'NULL',
      barcodeId: json['BARCODE_ID'] ?? 'NULL',
      rfidNo: json['RFID_NO'] ?? 'NULL',
      carFullNo: json['CAR_FULL_NO'] ?? 'NULL',
      driverName: json['DRIVER_NAME'] ?? 'NULL',
      driverPhoneNo: json['DRIVER_PHONE_NO'] ?? 'NULL',
      inStoreTime: json['IN_STORE_TIME'] ?? 'NULL',
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
