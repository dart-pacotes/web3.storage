part of 'device_bloc.dart';

abstract class DeviceState {}

class DeviceInitial extends DeviceState {}

class PickFileInProgress extends DeviceState {}

class PickFileSuccess extends DeviceState {
  final RawFile file;

  PickFileSuccess({
    required this.file,
  });
}

class PickFileFailure extends DeviceState {}

class SaveFileInProgress extends DeviceState {}

class SaveFileSuccess extends DeviceState {}

class SaveFileFailure extends DeviceState {}
