
class ConnectedDevice {
  late final int? id;
  late final int? trackerId;
  late final String? type;
  late final String? name;
  late final String? chatId;
  late final String? token;
  late final int? state;
  late final int? speechCount;
  late final int? deviceId;

  ConnectedDevice(
      {this.id,
        this.trackerId,
        this.type,
        this.name,
        this.chatId,
        this.token,
        this.state,
        this.speechCount,
        this.deviceId});

  ConnectedDevice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trackerId = json['tracker_id'];
    type = json['type'];
    name = json['name'];
    chatId = json['chat_id'];
    token = json['token'];
    state = json['state'];
    speechCount = json['speech_count'];
    deviceId = json['device_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tracker_id'] = this.trackerId;
    data['type'] = this.type;
    data['name'] = this.name;
    data['chat_id'] = this.chatId;
    data['token'] = this.token;
    data['state'] = this.state;
    data['speech_count'] = this.speechCount;
    data['device_id'] = this.deviceId;
    return data;
  }
}