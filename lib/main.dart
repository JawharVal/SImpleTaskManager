import 'dart:io';

import 'package:flutters/task_manager.dart';

void main() {
  final taskManager = TaskManager();

  while (true) {
    printMenu();
    stdout.write("Enter your choice: ");
    final input = stdin.readLineSync();
    final choice = int.tryParse(input ?? '');

    switch (choice) {
      case 1:
        taskManager.addTask();
        break;
      case 2:
        taskManager.viewTasks();
        break;
      case 3:
        taskManager.markTaskCompleted();
        break;
      case 4:
        taskManager.deleteTask();
        break;
      case 5:
        print("Exiting Task Manager. Goodbye!");
        return;
      default:
        print("Invalid choice. Try again.");
    }
  }
}

void printMenu() {
  print("\n=== Task Manager Menu ===");
  print("1. Add Task");
  print("2. View All Tasks");
  print("3. Mark Task as Completed");
  print("4. Delete Task");
  print("5. Exit");
}
