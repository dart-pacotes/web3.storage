part of 'web3_storage_bloc.dart';

abstract class Web3StorageEvent {}

class ListUserUploadsEvent extends Web3StorageEvent {}

class UploadFileEvent extends Web3StorageEvent {
  final RawFile file;

  UploadFileEvent({
    required this.file,
  });
}

class DownloadFileEvent extends Web3StorageEvent {
  final CID cid;

  DownloadFileEvent({
    required this.cid,
  });
}

class UpdateApiTokenEvent extends Web3StorageEvent {
  final String apiToken;

  UpdateApiTokenEvent({
    required this.apiToken,
  });
}
