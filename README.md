#Kanban App Demo Project:

A boilerplate project created in flutter using Getx and firebase firestore. clone the main branches mentioned below:

#Getting Started
The app contains the minimal implementation required to create tasks and managing the task. I have used the getx package for the app state management.
I have used firebase firestore for database and to download the tasks data in csv file i have used csv,path_provider,open_file packages in flutter.

#How to Use
#Step 1:

Download or clone this repo by using the link below:
```
https://github.com/bilal-azmat/kanban-app-task-management-.git
```

#Step 2:


Go to project root and execute the following command in console to get the required dependencies:

flutter pub get

#Step 3:

#Boilerplate Features:
```
Kanban Screen
Theme
Firebase Forestore (For database)
GetX (state management)
Form Validation
Folder Structure
```
Here is the core folder structure which flutter provides.
```
flutter-app/
|- android
|- build
|- ios
|- lib
|- test
Here is the folder structure we have been using in this project

lib/
|- data/
|- data/controller/
|- data/model/
|- data/repository/
|- data/service/
|- ui/
|- ui/screens/
|- ui/common_widgets/
|- ui/values/
|- main.dart

```

Now, lets dive into the lib folder which has the main code for the application.

1- data - Contains the data layer of your project, includes directories for controller,repositry,models,service
2- ui — Contains all the ui of your project, contains sub directory for each screen,common widgets and constant data.
3- main.dart - This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, title, firebase configuration etc.
Data
This directory contains all the application level data. A separate file is created for each type as shown in example below:

```
data/
|- controller/
|- task_controller.dart
|- add_task_controller.dart
|- duration_controller.dart

|- model/
|- response_model.dart
|- task_model.dart


|- repository
|- add_task_repository.dart
|- task_repository.dart

|- service
|- database_service.dart

```


UI
This directory contains all the ui of your application. Each screen is located in a separate folder making it easy to combine group of files related to that particular screen. All the screen common widgets will be placed in common_widget directory and all the style,dimensions,colors,strings will be added under values directory as shown in the example below:
```
ui/
|- screens/
|- add_task_screen.dart
|- kanban_screen.dart
|- values/
|- colors.dart
|- dimens.dart
|- strings.dart
|- theme.dart
|- values.dart

|- common_widgets/
|- custom_button.dart
|- custom_textfield.dart

```


#Main
This is the starting point of the application.
```
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:task_management/ui/screens/kanban_screen.dart';

Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});

@override
Widget build(BuildContext context) {
return GetMaterialApp(
title: 'Flutter Demo',
debugShowCheckedModeBanner:false,
theme: ThemeData(
primarySwatch: Colors.blue,
),

      home:  KanbanScreen(),
    );
}
}

```


#Conclusion:
Due to shortage of time i have just focused on the main functionality of the task. I have made a project architecture according to app functionality but ofcourse we can add/change more functionality like Utils, extension or http services late on according to our use.  

