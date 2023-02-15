import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/data/controller/add_task_controller.dart';
import 'package:task_management/data/model/task_model.dart';
import 'package:task_management/ui/values/colors.dart';
import 'package:task_management/ui/widgets/custom_button.dart';
import 'package:task_management/ui/widgets/custom_textfield.dart';

class AddTaskScreen extends StatelessWidget {
  final TaskModel? model;
  AddTaskScreen({super.key, this.model});

  AddTaskController controller = Get.put(AddTaskController());

  @override
  Widget build(BuildContext context) {
    if (model != null) {
      controller.setControllerData(model!);
    } else {
      controller.clearControllerData();
    }
    return Scaffold(
      backgroundColor: AppColors.bodyColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: model != null
            ? const Text('Update Task')
            : const Text('Create Task'),
        centerTitle: true,
        backgroundColor: AppColors.bodyColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: controller.formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomInputField(
                        controller.titleController, "Title", false),
                    const SizedBox(height: 20.0),
                    CustomInputField(
                        controller.descriptionController, "Subtitle", false),
                    const SizedBox(height: 20.0),
                    CustomInputField(controller.estimateStartTimeController,
                        "Est Start Time", true),
                    const SizedBox(height: 20.0),
                    CustomInputField(controller.estimateEndTimeController,
                        "Est End Time", true),
                    const SizedBox(height: 20.0),
                    model != null
                        ? CustomButton(
                            context: context,
                            text: "Update",
                            onPressed: () async {
                              if (controller.formKey.currentState!.validate()) {
                                await controller.updateTask(
                                    model?.id, model?.label);
                              }
                            })
                        : CustomButton(
                            context: context,
                            text: "Create",
                            onPressed: () async {
                              if (controller.formKey.currentState!.validate()) {
                                await controller.addTask("To Do");
                              }
                            }),
                    const SizedBox(height: 15.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
