part of 'device_bloc.dart';

abstract class DeviceEvent {}

class PickFileEvent extends DeviceEvent {}

class SaveFileEvent extends DeviceEvent {
  final RawFile file;

  SaveFileEvent({
    required this.file,
  });
}
