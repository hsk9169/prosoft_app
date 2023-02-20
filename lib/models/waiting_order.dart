class WaitingOrder {
  final String? matlName;
  final String? measrFullNo;
  final String? barcodeId;
  final String? measrGbnCode;
  final String? scrapYardCode;
  final String? currentTime;
  final String? waitingStatusCode;
  final String? measrInNo;
  final String? step1Time;
  final String? step2Time;
  final String? step3Time;
  final String? step4Time;
  final String? step5Time;
  final String? step6Time;
  final String? step1Data;
  final String? step2Data;
  final String? step3Data;
  final String? step4Data;
  final String? step5Data;
  final String? step6Data;

  WaitingOrder({
    this.matlName,
    this.measrFullNo,
    this.barcodeId,
    this.measrGbnCode,
    this.scrapYardCode,
    this.currentTime,
    this.waitingStatusCode,
    this.measrInNo,
    this.step1Time,
    this.step2Time,
    this.step3Time,
    this.step4Time,
    this.step5Time,
    this.step6Time,
    this.step1Data,
    this.step2Data,
    this.step3Data,
    this.step4Data,
    this.step5Data,
    this.step6Data,
  });

  factory WaitingOrder.fromJson(Map<String, dynamic> json) {
    return WaitingOrder(
      matlName: json['MATL_NAME'] ?? '',
      measrFullNo: json['MEASR_FULL_NO'] ?? '',
      barcodeId: json['BARCODE_ID'] ?? '',
      measrGbnCode: json['MEASR_GBN_CODE'] ?? '',
      scrapYardCode: json['SCRAP_YARD_CODE'] ?? '',
      currentTime: json['CURRENT_TIME'] ?? '',
      waitingStatusCode: json['WAITING_STATUS_CODE'] ?? '',
      measrInNo: json['MEASR_IN_NO'] ?? '',
      step1Time: json['STEP_1_TIME'] ?? '',
      step2Time: json['STEP_2_TIME'] ?? '',
      step3Time: json['STEP_3_TIME'] ?? '',
      step4Time: json['STEP_4_TIME'] ?? '',
      step5Time: json['STEP_5_TIME'] ?? '',
      step6Time: json['STEP_6_TIME'] ?? '',
      step1Data: json['STEP_1_DATA'] ?? '',
      step2Data: json['STEP_2_DATA'] ?? '',
      step3Data: json['STEP_3_DATA'] ?? '',
      step4Data: json['STEP_4_DATA'] ?? '',
      step5Data: json['STEP_5_DATA'] ?? '',
      step6Data: json['STEP_6_DATA'] ?? '',
    );
  }

  // For debugging
  Map<String, dynamic> toJson() => {
        'matlName': matlName,
        'measrFullNo': measrFullNo,
        'barcodeId': barcodeId,
        'measrGbnCode': measrGbnCode,
        'scrapYardCode': scrapYardCode,
        'currentTime': currentTime,
        'waitingStatusCode': waitingStatusCode,
        'step1Time': step1Time,
        'step2Time': step2Time,
        'step3Time': step3Time,
        'step4Time': step4Time,
        'step5Time': step5Time,
        'step6Time': step6Time,
        'step1Data': step1Data,
        'step2Data': step2Data,
        'step3Data': step3Data,
        'step4Data': step4Data,
        'step5Data': step5Data,
        'step6Data': step6Data,
      };
}
