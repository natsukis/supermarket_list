import 'package:flutter/material.dart';
import 'package:supermarket_list/dbhelper/dbhelper.dart';
import 'package:supermarket_list/model/grouplist.dart';
import 'package:supermarket_list/screens/listScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tortoise: Listas diarias',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Listas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DbHelper helper = DbHelper();
  List<GroupList> groupList;
  int count = 0;
  GroupList list;
  TextEditingController groupController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Listas'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_box), 
            onPressed: (){
                showDialog(child: new Dialog(
                child: new Column(
                  children: <Widget>[
                    new TextField(
                        decoration: new InputDecoration(hintText: "Nombre de nueva lista"),
                        controller: groupController,
                    ),
                    new FlatButton(
                      child: new Text("Guardar"),
                      onPressed: (){
                        list = new GroupList(groupController.text);
                        save();                      
                      Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ), context: context);
          })
        ],
      ),
      body: marketListItems()
    );
  }

  ListView marketListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.brown[100],
          elevation: 2.0,
          child: ListTile(
              title: Text(this.groupList[position].name),
              onTap: () {
                navigateToItem(this.groupList[position]);
              }),
        );
      },
    );
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final groups = helper.getGroups();
      groups.then((result) {
        List<GroupList> groupListTemp = List<GroupList>();
        int tempCount = result.length;
        for (int i = 0; i < tempCount; i++) {
          groupListTemp.add(GroupList.fromObject(result[i]));
        }
        setState(() {
          groupList = groupListTemp;
          count = tempCount;
        });
      });
    });
  }

  void save() {
      helper.insertGroup(list);
  }

  void navigateToItem(GroupList selectedGroup) async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListScreen(selectedGroup)));
    if (result == true) {
      getData();
    }
  }
}
