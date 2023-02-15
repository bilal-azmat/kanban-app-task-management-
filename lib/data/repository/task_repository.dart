import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:task_management/data/service/database_service.dart';
import 'package:task_management/data/model/response_model.dart';

class TaskRepository{
  final DatabaseService _service=DatabaseService();


  Future<ResponseModel> moveTaskToNewBoard({
    required String docId,
    required String title,
    required String description,
    required String estimatedStartTime,
    required String estimatedEndTime,
    required String category,
    required String startTime,
    required String endTime
  }) async {
    return _service.moveTaskToNewBoard(docId:docId,title: title, description: description, estimatedStartTime: estimatedStartTime, estimatedEndTime: estimatedEndTime, category: category,startTime:startTime,endTime:endTime);
  }

  Future<ResponseModel> deleteTask(String docId){
    return _service.deleteTask(docId: docId);
  }

  Stream<QuerySnapshot> getTasksList(){
    return _service.getTasksList();
  }
}