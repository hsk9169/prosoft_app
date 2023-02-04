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
    final data = json['data']['list'];
    if (data.length > 0) {
      return WaitingStatus(
        measrGbnCode: data['MEASR_GBN_CODE'] ?? '',
        scrapYardCode: data['SCRAP_YARD_CODE'] ?? '',
        waitingSeq: data['WAITING_SEQ'] ?? '',
        carFullNo: data['CAR_FULL_NO'] ?? '',
        visitName: data['VISIT_NAME'] ?? '',
        measrStatus: data['MEASR_STATUS'] ?? '',
      );
    } else {
      return WaitingStatus(
        measrGbnCode: '',
        scrapYardCode: '',
        waitingSeq: '',
        carFullNo: '',
        visitName: '',
        measrStatus: '',
      );
    }
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
