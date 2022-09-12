class Contact {
  static const tblContact = 'contacts';
  static const colID = 'id';
  static const colName = 'name';
  static const colMobile = 'mobile';

  Contact({required this.id, required this.name, required this.mobile});

  Contact.fromMap(Map<String, dynamic> map) {
    id = map[colID];
    name = map[colMobile];
    mobile = map[colMobile];
  }
  late int id;
  late String name;
  late String mobile;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{colName: name, colMobile: mobile};
    if (id != null) map[colID] = id;
    return map;
  }
}
