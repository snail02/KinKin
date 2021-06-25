class ResultResponse {
  final String? result;

  ResultResponse({
    this.result,
  });

  factory ResultResponse.fromJson(Map<dynamic, dynamic> json) {
    return ResultResponse(
      result: json['result'],
    );
  }
}
