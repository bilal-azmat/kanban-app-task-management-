import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/ui/screens/add_task_screen.dart';
import 'package:task_management/ui/values/values.dart';
import 'package:task_management/data/controller/duration_calculate_controller.dart';
import 'package:task_management/data/controller/task_controller.dart';
import 'package:task_management/data/model/task_model.dart';

class KanbanScreen extends StatefulWidget {
  @override
  _KanbanState createState() => _KanbanState();
}

class _KanbanState extends State<KanbanScreen> {
  LinkedHashMap<String, List<TaskModel>> board = LinkedHashMap();
  TaskController controller = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
  }

  getBoardData(var snapshot) async {
    List<TaskModel> inProgressTasks = [];
    List<TaskModel> toDoTasks = [];
    List<TaskModel> doneTasks = [];

    inProgressTasks.clear();
    toDoTasks.clear();
    doneTasks.clear();
    for (var document in snapshot.docs) {
      if (document.get('category') == MyString().toDo) {
        toDoTasks.add(TaskModel(
          id: document.id,
          listId: '1',
          title: document.get('title'),
          description: document.get('description'),
          estimatedStartTime: document.get('estimated_start_time'),
          estimatedEndTime: document.get('estimated_end_time'),
          label: document.get('category'),
        ));
      } else if (document.get('category') == MyString().inProgress) {
        inProgressTasks.add(TaskModel(
          id: document.id,
          listId: '2',
          title: document.get('title'),
          description: document.get('description'),
          estimatedStartTime: document.get('estimated_start_time'),
          estimatedEndTime: document.get('estimated_end_time'),
          label: document.get('category'),
          startTime: document.get('start_time'),
        ));
      } else if (document.get('category') == MyString().done) {
        Duration difference = DurationCalculator().calculateTimeDifference(
            DateTime.parse(document.get('start_time')),
            DateTime.parse(document.get('end_time')));
        String formattedDuration =
            DurationCalculator().formatDuration(difference);
        doneTasks.add(TaskModel(
          id: document.id,
          listId: '3',
          title: document.get('title'),
          description: document.get('description'),
          estimatedStartTime: document.get('estimated_start_time'),
          estimatedEndTime: document.get('estimated_end_time'),
          label: document.get('category'),
          duration: formattedDuration,
        ));
      }
    }
    board.addAll({"1": toDoTasks, "2": inProgressTasks, "3": doneTasks});

  }



  buildItemDragTarget(listId, targetPosition, double height) {
    return DragTarget<TaskModel>(
      // Will accept others, but not himself
      onWillAccept: (TaskModel? data) {
        return board[listId]!.isEmpty ||
            data!.id != board[listId]![targetPosition].id;
      },
      // Moves the card into the position
      onAccept: (TaskModel data) {
        setState(() {
          board[data.listId]!.remove(data);
          data.listId = listId;
          if (board[listId]!.length > targetPosition) {
            board[listId]!.insert(targetPosition + 1, data);
            controller.moveTaskToNewBoard(listId, data);
          } else {
            // to add task in any other column
            board[listId]!.add(data);
            controller.moveTaskToNewBoard(listId, data);
          }
        });
        // controller.update();
      },
      builder: (BuildContext context, List<TaskModel?> data,
          List<dynamic> rejectedData) {
        if (data.isEmpty) {
          // The area that accepts the draggable
          return Container(
            height: height,
          );
        } else {
          return Column(
            // What's shown when hovering on it
            children: [
              Container(
                height: height,
              ),
              ...data.map((TaskModel? item) {
                return Opacity(
                  opacity: 0.5,
                  child: ItemWidget(item: item!),
                );
              }).toList()
            ],
          );
        }
      },
    );
  }

  buildHeader(String listId) {
    Widget header = SizedBox(
      height: Dimens.headerHeight,
      child: HeaderWidget(title: listId),
    );

    return Stack(
      // The header
      children: [
        Draggable<String>(
          data: listId, // A header waiting to be dragged
          childWhenDragging: Opacity(
            // The header that's left behind
            opacity: 0.2,
            child: header,
          ),
          feedback: FloatingWidget(
            child: SizedBox(
              // A header floating around
              width: Dimens.tileWidth,
              child: header,
            ),
          ),
          child: header,
        ),
        buildItemDragTarget(listId, 0, Dimens.headerHeight),
        DragTarget<String>(
          // Will accept others, but not himself
          onWillAccept: (String? incomingListId) {
            return listId != incomingListId;
          },
          // Moves the card into the position
          onAccept: (String incomingListId) {
            setState(
              () {
                LinkedHashMap<String, List<TaskModel>> reorderedBoard =
                    LinkedHashMap();
                for (String key in board.keys) {
                  if (key == incomingListId) {
                    reorderedBoard[listId] = board[listId]!;
                  } else if (key == listId) {
                    reorderedBoard[incomingListId] = board[incomingListId]!;
                  } else {
                    reorderedBoard[key] = board[key]!;
                  }
                }
                board = reorderedBoard;
              },
            );
          },

          builder: (BuildContext context, List<String?> data,
              List<dynamic> rejectedData) {
            if (data.isEmpty) {
              // The area that accepts the draggable
              return const SizedBox(
                height: Dimens.headerHeight,
                width: Dimens.tileWidth,
              );
            } else {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                    color: Colors.blueAccent,
                  ),
                ),
                height: Dimens.headerHeight,
                width: Dimens.tileWidth,
              );
            }
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    buildKanbanList(String listId, List<TaskModel> items) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            buildHeader(listId),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                // A stack that provides:
                // * A draggable object
                // * An area for incoming draggables
                return Stack(
                  children: [
                    Draggable<TaskModel>(
                      data: items[index], // A card waiting to be dragged
                      childWhenDragging: Opacity(
                        // The card that's left behind
                        opacity: 0.2,
                        child: ItemWidget(item: items[index]),
                      ),
                      feedback: SizedBox(
                        // A card floating around
                        height: Dimens.tileHeight,
                        width: Dimens.tileWidth,
                        child: FloatingWidget(
                            child: ItemWidget(
                          item: items[index],
                        )),
                      ),
                      child: ItemWidget(
                        item: items[index],
                      ),
                    ),
                    buildItemDragTarget(listId, index, Dimens.tileHeight),
                  ],
                );
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
        backgroundColor: AppColors.bodyColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                Get.to(AddTaskScreen());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Add New Task",
                      style: AppTheme.appTheme.textTheme.headline4
                          ?.copyWith(color: AppColors.headingColor),
                    ),
                    Icon(Icons.add)
                    //Icon(Icons.add)
                  ],
                ),
              ),
            ),
          ],
        ),
        body: StreamBuilder(
            stream: controller.getTasksList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                getBoardData(snapshot.data);
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: board != null || board.isNotEmpty
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: board.keys.map((String key) {
                                return SizedBox(
                                  width: Dimens.tileWidth,
                                  child: buildKanbanList(key, board[key]!),
                                );
                              }).toList()),
                        )
                      : const Center(child: CircularProgressIndicator()),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }),
        bottomNavigationBar: ElevatedButton(
            onPressed: () async {
              await controller.generateCSVFile();
            },
            style: ElevatedButton.styleFrom(
                primary: AppColors.cardColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: AppTheme.appTheme.textTheme.headline6),
            child: const Text('Export To CSV File')));
  }
}

