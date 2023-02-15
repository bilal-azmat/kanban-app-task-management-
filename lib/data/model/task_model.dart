class TaskModel {
  final String id;
  String? listId;
  final String title;
  final String description;
  final String estimatedStartTime;
  final String estimatedEndTime;
  final String label;
  String? startTime;
  String? endTime;
  String? duration;

  TaskModel(
      {required this.id,
      this.listId,
      required this.title,
      required this.estimatedStartTime,
      required this.estimatedEndTime,
      required this.description,
      required this.label,
      this.startTime,
      this.endTime,
      this.duration});
}
