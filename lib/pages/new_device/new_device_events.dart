
import 'package:flutter_app/utils/view_model/view_model_event.dart';

abstract class NewDeviceEvent extends ViewModelEvent {}

class AddDeviceError extends NewDeviceEvent {}