// The list header (static)
class HeaderWidget extends StatelessWidget {
  final String title;

  const HeaderWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal,
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        title: Text(
          title == '1'
              ? MyString().toDo
              : title == '2'
                  ? MyString().inProgress
                  : MyString().done,
          style: AppTheme.appTheme.textTheme.headline6
              ?.copyWith(color: AppColors.headingColor),
        ),
        trailing: const Icon(
          Icons.sort,
          color: Colors.white,
          size: 30.0,
        ),
        onTap: () {},
      ),
    );
  }
}

// The card
class ItemWidget extends StatelessWidget {
  final TaskModel item;

  TaskController controller = Get.put(TaskController());

  ItemWidget({Key? key, required this.item}) : super(key: key);
  Container makeListTile(TaskModel item) => Container(
        width: Dimens.tileWidth,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item.duration != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.title,
                        style: AppTheme.appTheme.textTheme.headline6
                            ?.copyWith(color: AppColors.headingColor),
                      ),
                      Text(
                        '${item.duration}',
                        style: AppTheme.appTheme.textTheme.subtitle1
                            ?.copyWith(color: AppColors.headingColor),
                      ),
                    ],
                  )
                : Text(
                    item.title,
                    style: AppTheme.appTheme.textTheme.headline6
                        ?.copyWith(color: AppColors.headingColor),
                  ),
            const SizedBox(
              height: 5,
            ),
            Text(
              item.description,
              style: AppTheme.appTheme.textTheme.bodyMedium
                  ?.copyWith(color: AppColors.bodyTextColor),
            ),
            const SizedBox(
              height: 0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(AddTaskScreen(model: item));
                  },
                  child: Text(
                    "Edit",
                    style: AppTheme.appTheme.textTheme.bodyMedium
                        ?.copyWith(color: AppColors.bodyTextColor),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    controller.deleteTask(docId: item.id);
                  },
                  child: Text(
                    "Delete",
                    style: AppTheme.appTheme.textTheme.bodyMedium
                        ?.copyWith(color: AppColors.bodyTextColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.cardColor,
        ),
        child: makeListTile(item),
      ),
    );
  }
}

class FloatingWidget extends StatelessWidget {
  final Widget child;

  const FloatingWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
