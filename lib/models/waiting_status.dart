class WaitingStatus {
  final String? measrGbnCode;
  final String? scrapYardCode;
  final String? waitingSeq;
  final String? carFullNo;
  final String? visitName;
  final String? measrStatus;

  WaitingStatus({
    this.measrGbnCode,
    this.scrapYardCode,
    this.waitingSeq,
    this.carFullNo,
    this.visitName,
    this.measrStatus,
  });

  factory WaitingStatus.fromJson(Map<String, dynamic> json) {
    return WaitingStatus(
      measrGbnCode: json['MEASR_GBN_CODE'],
      scrapYardCode: json['SCRAP_YARD_CODE'],
      waitingSeq: json['WAITING_SEQ'],
      carFullNo: json['CAR_FULL_NO'],
      visitName: json['VISIT_NAME'],
      measrStatus: json['MEASR_STATUS'],
    );
  }

  // For debugging
  Map<String, dynamic> toJson() => {
        'measrGbnCode': measrGbnCode,
        'scrapYardCode': scrapYardCode,
        'waitingSeq': waitingSeq,
        'carFullNo': carFullNo,
        'visitName': visitName,
        'measrStatus': measrStatus,
      };
}
