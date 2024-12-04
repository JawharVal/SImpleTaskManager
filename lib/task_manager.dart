import 'dart:convert';
import 'dart:io';
import 'package:flutters/task.dart';

class TaskManager {
  final List<Task> _tasks = [];
  final String _storageFile = "tasks.json";

  TaskManager() {
    _loadTasks();
  }

  void run() {
    while (true) {
      _printMenu();
      stdout.write("Enter your choice: ");
      final input = stdin.readLineSync();
      final choice = int.tryParse(input ?? '');

      switch (choice) {
        case 1:
          addTask();
          break;
        case 2:
          viewTasks();
          break;
        case 3:
          markTaskCompleted();
          break;
        case 4:
          deleteTask();
          break;
        case 5:
          filterTasksByCategory();
          break;
        case 6:
          sortTasksByDueDate();
          break;
        case 7:
          _saveTasks();
          print("Exiting Task Manager. Goodbye!");
          return;
        default:
          print("Invalid choice. Please enter a number between 1 and 7.");
      }
    }
  }

  void _printMenu() {
    print("\n=== Task Manager Menu ===");
    print("1. Add Task");
    print("2. View All Tasks");
    print("3. Mark Task as Completed");
    print("4. Delete Task");
    print("5. Filter Tasks by Category");
    print("6. Sort Tasks by Due Date");
    print("7. Exit");
  }

  void addTask() {
    final title = _getNonEmptyInput("Enter task title: ");
    final description = _getNonEmptyInput("Enter task description: ");
    final category = _getNonEmptyInput("Enter task category (e.g., Work, Personal): ");
    final dueDate = _getValidDateInput("Enter due date (YYYY-MM-DD) or leave blank: ");

    final newTask = Task(
      id: _tasks.isEmpty ? 1 : _tasks.last.id + 1,
      title: title,
      description: description,
      category: category,
      status: "Pending",
      dueDate: dueDate,
    );

    _tasks.add(newTask);
    print("Task added successfully!");
  }

  void viewTasks() {
    if (_tasks.isEmpty) {
      print("No tasks available.");
      return;
    }

    print("\n=== Task List ===");
    for (var task in _tasks) {
      print(task);
    }
  }

  void markTaskCompleted() {
    final taskId = _getValidTaskId("Enter the task ID to mark as completed: ");

    final task = _tasks.firstWhereOrNull((task) => task.id == taskId);

    if (task != null) {
      task.status = "Completed";
      print("Task marked as completed!");
    } else {
      print("Task not found.");
    }
  }

  void deleteTask() {
    final taskId = _getValidTaskId("Enter the task ID to delete: ");

    final task = _tasks.firstWhereOrNull((task) => task.id == taskId);

    if (task != null) {
      _tasks.remove(task);
      print("Task deleted successfully!");
    } else {
      print("Task not found.");
    }
  }

  void filterTasksByCategory() {
    final category = _getNonEmptyInput("Enter the category to filter by: ");

    final filteredTasks = _tasks.where((task) => task.category == category).toList();

    if (filteredTasks.isEmpty) {
      print("No tasks found for the category: $category.");
    } else {
      print("\n=== Tasks in $category Category ===");
      for (var task in filteredTasks) {
        print(task);
      }
    }
  }

  void sortTasksByDueDate() {
    final sortedTasks = List<Task>.from(_tasks)
      ..sort((a, b) => (a.dueDate ?? DateTime.now())
          .compareTo(b.dueDate ?? DateTime.now()));

    print("\n=== Tasks Sorted by Due Date ===");
    for (var task in sortedTasks) {
      print(task);
    }
  }

  void _loadTasks() {
    final file = File(_storageFile);
    if (file.existsSync()) {
      final jsonString = file.readAsStringSync();
      final List<dynamic> jsonData = jsonDecode(jsonString);
      _tasks.clear();
      _tasks.addAll(jsonData.map((json) => Task.fromJson(json)).toList());
    }
  }

  void _saveTasks() {
    final file = File(_storageFile);
    final jsonString = jsonEncode(_tasks.map((task) => task.toJson()).toList());
    file.writeAsStringSync(jsonString);
    print("Tasks saved successfully!");
  }

  // Helper method to get non-empty input
  String _getNonEmptyInput(String prompt) {
    while (true) {
      stdout.write(prompt);
      final input = stdin.readLineSync()?.trim();
      if (input != null && input.isNotEmpty) {
        return input;
      }
      print("Input cannot be empty. Please try again.");
    }
  }

  // Helper method to get valid date input
  DateTime? _getValidDateInput(String prompt) {
    while (true) {
      stdout.write(prompt);
      final input = stdin.readLineSync()?.trim();
      if (input == null || input.isEmpty) {
        return null; // No date provided
      }
      try {
        return DateTime.parse(input);
      } catch (e) {
        print("Invalid date format. Please use YYYY-MM-DD.");
      }
    }
  }

  // Helper method to get a valid task ID
  int _getValidTaskId(String prompt) {
    while (true) {
      stdout.write(prompt);
      final input = stdin.readLineSync()?.trim();
      final taskId = int.tryParse(input ?? '');
      if (taskId != null && taskId > 0) {
        return taskId;
      }
      print("Invalid task ID. Please enter a positive number.");
    }
  }
}

// Extension to safely handle nullable results
extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
