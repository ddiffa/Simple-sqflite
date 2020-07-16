import 'package:flutter/material.dart';
import '../util/dbhelper.dart';
import '../model/shopping_list.dart';

class ShoppingListDialog {
  final txtName = TextEditingController();
  final txtPriority = TextEditingController();

  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew) {
    DbHelper helper = DbHelper();
    if (!isNew) {
      txtName.text = list.name;
      txtPriority.text = list.priority.toString();
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      title: Text((isNew) ? 'New shopping list' : 'Edit shopping list'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: InputDecoration(hintText: 'Shopping List Name'),
            ),
            TextField(
              controller: txtPriority,
              decoration:
                  InputDecoration(hintText: 'Shopping List Priority (1-3)'),
            ),
            RaisedButton(child: Text('Save Shopping List'), onPressed: () {
              list.name = txtName.text;
              list.priority = int.parse(txtPriority.text);
              helper.insertList(list);
              Navigator.pop(context);
            })
          ],
        ),
      ),
    );
  }
}
