import 'package:flutter/material.dart';
import 'package:supermarket_list/dbhelper/dbhelper.dart';
import 'package:supermarket_list/model/supermarketlist.dart';

class Item extends StatefulWidget {
  Item(this.group, this.item);
  final int group;
  final SuperMarketList item;
  @override
  State<StatefulWidget> createState() => ItemState(group, item);
}

class ItemState extends State {
  ItemState(this.group, this.item);
  int group;
  SuperMarketList item;
  TextEditingController articleController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  DbHelper helper = new DbHelper();

  @override
  Widget build(BuildContext context) {
TextStyle textStyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
        backgroundColor: Colors.brown[200],
        appBar: AppBar(
          backgroundColor: Colors.brown,
          automaticallyImplyLeading: false,
          title: Text('Nuevo item'),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10),
          child: ListView(children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: TextField(
                      controller: articleController,
                      style: textStyle,
                      onChanged: (value) => this.updateDescription(),
                      decoration: InputDecoration(
                          labelStyle: textStyle,
                          labelText: "Articulo",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: TextField(
                      controller: totalController,
                      style: textStyle,
                      onChanged: (value) => this.updateTotal(),
                      decoration: InputDecoration(
                          labelStyle: textStyle,
                          labelText: "Cantidad",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ))
              ],
            )
          ]),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.brown,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.save),
              title: Text('Guardar'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.delete),
              title: Text('Borrar'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_back),
              title: Text('Volver'),
            ),
          ],
          selectedItemColor: Colors.amber[800],
          onTap: navigate,
        ));
  }

  void save() {
    item.idGroup = group;
    if (item.id != null) {
      helper.updateProduct(item);
    } else {
      helper.insertProduct(item);
    }
    Navigator.pop(context, true);
  }

  void updateDescription() {
    item.article = articleController.text;
  }

    void updateTotal() {
    item.quantity = int.parse(totalController.text);
  }

  void navigate(int index) async {
    if (index == 0) {
      save();
    } else if (index == 1) {
      if (item.id == null) {
        return;
      }
      int result = await helper.deleteProduct(item.id);
      if (result != 0) {
        Navigator.pop(context, true);
        AlertDialog alertDialog = AlertDialog(
          title: Text("Borrado"),
          content: Text("El item fue borrado exitosamente."),
        );
        showDialog(context: context, builder: (_) => alertDialog);
      }
    } else {
      Navigator.pop(context, true);
    }
  }
}