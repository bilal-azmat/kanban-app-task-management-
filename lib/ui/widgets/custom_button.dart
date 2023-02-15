import 'package:flutter/material.dart';
import 'package:task_management/ui/values/values.dart';

class CustomButton extends StatelessWidget {
   BuildContext? context;
  final String? text;
  var onPressed;

   CustomButton({Key? key, this.context,this.text,this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(10.0),
      color: AppColors.cardColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: onPressed,
        child: Text(
          text!,
          style: AppTheme.appTheme.textTheme.headline4?.copyWith(color: AppColors.bodyTextColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
