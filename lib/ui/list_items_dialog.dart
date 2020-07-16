import 'package:flutter/material.dart';
import 'package:sqlite/model/list_items.dart';
import '../util/dbhelper.dart';

class ListItemsDialog {
  final txtName = TextEditingController();
  final txtQuantity = TextEditingController();
  final txtNote = TextEditingController();

  Widget buildDialog(BuildContext context, ListItem list, bool isNew) {
    DbHelper helper = DbHelper();
    if (!isNew) {
      txtName.text = list.name;
      txtQuantity.text = list.quantity;
      txtNote.text = list.note;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      title: Text((isNew) ? 'New Shopping item' : 'Edit Shopping Item'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: InputDecoration(
                  hintText: 'Shopping Item Name'
              ),
            ),
            TextField(
              controller: txtQuantity,
              decoration: InputDecoration(
                  hintText: 'Shopping Item Quantity'
              ),
            ),
            TextField(
              controller: txtNote,
              decoration: InputDecoration(
                  hintText: 'Shopping Item Note'
              ),
            ),
            RaisedButton(
                child: Text('Save item'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ), onPressed: () {
              list.name = txtName.text;
              list.note = txtNote.text;
              list.quantity = txtQuantity.text;
              helper.insertItem(list);
              Navigator.pop(context);
            })
          ],
        ),
      ),
    );
  }
}
