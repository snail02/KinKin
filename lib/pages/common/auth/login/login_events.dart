import 'package:flutter_app/utils/view_model/view_model_event.dart';


abstract class LoginEvent extends ViewModelEvent {}

class LoginError extends LoginEvent {}