import 'package:flutter/material.dart';

import '../../firebase_funcations.dart';
import '../../models/task_model.dart';

class TasksProvider with ChangeNotifier {
  List<TaskModel> tasks = [];
  DateTime selectedDate = DateTime.now();

  Future<void> getTasks(String userId) async {
    List<TaskModel> allTasks =
        await FirebaseFuncations.getAllTasksFromFirestore(userId);
    tasks = allTasks
        .where((task) =>
            task.date.day == selectedDate.day &&
            task.date.month == selectedDate.month &&
            task.date.year == selectedDate.year)
        .toList();
    notifyListeners();
  }

  changeSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }
}
