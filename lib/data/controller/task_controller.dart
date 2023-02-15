import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_management/ui/screens/kanban_screen.dart';
import 'package:task_management/data/model/response_model.dart';
import 'package:task_management/data/model/task_model.dart';
import 'package:task_management/data/repository/task_repository.dart';

class TaskController extends GetxController {
  final TaskRepository _repository = TaskRepository();
  ResponseModel response = ResponseModel();

  late final Stream<QuerySnapshot> collectionReference;


  deleteTask({required String docId}) async {
    response = await _repository.deleteTask(docId);
    if (response.code != 200) {
      Get.dialog(AlertDialog(
        content: Text(response.message.toString()),
      ));
    } else {
      Get.dialog(AlertDialog(
        content: Text(response.message.toString()),
      ));
    }
  }

  Stream<QuerySnapshot> getTasksList() {
    return _repository.getTasksList();
  }

  generateCSVFile() async {
    print("hello world");
    List<List<String>> itemList = [];
    itemList = [
      <String>[
        "Title",
        "Description",
        "`Est start time",
        "Est end time",
        "category"
      ]
    ];

    await FirebaseFirestore.instance
        .collection('tasks')
        .get()
        .then((QuerySnapshot snapshot) async {
      for (var document in snapshot.docs) {
        itemList.add(<String>[
          document.get('title'),
          document.get('description'),
          document.get('estimated_start_time'),
          document.get('estimated_end_time'),
          document.get('category')
        ]);
      }
      var csvData = const ListToCsvConverter().convert(itemList);
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('MM-dd-yyyy-HH-mm-ss').format(now);

      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      final String filePath = '$appDocPath/item_export_$formattedDate.csv';

      final File file = await (File(filePath).create());

      await file.writeAsString(csvData);
      // Open the file with the default file manager on the device
      await OpenFile.open(filePath);
    });
  }

  moveTaskToNewBoard(String listId, TaskModel data) async {
    var response = await _repository.moveTaskToNewBoard(
      docId: data.id,
      title: data.title,
      description: data.description,
      estimatedStartTime: data.estimatedStartTime,
      estimatedEndTime: data.estimatedEndTime,
      category: listId == '1'
          ? 'To Do'
          : listId == '2'
              ? 'In Progress'
              : 'Done',
      startTime: listId == '1'
          ? ''
          : listId == '2'
              ? DateTime.now().toString()
              : data.startTime != null
                  ? data.startTime!
                  : '',
      endTime: listId == '1'
          ? ''
          : listId == '2'
              ? ''
              : DateTime.now().toString(),
    );
    if (response.code != 200) {
      Get.dialog(AlertDialog(
        content: Text(response.message.toString()),
      ));
      Get.back();
      Get.offAll(KanbanScreen());
    } else {
      Get.dialog(AlertDialog(
        content: Text(response.message.toString()),
      ));
    }
  }

}
