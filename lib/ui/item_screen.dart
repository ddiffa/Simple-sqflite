import 'package:flutter/material.dart';
import 'package:sqlite/ui/list_items_dialog.dart';
import '../model/list_items.dart';
import '../model/shopping_list.dart';
import '../util/dbhelper.dart';

class ItemScreen extends StatefulWidget {
  final ShoppingList shoppingList;

  ItemScreen(this.shoppingList);

  @override
  _ItemScreenState createState() => _ItemScreenState(this.shoppingList);
}

class _ItemScreenState extends State<ItemScreen> {
  final ShoppingList shoppingList;
  DbHelper helper;
  List<ListItem> items;

  _ItemScreenState(this.shoppingList);

  ListItemsDialog dialog;

  @override
  void initState() {
    dialog = ListItemsDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    helper = DbHelper();
    showData(this.shoppingList.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.name),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.pinkAccent,
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => dialog.buildDialog(
                    context, ListItem(0, shoppingList.id, '', '', ''), true));
          }),
      body: ListView.builder(
          itemCount: (items != null) ? items.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(items[index].name),
                onDismissed: (direction) {
                  String strName = items[index].name;
                  helper.deleteItems(items[index]);
                  setState(() {
                    items = items;
                  });

                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('${strName} has been deleted')));
                },
                child: ListTile(
                  title: Text(items[index].name),
                  subtitle: Text(
                      'Quantity : ${items[index].quantity}\nNote : ${items[index].note}'),
                  onTap: () {},
                  trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => dialog
                                .buildDialog(context, items[index], false));
                      }),
                ));
          }),
    );
  }

  Future showData(int idList) async {
    await helper.openDB();
    items = await helper.getItems(idList);

    setState(() {
      items = items;
    });
  }
}
