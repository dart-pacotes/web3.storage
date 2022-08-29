///
/// An alias for a Content Identifier, the global label that uniquely identifies the file in IPFS.
/// Refer to the official docs for more information: https://docs.ipfs.tech/concepts/content-addressing/#what-is-a-cid
///
typedef CID = String;

extension CIDExtension on CID {
  static CID fromJson(final Map<String, dynamic> json) {
    return json['cid'];
  }
}
