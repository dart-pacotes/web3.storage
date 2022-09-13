part of 'web3_storage_bloc.dart';

abstract class Web3StorageState {
  final List<Web3FileReference> uploadedFiles;

  const Web3StorageState({
    required this.uploadedFiles,
  });
}

class Web3StorageInitial extends Web3StorageState {
  const Web3StorageInitial({
    required super.uploadedFiles,
  });
}

abstract class Web3StorageCallFailure extends Web3StorageState {
  final RequestError error;

  const Web3StorageCallFailure({
    required super.uploadedFiles,
    required this.error,
  });
}

class ListUserUploadsInProgress extends Web3StorageState {
  const ListUserUploadsInProgress({
    required super.uploadedFiles,
  });
}

class ListUserUploadsSuccess extends Web3StorageState {
  const ListUserUploadsSuccess({
    required super.uploadedFiles,
  });
}

class ListUserUploadsFailure extends Web3StorageCallFailure {
  const ListUserUploadsFailure({
    required super.uploadedFiles,
    required super.error,
  });
}

class UploadFileInProgress extends Web3StorageState {
  const UploadFileInProgress({
    required super.uploadedFiles,
  });
}

class UploadFileSuccess extends Web3StorageState {
  final Web3File file;

  const UploadFileSuccess({
    required super.uploadedFiles,
    required this.file,
  });
}

class UploadFileFailure extends Web3StorageCallFailure {
  const UploadFileFailure({
    required super.uploadedFiles,
    required super.error,
  });
}

class DownloadFileInProgress extends Web3StorageState {
  const DownloadFileInProgress({
    required super.uploadedFiles,
  });
}

class DownloadFileSuccess extends Web3StorageState {
  final Web3File file;

  const DownloadFileSuccess({
    required super.uploadedFiles,
    required this.file,
  });
}

class DownloadFileFailure extends Web3StorageCallFailure {
  const DownloadFileFailure({
    required super.uploadedFiles,
    required super.error,
  });
}
