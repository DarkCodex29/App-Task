class Task{
  int id;
  String title;
  String description;
  bool isCompleted;
  Task({required this.id,required this.title, required this.description, this.isCompleted = false});
}