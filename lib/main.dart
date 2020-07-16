import 'package:flutter/material.dart';
import 'package:sqlite/model/shopping_list.dart';
import 'package:sqlite/ui/shopping_list_dialog.dart';

import './util/dbhelper.dart';
import 'ui/item_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DbHelper helper = DbHelper();
    return MaterialApp(
        title: 'Shopping List',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: ShList());
  }
}

class ShList extends StatefulWidget {
  @override
  _ShListState createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  DbHelper helper = DbHelper();
  List<ShoppingList> shoppingList;
  ShoppingListDialog dialog;

  @override
  void initState() {
    dialog = ShoppingListDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.pinkAccent,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  dialog.buildDialog(context, ShoppingList(0, '', 0), true));
        },
      ),
      body: ListView.builder(
          itemCount: (shoppingList != null) ? shoppingList.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(shoppingList[index].name),
              onDismissed: (direction) {
                String strName = shoppingList[index].name;
                helper.deleteList(shoppingList[index]);
                setState(() {
                  shoppingList.removeAt(index);
                });
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('${strName} has been deleted'),
                ));
              },
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contex) =>
                              ItemScreen(shoppingList[index])));
                },
                trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => dialog.buildDialog(
                              context, shoppingList[index], false));
                    }),
                leading: CircleAvatar(
                  child: Text(shoppingList[index].priority.toString()),
                ),
                title: Text(shoppingList[index].name),
              ),
            );
          }),
    );
  }

  Future showData() async {
    await helper.openDB();
    shoppingList = await helper.getLists();
    setState(() {
      shoppingList = shoppingList;
    });
  }
}
