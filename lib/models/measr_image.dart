class MeasrImage {
  final String? measrFullNo;
  final String? image;
  final String? barcodeId;
  final String? rfidNo;
  final String? measrInNo;

  MeasrImage({
    this.measrFullNo,
    this.image,
    this.barcodeId,
    this.rfidNo,
    this.measrInNo,
  });

  factory MeasrImage.fromJson(Map<String, dynamic> data) {
    final json = data['data']['list'][0];
    return MeasrImage(
      measrFullNo: json['MEASR_FULL_NO'] ?? '',
      image: json['IMAGE'] ?? '',
      barcodeId: json['BARCODE_ID'] ?? '',
      rfidNo: json['RFID_NO'] ?? '',
      measrInNo: json['MEASR_IN_NO'] ?? '',
    );
  }

  // For debugging
  Map<String, dynamic> toJson() => {
        'measrFullNo': measrFullNo,
        'image': image,
        'barcodeId': barcodeId,
        'rfidNo': rfidNo,
        'measrInNo': measrInNo,
      };
}
