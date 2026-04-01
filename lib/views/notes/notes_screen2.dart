import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noteflow/core/constants/app_colors.dart';
import 'package:noteflow/core/widgets/bottom_sheet_widget/bottom_sheet_widgets.dart';
import 'package:noteflow/data/local_db/db_helper.dart';

import '../../core/constants/app_strings.dart';

class NotesScreen2 extends StatefulWidget {
  const NotesScreen2({super.key});

  @override
  State<NotesScreen2> createState() => _NotesScreen2State();
}

class _NotesScreen2State extends State<NotesScreen2> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  List<Map<String, dynamic>> allNotes = [];
  DBHelper? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
  }

  Future<void> getNotes() async {
    allNotes = await dbRef!.getAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Note Screen')),
      body:
          allNotes.isNotEmpty
              ? ListView.builder(
                itemCount: allNotes.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(
                      allNotes[index][DBHelper.COLUMN_NOTE_TITLE],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(allNotes[index][DBHelper.COLUMN_NOTE_DESC]),
                    trailing: SizedBox(
                      width: 50,
                      child: Row(
                        children: [
                          InkWell(
                            child: Icon(Icons.edit),
                            onTap: () async {
                              titleController.text =
                                  allNotes[index][DBHelper.COLUMN_NOTE_TITLE];
                              descController.text =
                                  allNotes[index][DBHelper.COLUMN_NOTE_DESC];
                              await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                //backgroundColor: Colors.transparent,
                                builder: (_) => SafeArea(
                                  child: getBottomSheetWidget(isUpdate: true,
                                      sno:
                                      allNotes[index][DBHelper
                                          .COLUMN_NOTE_SNO]),
                                ),
                              );

                              getNotes();
                            },
                          ),
                          InkWell(
                            child: Icon(Icons.delete, color: Colors.red),
                            onTap: () async {
                              bool check = await dbRef!.deleteNote(
                                sno: allNotes[index][DBHelper.COLUMN_NOTE_SNO],
                              );
                              if (check) {
                                getNotes();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
              : Center(child: Text(AppStrings.noNotesFound,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      floatingActionButton: FloatingActionButton(
        foregroundColor: AppColors.blackColor,
        backgroundColor: AppColors.babyBlue,
        onPressed: () async {
          /// Note to be added from here
          titleController.clear();
          descController.clear();
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            //backgroundColor: Colors.transparent,
            builder: (_) => SafeArea(
              child: getBottomSheetWidget(),
            ),
          );
          getNotes();
        },
        child: Icon(Icons.add),
      ),
    );
  }


  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  Widget getBottomSheetWidget({bool isUpdate = false, int sno = 0}) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isUpdate ? 'Update Notes' : 'Add Notes',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final title = titleController.text.trim();
                        final desc = descController.text.trim();

                        if (title.isEmpty || desc.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('All fields are required'),
                            ),
                          );
                          return;
                        }

                        final success =
                            isUpdate
                                ? await dbRef!.updateNotes(
                                  mTitle: title,
                                  mDesc: desc,
                                  sno: sno,
                                )
                                : await dbRef!.addNotes(
                                  mTitle: title,
                                  mDesc: desc,
                                );

                        if (success) {
                          Get.back();
                        }
                      },
                      child: Text(isUpdate ? 'Update' : 'Add'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
