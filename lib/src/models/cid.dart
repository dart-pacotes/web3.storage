typedef CID = String;

extension CIDExtension on CID {
  static CID fromJson(final Map<String, dynamic> json) {
    return json['cid'];
  }
}
