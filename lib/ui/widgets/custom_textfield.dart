import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/ui/values/values.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  bool readOnly;

  CustomInputField(this.controller,this.hintText,this.readOnly);


  @override
  Widget build(BuildContext context) {
    return   TextFormField(
      onTap: readOnly?(){
        showPicker(controller);
      }:null,
      controller: controller,
      autofocus: false,
      readOnly: readOnly,
      style: AppTheme.appTheme.textTheme.bodyLarge?.copyWith(color: AppColors.headingColor),
      decoration: InputDecoration(
          contentPadding:  const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: hintText,
          hintStyle: AppTheme.appTheme.textTheme.bodyLarge?.copyWith(color: AppColors.headingColor),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1, color: AppColors.bodyTextColor),
              borderRadius: BorderRadius.circular(5)//<-- SEE HERE
          ),
          border: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1, color: AppColors.bodyTextColor),
              borderRadius: BorderRadius.circular(5))),
      validator: (String? value){
        if(value!.isEmpty){
          return "Field Required";
        }
        return null;
      }
    );
  }
}

Future<void> showPicker(controller) async {
  final TimeOfDay? result =
  await showTimePicker(context: Get.context!, initialTime: TimeOfDay.now());
  if (result != null) {

    controller.text = result.format(Get.context!);

  }
}
