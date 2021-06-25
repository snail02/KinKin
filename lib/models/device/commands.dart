class Commands {
  late final int id;
  late final int modelId;
  late final String type;
  late final String code;
  String? command;
  String? setType;

  Commands(
      {required this.id,
        required this.modelId,
        required this.type,
        required this.code,
        this.command,
        this.setType});

  Commands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    modelId = json['model_id'];
    type = json['type'];
    code = json['code'];
    command = json['command'];
    setType = json['set_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['model_id'] = this.modelId;
    data['type'] = this.type;
    data['code'] = this.code;
    data['command'] = this.command;
    data['set_type'] = this.setType;
    return data;
  }
}