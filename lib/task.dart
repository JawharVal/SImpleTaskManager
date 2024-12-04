import 'package:intl/intl.dart';

class Task {
  final int id;
  final String title;
  final String description;
  final String category;
  String status;
  final DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    this.dueDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      status: json['status'],
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  @override
  String toString() {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final dueDateString = dueDate != null ? dateFormat.format(dueDate!) : 'None';
    return "Task ID: $id\nTitle: $title\nDescription: $description\nCategory: $category\nStatus: $status\nDue Date: $dueDateString\n";
  }
}
