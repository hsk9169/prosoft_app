class WaitingOrder {
  final String? matlName;
  final String? measrFullNo;
  final int? barcodeId;
  final String? measrGbnCode;
  final String? scrapYardCode;
  final String? currentTime;
  final String? waitingStatusCode;
  final String? waitingYN;
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
    this.waitingYN,
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
    final data = json['data']['list'][0];
    return WaitingOrder(
      matlName: data['MATL_NAME'] ?? '',
      measrFullNo: data['MEASR_FULL_NO'] ?? '',
      barcodeId: data['BARCODE_ID'] ?? '',
      measrGbnCode: data['MEASR_GBN_CODE'] ?? '',
      scrapYardCode: data['SCRAP_YARD_CODE'] ?? '',
      currentTime: data['CURRENT_TIME'] ?? '',
      waitingStatusCode: data['WAITING_STATUS_CODE'] ?? '',
      waitingYN: data['WAITING_YN'] ?? '',
      step1Time: data['STEP_1_TIME'] ?? '',
      step2Time: data['STEP_2_TIME'] ?? '',
      step3Time: data['STEP_3_TIME'] ?? '',
      step4Time: data['STEP_4_TIME'] ?? '',
      step5Time: data['STEP_5_TIME'] ?? '',
      step6Time: data['STEP_6_TIME'] ?? '',
      step1Data: data['STEP_1_DATA'] ?? '',
      step2Data: data['STEP_2_DATA'] ?? '',
      step3Data: data['STEP_3_DATA'] ?? '',
      step4Data: data['STEP_4_DATA'] ?? '',
      step5Data: data['STEP_5_DATA'] ?? '',
      step6Data: data['STEP_6_DATA'] ?? '',
    );
  }

  // For debugging
  Map<String, dynamic> toJson() => {
        'matlName': matlName,
        'measrFullNo': measrFullNo,
        'barcodeId': barcodeId.toString(),
        'measrGbnCode': measrGbnCode,
        'scrapYardCode': scrapYardCode,
        'currentTime': currentTime,
        'waitingStatusCode': waitingStatusCode,
        'waitingYN': waitingYN,
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
