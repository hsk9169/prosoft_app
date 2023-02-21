class FcmMessage {
  final String? msgBody;
  final String? measrFullNo;
  final String? appPgmId;
  final int? barcodeId;
  final String? rfidNo;
  final String? waitingNo;
  final String? carFullNo;
  final int? transId;
  final String? msgDate;
  final String? gateIoNo;
  final String? msgTitle;
  final String? transDate;
  final int? msgSeq;
  final String? mobileId;
  final String? reservNo;
  final String? measrInNo;

  FcmMessage({
    this.msgBody,
    this.measrFullNo,
    this.appPgmId,
    this.barcodeId,
    this.rfidNo,
    this.waitingNo,
    this.carFullNo,
    this.transId,
    this.msgDate,
    this.gateIoNo,
    this.msgTitle,
    this.transDate,
    this.msgSeq,
    this.mobileId,
    this.reservNo,
    this.measrInNo,
  });

  factory FcmMessage.fromJson(Map<String, dynamic> json) {
    return FcmMessage(
      msgBody: json['MSG_BODY'],
      measrFullNo: json['MEASR_FULL_NO'],
      appPgmId: json['APP_PGM_ID'],
      barcodeId: json['BARCODE_ID'] ?? 0,
      rfidNo: json['RFID_NO'],
      waitingNo: json['WAITING_NO'],
      carFullNo: json['CAR_FULL_NO'],
      transId: json['TRANS_ID'],
      msgDate: json['MSG_DATE'],
      gateIoNo: json['GATE_IO_NO'],
      msgTitle: json['MSG_TITLE'],
      transDate: json['TRANS_DATE'],
      msgSeq: json['MSG_SEQ'],
      mobileId: json['MOBILE_ID'],
      reservNo: json['RESERV_NO'],
      measrInNo: json['MEASR_IN_NO'],
    );
  }

  // For debugging
  Map<String, dynamic> toJson() => {
        'msgBody': msgBody,
        'measrFullNo': measrFullNo,
        'appPgmId': appPgmId,
        'barcodeId': barcodeId.toString(),
        'rfidNo': rfidNo,
        'waitingNo': waitingNo,
        'carFullNo': carFullNo,
        'transId': transId.toString(),
        'msgDate': msgDate,
        'gateIoNo': gateIoNo,
        'msgTitle': msgTitle,
        'transDate': transDate,
        'msgSeq': msgSeq.toString(),
        'mobileId': mobileId,
        'reservNo': reservNo,
        'measrInNo': measrInNo,
      };
}
