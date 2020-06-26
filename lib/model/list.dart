class SuperMarketList {
  int id;
  int quantity;
  String article;
  int status;
  String date;

  SuperMarketList(this.quantity, this.article, this.status, this.date);
  SuperMarketList.withId(
      this.id, this.quantity, this.article, this.status, this.date);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["quantity"] = quantity;
    map["article"] = article;
    map["status"] = status;
    map["date"] = date;
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  SuperMarketList.fromObject(dynamic o) {
    this.id = o["id"];
    this.quantity = o["quantity"];
    this.article = o["article"];
    this.status = o["status"];
    this.date = o["date"];
  }
}
