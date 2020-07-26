import 'package:flutter/material.dart';
import 'package:supermarket_list/dbhelper/dbhelper.dart';
import 'package:supermarket_list/model/grouplist.dart';
import 'package:supermarket_list/model/supermarketlist.dart';
import 'package:supermarket_list/screens/item.dart';

class ListScreen extends StatefulWidget {
  final GroupList group;
  ListScreen(this.group);
  @override
  State<StatefulWidget> createState() => ListScreenState(group);
}

class ListScreenState extends State {
  ListScreenState(this.group);
  DbHelper helper = DbHelper();
  List<SuperMarketList> lists;
  int count = 0;
  GroupList group;
  @override
  Widget build(BuildContext context) {
    if (lists == null) {
      lists = List<SuperMarketList>();
      getData();
    }
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        title: Text(group.name),
        backgroundColor: Colors.brown,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete), 
            onPressed: (){
              delete();
            }),
          SizedBox(width: 10),
        ],
      ),
      body: articleListItems(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.brown,
          onPressed: () {
            navigateToItem(group.id, new SuperMarketList(group.id, 0, '', 0));
          },
          tooltip: "Agregar nuevo item",
          child: new Icon(Icons.add)),
    );
  }

  ListView articleListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.brown[100],
          elevation: 2.0,
          child: ListTile(              
              title: Text(this.lists[position].article) ,
              
              onTap: () {
                navigateToItem(group.id, this.lists[position]);
              }),
        );
      },
    );
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final articleFuture = helper.getProductByGroup(group.id);
      articleFuture.then((result) {
        List<SuperMarketList> articleList = List<SuperMarketList>();
        count = result.length;
        for (int i = 0; i < count; i++) {
            articleList.add(SuperMarketList.fromObject(result[i]));
        }
        setState(() {
          lists = articleList;
          count = count;
        });
      });
    });
  }


  void navigateToItem(int id, SuperMarketList article) async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Item(id, article)));
    if (result == true) {
      getData();
    }
  }

  void delete() async{
     int result = await helper.deleteGroup(group.id);
      if (result != 0) {
        Navigator.pop(context, true);
        AlertDialog alertDialog = AlertDialog(
          title: Text("Borrada!"),
          content: Text("La lista fue borrada exitosamente."),
        );
        showDialog(context: context, builder: (_) => alertDialog);      
      Navigator.pop(context, true);
    }
  }
}