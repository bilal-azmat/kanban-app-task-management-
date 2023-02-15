import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:task_management/data/model/response_model.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _Collection = _firestore.collection('tasks');

class DatabaseService {
  Future<ResponseModel> addTask(
      {required String title,
      required String description,
      required String estimatedStartTime,
      required String estimatedEndTime,
      required String category,


      }) async {
    ResponseModel response = ResponseModel();
    DocumentReference documentReferencer = _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
      "estimated_start_time": estimatedStartTime,
      "estimated_end_time": estimatedEndTime,
      "category": category
    };

    await documentReferencer.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Successfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  Future<ResponseModel> updateTask(
      {
        required String? docId,
        required String title,
        required String description,
        required String estimatedStartTime,
        required String estimatedEndTime,
        required String category}) async {
    ResponseModel response = ResponseModel();

    DocumentReference documentReferencer =
    _Collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
      "estimated_start_time": estimatedStartTime,
      "estimated_end_time": estimatedEndTime,
      "category": category
    };

    await documentReferencer
        .update(data)
        .whenComplete(() {
      response.code = 200;
      response.message = "Task updated Successfully!";
    });

    return response;
  }

  Future<ResponseModel> moveTaskToNewBoard(
      {
        required String? docId,
        required String title,
        required String description,
        required String estimatedStartTime,
        required String estimatedEndTime,
        required String category,
        required String startTime,
        required String endTime,

      }) async {
    ResponseModel response = ResponseModel();

    DocumentReference documentReferencer =
    _Collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
      "estimated_start_time": estimatedStartTime,
      "estimated_end_time": estimatedEndTime,
      "category": category,
      'start_time':startTime,
      'end_time':endTime
    };

    await documentReferencer
        .update(data)
        .whenComplete(() {
      response.code = 200;
      response.message = "Card Moved Successfully!";
    });

    return response;
  }


   Stream<QuerySnapshot> getTasksList() {
    CollectionReference taskItemCollection =
        _Collection;
    print("tasks list");
    print(taskItemCollection.snapshots());

    return taskItemCollection.snapshots();



  }


   Future<ResponseModel> deleteTask({
    required String docId,
  }) async {
     ResponseModel response = ResponseModel();
    DocumentReference documentReferencer =
    _Collection.doc(docId);

    await documentReferencer
        .delete()
        .whenComplete((){
      response.code = 200;
      response.message = "Sucessfully Deleted Employee";
    })
        .catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }


  //deleteTask() {}
}
