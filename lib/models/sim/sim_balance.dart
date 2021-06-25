class SimBalance {
  double? balance;
  String? currency;
  int? calls;
  double? data;
  int? sms;

  SimBalance({this.balance, this.currency, this.calls, this.data, this.sms});

  SimBalance.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    currency = json['currency'];
    calls = json['calls'];
    data = json['data'];
    sms = json['sms'];

  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    data['currency'] = this.currency;
    data['calls'] = this.calls;
    data['data'] = this.data;
    data['sms'] = this.sms;
    return data;
  }
}