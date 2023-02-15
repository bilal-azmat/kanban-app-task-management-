import 'package:task_management/data/model/response_model.dart';
import 'package:task_management/data/service/database_service.dart';

class AddTaskRepository{
  final DatabaseService _service=DatabaseService();
  Future<ResponseModel> addTask({
    required String title,
    required String description,
    required String estimatedStartTime,
    required String estimatedEndTime,
    required String category
  }) async {
    return _service.addTask(title: title, description: description, estimatedStartTime: estimatedStartTime, estimatedEndTime: estimatedEndTime, category: category);
  }

  Future<ResponseModel> updateTask({
    required String docId,
    required String title,
    required String description,
    required String estimatedStartTime,
    required String estimatedEndTime,
    required String category
  }) async {
    return _service.updateTask(docId:docId,title: title, description: description, estimatedStartTime: estimatedStartTime, estimatedEndTime: estimatedEndTime, category: category);
  }
}