class SuperMarketList {
  int id;
  int idGroup;
  int quantity;
  String article;
  int status;

  SuperMarketList(this.idGroup, this.quantity, this.article, this.status);
  SuperMarketList.withId(
      this.id, idGroup, this.quantity, this.article, this.status);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["idGroup"] = idGroup;
    map["quantity"] = quantity;
    map["article"] = article;
    map["status"] = status;
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  SuperMarketList.fromObject(dynamic o) {
    this.id = o["id"];
    this.idGroup = o["idGroup"];
    this.quantity = o["quantity"];
    this.article = o["article"];
    this.status = o["status"];
  }
}
