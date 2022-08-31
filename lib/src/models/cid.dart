// A fast and free gateway to access IPFS files via HTTP, offered by Web3.Storage
final _w3linkBaseUri = Uri.parse('https://w3s.link/ipfs/');

///
/// An alias for a Content Identifier, the global label that uniquely identifies the file in IPFS.
/// Refer to the official docs for more information: https://docs.ipfs.tech/concepts/content-addressing/#what-is-a-cid
///
typedef CID = String;

extension CIDExtension on CID {
  static CID fromJson(final Map<String, dynamic> json) {
    return json['cid'];
  }

  ///
  /// Returns an URI instance that allows accessing the file pointed by this CID
  ///
  Uri get web => _w3linkBaseUri.resolve(this);
}
