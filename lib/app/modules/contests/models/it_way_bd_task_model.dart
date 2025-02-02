import 'dart:developer';

class ITWayBDTask {
  final String id;
  final String? title;
  final String? description;
  final String? status;
  final DateTime? dueDate;
 

  ITWayBDTask({
    required this.id,
    this.title,
    this.description,
    this.status,
    this.dueDate,
   
  });

  factory ITWayBDTask.fromJson(Map<String, dynamic> json) {
    return ITWayBDTask(
      id: json['_id'] ?? '',
      title: json['title'],
      description: json['description'],
      status: json['status'],
      dueDate: json['dueDate'],
    
    );
  }

  static DateTime parseDate(String? dateStr) {
    if (dateStr == null) return DateTime.now(); // Handle null date string
    try {
      return DateTime.parse(dateStr); // ISO 8601 parsing
    } catch (e) {
      log('Invalid date format: $dateStr');
      return DateTime.now(); // Fallback date
    }
  }
}
