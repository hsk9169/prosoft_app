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
      measrGbnCode: json['MEASR_GBN_CODE'] ?? 'NULL',
      scrapYardCode: json['SCRAP_YARD_CODE'] ?? 'NULL',
      waitingSeq: json['WAITING_SEQ'] ?? 'NULL',
      carFullNo: json['CAR_FULL_NO'] ?? 'NULL',
      visitName: json['VISIT_NAME'] ?? 'NULL',
      measrStatus: json['MEASR_STATUS'] ?? 'NULL',
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
