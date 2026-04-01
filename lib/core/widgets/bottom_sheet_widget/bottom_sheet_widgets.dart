import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noteflow/data/local_db/db_helper.dart';

class BottomSheetWidgets extends StatefulWidget {
  bool isUpdate;
  int sno;

  BottomSheetWidgets({super.key, this.isUpdate = false, this.sno = 0});

  @override
  State<BottomSheetWidgets> createState() => _BottomSheetWidgetsState();
}

class _BottomSheetWidgetsState extends State<BottomSheetWidgets> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  DBHelper? dbRef;
  String msg = '';
  List<Map<String, dynamic>> allNotes = [];

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            widget.isUpdate ? 'Update Note' : 'Add Note',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Enter Title here *',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          TextField(
            controller: descController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Enter Description here *',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('Cancel'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    var title = titleController.text;
                    var desc = descController.text;
                    if (widget.isUpdate) {
                      allNotes = await dbRef!.getAllNotes();
                    }
                    if (title.isNotEmpty && desc.isNotEmpty) {
                      bool check =
                          widget.isUpdate
                              ? await dbRef!.updateNotes(
                                mTitle: title,
                                mDesc: desc,
                                sno:
                                    allNotes[widget.sno][DBHelper
                                        .COLUMN_NOTE_SNO],
                              )
                              : await dbRef!.addNotes(
                                mTitle: title,
                                mDesc: desc,
                              );
                      if (check) {
                        msg =
                            widget.isUpdate
                                ? 'Note updated successfully.'
                                : 'Note added successfully.';
                      }
                    } else {
                      msg = 'Please fill all the required fields.';
                    }
                    setState(() {});
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(msg)));
                    Get.back();
                  },
                  child: Text(widget.isUpdate ? 'Update Note' : 'Add Note'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
