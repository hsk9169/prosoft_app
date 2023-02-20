class MainContent {
  final String? scrapYardCode;
  final String? matlName;
  final String? measrGbnCode;
  final String? barcodeId;
  final String? rfidNumber;
  final String? carFullNo;
  final String? waitingYn;

  MainContent({
    this.scrapYardCode,
    this.matlName,
    this.measrGbnCode,
    this.barcodeId,
    this.rfidNumber,
    this.carFullNo,
    this.waitingYn,
  });

  factory MainContent.fromJson(Map<String, dynamic> json) {
    return MainContent(
      scrapYardCode: json['SCRAP_YARD_CODE'] ?? '',
      matlName: json['MATL_NAME'] ?? '',
      measrGbnCode: json['MEASR_GBN_CODE'] ?? '',
      barcodeId: json['BARCODE_ID'] ?? '',
      rfidNumber: json['RFID_NO'] ?? '',
      carFullNo: json['CAR_FULL_NO'] ?? '',
      waitingYn: json['WAITING_YN'] ?? '',
    );
  }

  // For debugging
  Map<String, dynamic> toJson() => {
        'scrapYardCode': scrapYardCode,
        'matlName': matlName,
        'measrGbnCode': measrGbnCode,
        'barcodeId': barcodeId,
        'rfidNumber': rfidNumber,
        'carFullNo': carFullNo,
        'waitingYn': waitingYn,
      };
}
