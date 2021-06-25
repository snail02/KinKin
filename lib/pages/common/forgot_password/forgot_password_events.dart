import 'package:flutter_app/utils/view_model/view_model_event.dart';

abstract class ForgotPasswordEvent extends ViewModelEvent {}

class ForgotPasswordError extends ForgotPasswordEvent {}