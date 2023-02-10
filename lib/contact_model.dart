class ContactModel {
  int? id;
  String? contactName;
  String? contactNumber;
  String? contactImageUrl;

  ContactModel(dynamic obj) {
    id = obj['id'];
    contactName = obj['contactName'];
    contactNumber = obj['contactNumber'];
    contactImageUrl = obj['contactImageUrl'];
  }

  ContactModel.fromMap(Map<String , dynamic> data) {
    id = data['id'];
    contactName = data['contactName'];
    contactNumber = data['contactNumber'];
    contactImageUrl = data['contactImageUrl'];
  }

  Map<String , dynamic> toMap() => {'id':id,'contactName':contactName,'contactNumber':contactNumber,'contactImageUrl':contactImageUrl};
}