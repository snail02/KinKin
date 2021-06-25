
class AddDeviceDataResponse {
  final String? result;
  final String? message;


  AddDeviceDataResponse({this.result,
    this.message,
  });

  factory AddDeviceDataResponse.fromJson(Map<dynamic, dynamic> json) {
    return AddDeviceDataResponse(
      result: json['result'],
      message: json['message'],
    );
  }

}