class GroupList{

  int id;
  String name;

  GroupList(this.name);
  GroupList.withId(this.id, this.name);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = name;
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  GroupList.fromObject(dynamic o) {
    this.id = o["id"];
    this.name = o["name"];
  }
}