import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/data/repository/add_task_repository.dart';
import 'package:task_management/ui/screens/kanban_screen.dart';
import 'package:task_management/data/model/task_model.dart';

class AddTaskController extends GetxController{

  final AddTaskRepository _repository=AddTaskRepository();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController estimateStartTimeController = TextEditingController();
  TextEditingController estimateEndTimeController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  addTask(String? category) async {
    var response = await _repository.addTask(
        title: titleController.text,
        description: descriptionController.text,
        estimatedStartTime: estimateStartTimeController.text,
        estimatedEndTime: estimateEndTimeController.text,
        category: category!);
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

  updateTask(String? uid, String? category) async {
    var response = await _repository.updateTask(
      docId: uid!,
      title: titleController.text,
      description: descriptionController.text,
      estimatedStartTime: estimateStartTimeController.text,
      estimatedEndTime: estimateEndTimeController.text,
      category: category!,

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



  setControllerData(TaskModel model) {
    titleController.text = model.title;
    descriptionController.text = model.description;
    estimateStartTimeController.text = model.estimatedStartTime;
    estimateEndTimeController.text = model.estimatedEndTime;
  }

  clearControllerData() {
    titleController.clear();
    descriptionController.clear();
    estimateStartTimeController.clear();
    estimateEndTimeController.clear();
  }



}