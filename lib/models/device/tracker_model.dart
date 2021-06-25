
class TrackerModel {
  late final int id;
  late final String type;
  late final String name;
  late final int protocolId;
  late final int ord;
  late final int enabled;
  late final String image;
  late final String? vendorId;

  TrackerModel(
      {required this.id,
        required this.type,
        required this.name,
        required this.protocolId,
        required this.ord,
        required this.enabled,
        required this.image,
        this.vendorId});

  TrackerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    protocolId = json['protocol_id'];
    ord = json['ord'];
    enabled = json['enabled'];
    image = json['image'];
    vendorId = json['vendor_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['protocol_id'] = this.protocolId;
    data['ord'] = this.ord;
    data['enabled'] = this.enabled;
    data['image'] = this.image;
    data['vendor_id'] = this.vendorId;
    return data;
  }
}
